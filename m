From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 6/7] tpm: expose spaces via a device
	link /dev/tpms<n>
Date: Fri, 24 Feb 2017 08:02:08 -0500
Message-ID: <1487941328.2249.23.camel@HansenPartnership.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-7-jarkko.sakkinen@linux.intel.com>
	<20170223090917.jq7thil5ggjmagil@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170223090917.jq7thil5ggjmagil-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-02-23 at 11:09 +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 16, 2017 at 09:25:19PM +0200, Jarkko Sakkinen wrote:
> > From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
> > 
> > Currently the tpm spaces are not exposed to userspace.  Make this
> > exposure via a separate device, which can now be opened multiple 
> > times because each read/write transaction goes separately via the
> > space.
> > 
> > Concurrency is protected by the chip->tpm_mutex for each read/write
> > transaction separately.  The TPM is cleared of all transient 
> > objects by the time the mutex is dropped, so there should be no
> > interference between the kernel and userspace.
> > Signed-off-by: James Bottomley <
> > 
> > James.Bottomley-d9PhHud1Jfhevp4ocFNHEFaTQe2KTcn/@public.gmane.org>

> Reviewed-by: Jarkko Sakkinen <jarkko.sakkine-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Tested-by: Jarkko Sakkinen <jarkko.sakkine-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Thanks!

> Nitpicking but I've been thinking about naming. What about calling 
> the device as tpmrc0 as in resource context. I think that would be a
> better name than TPM space.

Well the original name was tpmrm<n> for TPM with Resource Manager.  You
wanted it to be tpms<n> for TPM with Spaces.

I'm not entirely sold on the Resource Context name ... I think Resource Manager (because it's what the TCG calls it) or Spaces (because it's what all the code comments call it) are better.  Resource Context sounds like what TPM2_SaveContext() creates for you rather than the interface.

>  You do not mix it up with namespaces and/or virtualization. With
> resource in front it cannot be easily mixed up with TPM contexts
> either.

I'm a containers person.  What this set of patches does is precisely OS
level virtualization in my book, so I don't think you need to pretend
it is't; and OS level virtualization is what a namespace does.  The
only difference between this and the other kernel namespaces is that
you get a new namespace automatically when you open the device and you
can't enter an existing namespace.

I think therefore that tpmns<n> for TPM Namespace would be very
appropriate.

> This does not require any effort from your side. I could do the
> renaming.
>
> PS. Could you go through my commits and test and review them at some
> point so we would have the whole patch set peer tested?

Already reviewed, just doing a test build (I'm travelling, so it
actually has to be on my physical laptop).

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
