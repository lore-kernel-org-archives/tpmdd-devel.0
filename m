From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH] tpm_tis: fix iTPM probe via probe_itpm() function
Date: Thu, 12 Jan 2017 19:12:06 +0100
Message-ID: <6bd0d2fe-f979-a4dc-7c4d-54036f4d37f8@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Christophe Ricard <christophe.ricard@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: tpmdd-devel@lists.sourceforge.net

probe_itpm() function is supposed to send command without an itpm flag set
and if this fails to repeat it, this time with the itpm flag set.

However, commit 41a5e1cf1fe15 ("tpm/tpm_tis: Split tpm_tis driver into a
core and TCG TIS compliant phy") moved the itpm flag from an "itpm"
variable to a TPM_TIS_ITPM_POSSIBLE chip flag, so setting the
(now function-local) itpm variable no longer had any effect.

Finally, this function-local itpm variable was removed by
commit 56af322156dbe9 ("tpm/tpm_tis: remove unused itpm variable")

Tested only on non-iTPM TIS TPM.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

Fixes: 41a5e1cf1fe15 ("Split tpm_tis driver into a core and TCG TIS compliant phy")
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm_tis_core.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index e42e5a6a3c2f..401f1228547c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -467,6 +467,9 @@ static int probe_itpm(struct tpm_chip *chip)
 	size_t len = sizeof(cmd_getticks);
 	u16 vendor;
 
+	if (priv->flags & TPM_TIS_ITPM_POSSIBLE)
+		return 0;
+
 	rc = tpm_tis_read16(priv, TPM_DID_VID(0), &vendor);
 	if (rc < 0)
 		return rc;
@@ -482,12 +485,15 @@ static int probe_itpm(struct tpm_chip *chip)
 	tpm_tis_ready(chip);
 	release_locality(chip, priv->locality, 0);
 
+	priv->flags |= TPM_TIS_ITPM_POSSIBLE;
+
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
-	if (rc == 0) {
+	if (rc == 0)
 		dev_info(&chip->dev, "Detected an iTPM.\n");
-		rc = 1;
-	} else
+	else {
+		priv->flags &= ~TPM_TIS_ITPM_POSSIBLE;
 		rc = -EFAULT;
+	}
 
 out:
 	tpm_tis_ready(chip);
@@ -743,15 +749,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
 		 vendor >> 16, rid);
 
-	if (!(priv->flags & TPM_TIS_ITPM_POSSIBLE)) {
-		probe = probe_itpm(chip);
-		if (probe < 0) {
-			rc = -ENODEV;
-			goto out_err;
-		}
-
-		if (!!probe)
-			priv->flags |= TPM_TIS_ITPM_POSSIBLE;
+	probe = probe_itpm(chip);
+	if (probe < 0) {
+		rc = -ENODEV;
+		goto out_err;
 	}
 
 	/* Figure out the capabilities */
