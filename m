From: Ed Swierk <eswierk@skyportsystems.com>
Subject: [PATCH v9 1/5] tpm_tis: Improve reporting of IO errors
Date: Wed, 13 Jul 2016 09:19:32 -0700
Message-ID: <1468426776-42762-2-git-send-email-eswierk@skyportsystems.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com, eswierk@skyportsystems.com
List-Id: tpmdd-devel@lists.sourceforge.net

Mysterious TPM behavior can be difficult to track down through all the
layers of software. Add error messages for conditions that should
never happen. Also include the manufacturer ID along with other chip
data printed during init.

Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 8110b52..e62fdeb 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -217,6 +217,8 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	expected = be32_to_cpu(*(__be32 *) (buf + 2));
 	if (expected > count) {
+		dev_err(&chip->dev, "Response too long (wanted %zd, got %d)\n",
+			count, expected);
 		size = -EIO;
 		goto out;
 	}
@@ -283,6 +285,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 				  &priv->int_queue, false);
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
+			dev_err(&chip->dev, "Chip not accepting %zd bytes\n",
+				len - count);
 			rc = -EIO;
 			goto out_err;
 		}
@@ -297,6 +301,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 			  &priv->int_queue, false);
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
+		dev_err(&chip->dev, "Chip not accepting last byte\n");
 		rc = -EIO;
 		goto out_err;
 	}
@@ -707,8 +712,9 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	if (rc < 0)
 		goto out_err;
 
-	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+	dev_info(dev, "%s TPM (manufacturer-id 0x%X, device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+		 priv->manufacturer_id,
 		 vendor >> 16, rid);
 
 	if (!(priv->flags & TPM_TIS_ITPM_POSSIBLE)) {
-- 
1.9.1

