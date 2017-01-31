From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
	exhaustion
Date: Tue, 31 Jan 2017 14:28:06 -0500
Message-ID: <o6qog0$30l$1@blaine.gmane.org>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<o6m2nv$g6n$1@blaine.gmane.org>
	<1485792295.2518.23.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485792295.2518.23.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/30/2017 11:04 AM, James Bottomley wrote:
>
> This depends what your threat model is.  For ssh keys, you worry
> that someone might be watching, so you use HMAC authority even for a
> local TPM.

If someone can "watch" my local process, they can capture my password 
anyway.  Does using a password that the attacker knows to HMAC the 
command help?

> In the cloud, you don't quite know where the TPM is, so again you'd
> use HMAC sessions ... however, in both use cases the sessions should
> be very short lived.

If your entire application is in the cloud, then I think the same 
question as above applies.

If you have your application on one platform (that you trust) and the 
TPM is on another (that you don't trust), then I absolutely agree that 
HMAC (and parameter encryption) are necessary.






------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
