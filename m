From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 27 Jan 2017 14:04:59 -0800
Message-ID: <1485554699.3229.20.camel@HansenPartnership.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o6gese$pev$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-27 at 16:42 -0500, Ken Goldman wrote:
> On 1/18/2017 3:48 PM, James Bottomley wrote:
> > In a TPM2, sessions can be globally exhausted once there are
> > TPM_PT_ACTIVE_SESSION_MAX of them (even if they're all context
> > saved).
> > The Strategy for handling this is to keep a global count of all the
> > sessions along with their creation time.  Then if we see the TPM
> > run
> > out of sessions (via the TPM_RC_SESSION_HANDLES) we first wait for
> > one
> > to become free, but if it doesn't, we forcibly evict an existing
> > one.
> > The eviction strategy waits until the current command is repeated
> > to
> > evict the session which should guarantee there is an available
> > slot.
> 
> Beware the nasty corner case:
> 
> - Application asks for a session and gets 02000000
> 
> - Time elapses and 02000000 gets forcibly flushed
> 
> - Later, app comes back, asks for a second session and again gets
> 02000000.
> 
> - App gets very confused.
> 
> May it be better to close the connection completely, which the 
> application can detect, than flush a session and give this corner
> case?

if I look at the code I've written, I don't know what the session
number is, I just save sessionHandle in a variable for later use (lets
say to v1).  If I got the same session number returned at a later time
and placed it in v2, all I'd notice is that an authorization using v1
would fail.  I'm not averse to killing the entire connection but,
assuming you have fallback, it might be kinder simply to ensure that
the operations with the reclaimed session fail (which is what the code
currently does).

> ~~~~
> 
> Part of me says to defer this.  That is:
> 
> 64 sessions / 3 = 21 simultaneous applications.  If we have 21 
> simultaneous TCG applications, we'll all celebrate.  For the DoS,
> chmod and chgrp /dev/tpm and let only well behaved applications in 
> the group.
> 
> Agreed, it's not a long term solution.

My use case is secret protection in the cloud.  I can certainly see >
21 applications wanting to do this at roughly the same time. However,
the periods over which they actually all need sessions should be very
short, hence the leasing proposal which would stagger them.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
