From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/5] tpm: Move priv field from
 tpm_vendor_specific to tpm_chip
Date: Thu, 24 Mar 2016 16:12:08 +0200
Message-ID: <20160324141208.GA21689@intel.com>
References: <1458764240-24185-1-git-send-email-christophe-h.ricard@st.com>
	<1458764240-24185-4-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458764240-24185-4-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Mar 23, 2016 at 09:17:18PM +0100, Christophe Ricard wrote:
> Move from tpm_vendor_specific priv field to tpm_chip as this is going to
> be used for additional tpm_chip description.

NAK. The remaining fields should be moved to tpm_chip.

/Jarkko

> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/tpm.h             |  4 ++--
>  drivers/char/tpm/tpm_atmel.c       | 12 +++++-----
>  drivers/char/tpm/tpm_atmel.h       |  2 +-
>  drivers/char/tpm/tpm_crb.c         | 12 +++++-----
>  drivers/char/tpm/tpm_i2c_atmel.c   | 12 +++++-----
>  drivers/char/tpm/tpm_i2c_nuvoton.c |  8 +++----
>  drivers/char/tpm/tpm_nsc.c         |  4 ++--
>  drivers/char/tpm/tpm_tis.c         | 46 +++++++++++++++++++-------------------
>  8 files changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 357ac14..06d5c2a 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -138,12 +138,11 @@ struct tpm_vendor_specific {
>  	bool timeout_adjusted;
>  	unsigned long duration[3]; /* jiffies */
>  	bool duration_adjusted;
> -	void *priv;
>  
>  	wait_queue_head_t read_queue;
>  };
>  
> -#define TPM_VPRIV(c)     ((c)->vendor.priv)
> +#define TPM_VPRIV(c)     ((c)->priv)
>  
>  #define TPM_VID_INTEL    0x8086
>  #define TPM_VID_WINBOND  0x1050
> @@ -159,6 +158,7 @@ enum tpm_chip_flags {
>  struct tpm_chip {
>  	struct device dev;
>  	struct cdev cdev;
> +	void *priv;
>  
>  	/* A driver callback under ops cannot be run unless ops_sem is held
>  	 * (sometimes implicitly, eg for the sysfs code). ops becomes null
> diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> index 242d6c6..56845bf 100644
> --- a/drivers/char/tpm/tpm_atmel.c
> +++ b/drivers/char/tpm/tpm_atmel.c
> @@ -44,7 +44,7 @@ struct tpm_atmel_priv {
>  
>  static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = chip->priv;
>  	u8 status, *hdr = buf;
>  	u32 size;
>  	int i;
> @@ -103,7 +103,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = chip->priv;
>  	int i;
>  
>  	dev_dbg(&chip->dev, "tpm_atml_send:\n");
> @@ -117,14 +117,14 @@ static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static void tpm_atml_cancel(struct tpm_chip *chip)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = chip->priv;
>  
>  	iowrite8(ATML_STATUS_ABORT, priv->iobase + 1);
>  }
>  
>  static u8 tpm_atml_status(struct tpm_chip *chip)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = chip->priv;
>  
>  	return ioread8(priv->iobase + 1);
>  }
> @@ -149,7 +149,7 @@ static struct platform_device *pdev;
>  static void atml_plat_remove(void)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = chip->priv;
>  
>  	if (chip) {
>  		tpm_chip_unregister(chip);
> @@ -214,7 +214,7 @@ static int __init init_atmel(void)
>  		goto err_unreg_dev;
>  	}
>  
> -	chip->vendor.priv = priv;
> +	chip->priv = priv;
>  
>  	rc = tpm_chip_register(chip);
>  	if (rc)
> diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
> index 08607a6..dedc5dc 100644
> --- a/drivers/char/tpm/tpm_atmel.h
> +++ b/drivers/char/tpm/tpm_atmel.h
> @@ -22,7 +22,7 @@
>   *
>   */
>  
> -#define atmel_get_priv(chip) ((struct tpm_atmel_priv *) chip->vendor.priv)
> +#define atmel_get_priv(chip) ((struct tpm_atmel_priv *) chip->priv)
>  
>  #ifdef CONFIG_PPC64
>  
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 8767da6..0e81a36 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -87,7 +87,7 @@ static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
>  
>  static u8 crb_status(struct tpm_chip *chip)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = chip->priv;
>  	u8 sts = 0;
>  
>  	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
> @@ -99,7 +99,7 @@ static u8 crb_status(struct tpm_chip *chip)
>  
>  static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = chip->priv;
>  	unsigned int expected;
>  
>  	/* sanity check */
> @@ -139,7 +139,7 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
>  
>  static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = chip->priv;
>  	int rc = 0;
>  
>  	if (len > ioread32(&priv->cca->cmd_size)) {
> @@ -163,7 +163,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  static void crb_cancel(struct tpm_chip *chip)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = chip->priv;
>  
>  	iowrite32(cpu_to_le32(CRB_CANCEL_INVOKE), &priv->cca->cancel);
>  
> @@ -175,7 +175,7 @@ static void crb_cancel(struct tpm_chip *chip)
>  
>  static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = chip->priv;
>  	u32 cancel = ioread32(&priv->cca->cancel);
>  
>  	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
> @@ -200,7 +200,7 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = priv;
> +	chip->priv = priv;
>  	chip->acpi_dev_handle = device->handle;
>  	chip->flags = TPM_CHIP_FLAG_TPM2;
>  
> diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
> index dd8f0eb..92cd080 100644
> --- a/drivers/char/tpm/tpm_i2c_atmel.c
> +++ b/drivers/char/tpm/tpm_i2c_atmel.c
> @@ -51,7 +51,7 @@ struct priv_data {
>  
>  static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	s32 status;
>  
> @@ -70,7 +70,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	struct tpm_output_header *hdr =
>  		(struct tpm_output_header *)priv->buffer;
> @@ -111,7 +111,7 @@ static void i2c_atmel_cancel(struct tpm_chip *chip)
>  
>  static u8 i2c_atmel_read_status(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	int rc;
>  
> @@ -163,9 +163,9 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
> -					 GFP_KERNEL);
> -	if (!chip->vendor.priv)
> +	chip->priv = devm_kzalloc(dev, sizeof(struct priv_data),
> +				  GFP_KERNEL);
> +	if (!chip->priv)
>  		return -ENOMEM;
>  
>  	/* Default timeouts */
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index a43b5f3..a9c6b2d 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -178,7 +178,7 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
>  {
>  	if (chip->vendor.irq && queue) {
>  		s32 rc;
> -		struct priv_data *priv = chip->vendor.priv;
> +		struct priv_data *priv = chip->priv;
>  		unsigned int cur_intrs = priv->intrs;
>  
>  		enable_irq(chip->vendor.irq);
> @@ -473,7 +473,7 @@ static const struct tpm_class_ops tpm_i2c = {
>  static irqreturn_t i2c_nuvoton_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	priv->intrs++;
>  	wake_up(&chip->vendor.read_queue);
> @@ -534,9 +534,9 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
> +	chip->priv = devm_kzalloc(dev, sizeof(struct priv_data),
>  					 GFP_KERNEL);
> -	if (!chip->vendor.priv)
> +	if (!chip->priv)
>  		return -ENOMEM;
>  
>  	init_waitqueue_head(&chip->vendor.read_queue);
> diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
> index 8ccb1d5..48cc7ff 100644
> --- a/drivers/char/tpm/tpm_nsc.c
> +++ b/drivers/char/tpm/tpm_nsc.c
> @@ -69,7 +69,7 @@ struct tpm_nsc_priv {
>  	unsigned long base;
>  };
>  
> -#define tpm_nsc_get_priv(chip) ((struct tpm_nsc_priv *) chip->vendor.priv)
> +#define tpm_nsc_get_priv(chip) ((struct tpm_nsc_priv *) chip->priv)
>  
>  /*
>   * Wait for a certain status to appear
> @@ -331,7 +331,7 @@ static int __init init_nsc(void)
>  		goto err_rel_reg;
>  	}
>  
> -	chip->vendor.priv = priv;
> +	chip->priv = priv;
>  
>  	rc = tpm_chip_register(chip);
>  	if (rc)
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 19dac62..96cb824 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -129,7 +129,7 @@ static inline int is_itpm(struct acpi_device *dev)
>   * correct values in the other bits.' */
>  static int wait_startup(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	unsigned long stop = jiffies + chip->vendor.timeout_a;
>  	do {
>  		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
> @@ -142,7 +142,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
>  
>  static int check_locality(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
>  	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> @@ -154,7 +154,7 @@ static int check_locality(struct tpm_chip *chip, int l)
>  
>  static void release_locality(struct tpm_chip *chip, int l, int force)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	if (force || (ioread8(priv->iobase + TPM_ACCESS(l)) &
>  		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
> @@ -165,7 +165,7 @@ static void release_locality(struct tpm_chip *chip, int l, int force)
>  
>  static int request_locality(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	unsigned long stop, timeout;
>  	long rc;
>  
> @@ -206,7 +206,7 @@ again:
>  
>  static u8 tpm_tis_status(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	return ioread8(priv->iobase +
>  		       TPM_STS(chip->vendor.locality));
> @@ -214,7 +214,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>  
>  static void tpm_tis_ready(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	/* this causes the current command to be aborted */
>  	iowrite8(TPM_STS_COMMAND_READY,
> @@ -223,7 +223,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
>  
>  static int get_burstcount(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	unsigned long stop;
>  	int burstcnt;
>  
> @@ -245,7 +245,7 @@ static int get_burstcount(struct tpm_chip *chip)
>  
>  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int size = 0, burstcnt;
>  	while (size < count &&
>  	       wait_for_tpm_stat(chip,
> @@ -264,7 +264,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int size = 0;
>  	int expected, status;
>  
> @@ -320,7 +320,7 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
>   */
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int rc, status, burstcnt;
>  	size_t count = 0;
>  
> @@ -376,7 +376,7 @@ out_err:
>  
>  static void disable_interrupts(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	u32 intmask;
>  
>  	intmask =
> @@ -396,7 +396,7 @@ static void disable_interrupts(struct tpm_chip *chip)
>   */
>  static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int rc;
>  	u32 ordinal;
>  	unsigned long dur;
> @@ -434,7 +434,7 @@ out_err:
>  static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	int rc, irq;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	if (!chip->vendor.irq || priv->irq_tested)
>  		return tpm_tis_send_main(chip, buf, len);
> @@ -466,7 +466,7 @@ static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
>  static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>  				    unsigned long *timeout_cap)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int i;
>  	u32 did_vid;
>  
> @@ -490,7 +490,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>   */
>  static int probe_itpm(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	int rc = 0;
>  	u8 cmd_getticks[] = {
>  		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> @@ -532,7 +532,7 @@ out:
>  
>  static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	switch (priv->manufacturer_id) {
>  	case TPM_VID_WINBOND:
> @@ -559,7 +559,7 @@ static const struct tpm_class_ops tpm_tis = {
>  static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	u32 interrupt;
>  	int i;
>  
> @@ -569,7 +569,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  	if (interrupt == 0)
>  		return IRQ_NONE;
>  
> -	((struct priv_data *)chip->vendor.priv)->irq_tested = true;
> +	((struct priv_data *)chip->priv)->irq_tested = true;
>  	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
>  		wake_up_interruptible(&chip->vendor.read_queue);
>  	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
> @@ -596,7 +596,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  				    int flags, int irq)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	u8 original_int_vec;
>  
>  	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> @@ -649,7 +649,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>   */
>  static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	u8 original_int_vec;
>  	int i;
>  
> @@ -673,7 +673,7 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
>  
>  static void tpm_tis_remove(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> @@ -702,7 +702,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = priv;
> +	chip->priv = priv;
>  #ifdef CONFIG_ACPI
>  	chip->acpi_dev_handle = acpi_dev_handle;
>  #endif
> @@ -841,7 +841,7 @@ out_err:
>  #ifdef CONFIG_PM_SLEEP
>  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = chip->priv;
>  	u32 intmask;
>  
>  	/* reenable interrupts that device may have lost or
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
