From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 20 Jan 2017 15:40:42 +0200
Message-ID: <20170120134042.yb75s3bgro7htvhk@intel.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
 <20170119122533.d7h5rgatpwl3qmcl@intel.com>
 <1484830744.3140.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484830744.3140.17.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 19, 2017 at 07:59:04AM -0500, James Bottomley wrote:
> On Thu, 2017-01-19 at 14:25 +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 18, 2017 at 03:48:09PM -0500, James Bottomley wrote:
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
> > 
> > I didn't yet read the code properly. I'll do a more proper review
> > once I have v4 of my patch set together. This comment is solely
> > based on your commit message.
> > 
> > I'm just thinking that do we need this complicated timeout stuff
> > or could you just kick a session out in LRU fashion as we run
> > out of them?
> > 
> > Or one variation of what you are doing: couldn't the session that
> > needs a session handle to do something sleep for 2 seconds and then
> > take the oldest session? It would have essentially the same effect
> > but no waitqueue needed.
> > 
> > Yeah, as I said, this is just commentary based on the description.
> 
> If you don't have a wait queue you lose fairness in resource allocation
> on starvation.  What happens is that you get RC_SESSION_HANDLES and
> sleep for 2s and retry.  Meanwhile someone frees a session, then next
> user grabs it while you were sleeping and when you wake you still get
> RC_SESSION_HANDLES.  I can basically DoS your process if I understand
> this. The only way to make the resource fairly allocated: i.e. the
> first person to sleep waiting for a session is the one who gets it when
> they wake is to make sure that you wake one waiter as soon as a free
> session comes in so probabalistically, they get the session.  If you
> look, there are two mechanisms for ensuring fairness: one is the FIFO
> wait queue (probabalistic) and the other is the reserved session which
> really ensures it belongs to you when you wake (deterministic but
> expensive, so this is only activated on the penultimate go around).
> 
> James

Right, I see your point.

/Jarkko
