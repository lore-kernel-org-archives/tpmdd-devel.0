From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm2: add session handle isolation to
	tpm spaces
Date: Fri, 20 Jan 2017 09:27:25 -0500
Message-ID: <o5t6ns$k6e$1@blaine.gmane.org>
References: <1484752097.2717.14.camel@HansenPartnership.com>
	<1484752186.2717.16.camel@HansenPartnership.com>
	<20170119115812.vqaoxv77mgnuq43h@intel.com>
	<1484827883.3140.7.camel@HansenPartnership.com>
	<20170120132331.74dixmuj6htzgr4z@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170120132331.74dixmuj6htzgr4z-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 1/20/2017 8:23 AM, Jarkko Sakkinen wrote:
>
> I'm talking about not trying to detect if something gets deleted. When
> something gets created you would go through the global list of sessions
> and check if it is used. If so, it must be that the session was deleted
> at some point.

Are you saying that, when a process flushes (or continue = false) a 
session, this code won't actually flush the context?  You'll wait until 
another startauthsession creates a handle, and then delete other 
occurrences of it?

If so, I wonder about this:

A process creates, uses, and flushes a session.  It then tries to use 
the session again.  It should fail, but will it with this design?

There may also be a security reason that an application expects the 
context to be flushed when requested.  E.g., it could have a satisfied 
policy.





------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
