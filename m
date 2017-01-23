From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v4 4/5] tpm: split out tpm-dev.c into
 tpm-dev.c and tpm-common-dev.c
Date: Mon, 23 Jan 2017 16:30:28 -0700
Message-ID: <20170123233028.GA24370@obsidianresearch.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
 <20170122234438.12102-5-jarkko.sakkinen@linux.intel.com>
 <20170123164754.GA29360@obsidianresearch.com>
 <1485210503.2534.32.camel@HansenPartnership.com>
 <20170123224952.GA21744@obsidianresearch.com>
 <1485212231.2534.35.camel@HansenPartnership.com>
 <20170123230433.GC21744@obsidianresearch.com>
 <1485213612.2534.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485213612.2534.45.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 03:20:12PM -0800, James Bottomley wrote:

> > So you are saying there is so much already deployed TPM2 software 
> > that has this TPM_DEVICE env var convention that we need to support 
> > it with compat?
> > 
> > I'm really surprised by that.. But OK.
> > 
> > Can you at least remove the 'user_read_timer' junk from the new cdev?
> 
> What's the problem with it?  Can we not just fix whatever the issue is?

The issue is that it exists at all.

I've been unwilling to remove it because some crazy userspace might
rely on it, but I really don't want to see it continue in any new
stuff.

If you know the existing TPM1 userspace is safe then lets just delete
it entirely. Otherwise lets be sure no new users crop up by disabling
it.

> I'd rather reuse all the R/W machinery as is.  If I start trying to
> special case it so that we only use some parts on some control flows,
> the chances are I'll introduce additional bugs as well.

Sure, this is part of the pain of compat..

Jason
