From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Fri, 18 Nov 2016 07:52:49 -0800
Message-ID: <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 07:30:04PM -0500, Stefan Berger wrote:
> tpm_bios_log_setup() may return -ENODEV in case no log was
> found. In this case we do not need to fail the device.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm-chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 3f27753..2d6530b 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -346,7 +346,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>  	tpm_sysfs_add_device(chip);
>  
>  	rc = tpm_bios_log_setup(chip);
> -	if (rc == -ENODEV)
> +	if (rc != -ENODEV)
>  		return rc;
>  
>  	tpm_add_ppi(chip);
> -- 
> 2.4.3

CC to linux-security-module

LGTM

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
