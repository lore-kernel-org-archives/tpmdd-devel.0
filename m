From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] tpm_tis: Fix IRQ autoprobing when
 using platform_device
Date: Tue, 9 May 2017 17:21:39 +0300
Message-ID: <20170509142139.w265y7uv2rw65eel@intel.com>
References: <1493913205-18276-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1493913205-18276-2-git-send-email-jgunthorpe@obsidianresearch.com>
	<20170508234502.2fhj5edbcubdalb5@intel.com>
	<20170509140301.bqh3hgpjccdcbj5p@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170509140301.bqh3hgpjccdcbj5p-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 09, 2017 at 05:03:01PM +0300, Jarkko Sakkinen wrote:
> On Tue, May 09, 2017 at 02:45:02AM +0300, Jarkko Sakkinen wrote:
> > On Thu, May 04, 2017 at 09:53:23AM -0600, Jason Gunthorpe wrote:
> > > The test was backwards, triggering IRQ autoprobing if the firmware
> > > did not specify an IRQ, instead of triggering it only when the
> > > module force parameter was specified.
> > > 
> > > Since autoprobing is not enabled on !x86 and the platform device is
> > > currently only used on !x86, or with force, this has gone unnoticed.
> > > 
> > > Fixes: 00194826e6be ("tpm_tis: Clean up the force=1 module parameter")
> > > Tested-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
