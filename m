From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 1/3] tpm: Introduce flag TPM_TRANSMIT_RAW
Date: Wed, 24 May 2017 15:18:40 -0700
Message-ID: <20170524221840.lv37joufkdepa5ci@intel.com>
References: <1495661981-27249-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1495661981-27249-2-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495661981-27249-2-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 24, 2017 at 05:39:39PM -0400, Stefan Berger wrote:
> Introduce the flag TPM_TRANSMIT_RAW that allows us to transmit
> a command without recursing into the requesting of locality.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I'll rename the constant as TPM_TRANSMIT_NO_LOCALITY if you don't mind.

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 3 ++-
>  drivers/char/tpm/tpm.h           | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 4ed08ab..2eacda2 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -416,7 +416,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	/* Store the decision as chip->locality will be changed. */
>  	need_locality = chip->locality == -1;
>  
> -	if (need_locality && chip->ops->request_locality)  {
> +	if (!(flags & TPM_TRANSMIT_RAW) &&
> +	    need_locality && chip->ops->request_locality)  {
>  		rc = chip->ops->request_locality(chip, 0);
>  		if (rc < 0)
>  			goto out_no_locality;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index e81d8c7..25d9858 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -525,6 +525,7 @@ extern struct idr dev_nums_idr;
>  
>  enum tpm_transmit_flags {
>  	TPM_TRANSMIT_UNLOCKED	= BIT(0),
> +	TPM_TRANSMIT_RAW	= BIT(1),
>  };
>  
>  ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> -- 
> 2.4.3
> 
