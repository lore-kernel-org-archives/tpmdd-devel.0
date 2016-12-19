From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: Handle 64-bit resource in crb_check_resource()
Date: Mon, 19 Dec 2016 09:22:01 -0700
Message-ID: <20161219162201.GA10988@obsidianresearch.com>
References: <1482121253-924-1-git-send-email-anjiandi@codeaurora.org>
	<20161219135624.2e7okpswnbqbvic7@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161219135624.2e7okpswnbqbvic7-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Dec 19, 2016 at 03:56:24PM +0200, Jarkko Sakkinen wrote:
> On Sun, Dec 18, 2016 at 10:20:53PM -0600, Jiandi An wrote:
> > crb_check_resource() in TPM CRB driver calls
> > acpi_dev_resource_memory() which only handles 32-bit resources.
> > Adding a call to acpi_dev_resource_address_space() in TPM CRB
> > driver which handles 64-bit resources.
> > 
> > Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> 1. Is there a platform in existence where this change fixes a problem?
> 2. What is difference between "memory" and "address space" conceptually?
>    Just wondering why 32-bit stuff is "memory" and 64-bit stuff is
>    "address space". Could there be a one function that would work both
>    for 32-bit and 64-bit cases?
>    
> Yeah, I do not know this API too well. That's why I'm asking.

If this is the right thing it also needs to be done in tpm_tis.

I will point out that this driver only works with memory, so using a
generic decoder without checking for IO maps may not be correct..

Jason

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today.http://sdm.link/intel
