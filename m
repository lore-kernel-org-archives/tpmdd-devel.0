From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 4/5] Initialize TPM and get durations and
	timeouts
Date: Mon,  8 Feb 2016 14:27:07 -0500
Message-ID: <1454959628-30582-5-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1454959628-30582-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
the startup of the TPM, do this for TPM 1.2 and TPM 2.

To not allow to interleave with commands from user space, so send the
TPM_Startup as the first command. The timeouts can then be gotten at any
later time, even interleaved with commands from user space.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-vtpm.c | 58 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/char/tpm/tpm-vtpm.c b/drivers/char/tpm/tpm-vtpm.c
index 6ee1e44..d9fd797 100644
--- a/drivers/char/tpm/tpm-vtpm.c
+++ b/drivers/char/tpm/tpm-vtpm.c
@@ -41,6 +41,7 @@ struct vtpm_dev {
 
 	long state;
 #define STATE_OPENED_BIT   0
+#define STATE_INIT_VTPM    1
 
 	spinlock_t buf_lock;         /* lock for buffers */
 
@@ -52,6 +53,8 @@ struct vtpm_dev {
 	size_t resp_len;             /* length of queued TPM response */
 	u8 resp_buf[TPM_BUFSIZE];    /* response buffer */
 
+	struct work_struct work;     /* task that retrieves TPM timeouts */
+
 	struct list_head list;
 };
 
@@ -292,6 +295,9 @@ static int vtpm_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	spin_unlock(&vtpm_dev->buf_lock);
 
+	/* sync for first startup command */
+	set_bit(STATE_INIT_VTPM, &vtpm_dev->state);
+
 	wake_up_interruptible(&vtpm_dev->wq);
 
 	return rc;
@@ -323,6 +329,52 @@ static const struct tpm_class_ops vtpm_tpm_ops = {
 };
 
 /*
+ * Code related to the startup of the TPM 2 and startup of TPM 1.2 +
+ * retrieval of timeouts and durations.
+ */
+
+static void vtpm_dev_work(struct work_struct *work)
+{
+	struct vtpm_dev *vtpm_dev = container_of(work, struct vtpm_dev, work);
+
+	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
+		tpm2_startup(vtpm_dev->chip, TPM2_SU_CLEAR);
+	else {
+		/* we must send TPM_Startup() first */
+		tpm_startup(vtpm_dev->chip, TPM_ST_CLEAR);
+		tpm_get_timeouts(vtpm_dev->chip);
+	}
+}
+
+/*
+ * vtpm_dev_start_work: Schedule the work for TPM 1.2 & 2 initialization
+ */
+static int vtpm_dev_start_work(struct vtpm_dev *vtpm_dev)
+{
+	int sig;
+
+	INIT_WORK(&vtpm_dev->work, vtpm_dev_work);
+	schedule_work(&vtpm_dev->work);
+
+	/* make sure we send the 1st command before user space can */
+	sig = wait_event_interruptible(vtpm_dev->wq,
+		test_bit(STATE_INIT_VTPM, &vtpm_dev->state));
+	if (sig) {
+		cancel_work_sync(&vtpm_dev->work);
+		return -EINTR;
+	}
+	return 0;
+}
+
+/*
+ * vtpm_dev_stop_work: prevent the scheduled work from running
+ */
+static void vtpm_dev_stop_work(struct vtpm_dev *vtpm_dev)
+{
+	cancel_work_sync(&vtpm_dev->work);
+}
+
+/*
  * Code related to creation and deletion of device pairs
  */
 static void vtpm_dev_release(struct device *dev)
@@ -449,6 +501,10 @@ static struct file *vtpm_create_device_pair(
 	}
 	vtpm_dev->chip = chip;
 
+	rc = vtpm_dev_start_work(vtpm_dev);
+	if (rc)
+		goto err_vtpm_fput;
+
 	vtpm_new_pair->fd = fd;
 	vtpm_new_pair->major = MAJOR(vtpm_dev->chip->dev.devt);
 	vtpm_new_pair->minor = MINOR(vtpm_dev->chip->dev.devt);
@@ -476,6 +532,8 @@ err_delete_vtpm_dev:
  */
 static void vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev)
 {
+	vtpm_dev_stop_work(vtpm_dev);
+
 	spin_lock(&driver_lock);
 	list_del_rcu(&vtpm_dev->list);
 	spin_unlock(&driver_lock);
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
