From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 3/9] tpm: replace dynamically allocated
 bios_dir with a static array
Date: Fri, 25 Nov 2016 10:08:38 +0200
Message-ID: <20161125080838.mpzflnz7epo6wv6g@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479117656-12403-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161122112333.7ootyrbssd6pkrjb@intel.com>
	<20161122165856.GD3956@obsidianresearch.com>
	<20161124135723.kfafipftppjyr5ip@intel.com>
	<20161124165313.GB4930@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161124165313.GB4930-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 24, 2016 at 09:53:13AM -0700, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2016 at 03:57:23PM +0200, Jarkko Sakkinen wrote:
> > I manually added the changes to:
> > 
> >   tpm: replace dynamically allocated bios_dir with a static array
> 
> For this patch..
> 
> Could drop 'int rc' from tpm1_chip_register, but it will come back in
> a later patch
> 
> Could dump TPM_NUM_EVENT_LOG_FILES and just use
> ARRAY_SIZE(chip->bios_dir)

Not a bug fix. Happy take a patch after the pull request.

> Now the the stub for tpm_bios_log_setup can properly return -ENODEV
> 
> This is no good at this point in the series - we need the ENODEV
> detection in tpm_chip_register() from the 'Fix handle of missing event
> log' moved into this patch, because it now returns ENODEV due to
> sercurityfs

Sure it would be cleaner but not really necessary. Do you really think
this is mandatory? No matter how I reorder patches this will require
time and effort to fix various merge conflicts because of the replacemnt
of event log. After that I have to test everything.

Not doing this for light reasons...

> The commit 'tpm: vtpm_proxy: Do not access host's event log' still
> needs a proper commit message - it doesn't match what the patch is
> doing at all.

The commit message otherwise great except for the short summary, which
is now fixed.

> If you are going to be editing the patches I'd suggest squashing all
> the bug fix ones with proper credit so it at least makes sense to
> read..
> 
> Jason

I do not have interest to edit patches more than I have to.

/Jarkko

------------------------------------------------------------------------------
