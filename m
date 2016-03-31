From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 6/6] tpm: Remove useless priv field in
 struct tpm_vendor_specific
Date: Thu, 31 Mar 2016 09:56:48 +0300
Message-ID: <20160331065648.GG6393@intel.com>
References: <1459373895-17704-1-git-send-email-christophe-h.ricard@st.com>
	<1459373895-17704-7-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459373895-17704-7-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Mar 30, 2016 at 11:38:15PM +0200, Christophe Ricard wrote:
> Remove useless priv field in struct tpm_vendor_specific and take benefit
> of chip->dev.driver_data.
> As priv is the latest field available in struct tpm_vendor_specific,
> remove any reference to that structure.
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/st33zp24/i2c.c      | 15 +++++++----
>  drivers/char/tpm/st33zp24/spi.c      | 15 +++++++----
>  drivers/char/tpm/st33zp24/st33zp24.c | 50 ++++++++++--------------------------
>  drivers/char/tpm/tpm.h               |  9 -------
>  drivers/char/tpm/tpm_atmel.c         | 12 ++++-----
>  drivers/char/tpm/tpm_atmel.h         |  5 ----
>  drivers/char/tpm/tpm_crb.c           | 12 ++++-----
>  drivers/char/tpm/tpm_i2c_atmel.c     | 14 +++++-----
>  drivers/char/tpm/tpm_i2c_nuvoton.c   | 17 ++++++------
>  drivers/char/tpm/tpm_ibmvtpm.c       | 38 ++++++++-------------------
>  drivers/char/tpm/tpm_nsc.c           | 48 ++++++++++++++++++----------------
>  drivers/char/tpm/tpm_tis.c           | 47 ++++++++++++++++-----------------
>  drivers/char/tpm/xen-tpmfront.c      | 14 +++++-----
>  13 files changed, 131 insertions(+), 165 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/i2c.c b/drivers/char/tpm/st33zp24/i2c.c
> index f8e8123..028a9cd 100644
> --- a/drivers/char/tpm/st33zp24/i2c.c
> +++ b/drivers/char/tpm/st33zp24/i2c.c
> @@ -26,6 +26,7 @@
>  #include <linux/tpm.h>
>  #include <linux/platform_data/st33zp24.h>
>  
> +#include "../tpm.h"
>  #include "st33zp24.h"
>  
>  #define TPM_DUMMY_BYTE			0xAA
> @@ -112,7 +113,9 @@ static const struct st33zp24_phy_ops i2c_phy_ops = {
>  
>  static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
>  {
> -	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
> +	struct tpm_chip *chip = i2c_get_clientdata(client);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_i2c_phy *phy = tpm_dev->phy_id;
>  	struct gpio_desc *gpiod_lpcpd;
>  	struct device *dev = &client->dev;
>  
> @@ -138,7 +141,9 @@ static int st33zp24_i2c_acpi_request_resources(struct i2c_client *client)
>  
>  static int st33zp24_i2c_of_request_resources(struct i2c_client *client)
>  {
> -	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
> +	struct tpm_chip *chip = i2c_get_clientdata(client);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_i2c_phy *phy = tpm_dev->phy_id;
>  	struct device_node *pp;
>  	int gpio;
>  	int ret;
> @@ -176,8 +181,10 @@ static int st33zp24_i2c_of_request_resources(struct i2c_client *client)
>  
>  static int st33zp24_i2c_request_resources(struct i2c_client *client)
>  {
> +	struct tpm_chip *chip = i2c_get_clientdata(client);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_i2c_phy *phy = tpm_dev->phy_id;
>  	struct st33zp24_platform_data *pdata;
> -	struct st33zp24_i2c_phy *phy = i2c_get_clientdata(client);
>  	int ret;
>  
>  	pdata = client->dev.platform_data;
> @@ -234,8 +241,6 @@ static int st33zp24_i2c_probe(struct i2c_client *client,
>  
>  	phy->client = client;
>  
> -	i2c_set_clientdata(client, phy);
> -
>  	pdata = client->dev.platform_data;
>  	if (!pdata && client->dev.of_node) {
>  		ret = st33zp24_i2c_of_request_resources(client);
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index 608dbc6..9f5a011 100644
> --- a/drivers/char/tpm/st33zp24/spi.c
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -26,6 +26,7 @@
>  #include <linux/tpm.h>
>  #include <linux/platform_data/st33zp24.h>
>  
> +#include "../tpm.h"
>  #include "st33zp24.h"
>  
>  #define TPM_DATA_FIFO           0x24
> @@ -231,7 +232,9 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
>  
>  static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
>  {
> -	struct st33zp24_spi_phy *phy = spi_get_drvdata(spi_dev);
> +	struct tpm_chip *chip = spi_get_drvdata(spi_dev);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_spi_phy *phy = tpm_dev->phy_id;
>  	struct gpio_desc *gpiod_lpcpd;
>  	struct device *dev = &spi_dev->dev;
>  
> @@ -256,7 +259,9 @@ static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
>  
>  static int st33zp24_spi_of_request_resources(struct spi_device *spi_dev)
>  {
> -	struct st33zp24_spi_phy *phy = spi_get_drvdata(spi_dev);
> +	struct tpm_chip *chip = spi_get_drvdata(spi_dev);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_spi_phy *phy = tpm_dev->phy_id;
>  	struct device_node *pp;
>  	int gpio;
>  	int ret;
> @@ -294,7 +299,9 @@ static int st33zp24_spi_of_request_resources(struct spi_device *spi_dev)
>  
>  static int st33zp24_spi_request_resources(struct spi_device *dev)
>  {
> -	struct st33zp24_spi_phy *phy = spi_get_drvdata(dev);
> +	struct tpm_chip *chip = spi_get_drvdata(dev);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
> +	struct st33zp24_spi_phy *phy = tpm_dev->phy_id;
>  	struct st33zp24_platform_data *pdata;
>  	int ret;
>  
> @@ -347,8 +354,6 @@ static int st33zp24_spi_probe(struct spi_device *dev)
>  
>  	phy->spi_device = dev;
>  
> -	spi_set_drvdata(dev, phy);
> -
>  	pdata = dev->dev.platform_data;
>  	if (!pdata && dev->dev.of_node) {
>  		ret = st33zp24_spi_of_request_resources(dev);
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index 07531e9..a7c99a2 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -94,11 +94,9 @@ static u8 clear_interruption(struct st33zp24_dev *tpm_dev)
>   */
>  static void st33zp24_cancel(struct tpm_chip *chip)
>  {
> -	struct st33zp24_dev *tpm_dev;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	data = TPM_STS_COMMAND_READY;
>  	tpm_dev->ops->send(tpm_dev->phy_id, TPM_STS, &data, 1);
>  } /* st33zp24_cancel() */
> @@ -110,11 +108,9 @@ static void st33zp24_cancel(struct tpm_chip *chip)
>   */
>  static u8 st33zp24_status(struct tpm_chip *chip)
>  {
> -	struct st33zp24_dev *tpm_dev;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1);
>  	return data;
>  } /* st33zp24_status() */
> @@ -126,12 +122,10 @@ static u8 st33zp24_status(struct tpm_chip *chip)
>   */
>  static int check_locality(struct tpm_chip *chip)
>  {
> -	struct st33zp24_dev *tpm_dev;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	u8 data;
>  	u8 status;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
>  	if (status && (data &
>  		(TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> @@ -148,13 +142,11 @@ static int check_locality(struct tpm_chip *chip)
>   */
>  static int request_locality(struct tpm_chip *chip)
>  {
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	unsigned long stop;
>  	long ret;
> -	struct st33zp24_dev *tpm_dev;
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	if (check_locality(chip) == tpm_dev->locality)
>  		return tpm_dev->locality;
>  
> @@ -182,10 +174,9 @@ static int request_locality(struct tpm_chip *chip)
>   */
>  static void release_locality(struct tpm_chip *chip)
>  {
> -	struct st33zp24_dev *tpm_dev;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	u8 data;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  	data = TPM_ACCESS_ACTIVE_LOCALITY;
>  
>  	tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
> @@ -198,12 +189,10 @@ static void release_locality(struct tpm_chip *chip)
>   */
>  static int get_burstcount(struct tpm_chip *chip)
>  {
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	unsigned long stop;
>  	int burstcnt, status;
>  	u8 temp;
> -	struct st33zp24_dev *tpm_dev;
> -
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  
>  	stop = jiffies + chip->timeout_d;
>  	do {
> @@ -263,15 +252,13 @@ static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
>  static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  			wait_queue_head_t *queue, bool check_cancel)
>  {
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	unsigned long stop;
>  	int ret = 0;
>  	bool canceled = false;
>  	bool condition;
>  	u32 cur_intrs;
>  	u8 status;
> -	struct st33zp24_dev *tpm_dev;
> -
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  
>  	/* check current status */
>  	status = st33zp24_status(chip);
> @@ -329,10 +316,8 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>   */
>  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	int size = 0, burstcnt, len, ret;
> -	struct st33zp24_dev *tpm_dev;
> -
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  
>  	while (size < count &&
>  	       wait_for_stat(chip,
> @@ -362,9 +347,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> -	struct st33zp24_dev *tpm_dev;
> -
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  
>  	tpm_dev->intrs++;
>  	wake_up_interruptible(&tpm_dev->read_queue);
> @@ -385,19 +368,17 @@ static irqreturn_t tpm_ioserirq_handler(int irq, void *dev_id)
>  static int st33zp24_send(struct tpm_chip *chip, unsigned char *buf,
>  			 size_t len)
>  {
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	u32 status, i, size, ordinal;
>  	int burstcnt = 0;
>  	int ret;
>  	u8 data;
> -	struct st33zp24_dev *tpm_dev;
>  
>  	if (!chip)
>  		return -EBUSY;
>  	if (len < TPM_HEADER_SIZE)
>  		return -EBUSY;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	ret = request_locality(chip);
>  	if (ret < 0)
>  		return ret;
> @@ -557,9 +538,9 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
>  	if (!tpm_dev)
>  		return -ENOMEM;
>  
> -	TPM_VPRIV(chip) = tpm_dev;
>  	tpm_dev->phy_id = phy_id;
>  	tpm_dev->ops = ops;
> +	dev_set_drvdata(&chip->dev, tpm_dev);
>  
>  	chip->timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
>  	chip->timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> @@ -643,10 +624,9 @@ EXPORT_SYMBOL(st33zp24_remove);
>  int st33zp24_pm_suspend(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	struct st33zp24_dev *tpm_dev;
> -	int ret = 0;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> +	int ret = 0;
>  
>  	if (gpio_is_valid(tpm_dev->io_lpcpd))
>  		gpio_set_value(tpm_dev->io_lpcpd, 0);
> @@ -665,11 +645,9 @@ EXPORT_SYMBOL(st33zp24_pm_suspend);
>  int st33zp24_pm_resume(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	struct st33zp24_dev *tpm_dev;
> +	struct st33zp24_dev *tpm_dev = dev_get_drvdata(&chip->dev);
>  	int ret = 0;
>  
> -	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> -
>  	if (gpio_is_valid(tpm_dev->io_lpcpd)) {
>  		gpio_set_value(tpm_dev->io_lpcpd, 1);
>  		ret = wait_for_stat(chip,
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 7e2b788..78e3b53 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -128,14 +128,6 @@ enum tpm2_startup_types {
>  	TPM2_SU_STATE	= 0x0001,
>  };
>  
> -struct tpm_chip;
> -
> -struct tpm_vendor_specific {
> -	void *priv;
> -};
> -
> -#define TPM_VPRIV(c)     ((c)->vendor.priv)
> -
>  #define TPM_VID_INTEL    0x8086
>  #define TPM_VID_WINBOND  0x1050
>  #define TPM_VID_STM      0x104A
> @@ -166,7 +158,6 @@ struct tpm_chip {
>  
>  	struct mutex tpm_mutex;	/* tpm is processing */
>  
> -	struct tpm_vendor_specific vendor;
>  	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
>  	bool timeout_adjusted;
>  	unsigned long duration[3]; /* jiffies */
> diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> index b769299..0d322ab 100644
> --- a/drivers/char/tpm/tpm_atmel.c
> +++ b/drivers/char/tpm/tpm_atmel.c
> @@ -37,7 +37,7 @@ enum tpm_atmel_read_status {
>  
>  static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  	u8 status, *hdr = buf;
>  	u32 size;
>  	int i;
> @@ -96,7 +96,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  	int i;
>  
>  	dev_dbg(&chip->dev, "tpm_atml_send:\n");
> @@ -110,14 +110,14 @@ static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static void tpm_atml_cancel(struct tpm_chip *chip)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  
>  	iowrite8(ATML_STATUS_ABORT, priv->iobase + 1);
>  }
>  
>  static u8 tpm_atml_status(struct tpm_chip *chip)
>  {
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  
>  	return ioread8(priv->iobase + 1);
>  }
> @@ -142,7 +142,7 @@ static struct platform_device *pdev;
>  static void atml_plat_remove(void)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
> -	struct tpm_atmel_priv *priv = chip->vendor.priv;
> +	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
>  
>  	if (chip) {
>  		tpm_chip_unregister(chip);
> @@ -207,7 +207,7 @@ static int __init init_atmel(void)
>  		goto err_unreg_dev;
>  	}
>  
> -	chip->vendor.priv = priv;
> +	dev_set_drvdata(&chip->dev, priv);
>  
>  	rc = tpm_chip_register(chip);
>  	if (rc)
> diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
> index 7e37c16..c786e01 100644
> --- a/drivers/char/tpm/tpm_atmel.h
> +++ b/drivers/char/tpm/tpm_atmel.h
> @@ -29,11 +29,6 @@ struct tpm_atmel_priv {
>  	void __iomem *iobase;
>  };
>  
> -static inline struct tpm_atmel_priv *atmel_get_priv(struct tpm_chip *chip)
> -{
> -	return chip->vendor.priv;
> -}
> -
>  #ifdef CONFIG_PPC64
>  
>  #include <asm/prom.h>
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 8767da6..20155d5 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -87,7 +87,7 @@ static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
>  
>  static u8 crb_status(struct tpm_chip *chip)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  	u8 sts = 0;
>  
>  	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
> @@ -99,7 +99,7 @@ static u8 crb_status(struct tpm_chip *chip)
>  
>  static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  	unsigned int expected;
>  
>  	/* sanity check */
> @@ -139,7 +139,7 @@ static int crb_do_acpi_start(struct tpm_chip *chip)
>  
>  static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  	int rc = 0;
>  
>  	if (len > ioread32(&priv->cca->cmd_size)) {
> @@ -163,7 +163,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  static void crb_cancel(struct tpm_chip *chip)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  
>  	iowrite32(cpu_to_le32(CRB_CANCEL_INVOKE), &priv->cca->cancel);
>  
> @@ -175,7 +175,7 @@ static void crb_cancel(struct tpm_chip *chip)
>  
>  static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
>  {
> -	struct crb_priv *priv = chip->vendor.priv;
> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  	u32 cancel = ioread32(&priv->cca->cancel);
>  
>  	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
> @@ -200,7 +200,7 @@ static int crb_init(struct acpi_device *device, struct crb_priv *priv)
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = priv;
> +	dev_set_drvdata(&chip->dev, priv);
>  	chip->acpi_dev_handle = device->handle;
>  	chip->flags = TPM_CHIP_FLAG_TPM2;
>  
> diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
> index 1b66da6..c37aa72 100644
> --- a/drivers/char/tpm/tpm_i2c_atmel.c
> +++ b/drivers/char/tpm/tpm_i2c_atmel.c
> @@ -51,7 +51,7 @@ struct priv_data {
>  
>  static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	s32 status;
>  
> @@ -70,7 +70,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  
>  static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	struct tpm_output_header *hdr =
>  		(struct tpm_output_header *)priv->buffer;
> @@ -111,7 +111,7 @@ static void i2c_atmel_cancel(struct tpm_chip *chip)
>  
>  static u8 i2c_atmel_read_status(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	struct i2c_client *client = to_i2c_client(chip->dev.parent);
>  	int rc;
>  
> @@ -155,6 +155,7 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  {
>  	struct tpm_chip *chip;
>  	struct device *dev = &client->dev;
> +	struct priv_data *priv;
>  
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
>  		return -ENODEV;
> @@ -163,9 +164,8 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
> -					 GFP_KERNEL);
> -	if (!chip->vendor.priv)
> +	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
> +	if (!priv)
>  		return -ENOMEM;
>  
>  	/* Default timeouts */
> @@ -174,6 +174,8 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  	chip->timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
>  	chip->timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
>  
> +	dev_set_drvdata(&chip->dev, priv);
> +
>  	/* There is no known way to probe for this device, and all version
>  	 * information seems to be read via TPM commands. Thus we rely on the
>  	 * TPM startup process in the common code to detect the device. */
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index 491a16a..4e32094 100644
> --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -180,7 +180,7 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
>  {
>  	if ((chip->flags & TPM_CHIP_FLAG_IRQ) && queue) {
>  		s32 rc;
> -		struct priv_data *priv = chip->vendor.priv;
> +		struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  		unsigned int cur_intrs = priv->intrs;
>  
>  		enable_irq(priv->irq);
> @@ -233,7 +233,7 @@ static int i2c_nuvoton_wait_for_data_avail(struct tpm_chip *chip, u32 timeout,
>  static int i2c_nuvoton_recv_data(struct i2c_client *client,
>  				 struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	s32 rc;
>  	int burst_count, bytes2read, size = 0;
>  
> @@ -267,7 +267,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
>  /* Read TPM command results */
>  static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	struct device *dev = chip->dev.parent;
>  	struct i2c_client *client = to_i2c_client(dev);
>  	s32 rc;
> @@ -351,7 +351,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>   */
>  static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	struct device *dev = chip->dev.parent;
>  	struct i2c_client *client = to_i2c_client(dev);
>  	u32 ordinal;
> @@ -478,7 +478,7 @@ static const struct tpm_class_ops tpm_i2c = {
>  static irqreturn_t i2c_nuvoton_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	priv->intrs++;
>  	wake_up(&priv->read_queue);
> @@ -543,7 +543,6 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> -	chip->vendor.priv = priv;
>  
>  	init_waitqueue_head(&priv->read_queue);
>  
> @@ -553,6 +552,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  	chip->timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
>  	chip->timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
>  
> +	dev_set_drvdata(&chip->dev, priv);
> +
>  	/*
>  	 * I2C intfcaps (interrupt capabilitieis) in the chip are hard coded to:
>  	 *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
> @@ -619,8 +620,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  
>  static int i2c_nuvoton_remove(struct i2c_client *client)
>  {
> -	struct device *dev = &(client->dev);
> -	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct tpm_chip *chip = i2c_get_clientdata(client);
> +
>  	tpm_chip_unregister(chip);
>  	return 0;
>  }
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index b0a9a9e..6b22826 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -54,21 +54,6 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
>  }
>  
>  /**
> - * ibmvtpm_get_data - Retrieve ibm vtpm data
> - * @dev:	device struct
> - *
> - * Return value:
> - *	vtpm device struct
> - */
> -static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
> -{
> -	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	if (chip)
> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -	return NULL;
> -}
> -
> -/**
>   * tpm_ibmvtpm_recv - Receive data after send
>   * @chip:	tpm chip struct
>   * @buf:	buffer to read
> @@ -79,12 +64,10 @@ static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
>   */
>  static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct ibmvtpm_dev *ibmvtpm;
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  	u16 len;
>  	int sig;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
>  		return 0;
> @@ -122,13 +105,11 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>   */
>  static int tpm_ibmvtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct ibmvtpm_dev *ibmvtpm;
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  	struct ibmvtpm_crq crq;
>  	__be64 *word = (__be64 *)&crq;
>  	int rc, sig;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
>  		return 0;
> @@ -289,8 +270,8 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
>   */
>  static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>  {
> -	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(&vdev->dev);
> -	struct tpm_chip *chip = dev_get_drvdata(ibmvtpm->dev);
> +	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  	int rc = 0;
>  
>  	tpm_chip_unregister(chip);
> @@ -327,7 +308,8 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>   */
>  static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>  {
> -	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(&vdev->dev);
> +	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  
>  	/* ibmvtpm initializes at probe time, so the data we are
>  	* asking for may not be set yet. Estimate that 4K required
> @@ -348,7 +330,8 @@ static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>   */
>  static int tpm_ibmvtpm_suspend(struct device *dev)
>  {
> -	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  	struct ibmvtpm_crq crq;
>  	u64 *buf = (u64 *) &crq;
>  	int rc = 0;
> @@ -400,7 +383,8 @@ static int ibmvtpm_reset_crq(struct ibmvtpm_dev *ibmvtpm)
>   */
>  static int tpm_ibmvtpm_resume(struct device *dev)
>  {
> -	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(dev);
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
>  	int rc = 0;
>  
>  	do {
> @@ -643,7 +627,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
>  
>  	crq_q->index = 0;
>  
> -	TPM_VPRIV(chip) = (void *)ibmvtpm;
> +	dev_set_drvdata(&chip->dev, ibmvtpm)
>  
>  	spin_lock_init(&ibmvtpm->rtce_lock);
>  
> diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
> index 07163a4..9ff0e07 100644
> --- a/drivers/char/tpm/tpm_nsc.c
> +++ b/drivers/char/tpm/tpm_nsc.c
> @@ -69,20 +69,16 @@ struct tpm_nsc_priv {
>  	unsigned long base;
>  };
>  
> -static inline struct tpm_nsc_priv *nsc_get_priv(struct tpm_chip *chip)
> -{
> -	return chip->vendor.priv;
> -}
> -
>  /*
>   * Wait for a certain status to appear
>   */
>  static int wait_for_stat(struct tpm_chip *chip, u8 mask, u8 val, u8 * data)
>  {
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
>  	unsigned long stop;
>  
>  	/* status immediately available check */
> -	*data = inb(nsc_get_priv(chip)->base + NSC_STATUS);
> +	*data = inb(priv->base + NSC_STATUS);
>  	if ((*data & mask) == val)
>  		return 0;
>  
> @@ -90,7 +86,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, u8 val, u8 * data)
>  	stop = jiffies + 10 * HZ;
>  	do {
>  		msleep(TPM_TIMEOUT);
> -		*data = inb(nsc_get_priv(chip)->base + 1);
> +		*data = inb(priv->base + 1);
>  		if ((*data & mask) == val)
>  			return 0;
>  	}
> @@ -101,13 +97,14 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, u8 val, u8 * data)
>  
>  static int nsc_wait_for_ready(struct tpm_chip *chip)
>  {
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
>  	int status;
>  	unsigned long stop;
>  
>  	/* status immediately available check */
> -	status = inb(nsc_get_priv(chip)->base + NSC_STATUS);
> +	status = inb(priv->base + NSC_STATUS);
>  	if (status & NSC_STATUS_OBF)
> -		status = inb(nsc_get_priv(chip)->base + NSC_DATA);
> +		status = inb(priv->base + NSC_DATA);
>  	if (status & NSC_STATUS_RDY)
>  		return 0;
>  
> @@ -115,9 +112,9 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
>  	stop = jiffies + 100;
>  	do {
>  		msleep(TPM_TIMEOUT);
> -		status = inb(nsc_get_priv(chip)->base + NSC_STATUS);
> +		status = inb(priv->base + NSC_STATUS);
>  		if (status & NSC_STATUS_OBF)
> -			status = inb(nsc_get_priv(chip)->base + NSC_DATA);
> +			status = inb(priv->base + NSC_DATA);
>  		if (status & NSC_STATUS_RDY)
>  			return 0;
>  	}
> @@ -130,6 +127,7 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
>  
>  static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
>  {
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
>  	u8 *buffer = buf;
>  	u8 data, *p;
>  	u32 size;
> @@ -143,7 +141,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
>  		return -EIO;
>  	}
>  
> -	data = inb(nsc_get_priv(chip)->base + NSC_DATA);
> +	data = inb(priv->base + NSC_DATA);
>  	if (data != NSC_COMMAND_NORMAL) {
>  		dev_err(&chip->dev, "not in normal mode (0x%x)\n",
>  			data);
> @@ -160,7 +158,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
>  		}
>  		if (data & NSC_STATUS_F0)
>  			break;
> -		*p = inb(nsc_get_priv(chip)->base + NSC_DATA);
> +		*p = inb(priv->base + NSC_DATA);
>  	}
>  
>  	if ((data & NSC_STATUS_F0) == 0 &&
> @@ -169,7 +167,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
>  		return -EIO;
>  	}
>  
> -	data = inb(nsc_get_priv(chip)->base + NSC_DATA);
> +	data = inb(priv->base + NSC_DATA);
>  	if (data != NSC_COMMAND_EOC) {
>  		dev_err(&chip->dev,
>  			"expected end of command(0x%x)\n", data);
> @@ -187,6 +185,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
>  
>  static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
>  {
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
>  	u8 data;
>  	int i;
>  
> @@ -196,7 +195,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
>  	 * fix it. Not sure why this is needed, we followed the flow
>  	 * chart in the manual to the letter.
>  	 */
> -	outb(NSC_COMMAND_CANCEL, nsc_get_priv(chip)->base + NSC_COMMAND);
> +	outb(NSC_COMMAND_CANCEL, priv->base + NSC_COMMAND);
>  
>  	if (nsc_wait_for_ready(chip) != 0)
>  		return -EIO;
> @@ -206,7 +205,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
>  		return -EIO;
>  	}
>  
> -	outb(NSC_COMMAND_NORMAL, nsc_get_priv(chip)->base + NSC_COMMAND);
> +	outb(NSC_COMMAND_NORMAL, priv->base + NSC_COMMAND);
>  	if (wait_for_stat(chip, NSC_STATUS_IBR, NSC_STATUS_IBR, &data) < 0) {
>  		dev_err(&chip->dev, "IBR timeout\n");
>  		return -EIO;
> @@ -218,26 +217,30 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
>  				"IBF timeout (while writing data)\n");
>  			return -EIO;
>  		}
> -		outb(buf[i], nsc_get_priv(chip)->base + NSC_DATA);
> +		outb(buf[i], priv->base + NSC_DATA);
>  	}
>  
>  	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
>  		dev_err(&chip->dev, "IBF timeout\n");
>  		return -EIO;
>  	}
> -	outb(NSC_COMMAND_EOC, nsc_get_priv(chip)->base + NSC_COMMAND);
> +	outb(NSC_COMMAND_EOC, priv->base + NSC_COMMAND);
>  
>  	return count;
>  }
>  
>  static void tpm_nsc_cancel(struct tpm_chip *chip)
>  {
> -	outb(NSC_COMMAND_CANCEL, nsc_get_priv(chip)->base + NSC_COMMAND);
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
> +
> +	outb(NSC_COMMAND_CANCEL, priv->base + NSC_COMMAND);
>  }
>  
>  static u8 tpm_nsc_status(struct tpm_chip *chip)
>  {
> -	return inb(nsc_get_priv(chip)->base + NSC_STATUS);
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
> +
> +	return inb(priv->base + NSC_STATUS);
>  }
>  
>  static bool tpm_nsc_req_canceled(struct tpm_chip *chip, u8 status)
> @@ -260,9 +263,10 @@ static struct platform_device *pdev = NULL;
>  static void tpm_nsc_remove(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	struct tpm_nsc_priv *priv = dev_get_drvdata(&chip->dev);
>  
>  	tpm_chip_unregister(chip);
> -	release_region(nsc_get_priv(chip)->base, 2);
> +	release_region(priv->base, 2);
>  }
>  
>  static SIMPLE_DEV_PM_OPS(tpm_nsc_pm, tpm_pm_suspend, tpm_pm_resume);
> @@ -334,7 +338,7 @@ static int __init init_nsc(void)
>  		goto err_rel_reg;
>  	}
>  
> -	chip->vendor.priv = priv;
> +	dev_set_drvdata(&chip->dev, priv);
>  
>  	rc = tpm_chip_register(chip);
>  	if (rc)
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 7b15097..c644f9c 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -132,7 +132,7 @@ static inline int is_itpm(struct acpi_device *dev)
>   * correct values in the other bits.' */
>  static int wait_startup(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	unsigned long stop = jiffies + chip->timeout_a;
>  	do {
>  		if (ioread8(priv->iobase + TPM_ACCESS(l)) &
> @@ -145,7 +145,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
>  
>  static int check_locality(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
>  	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> @@ -157,7 +157,7 @@ static int check_locality(struct tpm_chip *chip, int l)
>  
>  static void release_locality(struct tpm_chip *chip, int l, int force)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	if (force || (ioread8(priv->iobase + TPM_ACCESS(l)) &
>  		      (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
> @@ -168,7 +168,7 @@ static void release_locality(struct tpm_chip *chip, int l, int force)
>  
>  static int request_locality(struct tpm_chip *chip, int l)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	unsigned long stop, timeout;
>  	long rc;
>  
> @@ -209,7 +209,7 @@ again:
>  
>  static u8 tpm_tis_status(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	return ioread8(priv->iobase +
>  		       TPM_STS(priv->locality));
> @@ -217,7 +217,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
>  
>  static void tpm_tis_ready(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	/* this causes the current command to be aborted */
>  	iowrite8(TPM_STS_COMMAND_READY,
> @@ -226,7 +226,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
>  
>  static int get_burstcount(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	unsigned long stop;
>  	int burstcnt;
>  
> @@ -248,7 +248,7 @@ static int get_burstcount(struct tpm_chip *chip)
>  
>  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int size = 0, burstcnt;
>  	while (size < count &&
>  	       wait_for_tpm_stat(chip,
> @@ -266,7 +266,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int size = 0;
>  	int expected, status;
>  
> @@ -322,7 +322,7 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
>   */
>  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc, status, burstcnt;
>  	size_t count = 0;
>  
> @@ -378,7 +378,7 @@ out_err:
>  
>  static void disable_interrupts(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	u32 intmask;
>  
>  	intmask =
> @@ -399,7 +399,7 @@ static void disable_interrupts(struct tpm_chip *chip)
>   */
>  static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc;
>  	u32 ordinal;
>  	unsigned long dur;
> @@ -437,7 +437,7 @@ out_err:
>  static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  {
>  	int rc, irq;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	if (!(chip->flags & TPM_CHIP_FLAG_IRQ) || priv->irq_tested)
>  		return tpm_tis_send_main(chip, buf, len);
> @@ -471,7 +471,7 @@ static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
>  static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>  				    unsigned long *timeout_cap)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int i;
>  	u32 did_vid;
>  
> @@ -495,7 +495,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>   */
>  static int probe_itpm(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	int rc = 0;
>  	u8 cmd_getticks[] = {
>  		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> @@ -537,7 +537,7 @@ out:
>  
>  static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	switch (priv->manufacturer_id) {
>  	case TPM_VID_WINBOND:
> @@ -564,7 +564,7 @@ static const struct tpm_class_ops tpm_tis = {
>  static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  {
>  	struct tpm_chip *chip = dev_id;
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	u32 interrupt;
>  	int i;
>  
> @@ -574,7 +574,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  	if (interrupt == 0)
>  		return IRQ_NONE;
>  
> -	((struct priv_data *)chip->vendor.priv)->irq_tested = true;
> +	priv->irq_tested = true;
>  	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
>  		wake_up_interruptible(&priv->read_queue);
>  	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
> @@ -601,7 +601,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>  static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>  				    int flags, int irq)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	u8 original_int_vec;
>  
>  	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> @@ -654,7 +654,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
>   */
>  static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	u8 original_int_vec;
>  	int i;
>  
> @@ -678,7 +678,7 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
>  
>  static void tpm_tis_remove(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> @@ -706,7 +706,6 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	if (IS_ERR(chip))
>  		return PTR_ERR(chip);
>  
> -	chip->vendor.priv = priv;
>  #ifdef CONFIG_ACPI
>  	chip->acpi_dev_handle = acpi_dev_handle;
>  #endif
> @@ -721,6 +720,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	chip->timeout_c = TIS_TIMEOUT_C_MAX;
>  	chip->timeout_d = TIS_TIMEOUT_D_MAX;
>  
> +	dev_set_drvdata(&chip->dev, priv);
> +
>  	if (wait_startup(chip, 0) != 0) {
>  		rc = -ENODEV;
>  		goto out_err;
> @@ -845,7 +846,7 @@ out_err:
>  #ifdef CONFIG_PM_SLEEP
>  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
>  {
> -	struct priv_data *priv = chip->vendor.priv;
> +	struct priv_data *priv = dev_get_drvdata(&chip->dev);
>  	u32 intmask;
>  
>  	/* reenable interrupts that device may have lost or
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 1b28f96..62028f4 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
> @@ -41,7 +41,7 @@ enum status_bits {
>  
>  static u8 vtpm_status(struct tpm_chip *chip)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = dev_get_drvdata(&chip->dev);
>  	switch (priv->shr->state) {
>  	case VTPM_STATE_IDLE:
>  		return VTPM_STATUS_IDLE | VTPM_STATUS_CANCELED;
> @@ -62,7 +62,7 @@ static bool vtpm_req_canceled(struct tpm_chip *chip, u8 status)
>  
>  static void vtpm_cancel(struct tpm_chip *chip)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = dev_get_drvdata(&chip->dev);
>  	priv->shr->state = VTPM_STATE_CANCEL;
>  	wmb();
>  	notify_remote_via_evtchn(priv->evtchn);
> @@ -75,7 +75,7 @@ static unsigned int shr_data_offset(struct vtpm_shared_page *shr)
>  
>  static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = dev_get_drvdata(&chip->dev);
>  	struct vtpm_shared_page *shr = priv->shr;
>  	unsigned int offset = shr_data_offset(shr);
>  
> @@ -117,7 +117,7 @@ static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
>  
>  static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  {
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = dev_get_drvdata(&chip->dev);
>  	struct vtpm_shared_page *shr = priv->shr;
>  	unsigned int offset = shr_data_offset(shr);
>  	size_t length = shr->length;
> @@ -184,7 +184,7 @@ static int setup_chip(struct device *dev, struct tpm_private *priv)
>  	init_waitqueue_head(&priv->read_queue);
>  
>  	priv->chip = chip;
> -	TPM_VPRIV(chip) = priv;
> +	dev_set_drvdata(&chip->dev, priv);
>  
>  	return 0;
>  }
> @@ -320,10 +320,10 @@ static int tpmfront_probe(struct xenbus_device *dev,
>  static int tpmfront_remove(struct xenbus_device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
> -	struct tpm_private *priv = TPM_VPRIV(chip);
> +	struct tpm_private *priv = dev_get_drvdata(&chip->dev);
>  	tpm_chip_unregister(chip);
>  	ring_free(priv);
> -	TPM_VPRIV(chip) = NULL;
> +	dev_set_drvdata(&chip->dev, NULL);
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
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
