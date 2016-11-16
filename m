From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] tpm/vtpm: fix kdoc warnings
Date: Wed, 16 Nov 2016 19:03:41 +0200
Message-ID: <1479315821-27349-4-git-send-email-tomas.winkler@intel.com>
References: <1479315821-27349-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1479315821-27349-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Use corret kdoc format for function description and eliminate warning
of type:

tpm_ibmvtpm.c:66: warning: No description found for parameter 'count'

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm_ibmvtpm.c    | 51 +++++++++++++++++++--------------------
 drivers/char/tpm/tpm_vtpm_proxy.c | 48 +++++++++++++++++++++++++++---------
 2 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 946025a7413b..bd5da4beb012 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -40,11 +40,12 @@ MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
 
 /**
  * ibmvtpm_send_crq - Send a CRQ request
+ *
  * @vdev:	vio device struct
  * @w1:		first word
  * @w2:		second word
  *
- * Return value:
+ * Return:
  *	0 -Sucess
  *	Non-zero - Failure
  */
@@ -55,11 +56,12 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
 
 /**
  * tpm_ibmvtpm_recv - Receive data after send
+ *
  * @chip:	tpm chip struct
  * @buf:	buffer to read
- * count:	size of buffer
+ * @count:	size of buffer
  *
- * Return value:
+ * Return:
  *	Number of bytes read
  */
 static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
@@ -96,11 +98,12 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 /**
  * tpm_ibmvtpm_send - Send tpm request
+ *
  * @chip:	tpm chip struct
  * @buf:	buffer contains data to send
- * count:	size of buffer
+ * @count:	size of buffer
  *
- * Return value:
+ * Return:
  *	Number of bytes sent
  */
 static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
@@ -172,7 +175,7 @@ static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
  * ibmvtpm_crq_get_rtce_size - Send a CRQ request to get rtce size
  * @ibmvtpm:	vtpm device struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -199,7 +202,7 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
  *			   - Note that this is vtpm version and not tpm version
  * @ibmvtpm:	vtpm device struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -225,7 +228,7 @@ static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
  * ibmvtpm_crq_send_init_complete - Send a CRQ initialize complete message
  * @ibmvtpm:	vtpm device struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -245,7 +248,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
  * ibmvtpm_crq_send_init - Send a CRQ initialize message
  * @ibmvtpm:	vtpm device struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -265,7 +268,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
  * tpm_ibmvtpm_remove - ibm vtpm remove entry point
  * @vdev:	vio device struct
  *
- * Return value:
+ * Return:
  *	0
  */
 static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
@@ -303,7 +306,7 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
  * tpm_ibmvtpm_get_desired_dma - Get DMA size needed by this driver
  * @vdev:	vio device struct
  *
- * Return value:
+ * Return:
  *	Number of bytes the driver needs to DMA map
  */
 static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
@@ -325,7 +328,7 @@ static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
  * tpm_ibmvtpm_suspend - Suspend
  * @dev:	device struct
  *
- * Return value:
+ * Return:
  *	0
  */
 static int tpm_ibmvtpm_suspend(struct device *dev)
@@ -352,7 +355,7 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
  * ibmvtpm_reset_crq - Reset CRQ
  * @ibmvtpm:	ibm vtpm struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -378,7 +381,7 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
  * tpm_ibmvtpm_resume - Resume from suspend
  * @dev:	device struct
  *
- * Return value:
+ * Return:
  *	0
  */
 static int tpm_ibmvtpm_resume(struct device *dev)
@@ -434,10 +437,10 @@ static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
 
 /**
  * ibmvtpm_crq_get_next - Get next responded crq
- * @ibmvtpm	vtpm device struct
  *
- * Return value:
- *	vtpm crq pointer
+ * @ibmvtpm:	vtpm device struct
+ *
+ * Return: vtpm crq pointer or NULL
  */
 static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
 {
@@ -455,11 +458,10 @@ static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
 
 /**
  * ibmvtpm_crq_process - Process responded crq
- * @crq		crq to be processed
- * @ibmvtpm	vtpm device struct
  *
- * Return value:
- *	Nothing
+ * @crq:	crq to be processed
+ * @ibmvtpm:	vtpm device struct
+ *
  */
 static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
 				struct ibmvtpm_dev *ibmvtpm)
@@ -557,7 +559,7 @@ static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
  * @vio_dev:	vio device struct
  * @id:		vio device id struct
  *
- * Return value:
+ * Return:
  *	0 - Success
  *	Non-zero - Failure
  */
@@ -673,7 +675,7 @@ static struct vio_driver ibmvtpm_driver = {
 /**
  * ibmvtpm_module_init - Initialize ibm vtpm module
  *
- * Return value:
+ * Return:
  *	0 -Success
  *	Non-zero - Failure
  */
@@ -684,9 +686,6 @@ static int __init ibmvtpm_module_init(void)
 
 /**
  * ibmvtpm_module_exit - Teardown ibm vtpm module
- *
- * Return value:
- *	Nothing
  */
 static void __exit ibmvtpm_module_exit(void)
 {
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 3d6f6ca81def..f973d8840e07 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -64,7 +64,12 @@ static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
 /**
  * vtpm_proxy_fops_read - Read TPM commands on 'server side'
  *
- * Return value:
+ * @filp: file pointer
+ * @buf: read buffer
+ * @count: number of bytes to read
+ * @off: offset
+ *
+ * Return:
  *	Number of bytes read or negative error code
  */
 static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
@@ -114,7 +119,12 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
 /**
  * vtpm_proxy_fops_write - Write TPM responses on 'server side'
  *
- * Return value:
+ * @filp: file pointer
+ * @buf: write buffer
+ * @count: number of bytes to write
+ * @off: offset
+ *
+ * Return:
  *	Number of bytes read or negative error value
  */
 static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
@@ -154,10 +164,12 @@ static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
 }
 
 /*
- * vtpm_proxy_fops_poll: Poll status on 'server side'
+ * vtpm_proxy_fops_poll - Poll status on 'server side'
+ *
+ * @filp: file pointer
+ * @wait: poll table
  *
- * Return value:
- *      Poll flags
+ * Return: Poll flags
  */
 static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
 {
@@ -184,6 +196,8 @@ static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
 /*
  * vtpm_proxy_fops_open - Open vTPM device on 'server side'
  *
+ * @filp: file pointer
+ *
  * Called when setting up the anonymous file descriptor
  */
 static void vtpm_proxy_fops_open(struct file *filp)
@@ -195,8 +209,9 @@ static void vtpm_proxy_fops_open(struct file *filp)
 
 /**
  * vtpm_proxy_fops_undo_open - counter-part to vtpm_fops_open
+ *       Call to undo vtpm_proxy_fops_open
  *
- * Call to undo vtpm_proxy_fops_open
+ *@proxy_dev: tpm proxy device
  */
 static void vtpm_proxy_fops_undo_open(struct proxy_dev *proxy_dev)
 {
@@ -211,9 +226,11 @@ static void vtpm_proxy_fops_undo_open(struct proxy_dev *proxy_dev)
 }
 
 /*
- * vtpm_proxy_fops_release: Close 'server side'
+ * vtpm_proxy_fops_release - Close 'server side'
  *
- * Return value:
+ * @inode: inode
+ * @filp: file pointer
+ * Return:
  *      Always returns 0.
  */
 static int vtpm_proxy_fops_release(struct inode *inode, struct file *filp)
@@ -244,7 +261,10 @@ static const struct file_operations vtpm_proxy_fops = {
 /*
  * Called when core TPM driver reads TPM responses from 'server side'
  *
- * Return value:
+ * @chip: tpm chip to use
+ * @buf: receive buffer
+ * @count: bytes to read
+ * Return:
  *      Number of TPM response bytes read, negative error value otherwise
  */
 static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
@@ -281,7 +301,11 @@ static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 /*
  * Called when core TPM driver forwards TPM requests to 'server side'.
  *
- * Return value:
+ * @chip: tpm chip to use
+ * @buf: send buffer
+ * @count: bytes to send
+ *
+ * Return:
  *      0 in case of success, negative error value otherwise.
  */
 static int vtpm_proxy_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
@@ -444,7 +468,7 @@ static inline void vtpm_proxy_delete_proxy_dev(struct proxy_dev *proxy_dev)
 /*
  * Create a /dev/tpm%d and 'server side' file descriptor pair
  *
- * Return value:
+ * Return:
  *      Returns file pointer on success, an error value otherwise
  */
 static struct file *vtpm_proxy_create_device(
@@ -572,7 +596,7 @@ static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
 /*
  * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
  *
- * Return value:
+ * Return:
  *      Returns 0 on success, a negative error code otherwise.
  */
 static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
-- 
2.7.4


------------------------------------------------------------------------------
