From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 15:00:46 +0200
Message-ID: <20170104130046.u5isqy3z2nptdpgk@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <1483374980.2458.13.camel@HansenPartnership.com>
 <20170102193320.trawto65nkjccbao@intel.com>
 <1483393248.2458.32.camel@HansenPartnership.com>
 <1483421218.19261.4.camel@linux.vnet.ibm.com>
 <649a9342-f1a5-ca63-90e3-efec1e537908@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <649a9342-f1a5-ca63-90e3-efec1e537908@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 09:47:21PM -0800, Andy Lutomirski wrote:
> On 01/02/2017 09:26 PM, James Bottomley wrote:
> > On Mon, 2017-01-02 at 13:40 -0800, James Bottomley wrote:
> > > On Mon, 2017-01-02 at 21:33 +0200, Jarkko Sakkinen wrote:
> > > > On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > > > > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > > > > This patch set adds support for TPM spaces that provide a
> > > > > > context for isolating and swapping transient objects. This
> > > > > > patch set does not yet include support for isolating policy and
> > > > > > HMAC sessions but it is trivial to add once the basic approach
> > > > > > is settled (and that's why I created an RFC patch set).
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
> > > OK, in general I buy this ... what you're effectively saying is that
> > > we need a non-RM interface for certain management type commands.
> > > 
> > > However, let me expand a bit on why I'm fretting about the non-RM use
> > > case.  Right at the moment, we have a single TPM device which you use
> > > for access to the kernel TPM.  The current tss2 just makes direct use
> > > of this, meaning it has to have 0666 permissions.  This means that
> > > any local user can simply DoS the TPM by running us out of transient
> > > resources if they don't activate the RM.  If they get a connection
> > > always via the RM, this isn't a worry.  Perhaps the best way of
> > > fixing this is to expose two separate device nodes: one raw to the
> > > TPM which we could keep at 0600 and one with an always RM connection
> > > which we can set to 0666.  That would mean that access to the non-RM
> > > connection is either root only or governed by a system set ACL.
> > 
> > OK, so I put a patch together that does this (see below). It all works
> > nicely (with a udev script that sets the resource manager device to
> > 0666):
> > 
> > jejb@jarvis:~> ls -l /dev/tpm*
> > crw------- 1 root root  10,   224 Jan  2 20:54 /dev/tpm0
> > crw-rw-rw- 1 root root 246, 65536 Jan  2 20:54 /dev/tpm0rm
> > 
> > I've modified the tss to connect to /dev/tpm0rm by default and it all
> > seems to work.
> > 
> > The patch applies on top of your tabrm branch, by the way.
> 
> Conceptually I like this a *lot* better.  I believe that this effectively
> solves my major gripe with the TPM 1.2 ecosystem.
> 
> However, can this be taken just a little farther?  IMO the tpm0rm (or tpms0
> or whatever) node should also restrict commands that can be sent (perhaps by
> in-kernel whitelist?) to those that shouldn't be restricted to the owner (by
> which I probably mean the Owner, the Platform, etc)? For example, someone
> with tpm0rm open should not be able to change key hierarchy passwords, write
> to NV memory, clear hierarchies, etc.

Yes. This was already discussed in Linux Plumbers. It is trivial to have
that. I just left it out from this RFC patch set to get something not
too complicated out quickly. Whitelist is coming to the non-RFC version.

> Hmm.  Maybe there should be a way to allocate NV slots to users.
> /dev/tpm/nv0?  I don't really like that idea, though.

/Jarkko
