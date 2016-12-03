From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 4/4] tpm/vtpm: fix kdoc warnings
Date: Sat, 3 Dec 2016 17:36:04 +0200
Message-ID: <20161203153604.pt5rnnhvovudku6r@intel.com>
References: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
 <1479895454-15076-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479895454-15076-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 12:04:14PM +0200, Tomas Winkler wrote:
> Use corret kdoc format for function description and eliminate warning
> of type:
> 
> tpm_ibmvtpm.c:66: warning: No description found for parameter 'count'
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkkko

> ---
> V2: more fixes
>  drivers/char/tpm/tpm_ibmvtpm.c    | 106 ++++++++++++++++++++------------------
>  drivers/char/tpm/tpm_vtpm_proxy.c |  48 ++++++++++++-----
>  2 files changed, 91 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index 946025a7413b..1b9d61ffe991 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -40,11 +40,12 @@ MODULE_DEVICE_TABLE(vio, tpm_ibmvtpm_device_table);
>  
>  /**
>   * ibmvtpm_send_crq - Send a CRQ request
> + *
>   * @vdev:	vio device struct
>   * @w1:		first word
>   * @w2:		second word
>   *
> - * Return value:
> + * Return:
>   *	0 -Sucess
>   *	Non-zero - Failure
>   */
> @@ -55,11 +56,12 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
>  
>  /**
>   * tpm_ibmvtpm_recv - Receive data after send
> + *
>   * @chip:	tpm chip struct
>   * @buf:	buffer to read
> - * count:	size of buffer
> + * @count:	size of buffer
>   *
> - * Return value:
> + * Return:
>   *	Number of bytes read
>   */
>  static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> @@ -96,12 +98,13 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  /**
>   * tpm_ibmvtpm_send - Send tpm request
> + *
>   * @chip:	tpm chip struct
>   * @buf:	buffer contains data to send
> - * count:	size of buffer
> + * @count:	size of buffer
>   *
> - * Return value:
> - *	Number of bytes sent
> + * Return:
> + *	Number of bytes sent or < 0 on error.
>   */
>  static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> @@ -170,11 +173,12 @@ static u8 tpm_ibmvtpm_status(struct tpm_chip *chip)
>  
>  /**
>   * ibmvtpm_crq_get_rtce_size - Send a CRQ request to get rtce size
> + *
>   * @ibmvtpm:	vtpm device struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -197,11 +201,12 @@ static int ibmvtpm_crq_get_rtce_size(struct ibmvtpm_dev *ibmvtpm)
>  /**
>   * ibmvtpm_crq_get_version - Send a CRQ request to get vtpm version
>   *			   - Note that this is vtpm version and not tpm version
> + *
>   * @ibmvtpm:	vtpm device struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -225,9 +230,9 @@ static int ibmvtpm_crq_get_version(struct ibmvtpm_dev *ibmvtpm)
>   * ibmvtpm_crq_send_init_complete - Send a CRQ initialize complete message
>   * @ibmvtpm:	vtpm device struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -245,9 +250,9 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
>   * ibmvtpm_crq_send_init - Send a CRQ initialize message
>   * @ibmvtpm:	vtpm device struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -265,8 +270,7 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
>   * tpm_ibmvtpm_remove - ibm vtpm remove entry point
>   * @vdev:	vio device struct
>   *
> - * Return value:
> - *	0
> + * Return: Always 0.
>   */
>  static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>  {
> @@ -303,18 +307,19 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>   * tpm_ibmvtpm_get_desired_dma - Get DMA size needed by this driver
>   * @vdev:	vio device struct
>   *
> - * Return value:
> - *	Number of bytes the driver needs to DMA map
> + * Return:
> + *	Number of bytes the driver needs to DMA map.
>   */
>  static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
>  	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  
> -	/* ibmvtpm initializes at probe time, so the data we are
> -	* asking for may not be set yet. Estimate that 4K required
> -	* for TCE-mapped buffer in addition to CRQ.
> -	*/
> +	/*
> +	 * ibmvtpm initializes at probe time, so the data we are
> +	 * asking for may not be set yet. Estimate that 4K required
> +	 * for TCE-mapped buffer in addition to CRQ.
> +	 */
>  	if (!ibmvtpm)
>  		return CRQ_RES_BUF_SIZE + PAGE_SIZE;
>  
> @@ -325,8 +330,7 @@ static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>   * tpm_ibmvtpm_suspend - Suspend
>   * @dev:	device struct
>   *
> - * Return value:
> - *	0
> + * Return: Always 0.
>   */
>  static int tpm_ibmvtpm_suspend(struct device *dev)
>  {
> @@ -350,11 +354,12 @@ static int tpm_ibmvtpm_suspend(struct device *dev)
>  
>  /**
>   * ibmvtpm_reset_crq - Reset CRQ
> + *
>   * @ibmvtpm:	ibm vtpm struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -376,10 +381,10 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
>  
>  /**
>   * tpm_ibmvtpm_resume - Resume from suspend
> + *
>   * @dev:	device struct
>   *
> - * Return value:
> - *	0
> + * Return: Always 0.
>   */
>  static int tpm_ibmvtpm_resume(struct device *dev)
>  {
> @@ -434,10 +439,10 @@ static const struct dev_pm_ops tpm_ibmvtpm_pm_ops = {
>  
>  /**
>   * ibmvtpm_crq_get_next - Get next responded crq
> - * @ibmvtpm	vtpm device struct
>   *
> - * Return value:
> - *	vtpm crq pointer
> + * @ibmvtpm:	vtpm device struct
> + *
> + * Return: vtpm crq pointer or NULL.
>   */
>  static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
>  {
> @@ -455,11 +460,10 @@ static struct ibmvtpm_crq *ibmvtpm_crq_get_next(struct ibmvtpm_dev *ibmvtpm)
>  
>  /**
>   * ibmvtpm_crq_process - Process responded crq
> - * @crq		crq to be processed
> - * @ibmvtpm	vtpm device struct
>   *
> - * Return value:
> - *	Nothing
> + * @crq:	crq to be processed
> + * @ibmvtpm:	vtpm device struct
> + *
>   */
>  static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
>  				struct ibmvtpm_dev *ibmvtpm)
> @@ -528,6 +532,7 @@ static void ibmvtpm_crq_process(struct ibmvtpm_crq *crq,
>  
>  /**
>   * ibmvtpm_interrupt -	Interrupt handler
> + *
>   * @irq:		irq number to handle
>   * @vtpm_instance:	vtpm that received interrupt
>   *
> @@ -554,12 +559,13 @@ static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
>  
>  /**
>   * tpm_ibmvtpm_probe - ibm vtpm initialize entry point
> + *
>   * @vio_dev:	vio device struct
>   * @id:		vio device id struct
>   *
> - * Return value:
> - *	0 - Success
> - *	Non-zero - Failure
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
>  				   const struct vio_device_id *id)
> @@ -671,11 +677,12 @@ static struct vio_driver ibmvtpm_driver = {
>  };
>  
>  /**
> - * ibmvtpm_module_init - Initialize ibm vtpm module
> + * ibmvtpm_module_init - Initialize ibm vtpm module.
>   *
> - * Return value:
> - *	0 -Success
> - *	Non-zero - Failure
> + *
> + * Return:
> + *	0 on success.
> + *	Non-zero on failure.
>   */
>  static int __init ibmvtpm_module_init(void)
>  {
> @@ -683,10 +690,7 @@ static int __init ibmvtpm_module_init(void)
>  }
>  
>  /**
> - * ibmvtpm_module_exit - Teardown ibm vtpm module
> - *
> - * Return value:
> - *	Nothing
> + * ibmvtpm_module_exit - Tear down ibm vtpm module.
>   */
>  static void __exit ibmvtpm_module_exit(void)
>  {
> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
> index 5463b58af26e..751059d2140a 100644
> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
> @@ -65,7 +65,12 @@ static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev);
>  /**
>   * vtpm_proxy_fops_read - Read TPM commands on 'server side'
>   *
> - * Return value:
> + * @filp: file pointer
> + * @buf: read buffer
> + * @count: number of bytes to read
> + * @off: offset
> + *
> + * Return:
>   *	Number of bytes read or negative error code
>   */
>  static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
> @@ -115,7 +120,12 @@ static ssize_t vtpm_proxy_fops_read(struct file *filp, char __user *buf,
>  /**
>   * vtpm_proxy_fops_write - Write TPM responses on 'server side'
>   *
> - * Return value:
> + * @filp: file pointer
> + * @buf: write buffer
> + * @count: number of bytes to write
> + * @off: offset
> + *
> + * Return:
>   *	Number of bytes read or negative error value
>   */
>  static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
> @@ -155,10 +165,12 @@ static ssize_t vtpm_proxy_fops_write(struct file *filp, const char __user *buf,
>  }
>  
>  /*
> - * vtpm_proxy_fops_poll: Poll status on 'server side'
> + * vtpm_proxy_fops_poll - Poll status on 'server side'
> + *
> + * @filp: file pointer
> + * @wait: poll table
>   *
> - * Return value:
> - *      Poll flags
> + * Return: Poll flags
>   */
>  static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
>  {
> @@ -185,6 +197,8 @@ static unsigned int vtpm_proxy_fops_poll(struct file *filp, poll_table *wait)
>  /*
>   * vtpm_proxy_fops_open - Open vTPM device on 'server side'
>   *
> + * @filp: file pointer
> + *
>   * Called when setting up the anonymous file descriptor
>   */
>  static void vtpm_proxy_fops_open(struct file *filp)
> @@ -196,8 +210,9 @@ static void vtpm_proxy_fops_open(struct file *filp)
>  
>  /**
>   * vtpm_proxy_fops_undo_open - counter-part to vtpm_fops_open
> + *       Call to undo vtpm_proxy_fops_open
>   *
> - * Call to undo vtpm_proxy_fops_open
> + *@proxy_dev: tpm proxy device
>   */
>  static void vtpm_proxy_fops_undo_open(struct proxy_dev *proxy_dev)
>  {
> @@ -212,9 +227,11 @@ static void vtpm_proxy_fops_undo_open(struct proxy_dev *proxy_dev)
>  }
>  
>  /*
> - * vtpm_proxy_fops_release: Close 'server side'
> + * vtpm_proxy_fops_release - Close 'server side'
>   *
> - * Return value:
> + * @inode: inode
> + * @filp: file pointer
> + * Return:
>   *      Always returns 0.
>   */
>  static int vtpm_proxy_fops_release(struct inode *inode, struct file *filp)
> @@ -245,7 +262,10 @@ static const struct file_operations vtpm_proxy_fops = {
>  /*
>   * Called when core TPM driver reads TPM responses from 'server side'
>   *
> - * Return value:
> + * @chip: tpm chip to use
> + * @buf: receive buffer
> + * @count: bytes to read
> + * Return:
>   *      Number of TPM response bytes read, negative error value otherwise
>   */
>  static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> @@ -282,7 +302,11 @@ static int vtpm_proxy_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  /*
>   * Called when core TPM driver forwards TPM requests to 'server side'.
>   *
> - * Return value:
> + * @chip: tpm chip to use
> + * @buf: send buffer
> + * @count: bytes to send
> + *
> + * Return:
>   *      0 in case of success, negative error value otherwise.
>   */
>  static int vtpm_proxy_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
> @@ -442,7 +466,7 @@ static inline void vtpm_proxy_delete_proxy_dev(struct proxy_dev *proxy_dev)
>  /*
>   * Create a /dev/tpm%d and 'server side' file descriptor pair
>   *
> - * Return value:
> + * Return:
>   *      Returns file pointer on success, an error value otherwise
>   */
>  static struct file *vtpm_proxy_create_device(
> @@ -571,7 +595,7 @@ static long vtpmx_ioc_new_dev(struct file *file, unsigned int ioctl,
>  /*
>   * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
>   *
> - * Return value:
> + * Return:
>   *      Returns 0 on success, a negative error code otherwise.
>   */
>  static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
> -- 
> 2.7.4
> 
