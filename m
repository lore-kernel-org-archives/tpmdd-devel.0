From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 3/8] tpm_tis: Introduce intermediate
 layer for TPM access
Date: Mon, 2 May 2016 20:03:21 +0300
Message-ID: <20160502170321.GB1764@intel.com>
References: <1461276283-2453-1-git-send-email-christophe-h.ricard@st.com>
	<1461276283-2453-4-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461276283-2453-4-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Fri, Apr 22, 2016 at 12:04:38AM +0200, Christophe Ricard wrote:
> This splits tpm_tis in a high-level protocol part and a low-level interface
> for the actual TPM communication. The low-level interface can then be
> implemented by additional drivers to provide access to TPMs using other
> mechanisms, for example native I2C or SPI transfers, while still reusing
> the same TIS protocol implementation.
> 
> Though the ioread/iowrite calls cannot fail, other implementations of this
> interface might want to return error codes if their communication fails.
> 
> This follows the usual pattern of negative values representing errors and
> zero representing success. Positive values are not used (yet).
> 
> Errors are passed back to the caller if possible. If the interface of a
> function does not allow that, it tries to do the most sensible thing it
> can, but this might also mean ignoring the error in this instance.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_tis.c | 323 ++++++++++++++++++++++++++++++---------------
>  drivers/char/tpm/tpm_tis.h |  48 +++++++
>  2 files changed, 268 insertions(+), 103 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 2d8aa2f..27a7802 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -99,8 +99,10 @@ struct tpm_tis_tcg_phy {
>  	void __iomem *iobase;
>  };
>  
> -#define to_tpm_tis_tcg_phy(data) container_of(data, struct tpm_tis_tcg_phy,\
> -					      priv)
> +static inline struct tpm_tis_tcg_phy *to_tpm_tis_tcg_phy(struct tpm_tis_data *data)
> +{
> +	return container_of(data, struct tpm_tis_tcg_phy, priv);
> +}

Couldn't the earlier patch already define this as an inline function
instead of a macro?

>  #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
>  static int has_hid(struct acpi_device *dev, const char *hid)
> @@ -132,11 +134,16 @@ static inline int is_itpm(struct acpi_device *dev)
>  static int wait_startup(struct tpm_chip *chip, int l)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	unsigned long stop = jiffies + chip->timeout_a;
> +	int rc;
> +	u8 access;
> +
>  	do {
> -		if (ioread8(phy->iobase + TPM_ACCESS(l)) &
> -		    TPM_ACCESS_VALID)
> +		rc = tpm_read8(priv, TPM_ACCESS(l), &access);
> +		if (rc < 0)
> +			return rc;
> +
> +		if (access & TPM_ACCESS_VALID)
>  			return 0;
>  		msleep(TPM_TIMEOUT);
>  	} while (time_before(jiffies, stop));
> @@ -146,10 +153,14 @@ static int wait_startup(struct tpm_chip *chip, int l)
>  static int check_locality(struct tpm_chip *chip, int l)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> +	int rc;
> +	u8 access;
> +
> +	rc = tpm_read8(priv, TPM_ACCESS(l), &access);
> +	if (rc < 0)
> +		return rc;
>  
> -	if ((ioread8(phy->iobase + TPM_ACCESS(l)) &
> -	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> +	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
>  		return priv->locality = l;
>  
> @@ -159,27 +170,32 @@ static int check_locality(struct tpm_chip *chip, int l)
>  static void release_locality(struct tpm_chip *chip, int l, int force)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> +	int rc;
> +	u8 access;
>  
> -	if (force || (ioread8(phy->iobase + TPM_ACCESS(l)) &
> +	rc = tpm_read8(priv, TPM_ACCESS(l), &access);
> +	if (rc < 0)
> +		return;
> +
> +	if (force || (access &
>  		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
> -		iowrite8(TPM_ACCESS_ACTIVE_LOCALITY,
> -			 phy->iobase + TPM_ACCESS(l));
> +		tpm_write8(priv, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
> +
>  }
>  
>  static int request_locality(struct tpm_chip *chip, int l)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	unsigned long stop, timeout;
>  	long rc;
>  
>  	if (check_locality(chip, l) >= 0)
>  		return l;
>  
> -	iowrite8(TPM_ACCESS_REQUEST_USE,
> -		 phy->iobase + TPM_ACCESS(l));
> +	rc = tpm_write8(priv, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
> +	if (rc < 0)
> +		return rc;
>  
>  	stop = jiffies + chip->timeout_a;
>  
> @@ -213,38 +229,45 @@ again:
>  static u8 tpm_tis_status(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> +	int rc;
> +	u8 status;
>  
> -	return ioread8(phy->iobase +
> -		       TPM_STS(priv->locality));
> +	rc = tpm_read8(priv, TPM_STS(priv->locality), &status);
> +	if (rc < 0)
> +		return 0;
> +
> +	return status;
>  }
>  
>  static void tpm_tis_ready(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  
>  	/* this causes the current command to be aborted */
> -	iowrite8(TPM_STS_COMMAND_READY,
> -		 phy->iobase + TPM_STS(priv->locality));
> +	tpm_write8(priv, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
>  }
>  
>  static int get_burstcount(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	unsigned long stop;
> -	int burstcnt;
> +	int burstcnt, rc;
> +	u8 value;
>  
>  	/* wait for burstcount */
>  	/* which timeout value, spec has 2 answers (c & d) */
>  	stop = jiffies + chip->timeout_d;
>  	do {
> -		burstcnt = ioread8(phy->iobase +
> -				   TPM_STS(priv->locality) + 1);
> -		burstcnt += ioread8(phy->iobase +
> -				    TPM_STS(priv->locality) +
> -				    2) << 8;
> +		rc = tpm_read8(priv, TPM_STS(priv->locality) + 1, &value);
> +		if (rc < 0)
> +			return rc;
> +
> +		burstcnt = value;
> +		rc = tpm_read8(priv, TPM_STS(priv->locality) + 2, &value);
> +		if (rc < 0)
> +			return rc;
> +
> +		burstcnt += value << 8;
>  		if (burstcnt)
>  			return burstcnt;
>  		msleep(TPM_TIMEOUT);
> @@ -255,18 +278,20 @@ static int get_burstcount(struct tpm_chip *chip)
>  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> -	int size = 0, burstcnt;
> +	int size = 0, burstcnt, rc;
> +
>  	while (size < count &&
>  	       wait_for_tpm_stat(chip,
>  				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>  				 chip->timeout_c,
> -				 &priv->read_queue, true)
> -	       == 0) {
> -		burstcnt = get_burstcount(chip);
> -		for (; burstcnt > 0 && size < count; burstcnt--)
> -			buf[size++] = ioread8(phy->iobase +
> -					      TPM_DATA_FIFO(priv->locality));
> +				 &priv->read_queue, true) == 0) {
> +		burstcnt = min_t(int, get_burstcount(chip), count - size);
> +		rc = tpm_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
> +				    burstcnt, buf + size);
> +		if (rc < 0)
> +			return rc;
> +
> +		size += burstcnt;
>  	}
>  	return size;
>  }
> @@ -330,7 +355,6 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	int rc, status, burstcnt;
>  	size_t count = 0;
>  
> @@ -349,12 +373,13 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  	}
>  
>  	while (count < len - 1) {
> -		burstcnt = get_burstcount(chip);
> -		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
> -			iowrite8(buf[count], phy->iobase +
> -				 TPM_DATA_FIFO(priv->locality));
> -			count++;
> -		}
> +		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
> +		rc = tpm_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> +				     burstcnt, buf + count);
> +		if (rc < 0)
> +			goto out_err;
> +
> +		count += burstcnt;
>  
>  		wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>  				  &priv->int_queue, false);
> @@ -366,8 +391,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  	}
>  
>  	/* write last byte */
> -	iowrite8(buf[count],
> -		 phy->iobase + TPM_DATA_FIFO(priv->locality));
> +	rc = tpm_write8(priv, TPM_DATA_FIFO(priv->locality), buf[count]);
> +	if (rc < 0)
> +		goto out_err;
> +
>  	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>  			  &priv->int_queue, false);
>  	status = tpm_tis_status(chip);
> @@ -387,15 +414,16 @@ out_err:
>  static void disable_interrupts(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	u32 intmask;
> +	int rc;
> +
> +	rc = tpm_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
> +	if (rc < 0)
> +		intmask = 0;
>  
> -	intmask =
> -	    ioread32(phy->iobase +
> -		     TPM_INT_ENABLE(priv->locality));
>  	intmask &= ~TPM_GLOBAL_INT_ENABLE;
> -	iowrite32(intmask,
> -		  phy->iobase + TPM_INT_ENABLE(priv->locality));
> +	tpm_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
> +
>  	devm_free_irq(&chip->dev, priv->irq, chip);
>  	priv->irq = 0;
>  	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
> @@ -409,7 +437,6 @@ static void disable_interrupts(struct tpm_chip *chip)
>  static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	int rc;
>  	u32 ordinal;
>  	unsigned long dur;
> @@ -419,8 +446,9 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  		return rc;
>  
>  	/* go and do it */
> -	iowrite8(TPM_STS_GO,
> -		 phy->iobase + TPM_STS(priv->locality));
> +	rc = tpm_write8(priv, TPM_STS(priv->locality), TPM_STS_GO);
> +	if (rc < 0)
> +		return rc;
>  
>  	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
>  		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> @@ -482,11 +510,12 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>  				    unsigned long *timeout_cap)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> -	int i;
> +	int i, rc;
>  	u32 did_vid;
>  
> -	did_vid = ioread32(phy->iobase + TPM_DID_VID(0));
> +	rc = tpm_read32(priv, TPM_DID_VID(0), &did_vid);
> +	if (rc < 0)
> +		return rc;
>  
>  	for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
>  		if (vendor_timeout_overrides[i].did_vid != did_vid)
> @@ -507,7 +536,6 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>  static int probe_itpm(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	int rc = 0;
>  	u8 cmd_getticks[] = {
>  		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> @@ -515,7 +543,11 @@ static int probe_itpm(struct tpm_chip *chip)
>  	};
>  	size_t len = sizeof(cmd_getticks);
>  	bool rem_itpm = itpm;
> -	u16 vendor = ioread16(phy->iobase + TPM_DID_VID(0));
> +	u16 vendor;
> +
> +	rc = tpm_read16(priv, TPM_DID_VID(0), &vendor);
> +	if (rc < 0)
> +		return rc;
>  
>  	/* probe only iTPMS */
>  	if (vendor != TPM_VID_INTEL)
> @@ -573,16 +605,68 @@ static const struct tpm_class_ops tpm_tis = {
>  	.req_canceled = tpm_tis_req_canceled,
>  };
>  
> +static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> +			      u8 *result)
> +{
> +	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> +
> +	while (len--)
> +		*result++ = ioread8(phy->iobase + addr);
> +	return 0;
> +}
> +
> +static int tpm_tcg_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> +			       u8 *value)
> +{
> +	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> +
> +	while (len--)
> +		iowrite8(*value++, phy->iobase + addr);
> +	return 0;
> +}
> +
> +static int tpm_tcg_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
> +{
> +	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> +
> +	*result = ioread16(phy->iobase + addr);
> +	return 0;
> +}
> +
> +static int tpm_tcg_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
> +{
> +	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> +
> +	*result = ioread32(phy->iobase + addr);
> +	return 0;
> +}
> +
> +static int tpm_tcg_write32(struct tpm_tis_data *data, u32 addr, u32 value)
> +{
> +	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(data);
> +
> +	iowrite32(value, phy->iobase + addr);
> +	return 0;
> +}
> +
> +static const struct tpm_tis_phy_ops tpm_tcg = {
> +	.read_bytes = tpm_tcg_read_bytes,
> +	.write_bytes = tpm_tcg_write_bytes,
> +	.read16 = tpm_tcg_read16,
> +	.read32 = tpm_tcg_read32,
> +	.write32 = tpm_tcg_write32,
> +};
> +
>  static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	u32 interrupt;
> -	int i;
> +	int i, rc;
>  
> -	interrupt = ioread32(phy->iobase +
> -			     TPM_INT_STATUS(priv->locality));
> +	rc = tpm_read32(priv, TPM_INT_STATUS(priv->locality), &interrupt);
> +	if (rc < 0)
> +		return IRQ_NONE;
>  
>  	if (interrupt == 0)
>  		return IRQ_NONE;
> @@ -600,10 +684,11 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  		wake_up_interruptible(&priv->int_queue);
>  
>  	/* Clear interrupts handled with TPM_EOI */
> -	iowrite32(interrupt,
> -		  phy->iobase +
> -		  TPM_INT_STATUS(priv->locality));
> -	ioread32(phy->iobase + TPM_INT_STATUS(priv->locality));
> +	rc = tpm_write32(priv, TPM_INT_STATUS(priv->locality), interrupt);
> +	if (rc < 0)
> +		return IRQ_NONE;
> +
> +	tpm_read32(priv, TPM_INT_STATUS(priv->locality), &interrupt);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -615,8 +700,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  				    int flags, int irq)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	u8 original_int_vec;
> +	int rc;
> +	u32 int_status;
>  
>  	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
>  			     dev_name(&chip->dev), chip) != 0) {
> @@ -626,19 +712,28 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  	}
>  	priv->irq = irq;
>  
> -	original_int_vec = ioread8(phy->iobase +
> -				   TPM_INT_VECTOR(priv->locality));
> -	iowrite8(irq,
> -		 phy->iobase + TPM_INT_VECTOR(priv->locality));
> +	rc = tpm_read8(priv, TPM_INT_VECTOR(priv->locality), &original_int_vec);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = tpm_write8(priv, TPM_INT_VECTOR(priv->locality), irq);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = tpm_read32(priv, TPM_INT_STATUS(priv->locality), &int_status);
> +	if (rc < 0)
> +		return rc;
>  
>  	/* Clear all existing */
> -	iowrite32(ioread32(phy->iobase +
> -			   TPM_INT_STATUS(priv->locality)),
> -		  phy->iobase + TPM_INT_STATUS(priv->locality));
> +	rc = tpm_write32(priv, TPM_INT_STATUS(priv->locality), int_status);
> +	if (rc < 0)
> +		return rc;
>  
>  	/* Turn on */
> -	iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
> -		  phy->iobase + TPM_INT_ENABLE(priv->locality));
> +	rc = tpm_write32(priv, TPM_INT_ENABLE(priv->locality),
> +			 intmask | TPM_GLOBAL_INT_ENABLE);
> +	if (rc < 0)
> +		return rc;
>  
>  	priv->irq_tested = false;
>  
> @@ -654,8 +749,11 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  	 * will call disable_irq which undoes all of the above.
>  	 */
>  	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
> -		iowrite8(original_int_vec,
> -			 phy->iobase + TPM_INT_VECTOR(priv->locality));
> +		rc = tpm_write8(priv, TPM_INT_VECTOR(priv->locality),
> +				original_int_vec);
> +		if (rc < 0)
> +			return rc;
> +
>  		return 1;
>  	}
>  
> @@ -669,12 +767,12 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	u8 original_int_vec;
> -	int i;
> +	int i, rc;
>  
> -	original_int_vec = ioread8(phy->iobase +
> -				   TPM_INT_VECTOR(priv->locality));
> +	rc = tpm_read8(priv, TPM_INT_VECTOR(priv->locality), &original_int_vec);
> +	if (rc < 0)
> +		return;
>  
>  	if (!original_int_vec) {
>  		if (IS_ENABLED(CONFIG_X86))
> @@ -694,10 +792,15 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
>  static void tpm_tis_remove(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
> -	void __iomem *reg = phy->iobase + TPM_INT_ENABLE(priv->locality);
> +	u32 reg = TPM_INT_ENABLE(priv->locality);
> +	u32 interrupt;
> +	int rc;
> +
> +	rc = tpm_read32(priv, reg, &interrupt);
> +	if (rc < 0)
> +		interrupt = 0;
>  
> -	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
> +	tpm_write32(priv, reg, ~TPM_GLOBAL_INT_ENABLE & interrupt);
>  	release_locality(chip, priv->locality, 1);
>  }
>  
> @@ -705,6 +808,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  			acpi_handle acpi_dev_handle)
>  {
>  	u32 vendor, intfcaps, intmask;
> +	u8 rid;
>  	int rc, probe;
>  	struct tpm_chip *chip;
>  	struct tpm_tis_tcg_phy *phy;
> @@ -725,6 +829,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (IS_ERR(phy->iobase))
>  		return PTR_ERR(phy->iobase);
>  
> +	phy->priv.phy_ops = &tpm_tcg;
> +
>  	/* Maximum timeouts */
>  	chip->timeout_a = TIS_TIMEOUT_A_MAX;
>  	chip->timeout_b = TIS_TIMEOUT_B_MAX;
> @@ -739,13 +845,15 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	}
>  
>  	/* Take control of the TPM's interrupt hardware and shut it off */
> -	intmask = ioread32(phy->iobase +
> -			   TPM_INT_ENABLE(phy->priv.locality));
> +	rc = tpm_read32(&phy->priv, TPM_INT_ENABLE(phy->priv.locality),
> +			&intmask);
> +	if (rc < 0)
> +		goto out_err;
> +
>  	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
>  		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
>  	intmask &= ~TPM_GLOBAL_INT_ENABLE;
> -	iowrite32(intmask,
> -		  phy->iobase + TPM_INT_ENABLE(phy->priv.locality));
> +	tpm_write32(&phy->priv, TPM_INT_ENABLE(phy->priv.locality), intmask);
>  
>  	if (request_locality(chip, 0) != 0) {
>  		rc = -ENODEV;
> @@ -756,12 +864,19 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (rc)
>  		goto out_err;
>  
> -	vendor = ioread32(phy->iobase + TPM_DID_VID(0));
> +	rc = tpm_read32(&phy->priv, TPM_DID_VID(0), &vendor);
> +	if (rc < 0)
> +		goto out_err;
> +
>  	phy->priv.manufacturer_id = vendor;
>  
> +	rc = tpm_read8(&phy->priv, TPM_RID(0), &rid);
> +	if (rc < 0)
> +		goto out_err;
> +
>  	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
>  		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> -		 vendor >> 16, ioread8(phy->iobase + TPM_RID(0)));
> +		 vendor >> 16, rid);
>  
>  	if (!itpm) {
>  		probe = probe_itpm(chip);
> @@ -775,11 +890,12 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (itpm)
>  		dev_info(dev, "Intel iTPM workaround enabled\n");
>  
> -
>  	/* Figure out the capabilities */
> -	intfcaps =
> -	    ioread32(phy->iobase +
> -		     TPM_INTF_CAPS(phy->priv.locality));
> +	rc = tpm_read32(&phy->priv, TPM_INTF_CAPS(phy->priv.locality),
> +			&intfcaps);
> +	if (rc < 0)
> +		goto out_err;
> +
>  	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
>  		intfcaps);
>  	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
> @@ -858,23 +974,24 @@ out_err:
>  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  {
>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> -	struct tpm_tis_tcg_phy *phy = to_tpm_tis_tcg_phy(priv);
>  	u32 intmask;
> +	int rc;
>  
>  	/* reenable interrupts that device may have lost or
>  	   BIOS/firmware may have disabled */
> -	iowrite8(priv->irq, phy->iobase +
> -		 TPM_INT_VECTOR(priv->locality));
> +	rc = tpm_write8(priv, TPM_INT_VECTOR(priv->locality), priv->irq);
> +	if (rc < 0)
> +		return;
>  
> -	intmask =
> -	    ioread32(phy->iobase + TPM_INT_ENABLE(priv->locality));
> +	rc = tpm_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
> +	if (rc < 0)
> +		return;
>  
>  	intmask |= TPM_INTF_CMD_READY_INT
>  	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
>  	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
>  
> -	iowrite32(intmask,
> -		  phy->iobase + TPM_INT_ENABLE(priv->locality));
> +	tpm_write32(priv, TPM_INT_ENABLE(priv->locality), intmask);
>  }
>  
>  static int tpm_tis_resume(struct device *dev)
> diff --git a/drivers/char/tpm/tpm_tis.h b/drivers/char/tpm/tpm_tis.h
> index 2260f89..75e16d0 100644
> --- a/drivers/char/tpm/tpm_tis.h
> +++ b/drivers/char/tpm/tpm_tis.h
> @@ -32,6 +32,54 @@ struct tpm_tis_data {
>  	bool irq_tested;
>  	wait_queue_head_t int_queue;
>  	wait_queue_head_t read_queue;
> +	const struct tpm_tis_phy_ops *phy_ops;
>  };
>  
> +struct tpm_tis_phy_ops {
> +	int (*read_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
> +			  u8 *result);
> +	int (*write_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
> +			   u8 *value);
> +	int (*read16)(struct tpm_tis_data *data, u32 addr, u16 *result);
> +	int (*read32)(struct tpm_tis_data *data, u32 addr, u32 *result);
> +	int (*write32)(struct tpm_tis_data *data, u32 addr, u32 src);
> +};
> +
> +static inline int tpm_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> +				 u8 *result)
> +{
> +	return data->phy_ops->read_bytes(data, addr, len, result);
> +}
> +
> +static inline int tpm_read8(struct tpm_tis_data *data, u32 addr, u8 *result)
> +{
> +	return data->phy_ops->read_bytes(data, addr, 1, result);
> +}
> +
> +static inline int tpm_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
> +{
> +	return data->phy_ops->read16(data, addr, result);
> +}
> +
> +static inline int tpm_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
> +{
> +	return data->phy_ops->read32(data, addr, result);
> +}
> +
> +static inline int tpm_write_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
> +				  u8 *value)
> +{
> +	return data->phy_ops->write_bytes(data, addr, len, value);
> +}
> +
> +static inline int tpm_write8(struct tpm_tis_data *data, u32 addr, u8 value)
> +{
> +	return data->phy_ops->write_bytes(data, addr, 1, &value);
> +}
> +
> +static inline int tpm_write32(struct tpm_tis_data *data, u32 addr, u32 value)
> +{
> +	return data->phy_ops->write32(data, addr, value);
> +}
> +

It would be cleaner if these would have tpm_tis_ prefix as the FIFO
interface is not the only standard interface to access TPMs.

>  #endif
> -- 
> 2.1.4

/Jarkko

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
