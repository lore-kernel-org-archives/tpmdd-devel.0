From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] tpm_crb: request and relinquish
	locality 0
Date: Mon, 13 Mar 2017 14:43:14 -0600
Message-ID: <20170313204314.GB3390@obsidianresearch.com>
References: <20170311130216.21419-1-jarkko.sakkinen@linux.intel.com>
	<20170313163452.GD22997@obsidianresearch.com>
	<20170313201235.tvcyugdh7awqfrfq@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170313201235.tvcyugdh7awqfrfq-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 13, 2017 at 10:12:35PM +0200, Jarkko Sakkinen wrote:
> > I think you should also put a relinquish_locality inside tpm_remove ?
> 
> Right. I was wondering why release_locality is called inside
> tpm_tis_remove().

I also wonder that.. It sort of makes send to idle the TPM, but it is
kinda goofy to have paired function calls that are not ultimately
paried.

> So is the idea of checking pendingRequest such that the release
> part is "lazy" and not like what I'm doing in tpm_crb (always
> relinquish).
>
> Is that done for performance reasons? Should I do the same (pr
> similar in tpm_crb?

No idea, sorry. This stuff is so old and locality has never been an
exposed API by the kernel, AFAIK. Wouldn't surprise me at all if it
doesn't work right.

But.. If you don't need 'force' for CRB, I suggest that we drop the
'force' from the public API. TIS can do its special !force behavior in
its own remove as it does today.

However.. if we want to do some kind of locality caching for
performance then I think the core code should do it, not the
individual drivers.

Why do we need to reliquish the locality on every command anyhow? Does
the firmware interact with this?

Why are you adding locality to crb without a user anyhow?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
