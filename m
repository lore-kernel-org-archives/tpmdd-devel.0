From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] tpm: make check_locality return bool
Date: Sat, 18 Mar 2017 01:59:57 -0700
Message-ID: <20170318085957.12277-1-jsnitsel@redhat.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Since check_locality is checking to see if a certain
locality is active, return true if active otherwise
return false.

Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Tested tpm_tis, but don't have the ability to
test Infineon or STMicro drivers.

 drivers/char/tpm/st33zp24/st33zp24.c | 12 ++++++------
 drivers/char/tpm/tpm_i2c_infineon.c  | 12 ++++++------
 drivers/char/tpm/tpm_tis_core.c      | 20 +++++++++++---------
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index e8e0f7c02686..4d1dc8b46877 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -117,9 +117,9 @@ static u8 st33zp24_status(struct tpm_chip *chip)
 /*
  * check_locality if the locality is active
  * @param: chip, the tpm chip description
- * @return: the active locality or -EACCESS.
+ * @return: true if LOCALITY0 is active, otherwise false
  */
-static int check_locality(struct tpm_chip *chip)
+static bool check_locality(struct tpm_chip *chip)
 {
 	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
 	u8 data;
@@ -129,9 +129,9 @@ static int check_locality(struct tpm_chip *chip)
 	if (status && (data &
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return tpm_dev->locality;
+		return true;
 
-	return -EACCES;
+	return false;
 } /* check_locality() */
 
 /*
@@ -146,7 +146,7 @@ static int request_locality(struct tpm_chip *chip)
 	long ret;
 	u8 data;
 
-	if (check_locality(chip) == tpm_dev->locality)
+	if (check_locality(chip))
 		return tpm_dev->locality;
 
 	data = TPM_ACCESS_REQUEST_USE;
@@ -158,7 +158,7 @@ static int request_locality(struct tpm_chip *chip)
 
 	/* Request locality is usually effective after the request */
 	do {
-		if (check_locality(chip) >= 0)
+		if (check_locality(chip))
 			return tpm_dev->locality;
 		msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 62ee44e57ddc..dc47fa222a26 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -278,22 +278,22 @@ enum tis_defaults {
 #define	TPM_DATA_FIFO(l)		(0x0005 | ((l) << 4))
 #define	TPM_DID_VID(l)			(0x0006 | ((l) << 4))
 
-static int check_locality(struct tpm_chip *chip, int loc)
+static bool check_locality(struct tpm_chip *chip, int loc)
 {
 	u8 buf;
 	int rc;
 
 	rc = iic_tpm_read(TPM_ACCESS(loc), &buf, 1);
 	if (rc < 0)
-		return rc;
+		return false;
 
 	if ((buf & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
 		tpm_dev.locality = loc;
-		return loc;
+		return true;
 	}
 
-	return -EIO;
+	return false;
 }
 
 /* implementation similar to tpm_tis */
@@ -315,7 +315,7 @@ static int request_locality(struct tpm_chip *chip, int loc)
 	unsigned long stop;
 	u8 buf = TPM_ACCESS_REQUEST_USE;
 
-	if (check_locality(chip, loc) >= 0)
+	if (check_locality(chip, loc))
 		return loc;
 
 	iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
@@ -323,7 +323,7 @@ static int request_locality(struct tpm_chip *chip, int loc)
 	/* wait for burstcount */
 	stop = jiffies + chip->timeout_a;
 	do {
-		if (check_locality(chip, loc) >= 0)
+		if (check_locality(chip, loc))
 			return loc;
 		usleep_range(TPM_TIMEOUT_US_LOW, TPM_TIMEOUT_US_HI);
 	} while (time_before(jiffies, stop));
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index c0f296b5d413..93d641996249 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -56,7 +56,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
 	return -1;
 }
 
-static int check_locality(struct tpm_chip *chip, int l)
+static bool check_locality(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int rc;
@@ -64,13 +64,15 @@ static int check_locality(struct tpm_chip *chip, int l)
 
 	rc = tpm_tis_read8(priv, TPM_ACCESS(l), &access);
 	if (rc < 0)
-		return rc;
+		return false;
 
 	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
-		return priv->locality = l;
+	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
+		priv->locality = l;
+		return true;
+	}
 
-	return -1;
+	return false;
 }
 
 static void release_locality(struct tpm_chip *chip, int l, int force)
@@ -96,7 +98,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 	unsigned long stop, timeout;
 	long rc;
 
-	if (check_locality(chip, l) >= 0)
+	if (check_locality(chip, l))
 		return l;
 
 	rc = tpm_tis_write8(priv, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
@@ -112,7 +114,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 			return -1;
 		rc = wait_event_interruptible_timeout(priv->int_queue,
 						      (check_locality
-						       (chip, l) >= 0),
+						       (chip, l)),
 						      timeout);
 		if (rc > 0)
 			return l;
@@ -123,7 +125,7 @@ static int request_locality(struct tpm_chip *chip, int l)
 	} else {
 		/* wait for burstcount */
 		do {
-			if (check_locality(chip, l) >= 0)
+			if (check_locality(chip, l))
 				return l;
 			msleep(TPM_TIMEOUT);
 		} while (time_before(jiffies, stop));
@@ -533,7 +535,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 		wake_up_interruptible(&priv->read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
 		for (i = 0; i < 5; i++)
-			if (check_locality(chip, i) >= 0)
+			if (check_locality(chip, i))
 				break;
 	if (interrupt &
 	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
-- 
2.12.0.399.g9d77b0405ce6


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
