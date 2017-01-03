From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 20:40:08 +0200
Message-ID: <20170103184008.l3qcnnqxl3kfu53n@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <1483374980.2458.13.camel@HansenPartnership.com>
 <20170102193320.trawto65nkjccbao@intel.com>
 <1483393248.2458.32.camel@HansenPartnership.com>
 <20170103135121.4kh3jld5gaq3ptj4@intel.com>
 <1483461370.2464.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483461370.2464.19.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 08:36:10AM -0800, James Bottomley wrote:
> On Tue, 2017-01-03 at 15:51 +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 02, 2017 at 01:40:48PM -0800, James Bottomley wrote:
> > > On Mon, 2017-01-02 at 21:33 +0200, Jarkko Sakkinen wrote:
> > > > On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > > > > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > > > > This patch set adds support for TPM spaces that provide a 
> > > > > > context for isolating and swapping transient objects. This 
> > > > > > patch set does not yet include support for isolating policy 
> > > > > > and HMAC sessions but it is trivial to add once the basic 
> > > > > > approach is settled (and that's why I created an RFC patch
> > > > > > set).
> > > > > 
> > > > > The approach looks fine to me.  The only basic query I have is 
> > > > > about the default: shouldn't it be with resource manager on 
> > > > > rather than off?  I can't really think of a use case that wants 
> > > > > the RM off (even if you're running your own, having another 
> > > > > doesn't hurt anything, and it's still required to share with in
> > > > > -kernel uses).
> > > > 
> > > > This is a valid question and here's a longish explanation.
> > > > 
> > > > In TPM2_GetCapability and maybe couple of other commands you can 
> > > > get handles in the response body. I do not want to have special 
> > > > cases in the kernel for response bodies because there is no a 
> > > > generic way to do the substitution. What's worse, new commands in 
> > > > the standard future revisions could have such commands requiring 
> > > > special cases. In addition, vendor specific commans could have 
> > > > handles in the response bodies.
> > > 
> > > OK, in general I buy this ... what you're effectively saying is 
> > > that we need a non-RM interface for certain management type
> > > commands.
> > 
> > Not only that.
> > 
> > Doing virtualization for commands like GetCapability is just a better
> > fit for doing in the user space. You could have a thin translation 
> > layer in your TSS library for example to handle these specific
> > messages.
> 
> Yes, we could do it that way too.  To be honest I can't see much use
> for getting the transient handles and all the other handles you'd be
> interested in aren't virtualized.
> 
> > > However, let me expand a bit on why I'm fretting about the non-RM 
> > > use case.  Right at the moment, we have a single TPM device which 
> > > you use for access to the kernel TPM.  The current tss2 just makes 
> > > direct use of this, meaning it has to have 0666 permissions.  This 
> > > means that any local user can simply DoS the TPM by running us out 
> > > of transient resources if they don't activate the RM.  If they get 
> > > a connection always via the RM, this isn't a worry.  Perhaps the 
> > > best way of fixing this is to expose two separate device nodes: one 
> > > raw to the TPM which we could keep at 0600 and one with an always 
> > > RM connection which we can set to 0666.  That would mean that 
> > > access to the non-RM connection is either root only or governed by
> > > a system set ACL.
> > 
> > I'm not sure about this. Why you couldn't have a very thin daemon 
> > that prepares the file descriptor and sends it through UDS socket to 
> > a client.
> 
> So I'm a bit soured on daemons from the trousers experience: tcsd
> crashed regularly and when it did it took all the TPM connections down
> irrecoverably.  I'm not saying we can't write a stateless daemon to fix
> most of the trousers issues, but I think it's valuable first to ask the
> question, "can we manage without a daemon at all?"  I actually think
> the answer is "yes", so I'm interested in seeing how far that line of
> research gets us.

This was not a good argument in the first place because you could also
use daemon with tpms0. We can ignore this.

> >   The non-RFC version will also have whitelisting ioctl for
> > further restricting the file descriptor to only specific TPM
> > commands.
> > 
> > This is also architecture I preseted in my LSS presentation and I 
> > think it makes sense especially when I add the whitelisting to the
> > pack.
> 
> Do you have a link to the presentation?  The Plumbers etherpad doesn't
> contain it.  I've been trying to work out whether a properly set up TPM
> actually does need any protections at all.  As far as I can tell, once
> you've set all the hierarchy authorities and the lockout one, you're
> pretty well protected.

http://events.linuxfoundation.org/sites/events/files/slides/201608-LinuxSecuritySummit-TPM.pdf

> > > James
> > 
> > I'm more dilated to keep things way they are now. I'll stick to that 
> > at least with the first non-RFC version and hopefully get the tpm2
> > -space.c part reviewed as I split that stuff to a separate commit.
> 
> Sure, we need the patch in an acceptable form first.  I'll keep
> worrying about the systems implications, but I can layer playing with
> those on top of what you do.
> 
> James

/Jarkko
