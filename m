From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Fri, 6 Jan 2017 12:10:49 -0700
Message-ID: <20170106191049.GA19576@obsidianresearch.com>
References: <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
	<20170105192025.GB12587@obsidianresearch.com>
	<1483646149.2515.83.camel@linux.vnet.ibm.com>
	<20170105222118.GC31047@obsidianresearch.com>
	<1483657126.2515.107.camel@linux.vnet.ibm.com>
	<20170105235046.GA4670@obsidianresearch.com>
	<1483663002.2515.134.camel@linux.vnet.ibm.com>
	<f5c8f4a2-d4ad-a2a0-9443-26589c58f9a7@sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f5c8f4a2-d4ad-a2a0-9443-26589c58f9a7-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andreas Fuchs <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 06, 2017 at 09:59:57AM +0100, Andreas Fuchs wrote:

> 1. PolicyPCR is an essential feature of TPM used all over the place,
> so we need support for policy sessions.
> 2. PolicySigned allows authentication of the user via SmartCard.

Are smart cards 0666 in linux?

> The all-defeating reason for having in-kernel-RM is trusted keyrings
> or IMA/EVM appraise/protect or similar. They will want to use sealing
> to PCRs which in turn requires policy sessions from inside the kernel
> and thus RM inside the kernel to play nicely with the TSS.

Yes. I had hoped the in-kernel-RM could also provide safe 0666 access,
but lets move on from that idea and focus on kernel/user TPM
application co-existence...

> And IMHO nobody wants the kernel security modules to call back to a
> userspace RM-daemon.

Yep.

> If everyone agrees with this presumption the only question becomes
> how to do this, such that we don't need a second RM in userspace
> for the 99% of use cases.

Yep.

> P.S. This fact should also be given some thought when discussing the
> priviledged 0600 node, i.e. /dev/tpm0 without the s in the middle.

We are stuck with the non-RM interface for compat. There could be a
kernel option/module option/sysctl/whatever of some kind to disable it
I guess.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
