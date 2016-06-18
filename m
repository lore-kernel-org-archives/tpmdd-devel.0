From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 1/3] tpm_crb: fix crb_req_canceled behavior
Date: Sat, 18 Jun 2016 17:10:26 +0200
Message-ID: <1466262628-25530-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1466262628-25530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466262628-25530-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
index 1b8e1b5..8819ef7 100644
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
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
