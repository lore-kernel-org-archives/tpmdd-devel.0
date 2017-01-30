From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Mon, 30 Jan 2017 23:45:26 +0200
Message-ID: <20170130214526.56e4ai2k6zhzvgy4@intel.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
	<1485563558.3229.41.camel@HansenPartnership.com>
	<20170129213957.zx6v6g42kwcabc6y@intel.com>
	<1485729418.2491.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485729418.2491.10.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jan 29, 2017 at 02:36:58PM -0800, James Bottomley wrote:
> On Sun, 2017-01-29 at 23:39 +0200, Jarkko Sakkinen wrote:
> > On Fri, Jan 27, 2017 at 04:32:38PM -0800, James Bottomley wrote:
> > > sessions are different from transient objects in that their handles
> > > may not be virtualized (because they're used for some hmac
> > > calculations).  Additionally when a session is context saved, a
> > > vestigial memory remains in the TPM and if it is also flushed, that
> > > will be lost and the session context will refuse to load next time,
> > > so
> > > the code is updated to flush only transient objects after a context
> > > save.  Add a separate array (chip->session_tbl) to save and restore
> > > sessions by handle.  Use the failure of a context save or load to
> > > signal that the session has been flushed from the TPM and we can
> > > remove its memory from chip->session_tbl.
> > > 
> > > Sessions are also isolated during each instance of a tpm space. 
> > >  This
> > > means that spaces shouldn't be able to see each other's sessions
> > > and
> > > is enforced by ensuring that a space user may only refer to
> > > sessions
> > > handles that are present in their own chip->session_tbl.  Finally
> > > when
> > > a space is closed, all the sessions belonging to it should be
> > > flushed
> > > so the handles may be re-used by other spaces.
> > > 
> > > Note that if we get a session save or load error, all sessions are
> > > effectively flushed.  Even though we restore the session buffer,
> > > all
> > > the old sessions will refuse to load after the flush and they'll be
> > > purged from our session memory.  This means that while transient
> > > context handling is still soft in the face of errors, session
> > > handling
> > > is hard (any failure of the model means all sessions are lost).
> > > 
> > > Signed-off-by: James Bottomley <
> > > James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > > 
> > > ---
> > > 
> > > v2: - add kill space to remove sessions on close
> > >     - update changelog
> > >     - reduce session table to 3 entries
> > > ---
> > >  drivers/char/tpm/tpm-chip.c   |   6 +++
> > >  drivers/char/tpm/tpm.h        |   4 +-
> > >  drivers/char/tpm/tpm2-space.c | 112
> > > ++++++++++++++++++++++++++++++++++++++++--
> > >  drivers/char/tpm/tpms-dev.c   |   2 +-
> > >  4 files changed, 118 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm
> > > -chip.c
> > > index ed4f887..6282ad0 100644
> > > --- a/drivers/char/tpm/tpm-chip.c
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -130,6 +130,7 @@ static void tpm_dev_release(struct device *dev)
> > >  
> > >  	kfree(chip->log.bios_event_log);
> > >  	kfree(chip->work_space.context_buf);
> > > +	kfree(chip->work_space.session_buf);
> > >  	kfree(chip);
> > >  }
> > >  
> > > @@ -223,6 +224,11 @@ struct tpm_chip *tpm_chip_alloc(struct device
> > > *pdev,
> > >  		rc = -ENOMEM;
> > >  		goto out;
> > >  	}
> > > +	chip->work_space.session_buf = kzalloc(PAGE_SIZE,
> > > GFP_KERNEL);
> > > +	if (!chip->work_space.session_buf) {
> > > +		rc = -ENOMEM;
> > > +		goto out;
> > > +	}
> > >  
> > >  	return chip;
> > >  
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > index c4b8ec9..10c57b9 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -161,6 +161,8 @@ enum tpm2_cc_attrs {
> > >  struct tpm_space {
> > >  	u32 context_tbl[3];
> > >  	u8 *context_buf;
> > > +	u32 session_tbl[3];
> > > +	u8 *session_buf;
> > >  };
> > >  
> > >  enum tpm_chip_flags {
> > > @@ -583,7 +585,7 @@ unsigned long tpm2_calc_ordinal_duration(struct
> > > tpm_chip *chip, u32 ordinal);
> > >  int tpm2_probe(struct tpm_chip *chip);
> > >  int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
> > >  int tpm2_init_space(struct tpm_space *space);
> > > -void tpm2_del_space(struct tpm_space *space);
> > > +void tpm2_del_space(struct tpm_chip *chip, struct tpm_space
> > > *space);
> > >  int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space
> > > *space, u32 cc,
> > >  		       u8 *cmd);
> > >  int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space
> > > *space,
> > > diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2
> > > -space.c
> > > index d241c2a..2b3d1ad 100644
> > > --- a/drivers/char/tpm/tpm2-space.c
> > > +++ b/drivers/char/tpm/tpm2-space.c
> > > @@ -32,18 +32,28 @@ struct tpm2_context {
> > >  	__be16 blob_size;
> > >  } __packed;
> > >  
> > > +static void tpm2_kill_sessions(struct tpm_chip *chip, struct
> > > tpm_space *space);
> > > +
> > >  int tpm2_init_space(struct tpm_space *space)
> > >  {
> > >  	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > >  	if (!space->context_buf)
> > >  		return -ENOMEM;
> > >  
> > > +	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> > > +	if (space->session_buf == NULL) {
> > > +		kfree(space->context_buf);
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > -void tpm2_del_space(struct tpm_space *space)
> > > +void tpm2_del_space(struct tpm_chip *chip, struct tpm_space
> > > *space)
> > >  {
> > > +	tpm2_kill_sessions(chip, space);
> > >  	kfree(space->context_buf);
> > > +	kfree(space->session_buf);
> > >  }
> > >  
> > >  static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
> > > @@ -69,6 +79,10 @@ static int tpm2_load_context(struct tpm_chip
> > > *chip, u8 *buf,
> > >  			 __func__, rc);
> > >  		tpm_buf_destroy(&tbuf);
> > >  		return -EFAULT;
> > > +	} else if (tpm2_rc_value(rc) == TPM2_RC_HANDLE ||
> > > +		   rc == TPM2_RC_REFERENCE_H0) {
> > > +		rc = -ENOENT;
> > > +		tpm_buf_destroy(&tbuf);
> > 
> > 1. Why isn't the check in tpm2_save_context sufficient to know that
> >    session was flushed?
> 
> Because sessions are global.  If something flushes the session not via
> our space (like /dev/tpm0) then our only indication will be a load
> failure.

Right, got it. In this case you would get TPM_RC_REFERENCE_H0 when you
do TPM2_ContextLoad.

> > 2. Can it really return both TPM_RC_HANDLE and TPM_RC_REFERENCE_H0? 
> 
> Yes, it seems that a session that doesn't exist (because it's been
> flushed) then it returns TPM_RC_REFERNCE_H0, but if the context has a
> sequence mismatch (because it's been flushed and reloaded) then we get
> TPM_RC_HANDLE.
> 
> James

If it is flushed, wouldn't you just get TPM_RC_REFERENCE_H0 when you try
to TPM2_ContextLoad? The "and reloaded" does not make sense to me. Once
a session is flushed it cannot be reloaded.

Maybe you meant to say "beause it's been saved and reloaded"? That would
make more sense and fits better what I see in the Commands specification.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
