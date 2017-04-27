From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Thu, 27 Apr 2017 11:26:59 -0700
Message-ID: <20170427182659.403-1-joshz@google.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

If a TPM2 loses power without a TPM2_Shutdown command being issued, it
may lose some state that has yet to be persisted to NVRam, and will
increment the DA counter (meaning that after too many disorderly
reboots, the TPM will lock the user out).

This is a variant of https://patchwork.kernel.org/patch/9516631/.
It differs in that:
  * It only changes behavior on TPM2 devices, to avoid invoking the
  unbounded-waiting sysfs codepath that was discussed on that patch.
  * It modifies tpm_tis rather than tpm_i2c_infineon, so that it can
  change behavior for all TPM2 devices.

Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..bd9c70b305ab 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -216,11 +216,23 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 	tpm_tis_remove(chip);
 }
 
+static void tpm_tis_pnp_shutdown(struct pnp_dev *dev)
+{
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	// TPM 2.0 requires that the TPM2_Shutdown() command be issued prior to loss of power.
+	// If it is not, the DA counter will be incremented and, eventually, the user will be
+	// locked out of their TPM.
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		tpm_tis_pnp_remove(dev);
+	}
+}
+
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
 	.remove = tpm_tis_pnp_remove,
+	.shutdown = tpm_tis_pnp_shutdown,
 	.driver	= {
 		.pm = &tpm_tis_pm,
 	},
-- 
2.13.0.rc0.306.g87b477812d-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
