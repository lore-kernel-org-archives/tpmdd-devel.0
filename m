From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 09/10] tpm: Initialize TPM and get
	durations and timeouts
Date: Mon, 29 Feb 2016 12:29:55 -0500
Message-ID: <1456766996-9300-10-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1456766996-9300-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add the retrieval of TPM 1.2 durations and timeouts. Since this requires
the startup of the TPM, do this for TPM 1.2 and TPM 2.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-vtpm.c | 85 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm-vtpm.c b/drivers/char/tpm/tpm-vtpm.c
index 2c69363..d0df2b4 100644
--- a/drivers/char/tpm/tpm-vtpm.c
+++ b/drivers/char/tpm/tpm-vtpm.c
@@ -45,8 +45,11 @@ struct vtpm_dev {
 	size_t req_len;              /* length of queued TPM request */
 	size_t resp_len;             /* length of queued TPM response */
 	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
+
+	struct work_struct work;     /* task that retrieves TPM timeouts */
 };
 
+static struct workqueue_struct *workqueue;
 
 static void vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev);
 
@@ -67,6 +70,9 @@ static ssize_t vtpm_fops_read(struct file *filp, char __user *buf,
 	size_t len;
 	int sig, rc;
 
+	if (!(vtpm_dev->state & STATE_OPENED_FLAG))
+		return -EPIPE;
+
 	sig = wait_event_interruptible(vtpm_dev->wq, vtpm_dev->req_len != 0);
 	if (sig)
 		return -EINTR;
@@ -108,6 +114,9 @@ static ssize_t vtpm_fops_write(struct file *filp, const char __user *buf,
 {
 	struct vtpm_dev *vtpm_dev = filp->private_data;
 
+	if (!(vtpm_dev->state & STATE_OPENED_FLAG))
+		return -EPIPE;
+
 	if (count > sizeof(vtpm_dev->buffer) ||
 	    !(vtpm_dev->state & STATE_WAIT_RESPONSE_FLAG))
 		return -EIO;
@@ -148,6 +157,8 @@ static unsigned int vtpm_fops_poll(struct file *filp, poll_table *wait)
 	ret = POLLOUT;
 	if (vtpm_dev->req_len)
 		ret |= POLLIN | POLLRDNORM;
+	if (!(vtpm_dev->state & STATE_OPENED_FLAG))
+		ret |= POLLHUP;
 
 	return ret;
 }
@@ -321,6 +332,54 @@ static const struct tpm_class_ops vtpm_tpm_ops = {
 };
 
 /*
+ * Code related to the startup of the TPM 2 and startup of TPM 1.2 +
+ * retrieval of timeouts and durations.
+ */
+
+static void vtpm_dev_work(struct work_struct *work)
+{
+	struct vtpm_dev *vtpm_dev = container_of(work, struct vtpm_dev, work);
+	int rc;
+
+	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
+		rc = tpm2_startup(vtpm_dev->chip, TPM2_SU_CLEAR);
+	else
+		rc = tpm_get_timeouts(vtpm_dev->chip);
+
+	if (rc)
+		goto err;
+
+	rc = tpm_chip_register(vtpm_dev->chip);
+	if (rc)
+		goto err;
+
+	return;
+
+err:
+	vtpm_fops_undo_open(vtpm_dev);
+}
+
+/*
+ * vtpm_dev_work_stop: make sure the work has finished
+ *
+ * This function is useful when user space closed the fd
+ * while the driver still determines timeouts.
+ */
+static void vtpm_dev_work_stop(struct vtpm_dev *vtpm_dev)
+{
+	vtpm_fops_undo_open(vtpm_dev);
+	flush_work(&vtpm_dev->work);
+}
+
+/*
+ * vtpm_dev_work_start: Schedule the work for TPM 1.2 & 2 initialization
+ */
+static inline void vtpm_dev_work_start(struct vtpm_dev *vtpm_dev)
+{
+	queue_work(workqueue, &vtpm_dev->work);
+}
+
+/*
  * Code related to creation and deletion of device pairs
  */
 static struct vtpm_dev *vtpm_create_vtpm_dev(void)
@@ -335,6 +394,7 @@ static struct vtpm_dev *vtpm_create_vtpm_dev(void)
 
 	init_waitqueue_head(&vtpm_dev->wq);
 	mutex_init(&vtpm_dev->buf_lock);
+	INIT_WORK(&vtpm_dev->work, vtpm_dev_work);
 
 	chip = tpm_chip_alloc(NULL, &vtpm_tpm_ops);
 	if (IS_ERR(chip)) {
@@ -404,9 +464,7 @@ static struct file *vtpm_create_device_pair(
 	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
 		vtpm_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
 
-	rc = tpm_chip_register(vtpm_dev->chip);
-	if (rc)
-		goto err_vtpm_fput;
+	vtpm_dev_work_start(vtpm_dev);
 
 	vtpm_new_pair->fd = fd;
 	vtpm_new_pair->major = MAJOR(vtpm_dev->chip->dev.devt);
@@ -415,12 +473,6 @@ static struct file *vtpm_create_device_pair(
 
 	return file;
 
-err_vtpm_fput:
-	put_unused_fd(fd);
-	fput(file);
-
-	return ERR_PTR(rc);
-
 err_put_unused_fd:
 	put_unused_fd(fd);
 
@@ -435,6 +487,8 @@ err_delete_vtpm_dev:
  */
 static void vtpm_delete_device_pair(struct vtpm_dev *vtpm_dev)
 {
+	vtpm_dev_work_stop(vtpm_dev);
+
 	tpm_chip_unregister(vtpm_dev->chip);
 
 	vtpm_fops_undo_open(vtpm_dev);
@@ -529,11 +583,24 @@ static int __init vtpm_module_init(void)
 		return rc;
 	}
 
+	workqueue = create_workqueue("tpm-vtpm");
+	if (!workqueue) {
+		pr_err("couldn't create workqueue\n");
+		rc = -ENOMEM;
+		goto err_vtpmx_cleanup;
+	}
+
 	return 0;
+
+err_vtpmx_cleanup:
+	vtpmx_cleanup();
+
+	return rc;
 }
 
 static void __exit vtpm_module_exit(void)
 {
+	destroy_workqueue(workqueue);
 	vtpmx_cleanup();
 }
 
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
