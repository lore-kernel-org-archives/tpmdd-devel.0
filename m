From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] tpm: ibmvtpm: simplify crq initialization and document crq format
Date: Tue, 31 Jan 2017 15:17:34 +0100
Message-ID: <20170131141734.28534-1-msuchanek@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Ashley Lai <ashleydlai@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linuxppc-dev@lists.ozlabs.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Michal Suchanek <msuchanek@suse.de>
List-Id: tpmdd-devel@lists.sourceforge.net


The crq is passed in registers so is the same on BE and LE hosts.
However, current implementation allocates a structure on-stack to
represent the crq, initializes the members swapping them to BE, and
loads the structure swapping it from BE. This is pointless and causes
GCC warnings about ununitialized members. Get rid of the structure and
the warnings.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 92 +++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 946025a7413b..b6402b1b76fe 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -39,18 +39,58 @@ static struct vio_device_id tpm_ibmvtpm_device_table[] = {
 MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
 
 /**
+ *
+ * ibmvtpm_send_crq_word - Send a CRQ request
+ * @vdev:	vio device struct
+ * @w1:		pre-constructed first word of tmp crq (second word is reserved)
+ *
+ * Return value:
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
  * @vdev:	vio device struct
- * @w1:		first word
- * @w2:		second word
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
+ * to load into the registar avoiding byteswap altogether. Endian only affects
+ * memory loads and stores - registers are internally represented the same.
  *
  * Return value:
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
@@ -106,8 +146,6 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
-	struct ibmvtpm_crq crq;
-	__be64 *word = (__be64 *)&crq;
 	int rc, sig;
 
 	if (!ibmvtpm->rtce_buf) {
@@ -134,10 +172,6 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	spin_lock(&ibmvtpm->rtce_lock);
 	ibmvtpm->res_len = 0;
 	memcpy((void *)ibmvtpm->rtce_buf, (void *)buf, count);
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_TPM_COMMAND;
-	crq.len = cpu_to_be16(count);
-	crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);
 
 	/*
 	 * set the processing flag before the Hcall, since we may get the
@@ -145,8 +179,9 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
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
@@ -178,15 +213,10 @@ static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
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
@@ -205,15 +235,10 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
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
@@ -233,7 +258,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
 {
 	int rc;
 
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_COMP_CMD, 0);
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_COMP_CMD);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_send_init_complete failed rc=%d\n", rc);
@@ -253,7 +278,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
 {
 	int rc;
 
-	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_CMD, 0);
+	rc = ibmvtpm_send_crq_word(ibmvtpm->vdev, INIT_CRQ_CMD);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
 			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
@@ -332,15 +357,10 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
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
