From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 1/3] tpm_crb: fix crb_req_canceled behavior
Date: Wed,  8 Jun 2016 02:02:00 +0300
Message-ID: <1465340522-1112-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The req_canceled() callback is used by tpm_transmit() periodically to
check whether the request has been canceled while it is receiving a
response from the TPM.

The TPM_CRB_CTRL_CANCEL register was cleared already in the crb_cancel
callback, which has two consequences:

* Cancel might not happen.
* req_canceled() always returns zero.

A better place to clear the register is when starting to send a new
command. The behavior of TPM_CRB_CTRL_CANCEL is described in the
section 5.5.3.6 of the PTP specification.

CC: stable@vger.kernel.org
Fixes: 30fc8d138e91 ("tpm: TPM 2.0 CRB Interface")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_crb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 1547636..b4d46ae 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -142,6 +142,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 	int rc = 0;
 
+	/* Zero the cancel register so that the next command will not get
+	 * canceled.
+	 */
+	iowrite32(0, &priv->cca->cancel);
+
 	if (len > ioread32(&priv->cca->cmd_size)) {
 		dev_err(&chip->dev,
 			"invalid command count value %x %zx\n",
@@ -175,8 +180,6 @@ static void crb_cancel(struct tpm_chip *chip)
 
 	if ((priv->flags & CRB_FL_ACPI_START) && crb_do_acpi_start(chip))
 		dev_err(&chip->dev, "ACPI Start failed\n");
-
-	iowrite32(0, &priv->cca->cancel);
 }
 
 static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
-- 
2.7.4
