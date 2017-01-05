From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 5 Jan 2017 16:50:46 -0700
Message-ID: <20170105235046.GA4670@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
	<20170105192025.GB12587@obsidianresearch.com>
	<1483646149.2515.83.camel@linux.vnet.ibm.com>
	<20170105222118.GC31047@obsidianresearch.com>
	<1483657126.2515.107.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483657126.2515.107.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 05, 2017 at 02:58:46PM -0800, James Bottomley wrote:
> On Thu, 2017-01-05 at 15:21 -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 05, 2017 at 11:55:49AM -0800, James Bottomley wrote:
> > 
> > > We don't really have that choice: Keys require authorization, so 
> > > you have to have an auth session.
> > 
> > I know, this is why I suggested a combo op (kernel level atomicity
> > is clearly DOS safe)..
> 
> Transactions are a hard thing to guarantee to be DoS safe and the more
> complex they get, the more difficult they are to police within the
> kernel.  Plus we have to keep the R/W interface for backwards
> compatibility now that we have it and I just don't see how we could
> layer transactions into it without having some sort of in-kernel
> emulator.

Again, this was only to make the unpriv FD usable and safe against
session DOS and that FD wouldn't use the legacy r/w interface. I don't
care if root can DOS the TPM via /dev/tpm0. combo ops would need to be
simple enough to reason about. (in my TPM libaries API calls are
combo'd with session anyhow, and that works quite well for my use
models)

> > Lets stick with the user space broker process and just introduce
> > enough kernel RM to enable co-existance with kernel users and clean
> > -up on crash. This should be enough to make a user space broker much
> > simpler.
> 
> I wouldn't go that far.  I'm still planning a userspace tss2 without
> any access broker daemon, but let's see how far I get on top of the RM.
>  I think building in stages is a good way to get actual use experience
> to guide the next stage.

I'm sure you can implement what you are doing on top of the RM -
that isn't a question in my mind.

My question has always been how does your plugin deliver messages to
the kernel RM in a way that does not compromise the security of the
TPM system.

> > So Jarkko's uapi is basically fine.. No need for a kernel white
> > list/etc
> 
> I suspect we'll eventually get to needing one, but I'm happy to
> begin

IMHO the problem with trousers as a broker is just how horribly
complex it was.

With the kernel RM this problem becomes very simple:

 - 1:1 relationship between incoming clients and kernel fds (Jarkko's
   existing design allows a broker to safely create many RM fds)
 - Trivial inspection of messages to determine op and check whitelist
   (just the first couple bytes give you the opcode, easy to deep
    inspect things like get capability)
 - No marshal/demarshal, no virtualization, no crypto.
   (kernel does virtualization, client does marshal and crypto)
   
I'm not sure what reason would be big enough to put it in the kernel
when we seem to have irreconcilable use models for the security policy
it needs to implement...

Maybe that is OK, but it isn't what I was hoping for at the start :)

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
