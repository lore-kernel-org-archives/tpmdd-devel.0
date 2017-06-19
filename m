From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC] tpm_crb: Fix AMD Zen on-chip fTPM
 detection
Date: Mon, 19 Jun 2017 02:15:33 +0200
Message-ID: <1497831333.2552.13.camel@linux.intel.com>
References: <20170616182951.398757-1-manuel.lauss@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170616182951.398757-1-manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Manuel Lauss <manuel.lauss-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

I'll look into this after it has been properly split.

/Jarkko

On Fri, 2017-06-16 at 20:29 +0200, Manuel Lauss wrote:
> This RFC patch fixes 2 issues which prevent the fTPM device from being initialized
> by the tpm_crb driver:
> 
> 1) use devm_ioremap() instead of devm_ioremap_resource() to fix the following error
> due to it not allowing overlapping resources:
> 
> tpm_crb MSFT0101:00: can't request region for resource [mem 0xdd84f000-0xdd84ffff]
> tpm_crb: probe of MSFT0101:00 failed with error -16
> 
> 2) The fTPM uses different buffer addresses for command and response, so the
>    priv->cmd_size member never gets initialized.  Move this initialization
>    to right after succesfully mapping the cmd buffer.
> 
> With these 2 issues fixed, the AMD Zen fTPM is detected correctly.
> 
> ---
> RFC, should probably be split into 2 parts.
> 
>  drivers/char/tpm/tpm_crb.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index b917b9d5f710..796274811f02 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -400,7 +400,7 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
>  		return (void __iomem *) ERR_PTR(-EINVAL);
>  
>  	if (!resource_contains(io_res, &new_res))
> -		return devm_ioremap_resource(dev, &new_res);
> +		return devm_ioremap(dev, new_res.start, resource_size(&new_res));
>  
>  	return priv->iobase + (new_res.start - io_res->start);
>  }
> @@ -451,7 +451,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		return -EINVAL;
>  	}
>  
> -	priv->iobase = devm_ioremap_resource(dev, &io_res);
> +	priv->iobase = devm_ioremap(dev, io_res.start, resource_size(&io_res));
>  	if (IS_ERR(priv->iobase))
>  		return PTR_ERR(priv->iobase);
>  
> @@ -494,6 +494,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		ret = PTR_ERR(priv->cmd);
>  		goto out;
>  	}
> +	priv->cmd_size = cmd_size;
>  
>  	memcpy_fromio(&rsp_pa, &priv->regs_t->ctrl_rsp_pa, 8);
>  	rsp_pa = le64_to_cpu(rsp_pa);
> @@ -515,8 +516,6 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		goto out;
>  	}
>  
> -	priv->cmd_size = cmd_size;
> -
>  	priv->rsp = priv->cmd;
>  
>  out:

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
