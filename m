From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Merge tpm_tis ACPI and platform
	drivers
Date: Tue, 9 May 2017 02:52:19 +0300
Message-ID: <20170508235219.2zczjmnujaenw2sv@intel.com>
References: <1493913205-18276-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<20170505064520.ef542rqeirrmpmqu@rhwork>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170505064520.ef542rqeirrmpmqu@rhwork>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 04, 2017 at 11:45:20PM -0700, Jerry Snitselaar wrote:
> On Thu May 04 17, Jason Gunthorpe wrote:
> > As suggested by Jarkko.
> > 
> > The two precursor patches might want to go to -stable.
> > 
> > Jerry says it worked on his system, but we still to see results from things
> > like crb systems/etc.
> > 
> > Jason Gunthorpe (3):
> >  tpm_tis: Fix IRQ autoprobing when using platform_device
> >  tpm_tis: Use platform_get_irq
> >  tpm_tis: Consolidate the platform and acpi probe flow
> > 
> > drivers/char/tpm/tpm_tis.c | 175 +++++++++++++++------------------------------
> > 1 file changed, 57 insertions(+), 118 deletions(-)
> > 
> > -- 
> > 2.7.4
> > 
> 
> I also tested on a crb device, and verified that check_acpi_tpm2 was detecting it.
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

You tested with TPM2 chips only, right? If this is the case, I'll test
with TPM 1.2.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
