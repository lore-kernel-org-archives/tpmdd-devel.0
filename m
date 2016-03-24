From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm/st33zp24/spi: Drop two useless
 checks in ACPI probe path
Date: Thu, 24 Mar 2016 15:24:28 +0200
Message-ID: <20160324132428.GD8452@intel.com>
References: <1458719734-13752-1-git-send-email-christophe-h.ricard@st.com>
	<1458719734-13752-3-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458719734-13752-3-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Wed, Mar 23, 2016 at 08:55:33AM +0100, Christophe Ricard wrote:
> When st33zp24_spi_acpi_request_resources() gets called we
> already know that the entries in ->acpi_match_table have matched ACPI ID
> of the device.
> In addition spi_device pointer cannot be NULL in any case (otherwise I2C
> core would not call ->probe() for the driver in the first place).
> 
> Drop the two useless checks from the driver.
> 
> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/st33zp24/spi.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/spi.c b/drivers/char/tpm/st33zp24/spi.c
> index 6be51ac..608dbc6 100644
> --- a/drivers/char/tpm/st33zp24/spi.c
> +++ b/drivers/char/tpm/st33zp24/spi.c
> @@ -232,19 +232,8 @@ static const struct st33zp24_phy_ops spi_phy_ops = {
>  static int st33zp24_spi_acpi_request_resources(struct spi_device *spi_dev)
>  {
>  	struct st33zp24_spi_phy *phy = spi_get_drvdata(spi_dev);
> -	const struct acpi_device_id *id;
>  	struct gpio_desc *gpiod_lpcpd;
> -	struct device *dev;
> -
> -	if (!spi_dev)
> -		return -EINVAL;
> -
> -	dev = &spi_dev->dev;
> -
> -	/* Match the struct device against a given list of ACPI IDs */
> -	id = acpi_match_device(dev->driver->acpi_match_table, dev);
> -	if (!id)
> -		return -ENODEV;
> +	struct device *dev = &spi_dev->dev;
>  
>  	/* Get LPCPD GPIO from ACPI */
>  	gpiod_lpcpd = devm_gpiod_get_index(dev, "TPM IO LPCPD", 1,
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
