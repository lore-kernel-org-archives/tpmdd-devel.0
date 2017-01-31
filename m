From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Tue, 31 Jan 2017 11:55:12 -0800
Message-ID: <1485892512.3199.81.camel@HansenPartnership.com>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<o6m2nv$g6n$1@blaine.gmane.org>
	<1485792295.2518.23.camel@HansenPartnership.com>
	<o6qog0$30l$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o6qog0$30l$1@blaine.gmane.org>
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

On Tue, 2017-01-31 at 14:28 -0500, Ken Goldman wrote:
> On 1/30/2017 11:04 AM, James Bottomley wrote:
> > 
> > This depends what your threat model is.  For ssh keys, you worry
> > that someone might be watching, so you use HMAC authority even for 
> > a local TPM.
> 
> If someone can "watch" my local process, they can capture my password
> anyway.  Does using a password that the attacker knows to HMAC the 
> command help?

It's about attack surface.  If you want my password and I use TPM_RS_PW
then you either prise it out of my app or snoop the command path.  If I
always use HMAC, I know you can only prise it out of my app (reduction
in attack surface) and I can plan defences accordingly (not saying I'll
be successful, just saying I have a better idea where the attack is
coming from).

> > In the cloud, you don't quite know where the TPM is, so again you'd
> > use HMAC sessions ... however, in both use cases the sessions 
> > should be very short lived.
> 
> If your entire application is in the cloud, then I think the same 
> question as above applies.
> 
> If you have your application on one platform (that you trust) and the
> TPM is on another (that you don't trust), then I absolutely agree 
> that HMAC (and parameter encryption) are necessary.

It's attack surface again ... although lengthening the transmission
pathway, which happens in the cloud, correspondingly increases that sur
face.

Look at it this way: if your TPM were network remote, would you still
think TPM_RS_PW to be appropriate?  I suspect not because the network
is seen as a very insecure pathway.  We can argue about the relative
security or insecurity of other pathways to the TPM, but it's
unarguable that using HMAC and parameter encryption means we don't have
to (and so is best practice).

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
