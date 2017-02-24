From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm crb: Work around BIOS's that report
 the wrong ACPI region size
Date: Fri, 24 Feb 2017 19:42:42 +0200
Message-ID: <20170224174242.6wonsevj2i2gls5f@intel.com>
References: <20170221211424.GA16091@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170221211424.GA16091-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Sakkinen, Jarkko" <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 21, 2017 at 02:14:24PM -0700, Jason Gunthorpe wrote:
> The expectation is that the if the CRB cmd/rsp buffer falls within the
> ACPI region that the entire buffer will be within the reason. Otherwise
> resource reservation will fail when it crosses regions.
> 
> Work around this BIOS bug by limiting the cmd/rsp buffer to the length
> of the declared ACPI region. BIOS vendors should fix this by making
> the ACPI and register length declarations consistent.
> 
> Reported-by: davide.guerri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I'll have to wait until Davide gives a tested-by.

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index a7c870af916c3d..fac1934eedf0bb 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -243,6 +243,27 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
>  	return priv->iobase + (new_res.start - io_res->start);
>  }
>  
> +/*
> + * Work around broken BIOSs that return inconsistent values from the ACPI
> + * region vs the registers. Trust the ACPI region. Such broken systems
> + * probably cannot send large TPM commands since the buffer will be truncated.
> + */
> +static u64 crb_fixup_cmd_size(struct device *dev, struct resource *io_res,
> +			      u64 start, u64 size)
> +{
> +	if (io_res->start > start || io_res->end < start)
> +		return size;
> +
> +	if (start + size - 1 <= io_res->end)
> +		return size;
> +
> +	dev_err(dev,
> +		FW_BUG "ACPI region does not cover the entire command/response buffer. %pr vs %llx %llx\n",
> +		io_res, start, size);
> +
> +	return io_res->end - start + 1;
> +}
> +
>  static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		      struct acpi_table_tpm2 *buf)
>  {
> @@ -278,14 +299,16 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  
>  	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
>  		  (u64) ioread32(&priv->cca->cmd_pa_low);
> -	cmd_size = ioread32(&priv->cca->cmd_size);
> +	cmd_size = crb_fixup_cmd_size(dev, &io_res, cmd_pa,
> +				      ioread32(&priv->cca->cmd_size));
>  	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
>  	if (IS_ERR(priv->cmd))
>  		return PTR_ERR(priv->cmd);
>  
>  	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
>  	rsp_pa = le64_to_cpu(rsp_pa);
> -	rsp_size = ioread32(&priv->cca->rsp_size);
> +	rsp_size = crb_fixup_cmd_size(dev, &io_res, rsp_pa,
> +				      ioread32(&priv->cca->rsp_size));
>  
>  	if (cmd_pa != rsp_pa) {
>  		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
