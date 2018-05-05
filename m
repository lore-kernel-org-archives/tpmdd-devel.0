From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] tpm: do not suspend/resume if power stays on
Date: Fri, 4 May 2018 19:27:13 -0700
Message-ID: <20180505022713.GA29590@kroah.com>
References: <20180502143830.3534-1-jarkko.sakkinen@linux.intel.com>
 <20180502143830.3534-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180502143830.3534-2-jarkko.sakkinen@linux.intel.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: stable@vger.kernel.org, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Sonny Rao <sonnyrao@chromium.org>, James Morris <james.l.morris@oracle.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 02, 2018 at 05:38:28PM +0300, Jarkko Sakkinen wrote:
> From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> 
> commit b5d0ebc99bf5d0801a5ecbe958caa3d68b8eaee8 upstream
> 
> The suspend/resume behavior of the TPM can be controlled by setting
> "powered-while-suspended" in the DTS. This is useful for the cases
> when hardware does not power-off the TPM.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> ---
>  drivers/char/tpm/tpm-interface.c | 3 +++
>  drivers/char/tpm/tpm.h           | 2 ++
>  drivers/char/tpm/tpm_of.c        | 3 +++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 830d7e30e508..5463b649bdf1 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -969,6 +969,9 @@ int tpm_pm_suspend(struct device *dev)
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> +	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
> +		return 0;
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>  		tpm2_shutdown(chip, TPM2_SU_STATE);
>  		return 0;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index aa4299cf7e5a..41756a9e9ad8 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -143,6 +143,8 @@ enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
>  	TPM_CHIP_FLAG_IRQ		= BIT(2),
>  	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
> +	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
> +	TPM_CHIP_FLAG_ALWAYS_POWERED	= BIT(5),
>  };
>  
>  struct tpm_chip {
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 570f30c5c5f4..669f4a046398 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -37,6 +37,9 @@ int read_log(struct tpm_bios_log *log)
>  		return -ENODEV;
>  	}
>  
> +	if (of_property_read_bool(np, "powered-while-suspended"))
> +		chip->flags |= TPM_CHIP_FLAG_ALWAYS_POWERED;
> +

This last line here blows up the build, there is no chip variable
defined in this function :(

So I have to drop both of these patches, from both 4.4.y and 4.9.y
queues right now.  Can you fix this up and resend them?

thanks,

greg k-h
