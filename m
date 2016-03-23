From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_tis: drop manufacturer_id from struct
	tpm_vendor_specific
Date: Wed, 23 Mar 2016 07:31:56 +0200
Message-ID: <1458711116-15898-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Dropped manufacturer_id from struct tpm_vendor_specific and redeclared
it in the private struct priv_data that tpm_tis uses because the field
is only used tpm_tis.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h     | 2 --
 drivers/char/tpm/tpm_tis.c | 7 +++++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index cbab4e9..fcd7f1e 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -145,8 +145,6 @@ struct tpm_vendor_specific {
 	void *priv;
 
 	wait_queue_head_t read_queue;
-
-	u16 manufacturer_id;
 };
 
 #define TPM_VPRIV(c)     ((c)->vendor.priv)
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 7d7a776..068f021 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -94,6 +94,7 @@ struct tpm_info {
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
 struct priv_data {
+	u16 manufacturer_id;
 	bool irq_tested;
 	wait_queue_head_t int_queue;
 };
@@ -516,7 +517,9 @@ out:
 
 static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 {
-	switch (chip->vendor.manufacturer_id) {
+	struct priv_data *priv = chip->vendor.priv;
+
+	switch (priv->manufacturer_id) {
 	case TPM_VID_WINBOND:
 		return ((status == TPM_STS_VALID) ||
 			(status == (TPM_STS_VALID | TPM_STS_COMMAND_READY)));
@@ -722,7 +725,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 		goto out_err;
 
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
-	chip->vendor.manufacturer_id = vendor;
+	priv->manufacturer_id = vendor;
 
 	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
-- 
2.7.3


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
