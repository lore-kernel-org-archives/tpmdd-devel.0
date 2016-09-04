From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: move struct tpm_class_ops to
	drivers/char/tpm/tpm.h
Date: Sun, 4 Sep 2016 14:14:06 -0600
Message-ID: <20160904201406.GA9854@obsidianresearch.com>
References: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160902221122.GA1897@obsidianresearch.com>
	<20160902223522.GA27454@intel.com>
	<20160902224531.GC1897@obsidianresearch.com>
	<20160903062221.GA2061@intel.com> <20160903062605.GB2061@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160903062605.GB2061-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Sep 03, 2016 at 09:26:05AM +0300, Jarkko Sakkinen wrote:
> > 
> > OK, how would one get the chip instance?

Most subsystems have a get function that returns a kref'd pointer. For
TPM all we really need today is a 'get_default_tpm_for_ns' kind of
function.

> This still doesn't explain why moving the structures inside the driver
> would be wrong. Even if outside callers would use a pointer the
> structure could be opaque.

For instance, if we did a get function then the 'put' function would
be an inline around dev_put and that needs to see inside the chip.

This is a well trodden pattern in the kernel, there is no reason to do
something different for tpm.

Jason

------------------------------------------------------------------------------
