From: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/1] tpm_tis: convert to using locality
	callbacks
Date: Sat, 25 Mar 2017 13:05:21 -0700
Message-ID: <20170325200521.19224-2-jsnitsel@redhat.com>
References: <20170325200521.19224-1-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170325200521.19224-1-jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patch converts tpm_tis to use of the new tpm class ops
request_locality, and relinquish_locality.

With the move to using the callbacks, release_locality is changed so
that we now release the locality even if there is no request pending.

This required some changes to the tpm_tis_core_init code path to
make sure locality is requested when needed:

  - tpm2_probe code path will end up calling request/release through
    callbacks, so request_locality prior to tpm2_probe not needed.

  - probe_itpm makes calls to tpm_tis_send_data which no longer calls
    request_locality, so add request_locality prior to tpm_tis_send_data
    calls. Also drop release_locality call in middleof probe_itpm, and
    keep locality until release_locality called at end of probe_itpm.

Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Signed-off-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index f31fc831c8f9..4483f6f25e17 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -75,21 +75,11 @@ static bool check_locality(struct tpm_chip *chip, int l)
 	return false;
 }
 
-static void release_locality(struct tpm_chip *chip, int l, int force)
+static void release_locality(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
-	u8 access;
-
-	rc = tpm_tis_read8(priv, TPM_ACCESS(l), &access);
-	if (rc < 0)
-		return;
-
-	if (force || (access &
-		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
-	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
-		tpm_tis_write8(priv, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
 
+	tpm_tis_write8(priv, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
 }
 
 static int request_locality(struct tpm_chip *chip, int l)
@@ -254,7 +244,6 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 out:
 	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
 	return size;
 }
 
@@ -270,9 +259,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 	size_t count = 0;
 	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
 
-	if (request_locality(chip, 0) < 0)
-		return -EBUSY;
-
 	status = tpm_tis_status(chip);
 	if ((status & TPM_STS_COMMAND_READY) == 0) {
 		tpm_tis_ready(chip);
@@ -331,7 +317,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 
 out_err:
 	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
 	return rc;
 }
 
@@ -392,7 +377,6 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 	return len;
 out_err:
 	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
 	return rc;
 }
 
@@ -479,12 +463,14 @@ static int probe_itpm(struct tpm_chip *chip)
 	if (vendor != TPM_VID_INTEL)
 		return 0;
 
+	if (request_locality(chip, 0) != 0)
+		return -EBUSY;
+
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0)
 		goto out;
 
 	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
 
 	priv->flags |= TPM_TIS_ITPM_WORKAROUND;
 
@@ -498,7 +484,7 @@ static int probe_itpm(struct tpm_chip *chip)
 
 out:
 	tpm_tis_ready(chip);
-	release_locality(chip, priv->locality, 0);
+	release_locality(chip, priv->locality);
 
 	return rc;
 }
@@ -672,7 +658,7 @@ void tpm_tis_remove(struct tpm_chip *chip)
 		interrupt = 0;
 
 	tpm_tis_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
-	release_locality(chip, priv->locality, 1);
+	release_locality(chip, priv->locality);
 }
 EXPORT_SYMBOL_GPL(tpm_tis_remove);
 
@@ -686,6 +672,8 @@ static const struct tpm_class_ops tpm_tis = {
 	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
 	.req_canceled = tpm_tis_req_canceled,
+	.request_locality = request_locality,
+	.relinquish_locality = release_locality,
 };
 
 int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
@@ -728,11 +716,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	intmask &= ~TPM_GLOBAL_INT_ENABLE;
 	tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
 
-	if (request_locality(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
 	rc = tpm2_probe(chip);
 	if (rc)
 		goto out_err;
-- 
2.11.0.258.ge05806da9


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
