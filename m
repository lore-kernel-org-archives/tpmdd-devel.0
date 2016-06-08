From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 1/4] tpm_tis: Improve reporting of IO errors
Date: Tue,  7 Jun 2016 17:45:37 -0700
Message-ID: <1465346740-60120-2-git-send-email-eswierk@skyportsystems.com>
References: <1465346740-60120-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465346740-60120-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Mysterious TPM behavior can be difficult to track down through all the
layers of software. Add error messages for conditions that should
never happen. Also include the manufacturer ID along with other chip
data printed during init.

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 65f7eec..088fa86 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -299,6 +299,8 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	expected = be32_to_cpu(*(__be32 *) (buf + 2));
 	if (expected > count) {
+		dev_err(chip->pdev, "Response too long (wanted %zd, got %d)\n",
+			count, expected);
 		size = -EIO;
 		goto out;
 	}
@@ -366,6 +368,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 				  &chip->vendor.int_queue, false);
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
+			dev_err(chip->pdev, "Chip not accepting %zd bytes\n",
+				len - count);
 			rc = -EIO;
 			goto out_err;
 		}
@@ -378,6 +382,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 			  &chip->vendor.int_queue, false);
 	status = tpm_tis_status(chip);
 	if ((status & TPM_STS_DATA_EXPECT) != 0) {
+		dev_err(chip->pdev, "Chip not accepting last byte\n");
 		rc = -EIO;
 		goto out_err;
 	}
@@ -689,8 +694,9 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 	chip->vendor.manufacturer_id = vendor;
 
-	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+	dev_info(dev, "%s TPM (manufacturer-id 0x%X, device-id 0x%X, rev-id %d)\n",
 		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
+		 chip->vendor.manufacturer_id,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
