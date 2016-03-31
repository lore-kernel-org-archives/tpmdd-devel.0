From: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2] vTPM: fix missing error handling for
	suspend operation
Date: Thu, 31 Mar 2016 10:41:23 -0400
Message-ID: <1459435283-1163-1-git-send-email-honclo@linux.vnet.ibm.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

ibmvtpm_send_crq in tpm_ibmvtpm_suspend returns errors in a more
granular level than what the existing code does.  This patch adds
the missing CRQ transport event code checks to ensure appropriate
action taken, in the case that ibmvtpm_send_crq returns H_CLOSED.

Signed-off-by: Hon Ching(Vicky) Lo <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_ibmvtpm.c |   43 ++++++++++++++++++++++++++++++++++++---
 drivers/char/tpm/tpm_ibmvtpm.h |    7 ++++++
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 3e6a226..ea2a970 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -335,17 +335,46 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
 	struct ibmvtpm_crq crq;
 	u64 *buf = (u64 *) &crq;
 	int rc = 0;
+	int counter = 0;
+	int sig;
 
-	crq.valid = (u8)IBMVTPM_VALID_CMD;
-	crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
+suspend:
+	crq_initialized = 0;
+	crq.valid = (u8) IBMVTPM_VALID_CMD;
+	crq.msg = (u8) VTPM_PREPARE_TO_SUSPEND;
 
 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
 			      cpu_to_be64(buf[1]));
+
+	if ((rc == H_CLOSED) && (crq.valid == (u8) VALID_TRANSPORT_EVENT)) {
+		if (crq.msg == (u8) PARTNER_PARTITION_FAILED) {
+			dev_err(ibmvtpm->dev,
+				"vtpm has terminated fatally; reboot to reinstate a trusted state.\n");
+		}
+
+		if ((crq.msg == (u8) PARTNER_PARTITION_DEREG_CRQ)
+		    && (counter < 1)) {
+			counter++;
+
+			/* The vtpm is in the process of being reloaded by
+			 * firmware and has de-registered CRQ.  The client
+			 * must wait for the CRQ INITIALIZATION message and
+			 * respond and must resubmit suspend message.
+			 */
+			sig =
+			    wait_event_interruptible(ibmvtpm->wq,
+						     crq_initialized == 1);
+			if (sig)
+				return -EINTR;
+			goto suspend;
+		}
+	}
+
 	if (rc != H_SUCCESS)
-		dev_err(ibmvtpm->dev,
-			"tpm_ibmvtpm_suspend failed rc=%d\n", rc);
+		dev_err(ibmvtpm->dev, "tpm_ibmvtpm_suspend failed rc=%d\n", rc);
 
 	return rc;
+
 }
 
 /**
@@ -477,6 +506,9 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 		case INIT_CRQ_COMP_RES:
 			dev_info(ibmvtpm->dev,
 				 "CRQ initialization completed\n");
+			/* in case vtpm is being reloaded */
+			crq_initialized = 1;
+			wake_up_interruptible(&ibmvtpm->wq);
 			return;
 		default:
 			dev_err(ibmvtpm->dev, "Unknown crq message type: %d\n", crq->msg);
@@ -517,6 +549,9 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 			ibmvtpm->res_len = be16_to_cpu(crq->len);
 			wake_up_interruptible(&ibmvtpm->wq);
 			return;
+		case VTPM_PREPARE_TO_SUSPEND_RES:
+			dev_info(ibmvtpm->dev, "Prepare to Suspend Response\n");
+			return;
 		default:
 			return;
 		}
diff --git a/drivers/char/tpm/tpm_ibmvtpm.h b/drivers/char/tpm/tpm_ibmvtpm.h
index 6af9289..ed5fd5f 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.h
+++ b/drivers/char/tpm/tpm_ibmvtpm.h
@@ -73,4 +73,11 @@ struct ibmvtpm_dev {
 #define VTPM_PREPARE_TO_SUSPEND			0x04
 #define VTPM_PREPARE_TO_SUSPEND_RES		(0x04 | VTPM_MSG_RES)
 
+/* vTPM CRQ Transport Event codes */
+#define VALID_TRANSPORT_EVENT		0xFF
+#define PARTNER_PARTITION_FAILED	0x01
+#define PARTNER_PARTITION_DEREG_CRQ	0x02
+
+int crq_initialized;
+
 #endif
-- 
1.7.1


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
