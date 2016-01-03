From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/7] tpm_tis: Use devm_ioremap_resource
Date: Sun, 3 Jan 2016 19:23:12 +0200
Message-ID: <20160103172312.GC4155@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450376600-6970-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Martin Wilck <Martin.Wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 17, 2015 at 11:23:17AM -0700, Jason Gunthorpe wrote:
> This does a request_resource under the covers which means tis holds a
> lock on the memory range it is using so other drivers cannot grab it.
> When doing probing it is important to ensure that other drivers are
> not using the same range before tis starts touching it.
> 
> To do this flow the actual struct resource from the device right
> through to devm_ioremap_resource. This ensures all the proper resource
> meta-data is carried down.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Tested-by: Wilck, Martin <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_tis.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index b2b31f5418ca..856fb35e574c 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -67,8 +67,7 @@ enum tis_defaults {
>  };
>  
>  struct tpm_info {
> -	unsigned long start;
> -	unsigned long len;
> +	struct resource res;
>  	/* irq > 0 means: use irq $irq;
>  	 * irq = 0 means: autoprobe for an irq;
>  	 * irq = -1 means: no irq support
> @@ -77,8 +76,11 @@ struct tpm_info {
>  };
>  
>  static struct tpm_info tis_default_info = {
> -	.start = TIS_MEM_BASE,
> -	.len = TIS_MEM_LEN,
> +	.res = {
> +		.start = TIS_MEM_BASE,
> +		.end = TIS_MEM_BASE + TIS_MEM_LEN - 1,
> +		.flags = IORESOURCE_MEM,
> +	},
>  	.irq = 0,
>  };
>  
> @@ -692,7 +694,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
>  	chip->acpi_dev_handle = acpi_dev_handle;
>  #endif
>  
> -	chip->vendor.iobase = devm_ioremap(dev, tpm_info->start, tpm_info->len);
> +	chip->vendor.iobase = devm_ioremap_resource(dev, &tpm_info->res);
>  	if (!chip->vendor.iobase)
>  		return -EIO;
>  
> @@ -875,9 +877,12 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  {
>  	struct tpm_info tpm_info = {};
>  	acpi_handle acpi_dev_handle = NULL;
> +	struct resource *res;
>  
> -	tpm_info.start = pnp_mem_start(pnp_dev, 0);
> -	tpm_info.len = pnp_mem_len(pnp_dev, 0);
> +	res = pnp_get_resource(pnp_dev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +	tpm_info.res = *res;
>  
>  	if (pnp_irq_valid(pnp_dev, 0))
>  		tpm_info.irq = pnp_irq(pnp_dev, 0);
> @@ -940,12 +945,10 @@ static int tpm_check_resource(struct acpi_resource *ares, void *data)
>  	struct tpm_info *tpm_info = (struct tpm_info *) data;
>  	struct resource res;
>  
> -	if (acpi_dev_resource_interrupt(ares, 0, &res)) {
> +	if (acpi_dev_resource_interrupt(ares, 0, &res))
>  		tpm_info->irq = res.start;
> -	} else if (acpi_dev_resource_memory(ares, &res)) {
> -		tpm_info->start = res.start;
> -		tpm_info->len = resource_size(&res);
> -	}
> +	else if (acpi_dev_resource_memory(ares, &res))
> +		tpm_info->res = res;
>  
>  	return 1;
>  }
> @@ -978,7 +981,7 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
>  
>  	acpi_dev_free_resource_list(&resources);
>  
> -	if (tpm_info.start == 0 && tpm_info.len == 0) {
> +	if (resource_type(&tpm_info.res) != IORESOURCE_MEM) {
>  		dev_err(&acpi_dev->dev,
>  			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
>  		return -EINVAL;
> -- 
> 2.1.4
> 

------------------------------------------------------------------------------
