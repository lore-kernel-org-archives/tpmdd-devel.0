From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 19 Jan 2017 14:25:33 +0200
Message-ID: <20170119122533.d7h5rgatpwl3qmcl@intel.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484772489.2396.2.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On Wed, Jan 18, 2017 at 03:48:09PM -0500, James Bottomley wrote:
> In a TPM2, sessions can be globally exhausted once there are
> TPM_PT_ACTIVE_SESSION_MAX of them (even if they're all context saved).
> The Strategy for handling this is to keep a global count of all the
> sessions along with their creation time.  Then if we see the TPM run
> out of sessions (via the TPM_RC_SESSION_HANDLES) we first wait for one
> to become free, but if it doesn't, we forcibly evict an existing one.
> The eviction strategy waits until the current command is repeated to
> evict the session which should guarantee there is an available slot.
> 
> On the force eviction case, we make sure that the victim session is at
> least SESSION_TIMEOUT old (currently 2 seconds).  The wait queue for
> session slots is a FIFO one, ensuring that once we run out of
> sessions, everyone will get a session in a bounded time and once they
> get one, they'll have SESSION_TIMEOUT to use it before it may be
> subject to eviction.
> 
> Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

I didn't yet read the code properly. I'll do a more proper review
once I have v4 of my patch set together. This comment is solely
based on your commit message.

I'm just thinking that do we need this complicated timeout stuff
or could you just kick a session out in LRU fashion as we run
out of them?

Or one variation of what you are doing: couldn't the session that
needs a session handle to do something sleep for 2 seconds and then
take the oldest session? It would have essentially the same effect
but no waitqueue needed.

Yeah, as I said, this is just commentary based on the description.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
