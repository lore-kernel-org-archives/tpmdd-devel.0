From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm2-space: add handling for global
 session exhaustion
Date: Thu, 26 Jan 2017 16:45:52 -0800
Message-ID: <1485477952.2457.55.camel@HansenPartnership.com>
References: <1485236113.2534.69.camel@HansenPartnership.com>
	<1485236313.2534.73.camel@HansenPartnership.com>
	<20170126125615.dt5hnfbpmtxk7xlq@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170126125615.dt5hnfbpmtxk7xlq-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Thu, 2017-01-26 at 14:56 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 09:38:33PM -0800, James Bottomley wrote:
> > In a TPM2, sessions can be globally exhausted once there are
> > TPM_PT_ACTIVE_SESSION_MAX of them (even if they're all context 
> > saved). The Strategy for handling this is to keep a global count of 
> > all the sessions along with their creation time.  Then if we see 
> > the TPM run out of sessions (via the TPM_RC_SESSION_HANDLES) we 
> > first wait for one to become free, but if it doesn't, we forcibly 
> > evict an existing one. The eviction strategy waits until the 
> > current command is repeated to evict the session which should 
> > guarantee there is an available slot.
> > 
> > On the force eviction case, we make sure that the victim session is 
> > at least SESSION_TIMEOUT old (currently 2 seconds).  The wait queue
> > for session slots is a FIFO one, ensuring that once we run out of
> > sessions, everyone will get a session in a bounded time and once 
> > they get one, they'll have SESSION_TIMEOUT to use it before it may 
> > be subject to eviction.
> > 
> > Signed-off-by: James Bottomley <
> > James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> 
> This is not a proper review yet. Just quick question: why do you need
> a real time (i.e. created)? Maybe in the force eviction case it would
> be enough to sleep lets say 500 ms and pick the victim with smallest
> number? I.e. just have increasing u64 counter instead of real time.

So that if the oldest session has already been around for > 2s there's
no need to wait.  In order to guarantee everyone gets a session for at
least 2s without tracking the age of sessions, you'd have to sleep for
2s after you find the oldest session.

> That would simplify this patch a lot and does not prevent to refine
> later on if workloads show need for more complex logic.

An increasing monotonic counter would actually not be much simpler: all
you could really cut out would be the four lines and two comments at
the bottom of the for loop in tpm2_session_wait() which check the age
of the found session.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
