From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix a race condition tpm2_unseal_trusted()
Date: Wed, 17 Aug 2016 07:31:13 +0300
Message-ID: <20160817043113.GA11281@intel.com>
References: <1471376302-25365-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471376302-25365-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 16, 2016 at 10:38:22PM +0300, Jarkko Sakkinen wrote:
> Unseal and load operations should be done as an atomic operation. This
> commit introduces unlocked tpm_transmit() so that tpm2_unseal_trusted()
> can do the locking by itself.
> 
> v2: Introduced an unlocked unseal operation instead of changing locking
>     strategy in order to make less intrusive bug fix and thus more
>     backportable.
> 
> CC: stable@vger.kernel.org
> Fixes: 954650efb79f ("tpm: seal/unseal for TPM 2.0")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-dev.c       |  2 +-
>  drivers/char/tpm/tpm-interface.c | 14 ++++++++------
>  drivers/char/tpm/tpm.h           | 18 ++++++++++++++----
>  drivers/char/tpm/tpm2-cmd.c      | 13 +++++++++----
>  4 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
> index f5d4521..8df8846 100644
> --- a/drivers/char/tpm/tpm-dev.c
> +++ b/drivers/char/tpm/tpm-dev.c
> @@ -145,7 +145,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
>  		return -EPIPE;
>  	}
>  	out_size = tpm_transmit(priv->chip, priv->data_buffer,
> -				sizeof(priv->data_buffer));
> +				sizeof(priv->data_buffer), TPM_TRANSMIT_LOCK);
>  
>  	tpm_put_ops(priv->chip);
>  	if (out_size < 0) {
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 43ef0ef..627daa7 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -331,7 +331,7 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
>   * Internal kernel interface to transmit TPM commands
>   */
>  ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> -		     size_t bufsiz)
> +		     size_t bufsiz, unsigned int flags)
>  {
>  	ssize_t rc;
>  	u32 count, ordinal;
> @@ -350,7 +350,8 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
>  		return -E2BIG;
>  	}
>  
> -	mutex_lock(&chip->tpm_mutex);
> +	if (flags & TPM_TRANSMIT_LOCK)
> +		mutex_lock(&chip->tpm_mutex);
>  
>  	rc = chip->ops->send(chip, (u8 *) buf, count);
>  	if (rc < 0) {
> @@ -393,20 +394,21 @@ out_recv:
>  		dev_err(&chip->dev,
>  			"tpm_transmit: tpm_recv: error %zd\n", rc);
>  out:
> -	mutex_unlock(&chip->tpm_mutex);
> +	if (flags & TPM_TRANSMIT_LOCK)
> +		mutex_unlock(&chip->tpm_mutex);
>  	return rc;
>  }
>  
>  #define TPM_DIGEST_SIZE 20
>  #define TPM_RET_CODE_IDX 6
>  
> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
> -			 int len, const char *desc)
> +ssize_t __tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
> +			   int len, const char *desc, unsigned int flags)
>  {
>  	struct tpm_output_header *header;
>  	int err;
>  
> -	len = tpm_transmit(chip, (u8 *) cmd, len);
> +	len = tpm_transmit(chip, cmd, len, flags);
>  	if (len <  0)
>  		return len;
>  	else if (len < TPM_HEADER_SIZE)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 6e002c4..b9383fd 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -476,12 +476,22 @@ extern dev_t tpm_devt;
>  extern const struct file_operations tpm_fops;
>  extern struct idr dev_nums_idr;
>  
> +enum tpm_transmit_flags {
> +	TPM_TRANSMIT_LOCK,
> +};
> +
> +ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> +		     size_t bufsiz, unsigned int flags);
> +ssize_t __tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
> +			   const char *desc, unsigned int flags);
> +static inline ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
> +				       int len, const char *desc)
> +{
> +	return __tpm_transmit_cmd(chip, cmd, len, desc, TPM_TRANSMIT_LOCK);
> +}
> +
>  ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
>  		   const char *desc);
> -ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> -		     size_t bufsiz);

By having also __tpm_transmit() the patch would be more localized, which
would make it easier to backport. I think I'll add that.

/Jarkko

> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
> -			 const char *desc);
>  int tpm_get_timeouts(struct tpm_chip *chip);
>  int tpm1_auto_startup(struct tpm_chip *chip);
>  int tpm_do_selftest(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 499f405..99007d8 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -576,7 +576,7 @@ static int tpm2_load(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob");
> +	rc = __tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob", 0);
>  	if (!rc)
>  		*blob_handle = be32_to_cpup(
>  			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
> @@ -604,7 +604,8 @@ static void tpm2_flush_context(struct tpm_chip *chip, u32 handle)
>  
>  	tpm_buf_append_u32(&buf, handle);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "flushing context");
> +	rc = __tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "flushing context",
> +				0);
>  	if (rc)
>  		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
>  			 rc);
> @@ -635,7 +636,7 @@ static int tpm2_unseal(struct tpm_chip *chip,
>  			     options->blobauth /* hmac */,
>  			     TPM_DIGEST_SIZE);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "unsealing");
> +	rc = __tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "unsealing", 0);
>  	if (rc > 0)
>  		rc = -EPERM;
>  
> @@ -668,13 +669,17 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
>  	u32 blob_handle;
>  	int rc;
>  
> +	mutex_lock(&chip->tpm_mutex);
>  	rc = tpm2_load(chip, payload, options, &blob_handle);
> -	if (rc)
> +	if (rc) {
> +		mutex_unlock(&chip->tpm_mutex);
>  		return rc;
> +	}
>  
>  	rc = tpm2_unseal(chip, payload, options, blob_handle);
>  
>  	tpm2_flush_context(chip, blob_handle);
> +	mutex_unlock(&chip->tpm_mutex);
>  
>  	return rc;
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
