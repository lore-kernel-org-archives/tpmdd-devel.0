From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Thu, 26 Jan 2017 08:26:19 -0800
Message-ID: <1485447979.2457.23.camel@HansenPartnership.com>
References: <1485236113.2534.69.camel@HansenPartnership.com>
	<1485236231.2534.71.camel@HansenPartnership.com>
	<20170126125151.32sky3tajp6zigpd@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170126125151.32sky3tajp6zigpd-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Thu, 2017-01-26 at 14:51 +0200, Jarkko Sakkinen wrote:
[...]
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index c48255e..b77fc60 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -159,6 +159,8 @@ enum tpm2_cc_attrs {
> >  struct tpm_space {
> >  	u32 context_tbl[3];
> >  	u8 *context_buf;
> > +	u32 session_tbl[6];
> > +	u8 *session_buf;
> >  };
> >  
> >  enum tpm_chip_flags {
> > @@ -588,4 +590,5 @@ int tpm2_prepare_space(struct tpm_chip *chip,
> > struct tpm_space *space, u32 cc,
> >  		       u8 *cmd);
> >  int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space
> > *space,
> >  		      u32 cc, u8 *buf, size_t bufsiz);
> > +void tpm2_flush_space(struct tpm_chip *chip, struct tpm_space
> > *space);
> 
> Why the extra parameter?

Because it was called from tpms-dev in release to flush all the
sessions still active.  At that point the work space is gone, so we
have to call it with the real space.  However, I realised that callsite
didn't hold the tpm_mutex like it should and that we don't need to
flush the contexts because they'll be guaranteed empty, so I added a
new function tpm2_kill_space() that does this.

> >  #endif
> > diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2
> > -space.c
> > index 7fd2fc5..ba4310a 100644
> > --- a/drivers/char/tpm/tpm2-space.c
> > +++ b/drivers/char/tpm/tpm2-space.c
> > @@ -59,11 +59,16 @@ static int tpm2_load_context(struct tpm_chip
> > *chip, u8 *buf,
> >  
> >  	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 4,
> >  			      TPM_TRANSMIT_UNLOCKED, NULL);
> > +
> 
> cruft

Removed.

[...] 
> > @@ -215,17 +265,20 @@ int tpm2_prepare_space(struct tpm_chip *chip,
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
> 
> For transient objects the rollback is straight forward and totally
> predictable. Given that with sessions you always keep some 
> information in the TPM the rollback would be a bit more complicated.

There is basically no rollback unless you really want to understand
what the commands did.  If we get a fault on the context save or load
that isn't one we understand, like TPM_RC_HANDLE meaning the session
won't load or TPM_RC_REFERENCE_H0 meaning the session no longer exists,
then I think the only option is flushing everything.

I'd like us to agree on a hard failure model: if we get some
unexplained error during our context loads or saves, we should clear
out the entire space (which would allow us to use pointers instead of
copyring) but we don't.  So we follow the soft failure.  However,
sessions will mostly fail to load after this with RPM_RC_HANDLE, so we
get the equivalent of soft failure for transients and hard failure for
sessions.

> Now your code seems to just keep the previous session_buf, doesn't
> it? Does that always work or not?

Yes, after tpm_flush_space, the session memory is gone and all the
sessions will refuse to load with RC_HANDLE, so we end up effectively
clearing them out.  It seemed better to do it this way than to try to
special case all the session stuff.

> PS. I have a high-level idea of attack vectors that are prevented by
> having meta-data for session inside the TPM but can you point me to
> the correct place in the TPM 2.0 specification that discusses about
> this?

The problem is replay.  If I'm snooping your TPM commands and I capture
your session context, if we don't have replay detection, I can re-load
your session HMAC and replay your command because the session has the
authorization or the encryption.  The TPM designers thought the only
way to avoid replay was to use a counter which was part of the session
context which increments every time a session is saved.  On loading you
check that the counters match and fail if they don't.  The only way to
implement this is to keep a memory of the counter in the TPM, hence the
annoying vestigial sessions.

It's note 2 of the architecture Part 1 guide, chapter "15.4 Session
Handles (MSO=02_16 and 03_16 )"

James

> 
> /Jarkko
> 


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
