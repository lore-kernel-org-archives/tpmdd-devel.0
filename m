From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/4] tpm_crb: fix crb_req_canceled behavior
Date: Fri,  2 Sep 2016 22:34:17 +0300
Message-ID: <1472844861-24599-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1472844861-24599-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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

CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: 30fc8d138e91 ("tpm: TPM 2.0 CRB Interface")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 018c3825..1801f38 100644
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


------------------------------------------------------------------------------
