From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] tpm/tpm_crb: Enable TPM CRB
	interface for ARM64
Date: Sun, 26 Mar 2017 22:41:31 +0300
Message-ID: <20170326194131.jb76vy4cptgyu7tl@intel.com>
References: <1490349345-26910-1-git-send-email-anjiandi@codeaurora.org>
	<1490349345-26910-3-git-send-email-anjiandi@codeaurora.org>
	<20170324174559.usyjoxnrkedxtrd3@intel.com>
	<58D58E33.5090305@codeaurora.org>
	<0c887895-0192-774b-6a9a-14784a28c748@codeaurora.org>
	<20170325191648.am2z2xxn4khdhuvl@intel.com>
	<20170326171545.ls4jcn2zkqeacksy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170326171545.ls4jcn2zkqeacksy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 26, 2017 at 08:15:45PM +0300, Jarkko Sakkinen wrote:
> On Sat, Mar 25, 2017 at 09:16:48PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Mar 24, 2017 at 05:50:57PM -0500, Shanker Donthineni wrote:
> > > Hi Jiandi
> > > 
> > > 
> > > On 03/24/2017 04:22 PM, Jiandi An wrote:
> > > > On 03/24/17 12:45, Jarkko Sakkinen wrote:
> > > >> On Fri, Mar 24, 2017 at 04:55:45AM -0500, Jiandi An wrote:
> > > >>> This enables TPM Command Response Buffer interface driver for
> > > >>> ARM64 and implements an ARM specific TPM CRB start method that
> > > >>> invokes a Secure Monitor Call (SMC) to request the TrustZone
> > > >>> Firmware to execute or cancel a TPM 2.0 command.
> > > >>>
> > > >>> In ARM, TrustZone security extensions enable a secure software
> > > >>> environment with Secure Monitor mode.  A Secure Monitor Call
> > > >>> (SMC) is used to enter the Secure Monitor mode and perform a
> > > >>> Secure Monitor service to communicate with TrustZone firmware
> > > >>> which has control over the TPM hardware.
> > > >>>
> > > >>> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > > >>
> > > >> LGTM
> > > >>
> > > >> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > >>
> > > 
> > > Tested-by: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > 
> > Thank you. I'll do my own testing next week.
> > 
> > /Jarkko
> 
> The patches are in my master branch now but not yet in next because I
> haven't done run-time testing.
> 
> /Jarkko

Now also in my next branch so it should be soon available on linux-next.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
