From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_tis: Issue a TPM2_Shutdown for TPM2
	devices.
Date: Thu, 27 Apr 2017 14:49:12 -0600
Message-ID: <20170427204912.GA26330@obsidianresearch.com>
References: <20170427182659.403-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170427182659.403-1-joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 27, 2017 at 11:26:59AM -0700, Josh Zimmerman wrote:
> If a TPM2 loses power without a TPM2_Shutdown command being issued, it
> may lose some state that has yet to be persisted to NVRam, and will
> increment the DA counter (meaning that after too many disorderly
> reboots, the TPM will lock the user out).
> 
> This is a variant of https://patchwork.kernel.org/patch/9516631/.

This has all the same problems of that patch, just now adds the code
to tis driver as well..

There is not much reason to accept this and reject the above patch.

> It differs in that:
>   * It only changes behavior on TPM2 devices, to avoid invoking the
>   unbounded-waiting sysfs codepath that was discussed on that patch.

Hum. If that is a sensible work around for now then lets just do that
at the core code level please.

If you do this, then tpm_sysfs_add_device really needs a comment
warning that tpm2 can not have sysfs until the problems are fixed with
shutdown.

>   * It modifies tpm_tis rather than tpm_i2c_infineon, so that it can
>   change behavior for all TPM2 devices.

There are many drivers that support TPM2 beyond tpm_tis, this just
fixes a few tis drivers, re-enforcing my point in the original patch
that this stuff has no buisness being in the low level drivers and
should be in core code.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
