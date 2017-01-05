From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 05 Jan 2017 14:58:46 -0800
Message-ID: <1483657126.2515.107.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
	<20170105192025.GB12587@obsidianresearch.com>
	<1483646149.2515.83.camel@linux.vnet.ibm.com>
	<20170105222118.GC31047@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170105222118.GC31047-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-05 at 15:21 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 11:55:49AM -0800, James Bottomley wrote:
> 
> > We don't really have that choice: Keys require authorization, so 
> > you have to have an auth session.
> 
> I know, this is why I suggested a combo op (kernel level atomicity
> is clearly DOS safe)..

Transactions are a hard thing to guarantee to be DoS safe and the more
complex they get, the more difficult they are to police within the
kernel.  Plus we have to keep the R/W interface for backwards
compatibility now that we have it and I just don't see how we could
layer transactions into it without having some sort of in-kernel
emulator.

> > If you want things like PCR sealed or time limited keys, you don't
> > really have a choice on policy sessions either.
> 
> .. and advanced stuff like is what I was talking about giving up for
> unpriv if it can't be allowed safely ...
> 
> > I think we've got to the point where arguing about our divergent 
> > use requirements shows the default should be 0600 and every command
> > enabled so that whatever changes the device to 0666 also applies 
> > the command
> 
> Well, that is what we already have with /dev/tpm0.

Except that doesn't have the RM.

> I'm very surprised by this level of disagreement, so I'm inclined to
> drop the idea that the kernel can directly support a 0666 cdev at
> all.

Great.  We'll keep it at 0600 and let userspace sort it out; that way
policy becomes flexible too.

> Lets stick with the user space broker process and just introduce
> enough kernel RM to enable co-existance with kernel users and clean
> -up on crash. This should be enough to make a user space broker much
> simpler.

I wouldn't go that far.  I'm still planning a userspace tss2 without
any access broker daemon, but let's see how far I get on top of the RM.
 I think building in stages is a good way to get actual use experience
to guide the next stage.

> So Jarkko's uapi is basically fine.. No need for a kernel white
> list/etc

I suspect we'll eventually get to needing one, but I'm happy to begin
without and see what that experience tells us before we try to build
it.  This is actually a better way of doing stuff because we can add to
an API based on what we find in the field; the hard thing is pulling
back an API that doesn't work.

> I had really hoped we could have a secure default 0666 cdev that
> would be able to support the basic use of your user space plugins
> without a daemon :(

I think we can; I just don't think we can define a single in-kernel use
policy that supports everyone's use case, so punting to userspace and
letting it sort out the desired policy for the platform will work for
everyone.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
