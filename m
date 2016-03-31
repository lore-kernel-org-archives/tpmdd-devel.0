From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/6] tpm: drop 'locality' from struct
 tpm_vendor_specific
Date: Thu, 31 Mar 2016 09:50:36 +0300
Message-ID: <20160331065035.GE6393@intel.com>
References: <1459373895-17704-1-git-send-email-christophe-h.ricard@st.com>
	<1459373895-17704-5-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459373895-17704-5-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Mar 30, 2016 at 11:38:13PM +0200, Christophe Ricard wrote:
> Dropped the field 'locality' from struct tpm_vendor_specific migrated it to
> the private structures of st33zp24, tpm_i2c_infineon and tpm_tis.
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> ---
>  drivers/char/tpm/st33zp24/st33zp24.c | 12 +++---
>  drivers/char/tpm/st33zp24/st33zp24.h |  1 +
>  drivers/char/tpm/tpm.h               |  1 -
>  drivers/char/tpm/tpm_i2c_infineon.c  | 25 ++++++------
>  drivers/char/tpm/tpm_tis.c           | 73 ++++++++++++++++++------------------
>  5 files changed, 56 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index d2e0175..3802c58 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -136,7 +136,7 @@ static int check_locality(struct tpm_chip *chip)
>  	if (status && (data &
>  		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
>  		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
> -		return chip->vendor.locality;
> +		return tpm_dev->locality;
>  
>  	return -EACCES;
>  } /* check_locality() */
> @@ -153,11 +153,11 @@ static int request_locality(struct tpm_chip *chip)
>  	struct st33zp24_dev *tpm_dev;
>  	u8 data;
>  
> -	if (check_locality(chip) == chip->vendor.locality)
> -		return chip->vendor.locality;
> -
>  	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  
> +	if (check_locality(chip) == tpm_dev->locality)
> +		return tpm_dev->locality;
> +
>  	data = TPM_ACCESS_REQUEST_USE;
>  	ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
>  	if (ret < 0)
> @@ -168,7 +168,7 @@ static int request_locality(struct tpm_chip *chip)
>  	/* Request locality is usually effective after the request */
>  	do {
>  		if (check_locality(chip) >= 0)
> -			return chip->vendor.locality;
> +			return tpm_dev->locality;
>  		msleep(TPM_TIMEOUT);
>  	} while (time_before(jiffies, stop));
>  
> @@ -566,7 +566,7 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
>  	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
>  	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
>  
> -	chip->vendor.locality = LOCALITY0;
> +	tpm_dev->locality = LOCALITY0;
>  
>  	if (irq) {
>  		/* INTERRUPT Setup */
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.h b/drivers/char/tpm/st33zp24/st33zp24.h
> index 9b5cdc7..6f4a419 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.h
> +++ b/drivers/char/tpm/st33zp24/st33zp24.h
> @@ -25,6 +25,7 @@ struct st33zp24_dev {
>  	struct tpm_chip *chip;
>  	void *phy_id;
>  	const struct st33zp24_phy_ops *ops;
> +	int locality;
>  	int irq;
>  	u32 intrs;
>  	int io_lpcpd;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 62e711b..68a40c6 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -131,7 +131,6 @@ enum tpm2_startup_types {
>  struct tpm_chip;
>  
>  struct tpm_vendor_specific {
> -	int locality;
>  	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
>  	bool timeout_adjusted;
>  	unsigned long duration[3]; /* jiffies */
> diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> index 093daf9..8318946 100644
> --- a/drivers/char/tpm/tpm_i2c_infineon.c
> +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> @@ -66,6 +66,7 @@ enum i2c_chip_type {
>  /* Structure to store I2C TPM specific stuff */
>  struct tpm_inf_dev {
>  	struct i2c_client *client;
> +	int locality;
>  	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
>  	struct tpm_chip *chip;
>  	enum i2c_chip_type chip_type;
> @@ -288,7 +289,7 @@ static int check_locality(struct tpm_chip *chip, int loc)
>  
>  	if ((buf & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
> -		chip->vendor.locality = loc;
> +		tpm_dev.locality = loc;
>  		return loc;
>  	}
>  
> @@ -337,7 +338,7 @@ static u8 tpm_tis_i2c_status(struct tpm_chip *chip)
>  	u8 i = 0;
>  
>  	do {
> -		if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
> +		if (iic_tpm_read(TPM_STS(tpm_dev.locality), &buf, 1) < 0)
>  			return 0;
>  
>  		i++;
> @@ -351,7 +352,7 @@ static void tpm_tis_i2c_ready(struct tpm_chip *chip)
>  {
>  	/* this causes the current command to be aborted */
>  	u8 buf = TPM_STS_COMMAND_READY;
> -	iic_tpm_write_long(TPM_STS(chip->vendor.locality), &buf, 1);
> +	iic_tpm_write_long(TPM_STS(tpm_dev.locality), &buf, 1);
>  }
>  
>  static ssize_t get_burstcount(struct tpm_chip *chip)
> @@ -365,7 +366,7 @@ static ssize_t get_burstcount(struct tpm_chip *chip)
>  	stop = jiffies + chip->vendor.timeout_d;
>  	do {
>  		/* Note: STS is little endian */
> -		if (iic_tpm_read(TPM_STS(chip->vendor.locality)+1, buf, 3) < 0)
> +		if (iic_tpm_read(TPM_STS(tpm_dev.locality)+1, buf, 3) < 0)
>  			burstcnt = 0;
>  		else
>  			burstcnt = (buf[2] << 16) + (buf[1] << 8) + buf[0];
> @@ -419,7 +420,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  		if (burstcnt > (count - size))
>  			burstcnt = count - size;
>  
> -		rc = iic_tpm_read(TPM_DATA_FIFO(chip->vendor.locality),
> +		rc = iic_tpm_read(TPM_DATA_FIFO(tpm_dev.locality),
>  				  &(buf[size]), burstcnt);
>  		if (rc == 0)
>  			size += burstcnt;
> @@ -477,7 +478,7 @@ out:
>  	 * so we sleep rather than keeping the bus busy
>  	 */
>  	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, tpm_dev.locality, 0);
>  	return size;
>  }
>  
> @@ -516,7 +517,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  		if (burstcnt > (len - 1 - count))
>  			burstcnt = len - 1 - count;
>  
> -		rc = iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality),
> +		rc = iic_tpm_write(TPM_DATA_FIFO(tpm_dev.locality),
>  				   &(buf[count]), burstcnt);
>  		if (rc == 0)
>  			count += burstcnt;
> @@ -539,7 +540,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	}
>  
>  	/* write last byte */
> -	iic_tpm_write(TPM_DATA_FIFO(chip->vendor.locality), &(buf[count]), 1);
> +	iic_tpm_write(TPM_DATA_FIFO(tpm_dev.locality), &(buf[count]), 1);
>  	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
>  	if ((status & TPM_STS_DATA_EXPECT) != 0) {
>  		rc = -EIO;
> @@ -547,7 +548,7 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	}
>  
>  	/* go and do it */
> -	iic_tpm_write(TPM_STS(chip->vendor.locality), &sts, 1);
> +	iic_tpm_write(TPM_STS(tpm_dev.locality), &sts, 1);
>  
>  	return len;
>  out_err:
> @@ -556,7 +557,7 @@ out_err:
>  	 * so we sleep rather than keeping the bus busy
>  	 */
>  	usleep_range(SLEEP_DURATION_RESET_LOW, SLEEP_DURATION_RESET_HI);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, tpm_dev.locality, 0);
>  	return rc;
>  }
>  
> @@ -623,7 +624,7 @@ static int tpm_tis_i2c_init(struct device *dev)
>  
>  	return tpm_chip_register(chip);
>  out_release:
> -	release_locality(chip, chip->vendor.locality, 1);
> +	release_locality(chip, tpm_dev.locality, 1);
>  	tpm_dev.client = NULL;
>  out_err:
>  	return rc;
> @@ -695,7 +696,7 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
>  	struct tpm_chip *chip = tpm_dev.chip;
>  
>  	tpm_chip_unregister(chip);
> -	release_locality(chip, chip->vendor.locality, 1);
> +	release_locality(chip, tpm_dev.locality, 1);
>  	tpm_dev.client = NULL;
>  
>  	return 0;
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 403c7bd..25f2854 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -96,6 +96,7 @@ struct tpm_info {
>  struct priv_data {
>  	void __iomem *iobase;
>  	u16 manufacturer_id;
> +	int locality;
>  	int irq;
>  	bool irq_tested;
>  	wait_queue_head_t int_queue;
> @@ -149,7 +150,7 @@ static int check_locality(struct tpm_chip *chip, int l)
>  	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
>  	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
> -		return chip->vendor.locality = l;
> +		return priv->locality = l;
>  
>  	return -1;
>  }
> @@ -211,7 +212,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>  	struct priv_data *priv = chip->vendor.priv;
>  
>  	return ioread8(priv->iobase +
> -		       TPM_STS(chip->vendor.locality));
> +		       TPM_STS(priv->locality));
>  }
>  
>  static void tpm_tis_ready(struct tpm_chip *chip)
> @@ -220,7 +221,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
>  
>  	/* this causes the current command to be aborted */
>  	iowrite8(TPM_STS_COMMAND_READY,
> -		 priv->iobase + TPM_STS(chip->vendor.locality));
> +		 priv->iobase + TPM_STS(priv->locality));
>  }
>  
>  static int get_burstcount(struct tpm_chip *chip)
> @@ -234,9 +235,9 @@ static int get_burstcount(struct tpm_chip *chip)
>  	stop = jiffies + chip->vendor.timeout_d;
>  	do {
>  		burstcnt = ioread8(priv->iobase +
> -				   TPM_STS(chip->vendor.locality) + 1);
> +				   TPM_STS(priv->locality) + 1);
>  		burstcnt += ioread8(priv->iobase +
> -				    TPM_STS(chip->vendor.locality) +
> +				    TPM_STS(priv->locality) +
>  				    2) << 8;
>  		if (burstcnt)
>  			return burstcnt;
> @@ -258,8 +259,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  		burstcnt = get_burstcount(chip);
>  		for (; burstcnt > 0 && size < count; burstcnt--)
>  			buf[size++] = ioread8(priv->iobase +
> -					      TPM_DATA_FIFO(chip->vendor.
> -							    locality));
> +					      TPM_DATA_FIFO(priv->locality));
>  	}
>  	return size;
>  }
> @@ -307,7 +307,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  out:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, priv->locality, 0);
>  	return size;
>  }
>  
> @@ -344,7 +344,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  		burstcnt = get_burstcount(chip);
>  		for (; burstcnt > 0 && count < len - 1; burstcnt--) {
>  			iowrite8(buf[count], priv->iobase +
> -				 TPM_DATA_FIFO(chip->vendor.locality));
> +				 TPM_DATA_FIFO(priv->locality));
>  			count++;
>  		}
>  
> @@ -359,7 +359,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  	/* write last byte */
>  	iowrite8(buf[count],
> -		 priv->iobase + TPM_DATA_FIFO(chip->vendor.locality));
> +		 priv->iobase + TPM_DATA_FIFO(priv->locality));
>  	wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
>  			  &priv->int_queue, false);
>  	status = tpm_tis_status(chip);
> @@ -372,7 +372,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  out_err:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, priv->locality, 0);
>  	return rc;
>  }
>  
> @@ -383,10 +383,10 @@ static void disable_interrupts(struct tpm_chip *chip)
>  
>  	intmask =
>  	    ioread32(priv->iobase +
> -		     TPM_INT_ENABLE(chip->vendor.locality));
> +		     TPM_INT_ENABLE(priv->locality));
>  	intmask &= ~TPM_GLOBAL_INT_ENABLE;
>  	iowrite32(intmask,
> -		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +		  priv->iobase + TPM_INT_ENABLE(priv->locality));
>  	devm_free_irq(&chip->dev, priv->irq, chip);
>  	priv->irq = 0;
>  	chip->flags &= ~TPM_CHIP_FLAG_IRQ;
> @@ -410,7 +410,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  	/* go and do it */
>  	iowrite8(TPM_STS_GO,
> -		 priv->iobase + TPM_STS(chip->vendor.locality));
> +		 priv->iobase + TPM_STS(priv->locality));
>  
>  	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
>  		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> @@ -430,7 +430,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  	return len;
>  out_err:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, priv->locality, 0);
>  	return rc;
>  }
>  
> @@ -516,7 +516,7 @@ static int probe_itpm(struct tpm_chip *chip)
>  		goto out;
>  
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, priv->locality, 0);
>  
>  	itpm = true;
>  
> @@ -530,7 +530,7 @@ static int probe_itpm(struct tpm_chip *chip)
>  out:
>  	itpm = rem_itpm;
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, priv->locality, 0);
>  
>  	return rc;
>  }
> @@ -569,7 +569,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  	int i;
>  
>  	interrupt = ioread32(priv->iobase +
> -			     TPM_INT_STATUS(chip->vendor.locality));
> +			     TPM_INT_STATUS(priv->locality));
>  
>  	if (interrupt == 0)
>  		return IRQ_NONE;
> @@ -589,8 +589,8 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  	/* Clear interrupts handled with TPM_EOI */
>  	iowrite32(interrupt,
>  		  priv->iobase +
> -		  TPM_INT_STATUS(chip->vendor.locality));
> -	ioread32(priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
> +		  TPM_INT_STATUS(priv->locality));
> +	ioread32(priv->iobase + TPM_INT_STATUS(priv->locality));
>  	return IRQ_HANDLED;
>  }
>  
> @@ -613,18 +613,18 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  	priv->irq = irq;
>  
>  	original_int_vec = ioread8(priv->iobase +
> -				   TPM_INT_VECTOR(chip->vendor.locality));
> +				   TPM_INT_VECTOR(priv->locality));
>  	iowrite8(irq,
> -		 priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
> +		 priv->iobase + TPM_INT_VECTOR(priv->locality));
>  
>  	/* Clear all existing */
>  	iowrite32(ioread32(priv->iobase +
> -			   TPM_INT_STATUS(chip->vendor.locality)),
> -		  priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
> +			   TPM_INT_STATUS(priv->locality)),
> +		  priv->iobase + TPM_INT_STATUS(priv->locality));
>  
>  	/* Turn on */
>  	iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
> -		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +		  priv->iobase + TPM_INT_ENABLE(priv->locality));
>  
>  	priv->irq_tested = false;
>  
> @@ -641,7 +641,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  	 */
>  	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>  		iowrite8(original_int_vec,
> -			 priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
> +			 priv->iobase + TPM_INT_VECTOR(priv->locality));
>  		return 1;
>  	}
>  
> @@ -659,7 +659,7 @@ static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
>  	int i;
>  
>  	original_int_vec = ioread8(priv->iobase +
> -				   TPM_INT_VECTOR(chip->vendor.locality));
> +				   TPM_INT_VECTOR(priv->locality));
>  
>  	if (!original_int_vec) {
>  		if (IS_ENABLED(CONFIG_X86))
> @@ -685,10 +685,9 @@ static void tpm_tis_remove(struct tpm_chip *chip)
>  
>  	iowrite32(~TPM_GLOBAL_INT_ENABLE &
>  		  ioread32(priv->iobase +
> -			   TPM_INT_ENABLE(chip->vendor.
> -					  locality)),
> -			   priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> -	release_locality(chip, chip->vendor.locality, 1);
> +			   TPM_INT_ENABLE(priv->locality)),
> +			   priv->iobase + TPM_INT_ENABLE(priv->locality));
> +	release_locality(chip, priv->locality, 1);
>  }
>  
>  static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
> @@ -729,12 +728,12 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  
>  	/* Take control of the TPM's interrupt hardware and shut it off */
>  	intmask = ioread32(priv->iobase +
> -			   TPM_INT_ENABLE(chip->vendor.locality));
> +			   TPM_INT_ENABLE(priv->locality));
>  	intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
>  		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
>  	intmask &= ~TPM_GLOBAL_INT_ENABLE;
>  	iowrite32(intmask,
> -		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +		  priv->iobase + TPM_INT_ENABLE(priv->locality));
>  
>  	if (request_locality(chip, 0) != 0) {
>  		rc = -ENODEV;
> @@ -768,7 +767,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	/* Figure out the capabilities */
>  	intfcaps =
>  	    ioread32(priv->iobase +
> -		     TPM_INTF_CAPS(chip->vendor.locality));
> +		     TPM_INTF_CAPS(priv->locality));
>  	dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
>  		intfcaps);
>  	if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
> @@ -852,17 +851,17 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  	/* reenable interrupts that device may have lost or
>  	   BIOS/firmware may have disabled */
>  	iowrite8(priv->irq, priv->iobase +
> -		 TPM_INT_VECTOR(chip->vendor.locality));
> +		 TPM_INT_VECTOR(priv->locality));
>  
>  	intmask =
> -	    ioread32(priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +	    ioread32(priv->iobase + TPM_INT_ENABLE(priv->locality));
>  
>  	intmask |= TPM_INTF_CMD_READY_INT
>  	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
>  	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
>  
>  	iowrite32(intmask,
> -		  priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +		  priv->iobase + TPM_INT_ENABLE(priv->locality));
>  }
>  
>  static int tpm_tis_resume(struct device *dev)
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
