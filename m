From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 05 Jan 2017 10:33:43 -0800
Message-ID: <1483641223.2515.62.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
         <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
         <20170105172726.GA11680@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170105172726.GA11680@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Fuchs, Andreas" <andreas.fuchs@sit.fraunhofer.de>
Cc: "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-05 at 10:27 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 03:52:02PM +0000, Fuchs, Andreas wrote:
[...]
> > - Session Limits (here it gets ugly):
> 
> > Even thought the TPM supports the same swapping-scheme for sessions
> > as it does for transient objects, it only allows for a limited
> > number of session to be opened (64 in case of PC-Client), called
> > active sessions.  This means that a single process can still DoS 
> > the TPM if it allocates 64 sessions, or 64 processes can DoS the
> > TPM if
> 
> Well, if we have an unpriv fd then it should not be able to DOS the
> system - that would suggest either that FD cannot use sessions or we
> need some kernel solution to guarentee the DOS is not possible.

The sessions issue is a bit of a monster nightmare.  The basic problem
is this issue that they're not fully virtualizable: the TPM retains
knowledge that a session existed on this handle even if the session
context is offloaded. It's this space for "session exists" that the TPM
has a limited space for.

> A combo ioctl that could setup the session, issue an operation in it
> and then delete the session, for instance.

This would work for encryption or HMAC sessions, but probably not for
policy sessions, because they can have an arbitrarily large command
sequence to construct them.

The other issue we're likely to run into if we do it this way is
delayed error reporting.

How about a more traditional approach which would be leasing (basically
what we use for NFS).  Any application opening a session would have a
certain time (probably in ms) to complete it or we'd close the handle
and flush it.  We'd store the jiffies time the session was first
requested and loop over all the extent sessions to find ones which get
too old.  We know there can only be TPM_PT_ACTIVE_SESSIONS_MAX of
these, so it's a cheap operation. It's only a small extra bit of logic
to take care of the GAP problem as well, I think.  If we're full when
you try and start a session, we block you until a handle becomes free
and the max lease time guarantees when this is.

James

