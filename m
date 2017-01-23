From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC v4 4/5] tpm: split out tpm-dev.c into
 tpm-dev.c and tpm-common-dev.c
Date: Mon, 23 Jan 2017 15:45:58 -0800
Message-ID: <1485215158.2534.53.camel@HansenPartnership.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
	<20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
	<20170123164754.GA29360@obsidianresearch.com>
	<1485210503.2534.32.camel@HansenPartnership.com>
	<20170123224952.GA21744@obsidianresearch.com>
	<1485212231.2534.35.camel@HansenPartnership.com>
	<20170123230433.GC21744@obsidianresearch.com>
	<1485213612.2534.45.camel@HansenPartnership.com>
	<20170123233028.GA24370@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170123233028.GA24370-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-23 at 16:30 -0700, Jason Gunthorpe wrote:
> On Mon, Jan 23, 2017 at 03:20:12PM -0800, James Bottomley wrote:
> 
> > > So you are saying there is so much already deployed TPM2 software
> > > that has this TPM_DEVICE env var convention that we need to 
> > > support it with compat?
> > > 
> > > I'm really surprised by that.. But OK.
> > > 
> > > Can you at least remove the 'user_read_timer' junk from the new
> > > cdev?
> > 
> > What's the problem with it?  Can we not just fix whatever the issue
> > is?
> 
> The issue is that it exists at all.
> 
> I've been unwilling to remove it because some crazy userspace might
> rely on it, but I really don't want to see it continue in any new
> stuff.

All it does is clear the pending read after 60s ... like you, I suspect
it could just be removed but I don't think having it present causes
problems.

> If you know the existing TPM1 userspace is safe then lets just delete
> it entirely. Otherwise lets be sure no new users crop up by disabling
> it.
> 
> > I'd rather reuse all the R/W machinery as is.  If I start trying to
> > special case it so that we only use some parts on some control 
> > flows, the chances are I'll introduce additional bugs as well.
> 
> Sure, this is part of the pain of compat..

Except for the added complexity and possibility of extra bugs, nothing
is gained by the special casing.  That tells me we should either remove
this interface behaviour globally or not at all.  Removing it globally
would be independent of the space patches, because they'd simply
inherit whatever was done.

Why don't you start by doubling the timeout?  If nothing notices,
chances are nothing relies on this aspect of the interface and it can
be easily removed.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
