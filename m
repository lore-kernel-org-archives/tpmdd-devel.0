From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] tpm: fix a race condition
	tpm2_unseal_trusted()
Date: Sun, 21 Aug 2016 20:25:16 -0400
Message-ID: <20160822002516.GA22069@intel.com>
References: <1471608498-2182-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471608498-2182-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 19, 2016 at 03:08:18PM +0300, Jarkko Sakkinen wrote:
> Unseal and load operations should be done as an atomic operation. This
> commit introduces unlocked tpm_transmit() so that tpm2_unseal_trusted()
> can do the locking by itself.
> 
> v2: Introduced an unlocked unseal operation instead of changing locking
>     strategy in order to make less intrusive bug fix and thus more
>     backportable.
> 
> v3: Have also separate __tpm_transmit() that takes 'flags' in order to
>     better localize the bug fix and make it easier to backport.
> 
> CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Again, I found myself couple of issues.

Fixes line was forgotten.

> ---
>  drivers/char/tpm/tpm-interface.c | 16 +++++++++-------
>  drivers/char/tpm/tpm.h           | 25 +++++++++++++++++++++----
>  drivers/char/tpm/tpm2-cmd.c      | 13 +++++++++----
>  3 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 43ef0ef..80e702a 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -330,8 +330,8 @@ EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
>  /*
>   * Internal kernel interface to transmit TPM commands
>   */
> -ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> -		     size_t bufsiz)
> +ssize_t __tpm_transmit(struct tpm_chip *chip, const char *buf,
> +		       size_t bufsiz, unsigned int flags)
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
> +	len = __tpm_transmit(chip, cmd, len, flags);
>  	if (len <  0)
>  		return len;
>  	else if (len < TPM_HEADER_SIZE)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 6e002c4..0a4abf0 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -476,12 +476,29 @@ extern dev_t tpm_devt;
>  extern const struct file_operations tpm_fops;
>  extern struct idr dev_nums_idr;
>  
> +enum tpm_transmit_flags {
> +	TPM_TRANSMIT_LOCK,
> +};
> +
> +ssize_t __tpm_transmit(struct tpm_chip *chip, const char *buf,
> +		       size_t bufsiz, unsigned int flags);
> +ssize_t __tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
> +			   const char *desc, unsigned int flags);
> +
> +static inline ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
> +				   size_t bufsiz)
> +{
> +	return __tpm_transmit(chip, buf, bufsiz, TPM_TRANSMIT_LOCK);
> +}
> +
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

goto out instead here.

>  
>  	rc = tpm2_unseal(chip, payload, options, blob_handle);
>  
>  	tpm2_flush_context(chip, blob_handle);
> +	mutex_unlock(&chip->tpm_mutex);
>  

out:

>  	return rc;
>  }
> -- 
> 2.7.4
> 

/Jarkko

------------------------------------------------------------------------------
