From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Tue, 22 Mar 2016 08:20:01 +0200
Message-ID: <20160322062001.GB4058@intel.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458502483-16887-6-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 20, 2016 at 08:34:36PM +0100, Christophe Ricard wrote:
> Remove TPM_VPRIV macro and replace with tpm_set_vendordata and
> tpm_get_vendordata.

NAK. These unnecessary wrapper functions make code just harder to read.
I'd rather accept a patch that would drop TPM_VPRIV and not introduce
new clutter.

/Jarkko

> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/st33zp24/st33zp24.c | 26 +++++++++++++-------------
>  drivers/char/tpm/tpm.h               | 12 ++++++++++--
>  drivers/char/tpm/tpm_ibmvtpm.c       |  8 ++++----
>  drivers/char/tpm/tpm_tis.c           |  2 +-
>  drivers/char/tpm/xen-tpmfront.c      | 14 +++++++-------
>  5 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index 9e91ca7..dc2d0f3 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -105,7 +105,7 @@ static void st33zp24_cancel(struct tpm_chip *chip)
>  	struct st33zp24_dev *tpm_dev;
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	data = TPM_STS_COMMAND_READY;
>  	tpm_dev->ops->send(tpm_dev->phy_id, TPM_STS, &data, 1);
> @@ -121,7 +121,7 @@ static u8 st33zp24_status(struct tpm_chip *chip)
>  	struct st33zp24_dev *tpm_dev;
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1);
>  	return data;
> @@ -138,7 +138,7 @@ static int check_locality(struct tpm_chip *chip)
>  	u8 data;
>  	u8 status;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
>  	if (status && (data &
> @@ -164,7 +164,7 @@ static int request_locality(struct tpm_chip *chip)
>  	if (check_locality(chip) == chip->vendor.locality)
>  		return chip->vendor.locality;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	data = TPM_ACCESS_REQUEST_USE;
>  	ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
> @@ -193,7 +193,7 @@ static void release_locality(struct tpm_chip *chip)
>  	struct st33zp24_dev *tpm_dev;
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  	data = TPM_ACCESS_ACTIVE_LOCALITY;
>  
>  	tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
> @@ -211,7 +211,7 @@ static int get_burstcount(struct tpm_chip *chip)
>  	u8 temp;
>  	struct st33zp24_dev *tpm_dev;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	stop = jiffies + chip->vendor.timeout_d;
>  	do {
> @@ -279,7 +279,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  	u8 status;
>  	struct st33zp24_dev *tpm_dev;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	/* check current status */
>  	status = st33zp24_status(chip);
> @@ -340,7 +340,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  	int size = 0, burstcnt, len, ret;
>  	struct st33zp24_dev *tpm_dev;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	while (size < count &&
>  	       wait_for_stat(chip,
> @@ -372,7 +372,7 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
>  	struct tpm_chip *chip = dev_id;
>  	struct st33zp24_dev *tpm_dev;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	tpm_dev->intrs++;
>  	wake_up_interruptible(&chip->vendor.read_queue);
> @@ -404,7 +404,7 @@ static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
>  	if (len < TPM_HEADER_SIZE)
>  		return -EBUSY;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	ret = request_locality(chip);
>  	if (ret < 0)
> @@ -565,7 +565,7 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
>  	if (!tpm_dev)
>  		return -ENOMEM;
>  
> -	TPM_VPRIV(chip) = tpm_dev;
> +	tpm_set_vendordata(chip, tpm_dev);
>  	tpm_dev->phy_id = phy_id;
>  	tpm_dev->ops = ops;
>  
> @@ -653,7 +653,7 @@ int st33zp24_pm_suspend(struct device *dev)
>  	struct st33zp24_dev *tpm_dev;
>  	int ret = 0;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	if (gpio_is_valid(tpm_dev->io_lpcpd))
>  		gpio_set_value(tpm_dev->io_lpcpd, 0);
> @@ -675,7 +675,7 @@ int st33zp24_pm_resume(struct device *dev)
>  	struct st33zp24_dev *tpm_dev;
>  	int ret = 0;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
>  
>  	if (gpio_is_valid(tpm_dev->io_lpcpd)) {
>  		gpio_set_value(tpm_dev->io_lpcpd, 1);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 28a0c17..6a973b9 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -157,8 +157,6 @@ struct tpm_vendor_specific {
>  	u16 manufacturer_id;
>  };
>  
> -#define TPM_VPRIV(c)     ((c)->vendor.priv)
> -
>  #define TPM_VID_INTEL    0x8086
>  #define TPM_VID_WINBOND  0x1050
>  #define TPM_VID_STM      0x104A
> @@ -203,6 +201,16 @@ struct tpm_chip {
>  
>  #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
>  
> +static inline void tpm_set_vendordata(struct tpm_chip *chip, void *data)
> +{
> +	chip->vendor.priv = data;
> +}
> +
> +static inline void *tpm_get_vendordata(struct tpm_chip *chip)
> +{
> +	return chip->vendor.priv;
> +}
> +
>  static inline int tpm_read_index(int base, int index)
>  {
>  	outb(index, base);
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index b0a9a9e..c8b1643 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -64,7 +64,7 @@ static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	if (chip)
> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +		return (struct ibmvtpm_dev *)tpm_get_vendordata(chip);
>  	return NULL;
>  }
>  
> @@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  	u16 len;
>  	int sig;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +	ibmvtpm = (struct ibmvtpm_dev *)tpm_get_vendordata(chip);
>  
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
> @@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  	__be64 *word = (__be64 *)&crq;
>  	int rc, sig;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +	ibmvtpm = (struct ibmvtpm_dev *)tpm_get_vendordata(chip);
>  
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
> @@ -643,7 +643,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
>  
>  	crq_q->index = 0;
>  
> -	TPM_VPRIV(chip) = (void *)ibmvtpm;
> +	tpm_set_vendordata(chip, (void *)ibmvtpm);
>  
>  	spin_lock_init(&ibmvtpm->rtce_lock);
>  
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index eed3bf5..607fa3f 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -678,7 +678,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = priv;
> +	tpm_set_vendordata(chip, priv);
>  #ifdef CONFIG_ACPI
>  	chip->acpi_dev_handle = acpi_dev_handle;
>  #endif
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 3111f27..c472fd8 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -39,7 +39,7 @@ enum status_bits {
>  
>  static u8 vtpm_status(struct tpm_chip *chip)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = tpm_get_vendordata(chip);
>  	switch (priv->shr->state) {
>  	case VTPM_STATE_IDLE:
>  		return VTPM_STATUS_IDLE | VTPM_STATUS_CANCELED;
> @@ -60,7 +60,7 @@ static bool vtpm_req_canceled(struct tpm_chip *chip, u8 status)
>  
>  static void vtpm_cancel(struct tpm_chip *chip)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = tpm_get_vendordata(chip);
>  	priv->shr->state = VTPM_STATE_CANCEL;
>  	wmb();
>  	notify_remote_via_evtchn(priv->evtchn);
> @@ -73,7 +73,7 @@ static unsigned int shr_data_offset(struct vtpm_shared_page *shr)
>  
>  static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = tpm_get_vendordata(chip);
>  	struct vtpm_shared_page *shr = priv->shr;
>  	unsigned int offset = shr_data_offset(shr);
>  
> @@ -115,7 +115,7 @@ static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = tpm_get_vendordata(chip);
>  	struct vtpm_shared_page *shr = priv->shr;
>  	unsigned int offset = shr_data_offset(shr);
>  	size_t length = shr->length;
> @@ -182,7 +182,7 @@ static int setup_chip(struct device *dev, struct tpm_private *priv)
>  	init_waitqueue_head(&chip->vendor.read_queue);
>  
>  	priv->chip = chip;
> -	TPM_VPRIV(chip) = priv;
> +	tpm_set_vendordata(chip, priv);
>  
>  	return 0;
>  }
> @@ -318,10 +318,10 @@ static int tpmfront_probe(struct xenbus_device *dev,
>  static int tpmfront_remove(struct xenbus_device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = tpm_get_vendordata(chip);
>  	tpm_chip_unregister(chip);
>  	ring_free(priv);
> -	TPM_VPRIV(chip) = NULL;
> +	tpm_set_vendordata(chip, NULL);
>  	return 0;
>  }
>  
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
