From: SZ Lin <sz.lin@moxa.com>
Subject: [PATCH 5/5] Use __func__ instead of function name
Date: Sat, 29 Jul 2017 15:24:33 +0800
Message-ID: <20170729072433.13194-6-sz.lin@moxa.com>
References: <20170729072433.13194-1-sz.lin@moxa.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-1-sz.lin@moxa.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, SZ Lin <sz.lin@moxa.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Fix following checkpatch.pl warning:
WARNING: Prefer using '"%s...", __func__' to using
the function's name, in a string

Signed-off-by: SZ Lin <sz.lin@moxa.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index e75a674b44ac..2d33acc43e25 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -151,7 +151,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
 			      be64_to_cpu(word[1]));
 	if (rc != H_SUCCESS) {
-		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_send failed rc=%d\n", rc);
+		dev_err(ibmvtpm->dev, "%s failed rc=%d\n", __func__, rc);
 		rc = 0;
 		ibmvtpm->tpm_processing_cmd = false;
 	} else
@@ -193,7 +193,7 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
 			      cpu_to_be64(buf[1]));
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_get_rtce_size failed rc=%d\n", rc);
+			"%s failed rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -221,7 +221,7 @@ static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
 			      cpu_to_be64(buf[1]));
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_get_version failed rc=%d\n", rc);
+			"%s failed rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -241,7 +241,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_COMP_CMD, 0);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_send_init_complete failed rc=%d\n", rc);
+			"%s rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -261,7 +261,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, INIT_CRQ_CMD, 0);
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
-			"ibmvtpm_crq_send_init failed rc=%d\n", rc);
+			"%s failed rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -351,7 +351,7 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
 			      cpu_to_be64(buf[1]));
 	if (rc != H_SUCCESS)
 		dev_err(ibmvtpm->dev,
-			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
+			"%s failed rc=%d\n", __func__, rc);
 
 	return rc;
 }
-- 
2.13.3
