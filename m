From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Mon, 30 Jan 2017 08:04:55 -0800
Message-ID: <1485792295.2518.23.camel@HansenPartnership.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<o6m2nv$g6n$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o6m2nv$g6n$1@blaine.gmane.org>
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

On Sun, 2017-01-29 at 19:52 -0500, Ken Goldman wrote:
> On 1/27/2017 5:04 PM, James Bottomley wrote:
> 
> > > Beware the nasty corner case:
> > > 
> > > - Application asks for a session and gets 02000000
> > > 
> > > - Time elapses and 02000000 gets forcibly flushed
> > > 
> > > - Later, app comes back, asks for a second session and again gets
> > > 02000000.
> > > 
> > > - App gets very confused.
> > > 
> > > May it be better to close the connection completely, which the
> > > application can detect, than flush a session and give this corner
> > > case?
> > 
> > if I look at the code I've written, I don't know what the session
> > number is, I just save sessionHandle in a variable for later use 
> > (lets say to v1).  If I got the same session number returned at a 
> > later time and placed it in v2, all I'd notice is that an 
> > authorization using v1 would fail.  I'm not averse to killing the 
> > entire connection but, assuming you have fallback, it might be 
> > kinder simply to ensure that the operations with the reclaimed 
> > session fail (which is what the code currently does).
> 
> My worry is that this session failure cannot be detected by the 
> application.  An HMAC failure could cause the app to tell a user that
> they entered the wrong password.  Misleading.  On the TPM, it could 
> trigger the dictionary attack lockout.  For a PIN index, it could 
> consume a failure count.  Killing a policy session that has e.g., a 
> policy signed term could cause the application to go back to some 
> external entity for another authorization signature.
> 
> Let's go up to the stack.  What's the attack?
> 
> If we're worried about many simultaneous applications (wouldn't that 
> be wonderful), why not just let startauthsession fail?  The 
> application can just retry periodically.

How in that scenario do we ensure that a session becomes available? 
 Once that's established, there's no real difference between retrying
the startauthsession in the kernel when we know the session is
available and forcing userspace to do the retry except that the former
has a far greater chance of success (and it's only about 6 lines of
code).

>   Just allocate them in triples so there's no deadlock.

Is this the application or the kernel?  If it's the kernel, that adds a
lot of complexity.

> If we're worried about a DoS attack, killing a session just helps the
> attacker.  The attacker can create a few connections and spin on 
> startauthsession, locking everyone out anyway.

There are two considerations here: firstly we'd need to introduce a
mechanism to "kill" the connection.  Probably we'd simply error every
command on the space until it was closed.  The second is which scenario
is more reasonable: Say the application simply forgot to flush the
session and will never use it again.  Simply reclaiming the session
would produce no effect at all on the application in this scenario. 
 However, I have no data to say what's likely.

> ~~
> 
> Also, let's remember that this is a rare application.  Sessions are 
> only needed for remote access (requiring encryption, HMAC or salt), 
> or policy sessions.

This depends what your threat model is.  For ssh keys, you worry that
someone might be watching, so you use HMAC authority even for a local
TPM.  In the cloud, you don't quite know where the TPM is, so again
you'd use HMAC sessions ... however, in both use cases the sessions
should be very short lived.

> ~~
> 
> Should the code also reserve a session for the kernel?  Mark it not 
> kill'able?

At the moment, the kernel doesn't use sessions, so let's worry about
that problem at the point it arises (if it ever arises).

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
