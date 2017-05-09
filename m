From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm_tis: Consolidate the platform
 and acpi probe flow
Date: Tue, 9 May 2017 17:04:25 +0300
Message-ID: <20170509140425.zr5hrxpjiytp6hpd@intel.com>
References: <1493913205-18276-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1493913205-18276-4-git-send-email-jgunthorpe@obsidianresearch.com>
	<20170508235033.qcq6my5dvpyvwrwx@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508235033.qcq6my5dvpyvwrwx-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Tue, May 09, 2017 at 02:50:33AM +0300, Jarkko Sakkinen wrote:
> On Thu, May 04, 2017 at 09:53:25AM -0600, Jason Gunthorpe wrote:
> > Now that the platform device was merged for OF support we can use the
> > platform device to match ACPI devices as well and run everything
> > through tpm_tis_init.
> > 
> > pnp_acpi_device is replaced with ACPI_COMPANION, and ACPI_HANDLE is
> > pushed further down.
> > 
> > platform_get_resource is used instead of acpi_dev_get_resources.
> > 
> > The itpm global module parameter is no longer changed during itpm
> > detection, instead the phy specific bit is set directly.
> > 
> > Tested-by: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
