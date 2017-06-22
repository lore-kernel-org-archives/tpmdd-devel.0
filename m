From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: Fix the ioremap() call for Braswell
 systems
Date: Thu, 22 Jun 2017 14:20:23 -0600
Message-ID: <20170622202023.GA3579@obsidianresearch.com>
References: <1498156197-180919-1-git-send-email-azhar.shaikh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498156197-180919-1-git-send-email-azhar.shaikh@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Azhar Shaikh <azhar.shaikh@intel.com>
Cc: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 22, 2017 at 11:29:57AM -0700, Azhar Shaikh wrote:
> ioremap() for Intel Braswell processors was done in
> tpm_tis_pnp_init(). But before this function gets called,
> platform driver 'tis_drv' gets registered and its probe function
> tpm_tis_plat_probe() is invoked, which does a TPM
> access. Now for Braswell processors tpm_platform_begin_xfer()
> will do an ioread32() without having a mapped address, which
> will lead to a bad I/O access warning.
> Hence move the ioremap() call from tpm_tis_pnp_init() to init_tis()
> before registering the 'tis_drv' or basically before any TPM access.
> Accordingly also move the iounmap() call from tpm_tis_pnp_remove()
> to cleanup_tis().
> 
> Signed-off-by: Azhar Shaikh <azhar.shaikh@intel.com>
>  drivers/char/tpm/tpm_tis.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 506e62ca3576..3224db80816a 100644
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -330,12 +330,6 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  	else
>  		tpm_info.irq = -1;
>  
> -#ifdef CONFIG_X86
> -	if (is_bsw())
> -		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
> -					ILB_REMAP_SIZE);
> -#endif
> -
>  	return tpm_tis_init(&pnp_dev->dev, &tpm_info);
>  }
>  
> @@ -359,12 +353,6 @@ static void tpm_tis_pnp_remove(struct pnp_dev *dev)
>  
>  	tpm_chip_unregister(chip);
>  	tpm_tis_remove(chip);
> -
> -#ifdef CONFIG_X86
> -	if (is_bsw())
> -		iounmap(ilb_base_addr);
> -#endif
> -
>  }
>  
>  static struct pnp_driver tis_pnp_driver = {
> @@ -472,6 +460,11 @@ static int __init init_tis(void)
>  	if (rc)
>  		goto err_force;
>  
> +#ifdef CONFIG_X86
> +	if (is_bsw())
> +		ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
> +					ILB_REMAP_SIZE);
> +#endif

The iounmap needs to be in the goto unwind for init_tis as well, surely?

>  	rc = platform_driver_register(&tis_drv);
>  	if (rc)
>  		goto err_platform;

Jason
