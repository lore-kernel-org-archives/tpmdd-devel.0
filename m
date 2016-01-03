From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 6/7] tpm_crb: Drop
	le32_to_cpu(ioread32(..))
Date: Sun, 3 Jan 2016 19:28:01 +0200
Message-ID: <20160103172801.GE4155@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-7-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450376600-6970-7-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Thu, Dec 17, 2015 at 11:23:19AM -0700, Jason Gunthorpe wrote:
> ioread32 and readl are defined to read from PCI style memory, ie little
> endian and return the result in host order. On platforms where a
> swap is required ioread32/readl do the swap internally (eg see ppc).

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_crb.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 8dd70696ebe8..0237006dc4d8 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -89,7 +89,7 @@ static u8 crb_status(struct tpm_chip *chip)
>  	struct crb_priv *priv = chip->vendor.priv;
>  	u8 sts = 0;
>  
> -	if ((le32_to_cpu(ioread32(&priv->cca->start)) & CRB_START_INVOKE) !=
> +	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
>  	    CRB_START_INVOKE)
>  		sts |= CRB_STS_COMPLETE;
>  
> @@ -105,7 +105,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>  	if (count < 6)
>  		return -EIO;
>  
> -	if (le32_to_cpu(ioread32(&priv->cca->sts)) & CRB_CA_STS_ERROR)
> +	if (ioread32(&priv->cca->sts) & CRB_CA_STS_ERROR)
>  		return -EIO;
>  
>  	memcpy_fromio(buf, priv->rsp, 6);
> @@ -141,11 +141,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	struct crb_priv *priv = chip->vendor.priv;
>  	int rc = 0;
>  
> -	if (len > le32_to_cpu(ioread32(&priv->cca->cmd_size))) {
> +	if (len > ioread32(&priv->cca->cmd_size)) {
>  		dev_err(&chip->dev,
>  			"invalid command count value %x %zx\n",
>  			(unsigned int) len,
> -			(size_t) le32_to_cpu(ioread32(&priv->cca->cmd_size)));
> +			(size_t) ioread32(&priv->cca->cmd_size));
>  		return -E2BIG;
>  	}
>  
> @@ -181,7 +181,7 @@ static void crb_cancel(struct tpm_chip *chip)
>  static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
>  {
>  	struct crb_priv *priv = chip->vendor.priv;
> -	u32 cancel = le32_to_cpu(ioread32(&priv->cca->cancel));
> +	u32 cancel = ioread32(&priv->cca->cancel);
>  
>  	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;
>  }
> @@ -251,10 +251,10 @@ static int crb_acpi_add(struct acpi_device *device)
>  		return -ENOMEM;
>  	}
>  
> -	pa = ((u64) le32_to_cpu(ioread32(&priv->cca->cmd_pa_high)) << 32) |
> -		(u64) le32_to_cpu(ioread32(&priv->cca->cmd_pa_low));
> -	priv->cmd = devm_ioremap_nocache(dev, pa,
> -					 ioread32(&priv->cca->cmd_size));
> +	pa = ((u64)ioread32(&priv->cca->cmd_pa_high) << 32) |
> +	     (u64)ioread32(&priv->cca->cmd_pa_low);
> +	priv->cmd =
> +	    devm_ioremap_nocache(dev, pa, ioread32(&priv->cca->cmd_size));
>  	if (!priv->cmd) {
>  		dev_err(dev, "ioremap of the command buffer failed\n");
>  		return -ENOMEM;
> @@ -262,8 +262,8 @@ static int crb_acpi_add(struct acpi_device *device)
>  
>  	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
>  	pa = le64_to_cpu(pa);
> -	priv->rsp = devm_ioremap_nocache(dev, pa,
> -					 ioread32(&priv->cca->rsp_size));
> +	priv->rsp =
> +	    devm_ioremap_nocache(dev, pa, ioread32(&priv->cca->rsp_size));
>  	if (!priv->rsp) {
>  		dev_err(dev, "ioremap of the response buffer failed\n");
>  		return -ENOMEM;
> -- 
> 2.1.4
> 

------------------------------------------------------------------------------
