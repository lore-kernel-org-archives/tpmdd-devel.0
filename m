From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm_crb: fix mapping of the buffers
Date: Tue, 19 Apr 2016 07:59:24 +0300
Message-ID: <20160419045924.GA10220@intel.com>
References: <1461020880-10914-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160418233457.GA20319@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160418233457.GA20319@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 18, 2016 at 05:34:57PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 19, 2016 at 02:08:00AM +0300, Jarkko Sakkinen wrote:
> > On my Lenovo x250 the following situation occurs:
> > 
> > [18697.813871] tpm_crb MSFT0101:00: can't request region for resource
> > [mem 0xacdff080-0xacdfffff]
> 
> Sigh, the BIOS vendors seem to be screwing this up a lot.. No doubt
> because the spec doesn't really say what to do very well...
> 
> > The mapping of the control area interleaves the mapping of the command
> > buffer. The control area is mapped over page, which is not right. It
> > should mapped over sizeof(struct crb_control_area).
> 
> Good
> 
> > Fixing this issue unmasks another issue. Command and response buffers
> > can interleave and they do interleave on this machine.
> 
> Do they 100% overlap because one is 'read' and the other is 'write'?

100% so it is kind of sane configuration.

> Or did the BIOS guys screw up the length of one of the regions, and
> they were supposed to be back to back? In which case it is just luck
> this proposed patch solves the issue :(
> 
> The request_io stuff is there specifically to prevent two peices of
> code from trying to control the same registers, I'm really reluctant to
> work-around it like this, though granted, crazy BIOS is a fine good reason.
> 
> Is this patch below enough to deal with it sanely?
> 
> If you do stick with this then:
> 
> > -static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
> > -				 struct resource *io_res, u64 start, u32 size)
> > +static int crb_map_res(struct device *dev, struct crb_priv *priv,
> > +		       int res_i, u64 start, u32 size)
> 
> I wouldn't change the signature at all, just add a counter to the priv and
> 'append to the list'
> 
> This change is creating a lot of needless churn which is not good at
> all for the stable rules.
> 
> Removing the pointer return is not an improvement..

Point taken but then it is better to make the fix even more localized. If
the physical addresses are equal, check the buffer sizes for sanity.
If they are not equal, emit FW_BUG and return -EINVAL.

I'll send an updated patch after I've done all testing rounds with my
laptop and Haswell NUC.

/Jarkko

> >  {
> > +	u8 __iomem *ptr;
> > +	int i;
> > +
> >  	struct resource new_res = {
> >  		.start	= start,
> >  		.end	= start + size - 1,
> > @@ -245,12 +257,25 @@ static void __iomem *crb_map_res(struct device *dev, struct crb_priv *priv,
> >  
> >  	/* Detect a 64 bit address on a 32 bit system */
> >  	if (start != new_res.start)
> > -		return ERR_PTR(-EINVAL);
> > +		return -EINVAL;
> >  
> > -	if (!resource_contains(io_res, &new_res))
> > -		return devm_ioremap_resource(dev, &new_res);
> > +	for (i = 0; i < CRB_NR_RESOURCES; i++) {
> > +		if (resource_contains(&priv->res[i], &new_res)) {
> > +			priv->res[res_i] = new_res;
> > +			priv->res_ptr[res_i] = priv->res_ptr[i] +
> > +				(new_res.start - priv->res[i].start);
> > +			return 0;
> > +		}
> > +	}
> 
> 
> Just add:
> 
>    id = priv->num_res++;
>    priv->res[id] = *io_res;
>    priv->res_ptr[id] = priv->iobase + (new_res.start  - io_res->start);
>    return priv->res_ptr[id];
> 
> And drop all the other hunks, except for the sizeof change and the
> above loop.
> 
> Maybe print a FW bug if it overlaps with id != 0, that is just
> crazy beans.
> 
> Jason
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 20155d55a62b..0a87c813d004 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -253,7 +253,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  	struct list_head resources;
>  	struct resource io_res;
>  	struct device *dev = &device->dev;
> -	u64 pa;
> +	u64 cmd_pa,rsp_pa;
>  	int ret;
>  
>  	INIT_LIST_HEAD(&resources);
> @@ -274,22 +274,33 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		return PTR_ERR(priv->iobase);
>  
>  	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
> -				0x1000);
> +				sizeof(*priv->cca));
>  	if (IS_ERR(priv->cca))
>  		return PTR_ERR(priv->cca);
>  
> -	pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
> -	      (u64) ioread32(&priv->cca->cmd_pa_low);
> -	priv->cmd = crb_map_res(dev, priv, &io_res, pa,
> -				ioread32(&priv->cca->cmd_size));
> -	if (IS_ERR(priv->cmd))
> -		return PTR_ERR(priv->cmd);
> -
> +	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
> +		(u64) ioread32(&priv->cca->cmd_pa_low);
>  	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
> -	pa = le64_to_cpu(pa);
> -	priv->rsp = crb_map_res(dev, priv, &io_res, pa,
> -				ioread32(&priv->cca->rsp_size));
> -	return PTR_ERR_OR_ZERO(priv->rsp);
> +	rsp_pa = le64_to_cpu(pa);
> +
> +	if (cmd_pa == rsp_pa) {
> +		u32 len = max_t(size_t,ioread32(&priv->cca->cmd_size),
> +				   ioread32(&priv->cca->rsp_size));
> +		priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, len);
> +		if (IS_ERR(priv->cmd))
> +			return PTR_ERR(priv->cmd);
> +		priv->rsp = priv->cmd;
> +	} else {
> +		priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa,
> +					ioread32(&priv->cca->rsp_size));
> +		if (IS_ERR(priv->cmd))
> +			return PTR_ERR(priv->cmd);
> +		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa,
> +					ioread32(&priv->cca->rsp_size));
> +		if (IS_ERR(priv->rsp))
> +			return PTR_ERR(priv->rsp);
> +	}
> +	return 0;
>  }
>  
>  static int crb_acpi_add(struct acpi_device *device)
