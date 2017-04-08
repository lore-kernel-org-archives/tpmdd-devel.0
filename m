From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Regression between Linux 3.16 and 4.8/4.9 on
 Lenovo X60 with coreboot
Date: Sat, 8 Apr 2017 14:25:09 -0600
Message-ID: <20170408202509.GA26119@obsidianresearch.com>
References: <c4bfd77e-3fb9-8a9b-28f5-48e6c13beb12@maciej.szmigiero.name>
	<bf4ca184f43cc7b6ee8069b63558087c@molgen.mpg.de>
	<20170406165557.GD7657@obsidianresearch.com>
	<20170408123651.76f18ba4@second-laptop.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170408123651.76f18ba4-r3nPC/fXJJgy06l1zSILBM/Rnsmy/zvw/z7RTEddyNg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Denis 'GNUtoo' Carikli <GNUtoo-n+LsquliYkMdnm+yROfE0A@public.gmane.org>
Cc: Paul Menzel <pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>, "Maciej S. Szmigiero" <mail-APzI5cXaD1zVlRWJc41N0YvC60bnQu0Y@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Apr 08, 2017 at 12:40:25PM +0200, Denis 'GNUtoo' Carikli wrote:

> I am working on it[1]. This commit has not been merged and is a work in
> progress. It is however available in coreboot's gerrit.

How did this work on any kernels if there was no PNP or ACPI entry?

FWIW, I wonder if coreboot is missing the code for wait_startup
in drivers/char/tpm/tpm_tis_core.c. If you don't do that step then
the DID/VID might not read properly.

> So far with it and a recent kernel and the patch mentioned above:
> - The linux driver finds the TPM automatically and doesn't require
>   force=1
> - The driver however still require itpm=1 to fully work: without it the
>   tpm is found, but I wasn't able to read the PCRs.

Unless it is an actual broken intel TPM you should never use
itpm=1. Juding by the log messages, it certainly is not.

Intel mode breaks the driver and removes certain error detection, eg
it may erronously succeed.

It is more likely that the failure to read PCRs reflects reality and
itpm=1 just supresses that error detection.

The TPM may need to be setup (eg cleared, EK generated, p/vflags setup
etc, etc) before it will support PCRs.

Usually the BIOS would do these steps when the TPM is first enabled,
you probably need to do them in userspace instead.

WARNING: Failure to provision the TPM properly before first use
could leave it in 'factory test' mode, which basically means it
doesn't work properly at all.

> - I want to make it work without itpm=1 if possible. I'll test with
>   INTC0102 as it is in the driver in the is_itpm function, and it was
>   also suggested to me by someone on IRC.

Don't do this unless it is actually that TPM.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
