From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] tpm: use get_unaligned_be32 unaligned buffer
	access.
Date: Wed, 23 Nov 2016 13:04:54 +0200
Message-ID: <1479899094-9486-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Use get_unaligned_be32 as b32_to_cpu doesn't work correctly on
all platforms for unaligned access.

The fix doesn't cover all the cases as also some cast
structures have members on unaligned addresses.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c    | 4 ++--
 drivers/char/tpm/tpm-sysfs.c        | 2 +-
 drivers/char/tpm/tpm.h              | 1 +
 drivers/char/tpm/tpm_crb.c          | 4 ++--
 drivers/char/tpm/tpm_i2c_infineon.c | 5 +++--
 drivers/char/tpm/tpm_i2c_nuvoton.c  | 7 ++++---
 drivers/char/tpm/tpm_nsc.c          | 4 +---
 drivers/char/tpm/tpm_tis_core.c     | 4 ++--
 8 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 769d8b0d31a3..4cf38d00d1b3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -353,8 +353,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	if (bufsiz > TPM_BUFSIZE)
 		bufsiz = TPM_BUFSIZE;
 
-	count = be32_to_cpu(*((__be32 *) (buf + 2)));
-	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+	count = get_unaligned_be32(buf + 2);
+	ordinal = get_unaligned_be32(buf + 6);
 	if (count == 0)
 		return -ENODATA;
 	if (count > bufsiz) {
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 848ad6580b46..2435d710b6af 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -71,7 +71,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 		    data[12], data[13], data[14], data[15],
 		    data[16], data[17], data[18], data[19],
 		    data[20], data[21], data[22], data[23],
-		    be32_to_cpu(*((__be32 *) (data + 24))));
+		    be32_to_cpup((__be32 *)(data + 24)));
 
 	for (i = 0; i < 256; i++) {
 		str += sprintf(str, "%02X ", data[i + 28]);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 1ae976894257..83dba0ff5ea0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -23,6 +23,7 @@
 #ifndef __TPM_H__
 #define __TPM_H__
 
+#include <asm/unaligned.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65040d74bb02..8067cfbfdbe2 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -168,7 +168,7 @@ static u8 crb_status(struct tpm_chip *chip)
 static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
-	unsigned int expected;
+	u32 expected;
 
 	/* sanity check */
 	if (count < 6)
@@ -178,7 +178,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return -EIO;
 
 	memcpy_fromio(buf, priv->rsp, 6);
-	expected = be32_to_cpup((__be32 *) &buf[2]);
+	expected = get_unaligned_be32(buf + 2);
 
 	if (expected > count)
 		return -EIO;
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 62ee44e57ddc..2dd4e3bb14c7 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -437,7 +437,8 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	int size = 0;
-	int expected, status;
+	u32 expected;
+	int status;
 
 	if (count < TPM_HEADER_SIZE) {
 		size = -EIO;
@@ -451,7 +452,7 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	expected = be32_to_cpu(*(__be32 *)(buf + 2));
+	expected = get_unaligned_be32(buf + 2);
 	if ((size_t) expected > count) {
 		size = -EIO;
 		goto out;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index e3a9155ee671..7ba9c435da4e 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -273,7 +273,8 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	struct device *dev = chip->dev.parent;
 	struct i2c_client *client = to_i2c_client(dev);
 	s32 rc;
-	int expected, status, burst_count, retries, size = 0;
+	int status, burst_count, retries, size = 0;
+	u32 expected;
 
 	if (count < TPM_HEADER_SIZE) {
 		i2c_nuvoton_ready(chip);    /* return to idle */
@@ -314,7 +315,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		 * convert number of expected bytes field from big endian 32 bit
 		 * to machine native
 		 */
-		expected = be32_to_cpu(*(__be32 *) (buf + 2));
+		expected = get_unaligned_be32(buf + 2);
 		if (expected > count) {
 			dev_err(dev, "%s() expected > count\n", __func__);
 			size = -EIO;
@@ -442,7 +443,7 @@ static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		i2c_nuvoton_ready(chip);
 		return rc;
 	}
-	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+	ordinal = get_unaligned_be32(buf + 6);
 	rc = i2c_nuvoton_wait_for_data_avail(chip,
 					     tpm_calc_ordinal_duration(chip,
 								       ordinal),
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 9ff0e072c476..99a8ff6ea37d 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -131,7 +131,6 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 	u8 *buffer = buf;
 	u8 data, *p;
 	u32 size;
-	__be32 *native_size;
 
 	if (count < 6)
 		return -EIO;
@@ -174,8 +173,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 	}
 
-	native_size = (__force __be32 *) (buf + 2);
-	size = be32_to_cpu(*native_size);
+	size = get_unaligned_be32(buf + 2);
 
 	if (count < size)
 		return -EIO;
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 7993678954a2..5323c54dc917 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -222,7 +222,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
-	expected = be32_to_cpu(*(__be32 *) (buf + 2));
+	expected = get_unaligned_be32(buf + 2);
 	if (expected > count) {
 		size = -EIO;
 		goto out;
@@ -371,7 +371,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 		goto out_err;
 
 	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
-		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+		ordinal = get_unaligned_be32(buf + 6);
 
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			dur = tpm2_calc_ordinal_duration(chip, ordinal);
-- 
2.7.4


------------------------------------------------------------------------------
