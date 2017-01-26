From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] tpm2: add session handle context saving and
 restoring to the space code
Date: Thu, 26 Jan 2017 14:51:51 +0200
Message-ID: <20170126125151.32sky3tajp6zigpd@intel.com>
References: <1485236113.2534.69.camel@HansenPartnership.com>
 <1485236231.2534.71.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485236231.2534.71.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 09:37:11PM -0800, James Bottomley wrote:
> sessions are different from transient objects in that their handles
> may not be virtualized (because they're used for some hmac
> calculations).  Additionally when a session is context saved, a
> vestigial memory remains in the TPM and if it is also flushed, that
> will be lost and the session context will refuse to load next time, so
> the code is updated to flush only transient objects after a context
> save.  Add a separate array (chip->session_tbl) to save and restore
> sessions by handle.  Use the failure of a context save or load to
> signal that the session has been flushed from the TPM and we can
> remove its memory from chip->session_tbl.
> 
> Sessions are also isolated during each instance of a tpm space.  This
> means that spaces shouldn't be able to see each other's sessions and
> is enforced by ensuring that a space user may only refer to sessions
> handles that are present in their own chip->session_tbl.  Finally when
> a space is closed, all the sessions belonging to it should be flushed
> so the handles may be re-used by other spaces.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

I'm wondering if you ever need more than two sessions at once? If we
would limit the number of sessions to that you could probably simplify a
lot.

> ---
>  drivers/char/tpm/tpm-chip.c   |  6 +++
>  drivers/char/tpm/tpm.h        |  3 ++
>  drivers/char/tpm/tpm2-space.c | 99 +++++++++++++++++++++++++++++++++++++++----
>  drivers/char/tpm/tpms-dev.c   |  8 ++++
>  4 files changed, 107 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ed4f887..6282ad0 100644
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
> index c48255e..b77fc60 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -159,6 +159,8 @@ enum tpm2_cc_attrs {
>  struct tpm_space {
>  	u32 context_tbl[3];
>  	u8 *context_buf;
> +	u32 session_tbl[6];
> +	u8 *session_buf;
>  };
>  
>  enum tpm_chip_flags {
> @@ -588,4 +590,5 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
>  		       u8 *cmd);
>  int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  		      u32 cc, u8 *buf, size_t bufsiz);
> +void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space);

Why the extra parameter?

>  #endif
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 7fd2fc5..ba4310a 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -59,11 +59,16 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
>  
>  	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 4,
>  			      TPM_TRANSMIT_UNLOCKED, NULL);
> +

cruft

>  	if (rc < 0) {
>  		dev_warn(&chip->dev, "%s: failed with a system error %d\n",
>  			 __func__, rc);
>  		tpm_buf_destroy(&tbuf);
>  		return -EFAULT;
> +	} else if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE ||
> +		   rc == TPM2_RC_REFERENCE_H0) {
> +		rc = -ENOENT;
> +		tpm_buf_destroy(&tbuf);
>  	} else if (rc > 0) {
>  		dev_warn(&chip->dev, "%s: failed with a TPM error 0x%04X\n",
>  			 __func__, rc);
> @@ -116,21 +121,44 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
>  	}
>  
>  	memcpy(&buf[*offset], &tbuf.data[TPM_HEADER_SIZE], body_size);
> -	tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
>  	*offset += body_size;
>  	tpm_buf_destroy(&tbuf);
>  	return 0;
>  }
>  
> -static void tpm2_flush_space(struct tpm_chip *chip)
> +static int tpm2_session_add(struct tpm_chip *chip,
> +			    struct tpm_space *space, u32 handle)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
> +		if (space->session_tbl[i] == 0)
> +			break;
> +	if (i == ARRAY_SIZE(space->session_tbl)) {
> +		dev_err(&chip->dev, "out of session slots\n");
> +		tpm2_flush_context_cmd(chip, handle, TPM_TRANSMIT_UNLOCKED);
> +		return -ENOMEM;
> +	}
> +
> +	space->session_tbl[i] = handle;
> +
> +	return 0;
> +}
> +
> +void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space *space)
>  {
> -	struct tpm_space *space = &chip->work_space;
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
>  		if (space->context_tbl[i] && ~space->context_tbl[i])
>  			tpm2_flush_context_cmd(chip, space->context_tbl[i],
>  					       TPM_TRANSMIT_UNLOCKED);
> +
> +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		if (space->session_tbl[i])
> +			tpm2_flush_context_cmd(chip, space->session_tbl[i],
> +					       TPM_TRANSMIT_UNLOCKED);
> +	}
>  }
>  
>  static int tpm2_load_space(struct tpm_chip *chip)
> @@ -156,6 +184,28 @@ static int tpm2_load_space(struct tpm_chip *chip)
>  			return rc;
>  	}
>  
> +	for (i = 0, offset = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> +		u32 handle;
> +
> +		if (!space->session_tbl[i])
> +			continue;
> +
> +		rc = tpm2_load_context(chip, space->session_buf,
> +				       &offset, &handle);
> +		if (rc == -ENOENT) {
> +			/* load failed, just forget session */
> +			space->session_tbl[i] = 0;
> +		} else if (rc) {
> +			tpm2_flush_space(chip, space);
> +			return rc;
> +		}
> +		if (handle != space->session_tbl[i]) {
> +			dev_warn(&chip->dev, "session restored to wrong handle\n");
> +			tpm2_flush_space(chip, space);
> +			return -EFAULT;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -215,17 +265,20 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
>  
>  	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
>  	       sizeof(space->context_tbl));
> +	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
> +	       sizeof(space->session_tbl));
>  	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> +	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);

For transient objects the rollback is straight forward and totally
predictable. Given that with sessions you always keep some information
in the TPM the rollback would be a bit more complicated.

Now your code seems to just keep the previous session_buf, doesn't it?
Does that always work or not?

PS. I have a high-level idea of attack vectors that are prevented by
having meta-data for session inside the TPM but can you point me to
the correct place in the TPM 2.0 specification that discusses about
this?

/Jarkko
