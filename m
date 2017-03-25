From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] tpm/tpm_crb: Enable TPM CRB
	interface for ARM64
Date: Sat, 25 Mar 2017 21:15:13 +0200
Message-ID: <20170325191513.n7sf67jy2yys4yhp@intel.com>
References: <1490349345-26910-1-git-send-email-anjiandi@codeaurora.org>
	<1490349345-26910-3-git-send-email-anjiandi@codeaurora.org>
	<20170324174559.usyjoxnrkedxtrd3@intel.com>
	<58D58E33.5090305@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58D58E33.5090305-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 24, 2017 at 04:22:59PM -0500, Jiandi An wrote:
> On 03/24/17 12:45, Jarkko Sakkinen wrote:
> > On Fri, Mar 24, 2017 at 04:55:45AM -0500, Jiandi An wrote:
> > > This enables TPM Command Response Buffer interface driver for
> > > ARM64 and implements an ARM specific TPM CRB start method that
> > > invokes a Secure Monitor Call (SMC) to request the TrustZone
> > > Firmware to execute or cancel a TPM 2.0 command.
> > > 
> > > In ARM, TrustZone security extensions enable a secure software
> > > environment with Secure Monitor mode.  A Secure Monitor Call
> > > (SMC) is used to enter the Secure Monitor mode and perform a
> > > Secure Monitor service to communicate with TrustZone firmware
> > > which has control over the TPM hardware.
> > > 
> > > Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > 
> > LGTM
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > How this can be tested / do you know anyone who could test your
> > change? I can test that it doesn't break x86.
> > 
> > /Jarkko
> 
> Thanks for the review Jarkko.  I'm including Shanker Donthineni
> (shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org) that has ARM64 platform that could test
> on the ARM64 side.
> 
> - Jiandi

That would be great.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
