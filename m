From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 05 Jan 2017 16:36:42 -0800
Message-ID: <1483663002.2515.134.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
         <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
         <20170105172726.GA11680@obsidianresearch.com>
         <1483641223.2515.62.camel@linux.vnet.ibm.com>
         <20170105192025.GB12587@obsidianresearch.com>
         <1483646149.2515.83.camel@linux.vnet.ibm.com>
         <20170105222118.GC31047@obsidianresearch.com>
         <1483657126.2515.107.camel@linux.vnet.ibm.com>
         <20170105235046.GA4670@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170105235046.GA4670@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-05 at 16:50 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 02:58:46PM -0800, James Bottomley wrote:
> > On Thu, 2017-01-05 at 15:21 -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 05, 2017 at 11:55:49AM -0800, James Bottomley wrote:
> > > 
> > > > We don't really have that choice: Keys require authorization, 
> > > > so you have to have an auth session.
> > > 
> > > I know, this is why I suggested a combo op (kernel level 
> > > atomicity is clearly DOS safe)..
> > 
> > Transactions are a hard thing to guarantee to be DoS safe and the 
> > more complex they get, the more difficult they are to police within 
> > the kernel.  Plus we have to keep the R/W interface for backwards
> > compatibility now that we have it and I just don't see how we could
> > layer transactions into it without having some sort of in-kernel
> > emulator.
> 
> Again, this was only to make the unpriv FD usable and safe against
> session DOS and that FD wouldn't use the legacy r/w interface. I 
> don't care if root can DOS the TPM via /dev/tpm0. combo ops would 
> need to be simple enough to reason about. (in my TPM libaries API 
> calls are combo'd with session anyhow, and that works quite well for 
> my use models)

In Ken's TSS2 they are for simple authorisation.  However, policy auth
is where it gets tricky and right at the moment I believe I need policy
based authorisation for keys.

> > > Lets stick with the user space broker process and just introduce
> > > enough kernel RM to enable co-existance with kernel users and 
> > > clean -up on crash. This should be enough to make a user space 
> > > broker much simpler.
> > 
> > I wouldn't go that far.  I'm still planning a userspace tss2 
> > without any access broker daemon, but let's see how far I get on 
> > top of the RM.  I think building in stages is a good way to get 
> > actual use experience to guide the next stage.
> 
> I'm sure you can implement what you are doing on top of the RM -
> that isn't a question in my mind.
> 
> My question has always been how does your plugin deliver messages to
> the kernel RM in a way that does not compromise the security of the
> TPM system.

So currently, it doesn't: I have to either run as root or run a udev
script to give me access to the device, neither of which will work out
of the box for distributions because of the security risks you
identified.  I think this is OK for now because the security issue only
has to be sorted out before we make this ready for general release
(i.e. advise the distros how to expose the TPM) and we need to gather
use case data before we do that.

> > > So Jarkko's uapi is basically fine.. No need for a kernel white
> > > list/etc
> > 
> > I suspect we'll eventually get to needing one, but I'm happy to
> > begin
> 
> IMHO the problem with trousers as a broker is just how horribly
> complex it was.
> 
> With the kernel RM this problem becomes very simple:
> 
>  - 1:1 relationship between incoming clients and kernel fds (Jarkko's
>    existing design allows a broker to safely create many RM fds)
>  - Trivial inspection of messages to determine op and check whitelist
>    (just the first couple bytes give you the opcode, easy to deep
>     inspect things like get capability)
>  - No marshal/demarshal, no virtualization, no crypto.
>    (kernel does virtualization, client does marshal and crypto)
>    
> I'm not sure what reason would be big enough to put it in the kernel
> when we seem to have irreconcilable use models for the security 
> policy it needs to implement...
> 
> Maybe that is OK, but it isn't what I was hoping for at the start :)

I actually think this is OK for now.  I have theories about how I'm
going to use policy in TPM keys but I haven't written any code yet. 
 The only actual code I have is the openssl and gnome-keyring patches I
posted to make use of password authorized TPM based RSA keys.

I'd really rather not say what is and isn't safe to blacklist until I
have some use experience of policy based keys: I'm going to continue
working on them (although it looks like a hard problem because we need
to standardise an ASN.1 form of key policy as well) so hopefully I can
acquire the necessary experience over the next few weeks.

I'm seriously pissed of with trousers and will port the trousers based
TPM1.2 RSA key patches I've done to whatever direct connect API you
come up with (just send me a link to the git tree or package or
whatever), so this should generate some use experience for 1.2, like
whether we actually need a RM without trousers and also what the safety
issues might be.  My main laptop is now TPM2, but I have a backup one
that's TPM1.2 and also has all the TPM key stuff as well.

Perhaps our models in practice may turn out not to be as diverse as
they appear in theory, so let's try it out.  This way we can build on
actual use experience for extending the API (and in the mean time we
keep the devices root only like they were previously)

James

