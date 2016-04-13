From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/12] tpm: tpm_tis: Share common data
	between phys
Date: Wed, 13 Apr 2016 21:55:40 +0200
Message-ID: <1460577351-24632-2-git-send-email-christophe-h.ricard@st.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460577351-24632-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

As preliminary, split priv_data structure in common and phy specific
structures.
iobase field is specific to lpc bus.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c      | 30 +++++++++++++++++++++++-------
 drivers/char/tpm/tpm_tis_core.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 7 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_tis_core.h

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1e45e73..cc64edb 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -93,14 +93,8 @@ struct tpm_info {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
-struct priv_data {
+struct tpm_tis_phy {
 	void __iomem *iobase;
-	u16 manufacturer_id;
-	int locality;
-	int irq;
-	bool irq_tested;
-	wait_queue_head_t int_queue;
-	wait_queue_head_t read_queue;
 };
 
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
@@ -133,6 +127,7 @@ static inline int is_itpm(struct acpi_device *dev)
 static int wait_startup(struct tpm_chip *chip, int l)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop = jiffies + chip->timeout_a;
 	do {
 		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
@@ -146,6 +141,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 
 	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
 	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
@@ -158,6 +154,7 @@ static int check_locality(struct tpm_chip *chip, int l)
 static void release_locality(struct tpm_chip *chip, int l, int force)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 
 	if (force || (ioread8(priv->iobase + TPM_ACCESS(l)) &
 		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
@@ -169,6 +166,7 @@ static void release_locality(struct tpm_chip *chip, int l, int force)
 static int request_locality(struct tpm_chip *chip, int l)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop, timeout;
 	long rc;
 
@@ -210,6 +208,7 @@ again:
 static u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 
 	return ioread8(priv->iobase +
 		       TPM_STS(priv->locality));
@@ -218,6 +217,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 static void tpm_tis_ready(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 
 	/* this causes the current command to be aborted */
 	iowrite8(TPM_STS_COMMAND_READY,
@@ -227,6 +227,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
 static int get_burstcount(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	unsigned long stop;
 	int burstcnt;
 
@@ -249,6 +250,7 @@ static int get_burstcount(struct tpm_chip *chip)
 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	int size = 0, burstcnt;
 	while (size < count &&
 	       wait_for_tpm_stat(chip,
@@ -323,6 +325,7 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	int rc, status, burstcnt;
 	size_t count = 0;
 
@@ -379,6 +382,7 @@ out_err:
 static void disable_interrupts(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	u32 intmask;
 
 	intmask =
@@ -472,6 +476,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 				    unsigned long *timeout_cap)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	int i;
 	u32 did_vid;
 
@@ -496,6 +501,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 static int probe_itpm(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	int rc = 0;
 	u8 cmd_getticks[] = {
 		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
@@ -565,6 +571,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	u32 interrupt;
 	int i;
 
@@ -602,6 +609,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 				    int flags, int irq)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	u8 original_int_vec;
 
 	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
@@ -655,6 +663,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	u8 original_int_vec;
 	int i;
 
@@ -679,6 +688,7 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
 static void tpm_tis_remove(struct tpm_chip *chip)
 {
 	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_phy *phy = priv->phy_id;
 	void __iomem *reg = priv->iobase + TPM_INT_ENABLE(priv->locality);
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
@@ -695,11 +705,16 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	int rc, probe;
 	struct tpm_chip *chip;
 	struct priv_data *priv;
+	struct tpm_tis_phy *phy;
 
 	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
 	if (priv == NULL)
 		return -ENOMEM;
 
+	phy = devm_kzalloc(dev, sizeof(struct tpm_tis_phy), GFP_KERNEL);
+	if (phy == NULL)
+		return -ENOMEM;
+
 	chip = tpmm_chip_alloc(dev, &tpm_tis);
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
@@ -717,6 +732,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	chip->timeout_b = TIS_TIMEOUT_B_MAX;
 	chip->timeout_c = TIS_TIMEOUT_C_MAX;
 	chip->timeout_d = TIS_TIMEOUT_D_MAX;
+	priv->phy_id = phy;
 
 	dev_set_drvdata(&chip->dev, priv);
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
new file mode 100644
index 0000000..b28ed00
--- /dev/null
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2005, 2006 IBM Corporation
+ * Copyright (C) 2014, 2015 Intel Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG TPM Interface Spec version 1.2, revision 1.0.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __TPM_TIS_CORE_H__
+#define __TPM_TIS_CORE_H__
+
+#include "tpm.h"
+
+struct priv_data {
+	u16 manufacturer_id;
+	int locality;
+	int irq;
+	bool irq_tested;
+	wait_queue_head_t int_queue;
+	wait_queue_head_t read_queue;
+	void *phy_id;
+};
+
+#endif
-- 
2.5.0


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
