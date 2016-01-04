From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 1/7] tpm_crb: Use the common ACPI
 definition of struct acpi_tpm2
Date: Mon, 4 Jan 2016 20:49:17 +0200
Message-ID: <20160104184917.GB16334@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-2-git-send-email-jgunthorpe@obsidianresearch.com>
	<20160103170906.GA4155@intel.com>
	<20160104182317.GB20016@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160104182317.GB20016-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Martin Wilck <Martin.Wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 04, 2016 at 11:23:17AM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 03, 2016 at 07:09:06PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Dec 17, 2015 at 11:23:14AM -0700, Jason Gunthorpe wrote:
> > > include/acpi/actbl2.h is the proper place for these definitions
> > > and the needed TPM2 ones have been there since
> > > commit 413d4a6defe0 ("ACPICA: Update TPM2 ACPI table")
> > > 
> > > This also drops a couple of le32_to_cpu's for members of this table,
> > > the existing swapping was not done consistently, and the definitions
> > > in actbl2.h do not have endianness annotations, declaring that no swap
> > > is required. Note that the TPM ACPI spec defines all of these
> > > values to be little endian, both in crb2 and ppi.
> > 
> > I think this patch mixes two separate changes to the driver: removing
> > l32_to_cpu's and moving to common headers and that is not right.
> 
> No, it is only one change: Move to the common kernel way of working
> with these structures.

I'm now cool with this.

> > Even if they should be removed I think what you say about actbl2.h is
> > wrong. Annotations are probably missing because it is imported code (I'm
> > happy to be corrected if this is not the case).
> 
> Edit the comments if you like.
> 
> Annotations are missing because BE is not supported at all, nothing to
> do with imported code.

The code change is OK but the argumentation in the commit messsage is
bogus.

ACPICA will probably do the conversions internally when moved to BE
architecture as I now remember we discussed in December. That's the
only right argument to rip off le32_to_cpu()'s.

Missing annotations are not related of BE support being missing or not.
ACPICA cannot use Linux annotations in it APIs because it is imported
code but can use in the Linux driver for it (drivers/acpi) for
internals.

> Jason

/Jarkko

------------------------------------------------------------------------------
