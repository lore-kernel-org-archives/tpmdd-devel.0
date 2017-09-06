From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [RFC] tpm: Register RNG device only on tpm chip init
Date: Wed,  6 Sep 2017 18:41:16 +0530
Message-ID: <20170906131116.25967-1-prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-crypto@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

RNG device is registered as soon as tpm-rng module is loaded even if
there are no TPM chip available. Call hwrng_register once tpm chip has
registered.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/tpm-rng.c | 50 ----------------------------------------
 drivers/char/tpm/tpm-chip.c      | 24 +++++++++++++++++++
 drivers/char/tpm/tpm.h           |  3 +++
 3 files changed, 27 insertions(+), 50 deletions(-)
 delete mode 100644 drivers/char/hw_random/tpm-rng.c

diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
deleted file mode 100644
index d6d4482..0000000
--- a/drivers/char/hw_random/tpm-rng.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (C) 2012 Kent Yoder IBM Corporation
- *
- * HWRNG interfaces to pull RNG data from a TPM
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-
-#include <linux/module.h>
-#include <linux/hw_random.h>
-#include <linux/tpm.h>
-
-#define MODULE_NAME "tpm-rng"
-
-static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
-{
-	return tpm_get_random(TPM_ANY_NUM, data, max);
-}
-
-static struct hwrng tpm_rng = {
-	.name = MODULE_NAME,
-	.read = tpm_rng_read,
-};
-
-static int __init rng_init(void)
-{
-	return hwrng_register(&tpm_rng);
-}
-module_init(rng_init);
-
-static void __exit rng_exit(void)
-{
-	hwrng_unregister(&tpm_rng);
-}
-module_exit(rng_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Kent Yoder <key@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("RNG driver for TPM devices");
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 0eca20c..bf9c2ad 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
 #include <linux/major.h>
+#include <linux/hw_random.h>
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
@@ -387,6 +388,15 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 
 	return 0;
 }
+
+static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	int chip_num = 0;
+
+	kstrtoint(&rng->name[8], 10, &chip_num);
+	return tpm_get_random(chip_num, data, max);
+}
+
 /*
  * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
@@ -401,6 +411,7 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 int tpm_chip_register(struct tpm_chip *chip)
 {
 	int rc;
+	char *tpm_rng_name;
 
 	if (chip->ops->flags & TPM_OPS_AUTO_STARTUP) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -431,6 +442,14 @@ int tpm_chip_register(struct tpm_chip *chip)
 		return rc;
 	}
 
+	tpm_rng_name = kmalloc(64, GFP_KERNEL);
+
+	if (tpm_rng_name) {
+		sprintf(tpm_rng_name, "tpm-rng-%d", chip->dev_num);
+		tpm_rng.name = tpm_rng_name;
+		tpm_rng.read = tpm_rng_read;
+		hwrng_register(&tpm_rng);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_chip_register);
@@ -450,6 +469,11 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
  */
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
+	if (chip->tpm_rng.name[0] != 0) {
+		hwrng_unregister(&tpm_rng);
+		kfree(chip->tpm_rng.name);
+		chip->tpm_rng.name[0] = 0;
+	}
 	tpm_del_legacy_sysfs(chip);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b50e92f..ca042f7 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
+#include <linux/hw_random.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/platform_device.h>
@@ -210,6 +211,8 @@ struct tpm_chip {
 	int dev_num;		/* /dev/tpm# */
 	unsigned long is_open;	/* only one allowed */
 
+	struct hwrng tpm_rng;
+
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	unsigned long timeout_a; /* jiffies */
-- 
2.10.0
