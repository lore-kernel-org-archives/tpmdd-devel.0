From: SZ Lin <sz.lin@moxa.com>
Subject: [PATCH 4/5] Remove unneccessary 'out of memory' message
Date: Sat, 29 Jul 2017 15:24:32 +0800
Message-ID: <20170729072433.13194-5-sz.lin@moxa.com>
References: <20170729072433.13194-1-sz.lin@moxa.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170729072433.13194-1-sz.lin@moxa.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ashleydlai@gmail.com
Cc: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, peterhuewe@gmx.de, tpmdd@selhorst.ne, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, SZ Lin <sz.lin@moxa.com>
List-Id: tpmdd-devel@lists.sourceforge.net

WARNING: Possible unnecessary 'out of memory' message
+                       if (!ibmvtpm->rtce_buf) {
+                               dev_err(ibmvtpm->dev, "Failed to allocate memory for rtce buffer\n");

WARNING: Possible unnecessary 'out of memory' message
+       if (!ibmvtpm) {
+               dev_err(dev, "kzalloc for ibmvtpm failed\n");

Signed-off-by: SZ Lin <sz.lin@moxa.com>
---
 drivers/char/tpm/tpm_ibmvtpm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index e53b9fb517d9..e75a674b44ac 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -501,10 +501,8 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 			ibmvtpm->rtce_size = be16_to_cpu(crq->len);
 			ibmvtpm->rtce_buf = kmalloc(ibmvtpm->rtce_size,
 						    GFP_ATOMIC);
-			if (!ibmvtpm->rtce_buf) {
-				dev_err(ibmvtpm->dev, "Failed to allocate memory for rtce buffer\n");
+			if (!ibmvtpm->rtce_buf)
 				return;
-			}
 
 			ibmvtpm->rtce_dma_handle = dma_map_single(ibmvtpm->dev,
 				ibmvtpm->rtce_buf, ibmvtpm->rtce_size,
@@ -584,10 +582,8 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 		return PTR_ERR(chip);
 
 	ibmvtpm = kzalloc(sizeof(struct ibmvtpm_dev), GFP_KERNEL);
-	if (!ibmvtpm) {
-		dev_err(dev, "kzalloc for ibmvtpm failed\n");
+	if (!ibmvtpm)
 		goto cleanup;
-	}
 
 	ibmvtpm->dev = dev;
 	ibmvtpm->vdev = vio_dev;
-- 
2.13.3
