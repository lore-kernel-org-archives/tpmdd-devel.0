From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] tpm/tpm_crb: open code the crb_init into
	acpi_add
Date: Sat,  8 Oct 2016 14:59:38 +0300
Message-ID: <1475927979-23484-4-git-send-email-tomas.winkler@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475927979-23484-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is preparation step for implementing tpm crb
runtime pm. We need to have tpm chip allocated
and populated before we access the runtime handlers.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
V2: new in the series
V3: resend
V4: resend

 drivers/char/tpm/tpm_crb.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 4eb96b85c653..def50b7d47b2 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -266,21 +266,6 @@ static const struct tpm_class_ops tpm_crb = {
 	.req_complete_val = CRB_DRV_STS_COMPLETE,
 };
 
-static int crb_init(struct acpi_device *device, struct crb_priv *priv)
-{
-	struct tpm_chip *chip;
-
-	chip = tpmm_chip_alloc(&device->dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
-
-	dev_set_drvdata(&chip->dev, priv);
-	chip->acpi_dev_handle = device->handle;
-	chip->flags = TPM_CHIP_FLAG_TPM2;
-
-	return tpm_chip_register(chip);
-}
-
 static int crb_check_resource(struct acpi_resource *ares, void *data)
 {
 	struct resource *io_res = data;
@@ -402,6 +387,7 @@ static int crb_acpi_add(struct acpi_device *device)
 {
 	struct acpi_table_tpm2 *buf;
 	struct crb_priv *priv;
+	struct tpm_chip *chip;
 	struct device *dev = &device->dev;
 	acpi_status status;
 	u32 sm;
@@ -439,11 +425,19 @@ static int crb_acpi_add(struct acpi_device *device)
 	if (rc)
 		return rc;
 
+	chip = tpmm_chip_alloc(dev, &tpm_crb);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
+	dev_set_drvdata(&chip->dev, priv);
+	chip->acpi_dev_handle = device->handle;
+	chip->flags = TPM_CHIP_FLAG_TPM2;
+
 	rc  = crb_cmd_ready(dev, priv);
 	if (rc)
 		return rc;
 
-	rc = crb_init(device, priv);
+	rc = tpm_chip_register(chip);
 	if (rc)
 		crb_go_idle(dev, priv);
 
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
