From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm2: context save and restore space
 managed sessions
Date: Thu, 19 Jan 2017 14:04:00 +0200
Message-ID: <20170119120400.ntvkkukm6oektvnj@intel.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
 <1484752242.2717.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484752242.2717.17.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 18, 2017 at 10:10:42AM -0500, James Bottomley wrote:
> Now that sessions are isolated, we can introduce a session_buf in the
> tpm2 space to save and restore them.  This allows us to have many more
> sessions active simultaneously (up to TPM_PT_MAX_SESSIONS).  As part
> of this, we must intercept and manually remove contexts for flushed
> sessions.

Again I don't understand the interception part. Like with transient
objects I just catch TPM_RC_HANDLE error and forget them in the save
part.

PS. Do you mind if I take part of the patch that encapsulates a
single context save as of my patch that implements transient object
swapping? It merely moves the code in there to a different location.
Would just make the patch set cleaner. I would do this for v4 of the
patch set.

/Jarkko

> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/char/tpm/tpm-chip.c   |   6 ++
>  drivers/char/tpm/tpm.h        |   1 +
>  drivers/char/tpm/tpm2-space.c | 223 ++++++++++++++++++++++++++++--------------
>  drivers/char/tpm/tpms-dev.c   |   7 ++
>  4 files changed, 164 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 96ea93e..a625884 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -130,6 +130,7 @@ static void tpm_dev_release(struct device *dev)
>  
>  	kfree(chip->log.bios_event_log);
>  	kfree(chip->work_space.context_buf);
> +	kfree(chip->work_space.session_buf);
>  	kfree(chip);
>  }
>  
> @@ -223,6 +224,11 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  		rc = -ENOMEM;
>  		goto out;
>  	}
> +	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!chip->work_space.session_buf) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  
>  	return chip;
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 265b7f5..9923daa 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -159,6 +159,7 @@ struct tpm_space {
>  	u32 context_tbl[14];
>  	u8 *context_buf;
>  	u32 session_tbl[6];
> +	u8 *session_buf;
>  };
>  
>  enum tpm_chip_flags {
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 49048af..04c9431 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -27,6 +27,91 @@ enum tpm2_handle_types {
>  
>  #define TPM2_HT_TAG_FOR_FLUSH	0xF0000000
>  
> +struct tpm2_context {
> +	__be64 sequence;
> +	__be32 saved_handle;
> +	__be32 hierarchy;
> +	__be16 blob_size;
> +} __packed;
> +
> +static int tpm2_context_save(struct tpm_chip *chip, u8 *area,
> +			     int *offset, u32 handle)
> +{
> +	struct tpm_buf buf;
> +	u32 s;
> +	int rc;
> +
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
> +			  TPM2_CC_CONTEXT_SAVE);
> +	if (rc)
> +		return rc;
> +
> +	tpm_buf_append_u32(&buf, handle);
> +
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
> +			      TPM_HEADER_SIZE, TPM_TRANSMIT_UNLOCKED,
> +			      NULL);
> +	if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE) {
> +		/* no handle to save */
> +		rc = 1;
> +		goto out;
> +	} else if (rc) {
> +		dev_warn(&chip->dev, "%s: saving failed with %d\n",
> +			 __func__, rc);
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +
> +	s = tpm_buf_length(&buf) - TPM_HEADER_SIZE;
> +	if ((*offset + s) > PAGE_SIZE) {
> +		dev_warn(&chip->dev, "out of context storage\n");
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	memcpy(&area[*offset], &buf.data[TPM_HEADER_SIZE], s);
> +	*offset += s;
> +
> + out:
> +	tpm_buf_destroy(&buf);
> +	return rc;
> +}
> +
> +static int tpm2_context_load(struct tpm_chip *chip, u8 *area,
> +			     int *offset, u32 *handle)
> +{
> +	struct tpm_buf buf;
> +	struct tpm2_context *ctx;
> +	int rc;
> +	u32 s;
> +
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
> +			  TPM2_CC_CONTEXT_LOAD);
> +	if (rc)
> +		return rc;
> +
> +	ctx = (struct tpm2_context *)&area[*offset];
> +	s = sizeof(*ctx) + be16_to_cpu(ctx->blob_size);
> +	tpm_buf_append(&buf, (const void *)ctx, s);
> +
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
> +			      TPM_HEADER_SIZE + 4,
> +			      TPM_TRANSMIT_UNLOCKED, NULL);
> +	if (rc) {
> +		dev_warn(&chip->dev, "context loading failed with %d\n", rc);
> +		rc = -EFAULT;
> +		goto out;
> +	}
> +	*handle = get_unaligned_be32((__be32 *)&buf.data[TPM_HEADER_SIZE]);
> +
> +	*offset += s;
> +
> + out:
> +	tpm_buf_destroy(&buf);
> +
> +	return rc;
> +}
> +
>  static int tpm2_session_find(struct tpm_space *space, u32 handle)
>  {
>  	int i;
> @@ -58,11 +143,35 @@ static int tpm2_session_add(struct tpm_chip *chip,
>  	return 0;
>  }
>  
> +static int tpm2_session_forget(struct tpm_space *space, u32 handle)
> +{
> +	int i, j;
> +	struct tpm2_context *ctx;
> +
> +	for (i = 0, j = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		if (space->session_tbl[i] == 0)
> +			continue;
> +
> +		ctx = (struct tpm2_context *)&space->session_buf[j];
> +		j += sizeof(*ctx) + get_unaligned_be16(&ctx->blob_size);
> +
> +		if (space->session_tbl[i] != handle)
> +			continue;
> +
> +		/* forget the session context */
> +		memcpy(ctx, &space->session_buf[j], PAGE_SIZE - j);
> +		space->session_tbl[i] = 0;
> +		break;
> +	}
> +	if (i == ARRAY_SIZE(space->session_tbl))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>  /* if a space is active, emulate some commands */
> -static int tpm2_intercept(struct tpm_chip *chip, struct tpm_space *space,
> -			  u32 cc, u8 *buf, size_t bufsiz)
> +static int tpm2_intercept(struct tpm_chip *chip, u32 cc, u8 *buf, size_t bufsiz)
>  {
> -	int j;
> +	struct tpm_space *space = &chip->work_space;
>  	u32 handle, handle_type;
>  
>  	if (!space)
> @@ -78,13 +187,7 @@ static int tpm2_intercept(struct tpm_chip *chip, struct tpm_space *space,
>  		/* let the TPM figure out and return the error */
>  		return 0;
>  
> -	j = tpm2_session_find(space, handle);
> -	if (j < 0)
> -		return -EINVAL;
> -
> -	space->session_tbl[j] |= TPM2_HT_TAG_FOR_FLUSH;
> -
> -	return 0;
> +	return tpm2_session_forget(space, handle);
>  }
>  
>  void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
> @@ -104,22 +207,12 @@ void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
>  	}
>  }
>  
> -struct tpm2_context {
> -	__be64 sequence;
> -	__be32 saved_handle;
> -	__be32 hierarchy;
> -	__be16 blob_size;
> -} __packed;
> -
>  static int tpm2_load_space(struct tpm_chip *chip)
>  {
>  	struct tpm_space *space = &chip->work_space;
> -	struct tpm2_context *ctx;
> -	struct tpm_buf buf;
>  	int i;
>  	int j;
>  	int rc;
> -	u32 s;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
>  		if (!space->context_tbl[i])
> @@ -131,37 +224,33 @@ static int tpm2_load_space(struct tpm_chip *chip)
>  			return -EFAULT;
>  		}
>  
> -		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
> -				 TPM2_CC_CONTEXT_LOAD);
> +		rc = tpm2_context_load(chip, space->context_buf,
> +				       &j, &space->context_tbl[i]);
>  		if (rc)
> -			return rc;
> -
> -		ctx = (struct tpm2_context *)&space->context_buf[j];
> -		s = sizeof(*ctx) + be16_to_cpu(ctx->blob_size);
> -		tpm_buf_append(&buf, &space->context_buf[j], s);
> -
> -		rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
> -				      TPM_HEADER_SIZE + 4,
> -				      TPM_TRANSMIT_UNLOCKED, NULL);
> -		if (rc) {
> -			dev_warn(&chip->dev, "%s: loading failed with %d\n",
> -				 __func__, rc);
> -			rc = -EFAULT;
>  			goto out_err;
> -		}
>  
> -		space->context_tbl[i] =
> -			be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE]);
> +	}
>  
> -		j += s;
> +	for (i = 0, j = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		u32 handle;
>  
> -		tpm_buf_destroy(&buf);
> +		if (!space->session_tbl[i])
> +			continue;
> +
> +		rc = tpm2_context_load(chip, space->session_buf,
> +				       &j, &handle);
> +		if (rc)
> +			goto out_err;
> +		if (handle != (space->session_tbl[i] & ~TPM2_HT_TAG_FOR_FLUSH)) {
> +			dev_warn(&chip->dev, "session restored to wrong handle\n");
> +			rc = -EFAULT;
> +			goto out_err;
> +		}
>  	}
>  
>  	return 0;
>  
>  out_err:
> -	tpm_buf_destroy(&buf);
>  	tpm2_flush_space(chip, space);
>  	return rc;
>  }
> @@ -297,8 +386,9 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
>  	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
>  	       sizeof(space->session_tbl));
>  	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> +	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
>  
> -	rc = tpm2_intercept(chip, space, cc, buf, bufsiz);
> +	rc = tpm2_intercept(chip, cc, buf, bufsiz);
>  	if (rc)
>  		return rc;
>  
> @@ -384,59 +474,45 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
>  static int tpm2_save_space(struct tpm_chip *chip)
>  {
>  	struct tpm_space *space = &chip->work_space;
> -	struct tpm_buf buf;
>  	int i;
>  	int j;
>  	int rc;
> -	u32 s;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(space->context_tbl); i++) {
>  		if (!(space->context_tbl[i] && ~space->context_tbl[i]))
>  			continue;
>  
> -		rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS,
> -				  TPM2_CC_CONTEXT_SAVE);
> -		if (rc)
> -			return rc;
> -
> -		tpm_buf_append_u32(&buf, space->context_tbl[i]);
> -
> -		rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE,
> -				      TPM_HEADER_SIZE, TPM_TRANSMIT_UNLOCKED,
> -				      NULL);
> -		if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE) {
> +		rc = tpm2_context_save(chip, space->context_buf, &j,
> +				       space->context_tbl[i]);
> +		if (rc < 0)
> +			goto out_err;
> +		if (rc > 0) {
>  			space->context_tbl[i] = 0;
>  			continue;
> -		} else if (rc) {
> -			dev_warn(&chip->dev, "%s: saving failed with %d\n",
> -				 __func__, rc);
> -			rc = -EFAULT;
> -			goto out_err;
>  		}
>  
> -		s = tpm_buf_length(&buf) - TPM_HEADER_SIZE;
> -		if ((j + s) > PAGE_SIZE) {
> -			dev_warn(&chip->dev, "%s: out of backing storage\n",
> -				 __func__);
> -			rc = -ENOMEM;
> -			goto out_err;
> -		}
> -
> -		memcpy(&space->context_buf[j], &buf.data[TPM_HEADER_SIZE], s);
> -
>  		tpm2_flush_context_cmd(chip, space->context_tbl[i],
>  				       TPM_TRANSMIT_UNLOCKED);
>  
>  		space->context_tbl[i] = ~0;
> +	}
>  
> -		j += s;
> +	for (i = 0, j = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		if (!space->session_tbl[i])
> +			continue;
>  
> -		tpm_buf_destroy(&buf);
> +		rc = tpm2_context_save(chip, space->session_buf, &j,
> +				       space->session_tbl[i]);
> +		if (rc < 0)
> +			goto out_err;
> +		if (rc > 0) {
> +			space->context_tbl[i] = 0;
> +			continue;
> +		}
>  	}
>  
>  	return 0;
>  out_err:
> -	tpm_buf_destroy(&buf);
>  	tpm2_flush_space(chip, space);
>  	return rc;
>  }
> @@ -462,6 +538,7 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
>  	       sizeof(space->session_tbl));
>  	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
> +	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
>  
>  	return 0;
>  }
> diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
> index d6e3491..12b6e34 100644
> --- a/drivers/char/tpm/tpms-dev.c
> +++ b/drivers/char/tpm/tpms-dev.c
> @@ -25,6 +25,12 @@ static int tpms_open(struct inode *inode, struct file *file)
>  		kfree(priv);
>  		return -ENOMEM;
>  	}
> +	priv->space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (priv->space.session_buf == NULL) {
> +		kfree(priv->space.context_buf);
> +		kfree(priv);
> +		return -ENOMEM;
> +	}
>  
>  	tpm_common_open(file, chip, &priv->priv);
>  
> @@ -39,6 +45,7 @@ static int tpms_release(struct inode *inode, struct file *file)
>  	tpm2_flush_space(fpriv->chip, &priv->space);
>  	tpm_common_release(file, fpriv);
>  	kfree(priv->space.context_buf);
> +	kfree(priv->space.session_buf);
>  	kfree(priv);
>  
>  	return 0;
> -- 
> 2.6.6
> 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
