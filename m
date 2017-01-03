From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 3 Jan 2017 14:47:02 -0700
Message-ID: <20170103214702.GC29656@obsidianresearch.com>
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
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 08:36:10AM -0800, James Bottomley wrote:

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

There is clearly no need for a daemon to be involved when working on
simple tasks like key load and key sign/enc/dec actions, adding such a
thing only increases the complexity.

If we discover a reason to have a daemon down the road then it should
work in some way where the user space can call out to the daemon over
a different path than the kernel. (eg dbus or something)

> Do you have a link to the presentation?  The Plumbers etherpad doesn't
> contain it.  I've been trying to work out whether a properly set up TPM
> actually does need any protections at all.  As far as I can tell, once
> you've set all the hierarchy authorities and the lockout one, you're
> pretty well protected.

I think we should also consider TPM 1.2 support in all of this, it is
still a very popular peice of hardware and it is equally able to
support a RM.

So, in general, I'd prefer to see the unprivileged char dev hard
prevented by the kernel from doing certain things:

- Wipe the TPM
- Manipulate the SRK, nvram, tpm flags, change passwords etc
- Read back the EK
- Write to PCRs
- etc.

Even if TPM 2 has a stronger password based model, I still think the
kernel should hard prevent those sorts of actions even if the user
knows the TPM password.

Realistically people in less senstive environments will want to use
the well known TPM passwords and still have reasonable safety in their
unprivileged accounts.

Jason
