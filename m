From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 3/5] tpm: return error code from tpm_gen_interrupt()
Date: Tue, 19 Jul 2016 23:52:35 +0300
Message-ID: <20160719205235.GA28103@intel.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1468935171-7815-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160719202741.GB16042@obsidianresearch.com>
 <20160719203147.GA26228@intel.com>
 <20160719203634.GB26228@intel.com>
 <20160719204027.GE16042@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160719204027.GE16042@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 02:40:27PM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 19, 2016 at 11:36:34PM +0300, Jarkko Sakkinen wrote:
> > If Christophe could submit a fix for st33, I could include it to this
> > series and make one more revision. Thank you for reviewing this!
> 
> Here is a commit:

Right I see. I just read through that file and now I understand the
context.

I revamp one more revision of the series with tpm_gen_interrupt()
moved as internal function for tis.

/Jarkko

> From 5e178858dcdc2bff9ac31f9851db52370cc282cb Mon Sep 17 00:00:00 2001
> From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Date: Tue, 19 Jul 2016 14:38:55 -0600
> Subject: [PATCH] tpm/st33zp24: Remove useless tpm_gen_interrupt
> 
> This function should only be called as part of an IRQ probing protocol
> and st33 does not have any code to detect that the IRQ it tries to
> generate was not generated and disable the IRQ.
> 
> Since st33 is primarily a DT binding driver it should not be doing
> IRQ probing anyhow, so let us just delete this useless call.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/st33zp24/st33zp24.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index c2ee30451e41..6f060c76217b 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -589,8 +589,6 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
>  		chip->flags |= TPM_CHIP_FLAG_IRQ;
>  
>  		disable_irq_nosync(tpm_dev->irq);
> -
> -		tpm_gen_interrupt(chip);
>  	}
>  
>  	return tpm_chip_register(chip);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
