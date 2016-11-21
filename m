From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after
	tpm_bios_log_setup
Date: Mon, 21 Nov 2016 10:55:20 -0700
Message-ID: <20161121175520.GA24191@obsidianresearch.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161118155249.sdxp2qfjfzfw4tzt@intel.com>
	<20161119182228.GA22775@obsidianresearch.com>
	<20161120121451.awcraondhcvzpbig@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161120121451.awcraondhcvzpbig-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Nov 20, 2016 at 12:14:51PM +0000, Jarkko Sakkinen wrote:
> I was able to apply the patch after manually editing the mbox file.
> Not nice. It'd be better to send these things with git-send-email
> to simplify the mgmt (like getting them into patchwork for starters)
> especially in a situation that is bit chaotic to begin with :-/

It is in patchwork just fine:

https://patchwork.kernel.org/patch/9438323/

git am is unfortunately much more limited than patchwork, but you can
apply right out of patchwork.

You forgot to add your signed-off-by though.

And this one fixes the sysfs problem

https://patchwork.kernel.org/patch/9438331/

Here is a commit message:

tpm: Do not call tpm_chip_unregister if register has not succeeded

This is no longer allowed, vtpm was relying on the check inside the
tpm core which was removed. Fixes an oops during error unwind.

Fixes: a8ed92219a04 ("tpm: Get rid of TPM_CHIP_FLAG_REGISTERED")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

That just leaves the ACPI thing..

Jason

------------------------------------------------------------------------------
