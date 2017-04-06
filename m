From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Regression between Linux 3.16 and 4.8/4.9 on
 Lenovo X60 with coreboot
Date: Thu, 6 Apr 2017 13:10:13 -0600
Message-ID: <20170406191013.GA25011@obsidianresearch.com>
References: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
	<bf4ca184f43cc7b6ee8069b63558087c@molgen.mpg.de>
	<20170406165557.GD7657@obsidianresearch.com>
	<3d62bd7d4addc020c2f8e3c2edf3280e@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3d62bd7d4addc020c2f8e3c2edf3280e-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Paul Menzel <pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Cc: "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GNUtoo-n+LsquliYkMdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 06, 2017 at 08:26:22PM +0200, Paul Menzel wrote:
> >We added direct ACPI binding to the driver in addition to PNP, so if
> >you have an ACPI table it goes down that path and does some additional
> >validation of what is in the TPM. The BIOS must provide a
> >acpi_dev_resource_memory and a ACPI_SIG_TPM2 for the ACPI entry at a
> >minimum.
> 
> Is it correct, that this is added in/for 4.11, so just recently? Testing
> with Linux 4.10.8, everything is detected just fine.

No, it is quite a bit older.. And it should only go for TPM2, which I
don't think you have??

Maybe Jarkko has a guess, but sure sounds like something is recently
broken in 4.11

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
