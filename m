From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
 devices.
Date: Wed, 3 May 2017 15:42:30 +0300
Message-ID: <20170503124230.gqoz3rouk3dxy5dj@intel.com>
References: <20170427182659.403-1-joshz@google.com>
	<20170428121226.7xnpfbxcjszrnz5d@intel.com>
	<20170428152748.GA32017@obsidianresearch.com>
	<20170429114013.67xwbv6xozarcieq@intel.com>
	<20170429153041.wb2tggovx2z6rjqt@rhwork>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170429153041.wb2tggovx2z6rjqt@rhwork>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Apr 29, 2017 at 08:30:41AM -0700, Jerry Snitselaar wrote:
> On Sat Apr 29 17, Jarkko Sakkinen wrote:
> > On Fri, Apr 28, 2017 at 09:27:48AM -0600, Jason Gunthorpe wrote:
> > > On Fri, Apr 28, 2017 at 03:12:26PM +0300, Jarkko Sakkinen wrote:
> > > 
> > > > I guess we have a problem in tis such that some of the devices in some
> > > > environments are not available through ACPI. There's also of_match_table
> > > > but I'm wondering if ACPI and OF would cover everything we are using
> > > > pnp_driver for.
> > > 
> > > How do you recover the acpi handle like pnp_acpi_device does from a
> > > platform_device?
> > > 
> > > If you know how to do that then we should use acpi_match_table and
> > > merge the platform and acpi devices..
> > > 
> > > Does the acpi_match_table encompass all of the pnp subsystem as well,
> > > or do we still need to have pnp_driver to handle legacy pre-acpi PNP
> > > systems?
> > > 
> > > Jason
> > 
> > AFAIK with ACPI_COMPANION as in
> > 
> > http://lxr.free-electrons.com/source/net/rfkill/rfkill-gpio.c
> > 
> > /Jarkko
> 
> What about ACPI_HANDLE like is done in thie bit of sdhci_acpi_probe()?
> 
>  static int sdhci_acpi_probe(struct platform_device *pdev)
>  {
>          struct device *dev = &pdev->dev;
>          acpi_handle handle = ACPI_HANDLE(dev);

Yes. That can be used for getting the handle. ACPI_HANDLE just wraps
ACPI_COMPANION in a way that it extracts the handle from struct
acpi_device.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
