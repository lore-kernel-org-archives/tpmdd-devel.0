From: Michal Suchanek <msuchanek-l3A5Bk7waGM@public.gmane.org>
Subject: [RFT PATCH] tpm: ibmvtpm: simplify crq initialization
	and document crq format
Date: Fri, 24 Feb 2017 20:35:16 +0100
Message-ID: <20170224193516.9342-1-msuchanek@suse.de>
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
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Ashley Lai <ashleydlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michal Suchanek <msuchanek-l3A5Bk7waGM@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The crq is passed in registers and is the same on BE and LE hosts.
However, current implementation allocates a structure on-stack to
represent the crq, initializes the members swapping them to BE, and
loads the structure swapping it from BE. This is pointless and causes
GCC warnings about ununitialized members. Get rid of the structure and
the warnings.

Signed-off-by: Michal Suchanek <msuchanek-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
v2

fix typos and spelling in comments
---
 drivers/char/tpm/tpm_ibmvtpm.c | 96 ++++++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 1b9d61ffe991..89027339d55f 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -39,19 +39,63 @@ static struct vio_device_id tpm_ibmvtpm_device_table[] = {
 MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
 
 /**
+ *
+ * ibmvtpm_send_crq_word - Send a CRQ request
+ * @vdev:	vio device struct
+ * @w1:		pre-constructed first word of tpm crq (second word is reserved)
+ *
+ * Return:
+ *	0 - Success
+ *	Non-zero - Failure
+ */
+static int ibmvtpm_send_crq_word(struct vio_dev *vdev, u64 w1)
+{
+	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, w1, 0);
+}
+
+/**
+ *
  * ibmvtpm_send_crq - Send a CRQ request
  *
  * @vdev:	vio device struct
- * @w1:		first word
- * @w2:		second word
+ * @valid:	Valid field
+ * @msg:	Type field
+ * @len:	Length field
+ * @data:	Data field
+ *
+ * The ibmvtpm crq is defined as follows:
+ *
+ * Byte  |   0   |   1   |   2   |   3   |   4   |   5   |   6   |   7
+ * -----------------------------------------------------------------------
+ * Word0 | Valid | Type  |     Length    |              Data
+ * -----------------------------------------------------------------------
+ * Word1 |                Reserved
+ * -----------------------------------------------------------------------
+ *
+ * Which matches the following structure (on bigendian host):
+ *
+ * struct ibmvtpm_crq {
+ *         u8 valid;
+ *         u8 msg;
+ *         __be16 len;
+ *         __be32 data;
+ *         __be64 reserved;
+ * } __attribute__((packed, aligned(8)));
+ *
+ * However, the value is passed in a register so just compute the numeric value
+ * to load into the register avoiding byteswap altogether. Endian only affects
+ * memory loads and stores - registers are internally represented the same.
  *
  * Return:
- *	0 -Sucess
+ *	0 (H_SUCCESS) - Success
  *	Non-zero - Failure
  */
-static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
+static int ibmvtpm_send_crq(struct vio_dev *vdev,
+		u8 valid, u8 msg, u16 len, u32 data)
 {
-	return plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, w1, w2);
+	u64 w1 = ((u64)valid << 56) | ((u64)msg << 48) | ((u64)len << 32) |
+		(u64)data;
+	return ibmvtpm_send_crq_word(vdev, w1);
 }
 
 /**
@@ -109,8 +153,6 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
-	struct ibmvtpm_crq crq;
-	__be64 *word = (__be64 *)&crq;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -137,10 +179,6 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	spin_lock(&ibmvtpm->rtce_lock);
 	ibmvtpm->res_len = 0;
 	memcpy((void *)ibmvtpm->rtce_buf, (void *)buf, count);
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_TPM_COMMAND;
-	crq.len = cpu_to_be16(count);
-	crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);
 
 	/*
 	 * set the processing flag before the Hcall, since we may get the
@@ -148,8 +186,9 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	 */
 	ibmvtpm->tpm_processing_cmd = true;
 
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
-			      be64_to_cpu(word[1]));
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
+			IBMVTPM_VALID_CMD, VTPM_TPM_COMMAND,
+			count, ibmvtpm->rtce_dma_handle);
 	if (rc != H_SUCCESS) {
 		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
 		rc = 0;
@@ -182,15 +221,10 @@ static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
  */
 static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
 {
-	struct ibmvtpm_crq crq;
-	u64 *buf = (u64 *) &crq;
 	int rc;
 
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_GET_RTCE_BUFFER_SIZE;
-
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
-			      cpu_to_be64(buf[1]));
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
+			IBMVTPM_VALID_CMD, VTPM_GET_RTCE_BUFFER_SIZE, 0, 0);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_get_rtce_size failed rc=%d\n", rc);
@@ -210,15 +244,10 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
  */
 static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
 {
-	struct ibmvtpm_crq crq;
-	u64 *buf = (u64 *) &crq;
 	int rc;
 
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_GET_VERSION;
-
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
-			      cpu_to_be64(buf[1]));
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
+			IBMVTPM_VALID_CMD, VTPM_GET_VERSION, 0, 0);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_get_version failed rc=%d\n", rc);
@@ -238,7 +267,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
 {
 	int rc;
 
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_COMP_CMD, 0);
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_COMP_CMD);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_send_init_complete failed rc=%d\n", rc);
@@ -258,7 +287,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
 {
 	int rc;
 
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_CMD, 0);
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
@@ -336,15 +365,10 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
-	struct ibmvtpm_crq crq;
-	u64 *buf = (u64 *) &crq;
 	int rc = 0;
 
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
-
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
-			      cpu_to_be64(buf[1]));
+	rc = ibmvtpm_send_crq(ibmvtpm->vdev,
+			IBMVTPM_VALID_CMD, VTPM_PREPARE_TO_SUSPEND, 0, 0);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
-- 
2.10.2


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
