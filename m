From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Fri, 10 Feb 2017 10:48:37 +0200
Message-ID: <20170210084837.lq3mofgfwvjx623m@intel.com>
References: <jarkko.sakkinen@linux.intel.com>
 <201702090906.v1996c6a015552@wind.enjellic.com>
 <20170209151922.cqo32h4io5dqyvvw@intel.com>
 <20170209190426.GA1104@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209190426.GA1104@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: greg@enjellic.com, James Bottomley <James.Bottomley@HansenPartnership.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Ken Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 09, 2017 at 12:04:26PM -0700, Jason Gunthorpe wrote:
> On Thu, Feb 09, 2017 at 05:19:22PM +0200, Jarkko Sakkinen wrote:
> > > userspace instance with subsequent relinquishment of privilege.  At
> > > that point one has the freedom to implement all sorts of policy.
> > 
> > If you look at the patch set that I sent yesterday it exactly has a
> > feature that makes it more lean for a privileged process to implement
> > a resource manager.
> 
> I continue to think, based on comments like this, that you should not
> implement tmps0 in the first revision either. That is also something
> we have to live with forever, and it can never become the 'policy
> limited' or 'unpriv safe' access point to the kernel.  ie go back to
> something based on tmp0 with ioctl.

With /dev/tpms0 I'm fairly certain that it is right way to go as it does
make sense to have it as close as being drop in replacement for
/dev/tpm0 as possible. There's factors more certainty that the API is
something that most people will like to have.

> This series should focus on allowing a user space RM to co-exist with
> the in-kernel services - lets try and tackle the idea of a
> policy-restricted or unpriv-safe cdev when someone comes up with a
> comprehensive proposal..

Sure. I do agree with this.

> > The current patch set does not define policy. The simple policy
> > addition that could be added soon is the limit of connections
> > because it is easy to implement in non-intrusive way.
> 
> It is also trivial for a userspace RM to limit the number of sessions
> or connections or otherwise to manage this limitation. It is hard to
> see why we'd need kernel support for this.
> 
> The main issue from the kernel perspecitive is how to allow sessions
> to be used in-kernel and continue to make progress when they start to
> run out.
> 
> Jason

This is an issue but in the current patch set there's nothing that would
make it harder to sort out.

/Jarkko
