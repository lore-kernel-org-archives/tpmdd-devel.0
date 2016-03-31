From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: cleanup tpm_tis_remove()
Date: Thu, 31 Mar 2016 13:15:36 +0300
Message-ID: <20160331101536.GA20686@intel.com>
References: <1459419087-20487-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459419087-20487-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Ricard <christophe-h.ricard@st.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

Christophe,

On Thu, Mar 31, 2016 at 01:11:27PM +0300, Jarkko Sakkinen wrote:
> Created a local variable for the register in order to clean up
> experession where TPM_GLOBAL_INT_ENABLE is cleared. This expression is
> horrible to read and makes changing the function uncomfortable because
> like easily surpass 80 characters.

Can you test this patch your hardware and reply with Tested-by tag if it
does? I can then update your iobase patch to apply on top of this.

I thought it was better idea to simplify the expression a little bit
than make it even worse mess.

/Jarkko

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm_tis.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 068f021..ce2b984 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -658,15 +658,14 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
>  
>  static void tpm_tis_remove(struct tpm_chip *chip)
>  {
> +	void __iomem *reg = chip->vendor.iobase +
> +		TPM_INT_ENABLE(chip->vendor.locality);
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  
> -	iowrite32(~TPM_GLOBAL_INT_ENABLE &
> -		  ioread32(chip->vendor.iobase +
> -			   TPM_INT_ENABLE(chip->vendor.
> -					  locality)),
> -		  chip->vendor.iobase +
> -		  TPM_INT_ENABLE(chip->vendor.locality));
> +	iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
> +
>  	release_locality(chip, chip->vendor.locality, 1);
>  }
>  
> -- 
> 2.7.4
> 
