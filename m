From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm2-space: add handling for global
 session exhaustion
Date: Wed, 1 Feb 2017 12:29:06 +0200
Message-ID: <20170201102906.y67owrhw4clvlge7@intel.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
 <1485563634.3229.43.camel@HansenPartnership.com>
 <20170129220219.oqv7fuofvcqy3gzh@intel.com>
 <1485905084.3199.114.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485905084.3199.114.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 31, 2017 at 03:24:44PM -0800, James Bottomley wrote:
> On Mon, 2017-01-30 at 00:02 +0200, Jarkko Sakkinen wrote:
> > On Fri, Jan 27, 2017 at 04:33:54PM -0800, James Bottomley wrote:
> > > In a TPM2, sessions can be globally exhausted once there are
> > > TPM_PT_ACTIVE_SESSION_MAX of them (even if they're all context
> > > saved).
> > > The Strategy for handling this is to keep a global count of all the
> > > sessions along with their creation time.  Then if we see the TPM
> > > run
> > > out of sessions (via the TPM_RC_SESSION_HANDLES) we first wait for
> > > one
> > > to become free, but if it doesn't, we forcibly evict an existing
> > > one.
> > > The eviction strategy waits until the current command is repeated
> > > to
> > > evict the session which should guarantee there is an available
> > > slot.
> > > 
> > > On the force eviction case, we make sure that the victim session is
> > > at
> > > least SESSION_TIMEOUT old (currently 2 seconds).  The wait queue
> > > for
> > > session slots is a FIFO one, ensuring that once we run out of
> > > sessions, everyone will get a session in a bounded time and once
> > > they
> > > get one, they'll have SESSION_TIMEOUT to use it before it may be
> > > subject to eviction.
> > > 
> > > Signed-off-by: James Bottomley <
> > > James.Bottomley@HansenPartnership.com>
> > > ---
> > >  drivers/char/tpm/tpm-chip.c   |   1 +
> > >  drivers/char/tpm/tpm.h        |  39 +++++++-
> > >  drivers/char/tpm/tpm2-cmd.c   |  15 +++
> > >  drivers/char/tpm/tpm2-space.c | 209
> > > ++++++++++++++++++++++++++++++++++++++++--
> > >  drivers/char/tpm/tpms-dev.c   |  17 +++-
> > >  5 files changed, 271 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm
> > > -chip.c
> > > index 6282ad0..150c6b8 100644
> > > --- a/drivers/char/tpm/tpm-chip.c
> > > +++ b/drivers/char/tpm/tpm-chip.c
> > > @@ -164,6 +164,7 @@ struct tpm_chip *tpm_chip_alloc(struct device
> > > *pdev,
> > >  
> > >  	mutex_init(&chip->tpm_mutex);
> > >  	init_rwsem(&chip->ops_sem);
> > > +	init_waitqueue_head(&chip->session_wait);
> > >  
> > >  	chip->ops = ops;
> > >  
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > index 10c57b9..658e5e2 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -95,7 +95,8 @@ enum tpm2_return_codes {
> > >  	TPM2_RC_HANDLE		= 0x008B,
> > >  	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
> > >  	TPM2_RC_DISABLED	= 0x0120,
> > > -	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
> > > +	TPM2_RC_SESSION_HANDLES	= 0x0905, /* RC_WARN */
> > > +	TPM2_RC_TESTING		= 0x090A,
> > >  	TPM2_RC_REFERENCE_H0	= 0x0910,
> > >  };
> > >  
> > > @@ -139,7 +140,8 @@ enum tpm2_capabilities {
> > >  };
> > >  
> > >  enum tpm2_properties {
> > > -	TPM_PT_TOTAL_COMMANDS	= 0x0129,
> > > +	TPM_PT_TOTAL_COMMANDS		= 0x0129,
> > > +	TPM_PT_ACTIVE_SESSIONS_MAX	= 0x0111,
> > >  };
> > >  
> > >  enum tpm2_startup_types {
> > > @@ -163,8 +165,24 @@ struct tpm_space {
> > >  	u8 *context_buf;
> > >  	u32 session_tbl[3];
> > >  	u8 *session_buf;
> > > +	u32 reserved_handle;
> > >  };
> > >  
> > > +#define TPM2_HANDLE_FORCE_EVICT 0xFFFFFFFF
> > > +
> > > +static inline void tpm2_session_force_evict(struct tpm_space
> > > *space)
> > > +{
> > > +	/* if reserved handle is not empty, we already have a
> > > +	 * session for eviction, so no need to force one
> > > +	 */
> > > +	if (space->reserved_handle == 0)
> > > +		space->reserved_handle = TPM2_HANDLE_FORCE_EVICT;
> > > +}
> > > +static inline bool tpm2_is_session_force_evict(struct tpm_space
> > > *space)
> > > +{
> > > +	return space->reserved_handle == TPM2_HANDLE_FORCE_EVICT;
> > > +}
> > > +
> > >  enum tpm_chip_flags {
> > >  	TPM_CHIP_FLAG_TPM2		= BIT(1),
> > >  	TPM_CHIP_FLAG_IRQ		= BIT(2),
> > > @@ -177,6 +195,12 @@ struct tpm_chip_seqops {
> > >  	const struct seq_operations *seqops;
> > >  };
> > >  
> > > +struct tpm_sessions {
> > > +	struct tpm_space *space;
> > > +	u32 handle;
> > > +	unsigned long created;
> > > +};
> > 
> > I would rethink this a bit. I kind of dislike this structure as it
> > 
> > I would rather have 
> > 
> > struct tpm_session {
> > 	u32 handle;
> > 	unsigned long created;
> > };
> > 
> > and in struct tpm_space:
> > 	
> > struct tpm_session session_tbl[3];
> > struct list_head session_list;
> > 	
> > and keep those instances that have sessions in that linked list.
> > 
> > What do you think? 
> 
> I can do ... but tpm_session will also need a struct list_head node so
> it can be placed on the list ...
> 
> If I'm listifying, I'd probably also add a hash bucket list for easy
> lookup by session.
> 
> James

I've been observing the discussion that you've been going with Ken and
I've started to think: "why this needs to be put into kernel?" We still
have quite narrow perspective of TPM 2.0 applications. It's so much more
capable than TPM 1.2 that it will be definitely have a wider set of
use cases.

You could probably make reasonable solution by using the view of handles
given by /dev/tpm0 and use that data the remove sessions, not as
accurate but reasonable. And we would't have to lock in the policy into
the kernel.

/Jarkko
