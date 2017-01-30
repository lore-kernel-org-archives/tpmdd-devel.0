From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] tpm2-space: add handling for global session
	exhaustion
Date: Mon, 30 Jan 2017 17:46:26 -0500
Message-ID: <o6ofns$5ic$1@blaine.gmane.org>
References: <1484772489.2396.2.camel@HansenPartnership.com>
	<o6gese$pev$1@blaine.gmane.org>
	<1485554699.3229.20.camel@HansenPartnership.com>
	<o6m2nv$g6n$1@blaine.gmane.org>
	<1485792295.2518.23.camel@HansenPartnership.com>
	<20170130215815.4lr42ob7e4cycwgi@intel.com>
	<1485814388.2518.28.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485814388.2518.28.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
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

On 1/30/2017 5:13 PM, James Bottomley wrote:
>
> But as I read the code, I can't find where the kernel creates a
> session.  It looks like the session and hmac are passed in as option
> arguments, aren't they?

A bit of background.

Unlike TPM 1.2, which always required an HMAC, TPM 2.0 has plaintext
password sessions, with the session number TPM_RS_PS.  This type of
session does not have to be created or flushed.  Since the kernel has a 
presumed trusted path to the TPM, I don't see any need for an HMAC session.

However, TPM 2.0 does has policy sessions.  These do have to be
created.  The kernel use case may be in the future.

The first use I encountered for a policy session is use of the EK.  The 
EK has no password of its own, but rather has a policy that points to 
the endorsement hierarchy authorization - policy secret.




------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
