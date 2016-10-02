From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Sun, 2 Oct 2016 15:21:26 -0600
Message-ID: <20161002212126.GA25872@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
	<20161002101755.GA25844@intel.com>
	<20161002102455.GA27464@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161002102455.GA27464-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 02, 2016 at 01:24:55PM +0300, Jarkko Sakkinen wrote:
> On Sun, Oct 02, 2016 at 01:17:55PM +0300, Jarkko Sakkinen wrote:
> > On Sun, Oct 02, 2016 at 10:39:31AM +0300, Tomas Winkler wrote:
> > > In tpm_del_char_device device_del is called
> > > prior to tpm2_shutdown where it is still used.
> > > 
> > > Fortunately, so far chip->dev was used only for printouts
> > > int tpm2_shutdown flow, hence system didn't crash. But with
> > > the introduction of runtime power management it will result in
> > > shutting down the parent device while it still in use.
> > > 
> > > Fixes: 20e0152393b41 ("tpm: fix crash in tpm_tis deinitialization")
> > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Applied.

This patch is wrong, I though the comments were clear. All entry
points to find the device must be deleted before we commit to shutting
down the device.

You need to figure out some other way to solve your problem.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
