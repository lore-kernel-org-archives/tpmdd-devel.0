From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/4] Small fixes and cleanups for tpm_crb
Date: Thu, 8 Sep 2016 14:35:41 +0300
Message-ID: <20160908113541.GA9684@intel.com>
References: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160908102759.GA4712@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160908102759.GA4712-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 08, 2016 at 01:27:59PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2016 at 10:34:16PM +0300, Jarkko Sakkinen wrote:
> > A set of small fixes and clean ups for tpm_crb.
> 
> I will apply these fixes tomorrow because they are no brainers
> basically. Tomas, I guess you can gives these tested-by since
> you've tested runtime PM code on top of these?

I've applied these to my master branch.

/Jarkko

> > Jarkko Sakkinen (4):
> >   tpm_crb: fix crb_req_canceled behavior
> >   tpm_crb: remove wmb()'s
> >   tpm_crb: refine the naming of constants
> >   tpm_crb: fix incorrect values of cmdReady and goIdle bits
> > 
> >  drivers/char/tpm/tpm_crb.c | 32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> > 
> > -- 
> > 2.7.4
> 
> /Jarkko

------------------------------------------------------------------------------
