From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 12/12] tpm/st33zp24/spi: Change
 xxx_request_resources header
Date: Thu, 11 Feb 2016 16:44:31 +0200
Message-ID: <20160211144431.GI4231@intel.com>
References: <1455010021-21927-1-git-send-email-christophe-h.ricard@st.com>
	<1455010021-21927-13-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455010021-21927-13-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Tue, Feb 09, 2016 at 10:27:01AM +0100, Christophe Ricard wrote:
> Simplify st33zp24_spi_acpi_request_resources, st33zp24_spi_of_request_resources
> and st33zp24_spi_request_resources to have the same prototype and using
> spi_get_drvdata.
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/st33zp24/spi.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index b9b74ae..f725d39 100644
> --- a/drivers/char/tpm/st33zp24/spi.c
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -228,9 +228,9 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
>  	.recv = st33zp24_spi_recv,
>  };
>  
> -static int st33zp24_spi_acpi_request_resources(struct st33zp24_i2c_phy *phy)
> +static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
>  {
> -	struct spi_device *spi_dev = phy->spi_device;
> +	struct st33zp24_spi_phy *phy = spi_get_drvdata(spi_dev);
>  	const struct acpi_device_id *id;
>  	struct gpio_desc *gpiod_lpcpd;
>  	struct device *dev;
> @@ -249,7 +249,7 @@ static int st33zp24_spi_acpi_request_resources(struct st33zp24_i2c_phy *phy)
>  	gpiod_lpcpd = devm_gpiod_get_index(dev, "TPM IO LPCPD", 1,
>  					   GPIOD_OUT_HIGH);
>  	if (IS_ERR(gpiod_lpcpd)) {
> -		dev_err(&client->dev,
> +		dev_err(dev,
>  			"Failed to retrieve lpcpd-gpios from acpi.\n");
>  		phy->io_lpcpd = -1;
>  		/*
> @@ -265,23 +265,23 @@ static int st33zp24_spi_acpi_request_resources(struct st33zp24_i2c_phy *phy)
>  	return 0;
>  }
>  
> -static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
> +static int st33zp24_spi_of_request_resources(struct spi_device *spi_dev)
>  {
> +	struct st33zp24_spi_phy *phy = spi_get_drvdata(spi_dev);
>  	struct device_node *pp;
> -	struct spi_device *dev = phy->spi_device;
>  	int gpio;
>  	int ret;
>  
> -	pp = dev->dev.of_node;
> +	pp = spi_dev->dev.of_node;
>  	if (!pp) {
> -		dev_err(&dev->dev, "No platform data\n");
> +		dev_err(&spi_dev->dev, "No platform data\n");
>  		return -ENODEV;
>  	}
>  
>  	/* Get GPIO from device tree */
>  	gpio = of_get_named_gpio(pp, "lpcpd-gpios", 0);
>  	if (gpio < 0) {
> -		dev_err(&dev->dev,
> +		dev_err(&spi_dev->dev,
>  			"Failed to retrieve lpcpd-gpios from dts.\n");
>  		phy->io_lpcpd = -1;
>  		/*
> @@ -292,10 +292,10 @@ static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
>  		return 0;
>  	}
>  	/* GPIO request and configuration */
> -	ret = devm_gpio_request_one(&dev->dev, gpio,
> +	ret = devm_gpio_request_one(&spi_dev->dev, gpio,
>  			GPIOF_OUT_INIT_HIGH, "TPM IO LPCPD");
>  	if (ret) {
> -		dev_err(&dev->dev, "Failed to request lpcpd pin\n");
> +		dev_err(&spi_dev->dev, "Failed to request lpcpd pin\n");
>  		return -ENODEV;
>  	}
>  	phy->io_lpcpd = gpio;
> @@ -303,9 +303,9 @@ static int st33zp24_spi_of_request_resources(struct st33zp24_spi_phy *phy)
>  	return 0;
>  }
>  
> -static int st33zp24_spi_request_resources(struct spi_device *dev,
> -					  struct st33zp24_spi_phy *phy)
> +static int st33zp24_spi_request_resources(struct spi_device *dev)
>  {
> +	struct st33zp24_spi_phy *phy = spi_get_drvdata(dev);
>  	struct st33zp24_platform_data *pdata;
>  	int ret;
>  
> @@ -357,13 +357,16 @@ static int st33zp24_spi_probe(struct spi_device *dev)
>  		return -ENOMEM;
>  
>  	phy->spi_device = dev;
> +
> +	spi_set_drvdata(dev, phy);
> +
>  	pdata = dev->dev.platform_data;
>  	if (!pdata && dev->dev.of_node) {
> -		ret = st33zp24_spi_of_request_resources(phy);
> +		ret = st33zp24_spi_of_request_resources(dev);
>  		if (ret)
>  			return ret;
>  	} else if (pdata) {
> -		ret = st33zp24_spi_request_resources(dev, phy);
> +		ret = st33zp24_spi_request_resources(dev);
>  		if (ret)
>  			return ret;
>  	} else if (ACPI_HANDLE(&dev->dev)) {
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
