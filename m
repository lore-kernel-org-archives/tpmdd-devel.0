From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Tue, 31 Jan 2017 14:55:40 -0800
Message-ID: <1485903340.3199.107.camel@HansenPartnership.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
	<1485563558.3229.41.camel@HansenPartnership.com>
	<20170131162115.vptki5ykmpnx27ym@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170131162115.vptki5ykmpnx27ym-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-31 at 18:21 +0200, Jarkko Sakkinen wrote:
[...]
> Now that I understand what is happening I'll give some code level
> feedback. Overally I think this is in really good shape!

Thanks!

[...]
> On Fri, Jan 27, 2017 at 04:32:38PM -0800, James Bottomley wrote:
> > --- a/drivers/char/tpm/tpm2-space.c
> > +++ b/drivers/char/tpm/tpm2-space.c
> > @@ -32,18 +32,28 @@ struct tpm2_context {
> >  	__be16 blob_size;
> >  } __packed;
> >  
> > +static void tpm2_kill_sessions(struct tpm_chip *chip, struct
> > tpm_space *space);
> 
> Move the declaration here so that you don't have to jump back and 
> forth in the code in order to understand what is happening.

OK, can do that.

> > +
> >  int tpm2_init_space(struct tpm_space *space)
> >  {
> >  	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >  	if (!space->context_buf)
> >  		return -ENOMEM;
> >  
> > +	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > +	if (space->session_buf == NULL) {
> > +		kfree(space->context_buf);
> > +		return -ENOMEM;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > -void tpm2_del_space(struct tpm_space *space)
> > +void tpm2_del_space(struct tpm_chip *chip, struct tpm_space
> > *space)
> >  {
> > +	tpm2_kill_sessions(chip, space);
> >  	kfree(space->context_buf);
> > +	kfree(space->session_buf);
> >  }
> >  
> >  static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
> > @@ -69,6 +79,10 @@ static int tpm2_load_context(struct tpm_chip
> > *chip, u8 *buf,
> >  			 __func__, rc);
> >  		tpm_buf_destroy(&tbuf);
> >  		return -EFAULT;
> > +	} else if (tpm2_rc_value(rc) == TPM2_RC_HANDLE ||
> > +		   rc == TPM2_RC_REFERENCE_H0) {
> > +		rc = -ENOENT;
> > +		tpm_buf_destroy(&tbuf);
> 
> Maybe a comment here would make sense (for maitenance purposes) as it
> isn't inherently obvious why and when these error codes are used.

Sure, I can put that in.

> 
> >  	} else if (rc > 0) {
> >  		dev_warn(&chip->dev, "%s: failed with a TPM error
> > 0x%04X\n",
> >  			 __func__, rc);
> > @@ -121,12 +135,30 @@ static int tpm2_save_context(struct tpm_chip
> > *chip, u32 handle, u8 *buf,
> >  	}
> >  
> >  	memcpy(&buf[*offset], &tbuf.data[TPM_HEADER_SIZE],
> > body_size);
> > -	tpm2_flush_context_cmd(chip, handle,
> > TPM_TRANSMIT_UNLOCKED);
> >  	*offset += body_size;
> >  	tpm_buf_destroy(&tbuf);
> >  	return 0;
> >  }
> >  
> > +static int tpm2_session_add(struct tpm_chip *chip, u32 handle)
> > +{
> > +	struct tpm_space *space = &chip->work_space;
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++)
> > +		if (space->session_tbl[i] == 0)
> > +			break;
> > +	if (i == ARRAY_SIZE(space->session_tbl)) {
> > +		dev_err(&chip->dev, "out of session slots\n");
> 
> I think using dev_err is not correct here as this is a legit 
> situation. I would lower this down to dev_dbg.

I can do that, but I think this should be higher than debug.  If this
trips, something an application was doing will fail with a non TPM
error and someone may wish to investigate why.  Having a kernel message
would help with that (but they won't see it if it's debug).

I'm also leaning towards the idea that we should actually have one more
_tbl slot than we know the TPM does, so that if someone goes over it's
the TPM that gives them a real TPM out of memory error rather than the
space code returning -ENOMEM.

If you agree, I think it should be four for both sessions_tbl and
context_tbl.

> > +		tpm2_flush_context_cmd(chip, handle,
> > TPM_TRANSMIT_UNLOCKED);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	space->session_tbl[i] = handle;
> > +
> > +	return 0;
> > +}
> > +
> >  static void tpm2_flush_space(struct tpm_chip *chip)
> >  {
> >  	struct tpm_space *space = &chip->work_space;
> > @@ -136,6 +168,25 @@ static void tpm2_flush_space(struct tpm_chip
> > *chip)
> >  		if (space->context_tbl[i] && ~space
> > ->context_tbl[i])
> >  			tpm2_flush_context_cmd(chip, space
> > ->context_tbl[i],
> >  					      
> >  TPM_TRANSMIT_UNLOCKED);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> > +		if (space->session_tbl[i])
> > +			tpm2_flush_context_cmd(chip, space
> > ->session_tbl[i],
> > +					      
> >  TPM_TRANSMIT_UNLOCKED);
> > +	}
> > +}
> > +
> > +static void tpm2_kill_sessions(struct tpm_chip *chip, struct
> > tpm_space *space)
> > +{
> > +	int i;
> > +
> > +	mutex_lock(&chip->tpm_mutex);
> > +	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
> > +		if (space->session_tbl[i])
> > +			tpm2_flush_context_cmd(chip, space
> > ->session_tbl[i],
> > +					      
> >  TPM_TRANSMIT_UNLOCKED);
> > +	}
> > +	mutex_unlock(&chip->tpm_mutex);
> >  }
> 
> Please use this in tpm2_flush_space()

OK.

>  and take the mutex in those call sites where you need it.

I think it's slightly better practice to hide critical sections in call
functions, that way callers don't have so much locking stuff to get
wrong (which is one of our biggest causes of programming faults). 
 However, since this has now become an internal function to tpm2
-space.c, i think moving the locking in this case is fine, so I'll
change it.

> >  static int tpm2_load_space(struct tpm_chip *chip)
> > @@ -161,6 +212,28 @@ static int tpm2_load_space(struct tpm_chip
> > *chip)
> >  			return rc;
> >  	}
> >  
> > +	for (i = 0, offset = 0; i < ARRAY_SIZE(space
> > ->session_tbl); i++) {
> > +		u32 handle;
> > +
> > +		if (!space->session_tbl[i])
> > +			continue;
> > +
> > +		rc = tpm2_load_context(chip, space->session_buf,
> > +				       &offset, &handle);
> > +		if (rc == -ENOENT) {
> > +			/* load failed, just forget session */
> > +			space->session_tbl[i] = 0;
> > +		} else if (rc) {
> > +			tpm2_flush_space(chip);
> > +			return rc;
> > +		}
> > +		if (handle != space->session_tbl[i]) {
> > +			dev_warn(&chip->dev, "session restored to
> > wrong handle\n");
> > +			tpm2_flush_space(chip);
> > +			return -EFAULT;
> 
> I forgot to ask about this corner case. When can it happen?

In theory never.  In practice, if the _tbl and the _buf ever got out of
sync (which hopefully should never happen), so it looks like a useful
assertion check (in the old days I'd have made it a BUG_ON).

> > +		}
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -220,7 +293,10 @@ int tpm2_prepare_space(struct tpm_chip *chip,
> > struct tpm_space *space, u32 cc,
> >  
> >  	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
> >  	       sizeof(space->context_tbl));
> > +	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
> > +	       sizeof(space->session_tbl));
> >  	memcpy(chip->work_space.context_buf, space->context_buf,
> > PAGE_SIZE);
> > +	memcpy(chip->work_space.session_buf, space->session_buf,
> > PAGE_SIZE);
> >  
> >  	rc = tpm2_load_space(chip);
> >  	if (rc) {
> > @@ -240,7 +316,7 @@ int tpm2_prepare_space(struct tpm_chip *chip,
> > struct tpm_space *space, u32 cc,
> >  static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8
> > *rsp, size_t len)
> >  {
> >  	struct tpm_space *space = &chip->work_space;
> > -	u32 phandle;
> > +	u32 phandle, phandle_type;
> 
> Extremely cosmetic comment but I prefer one line per declaration.

Well, OK.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
