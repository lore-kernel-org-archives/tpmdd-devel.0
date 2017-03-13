From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/3] ACPICA: Update TPM2 ACPI table
Date: Mon, 13 Mar 2017 13:43:35 +0200
Message-ID: <20170313114335.jlm4tttbzaeqmryz@intel.com>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
	<1489139889-14376-2-git-send-email-anjiandi@codeaurora.org>
	<20170311081914.k5qrbfwmjfb3fa7e@intel.com>
	<58C4698B.3030601@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58C4698B.3030601-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 11, 2017 at 03:18:03PM -0600, Jiandi An wrote:
> On 03/11/17 02:19, Jarkko Sakkinen wrote:
> > On Fri, Mar 10, 2017 at 03:58:07AM -0600, Jiandi An wrote:
> > > TCG ACPI Specification Family "1.2" and "2.0" Version 1.2
> > > Revision 8 introduces new start method for ARM SMC.
> > > 
> > > - Add new start method (type 11) for ARM SMC
> > > - Add start method specific parameters for ARM SMC start method
> > > 
> > > Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > 
> > Could you briefly describe what SMC is? I don't know
> > 
> > 1. What the abbrevation stands for.
> SMC stands for Secure Monitor Call.
> 
> > 2. What it is.
> In ARM, TrustZone security extensions ennable a Secure software
> environment with Secure Monitor mode.  A Secure Monitor Call (SMC) is
> used to enter the Secure Monitor mode and perform a Secure Monitor
> service call.  Software executing in the non-secure state and in the
> secure state at exception levels lower than EL3 in ARM will request
> runtime services using the Secure Monitor Call (SMC) instruction to
> enter EL3 secure mode.
> 
> I'll include a brief description in commit message of patch as well
> in next version of the patch.
> 
> Thanks.
> - Jiandi

Thank you. I got the idea but it still would be also good idea to
have this documented in the commit message so it's available in the
commit log if we need to backtrack something.

/Jarkko

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
