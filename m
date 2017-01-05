From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Thu, 05 Jan 2017 11:55:49 -0800
Message-ID: <1483646149.2515.83.camel@linux.vnet.ibm.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
         <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
         <20170105172726.GA11680@obsidianresearch.com>
         <1483641223.2515.62.camel@linux.vnet.ibm.com>
         <20170105192025.GB12587@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170105192025.GB12587@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-05 at 12:20 -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 10:33:43AM -0800, James Bottomley wrote:
> 
> > > A combo ioctl that could setup the session, issue an operation in
> > > it
> > > and then delete the session, for instance.
> > 
> > This would work for encryption or HMAC sessions, but probably not 
> > for policy sessions, because they can have an arbitrarily large 
> > command sequence to construct them.
> 
> I'd rather give up features (eg policy sessions, if necessary) for 
> the unpriv fd than give up security of the unpriv fd.

We don't really have that choice: Keys require authorization, so you
have to have an auth session.  If you want things like PCR sealed or
time limited keys, you don't really have a choice on policy sessions
either.

I think we've got to the point where arguing about our divergent use
requirements shows the default should be 0600 and every command enabled
so that whatever changes the device to 0666 also applies the command
filter policy.  It's the fully safe default that satisfies everyone.
Once you have the command blacklist, you can blacklist every policy
command before you make your device 0666.  That effecively achieves
what you want because no-one can now initiate a policy session.

> We always have the out that special stuff can go down the priv path.
> 
> > The other issue we're likely to run into if we do it this way is
> > delayed error reporting.
> 
> Not sure I follow.

If we try to issue a load of commands as a transaction, you only get
the error when the transaction is executed, even if the entity causing
the problem is way back in the command sequence.

> > How about a more traditional approach which would be leasing 
> > (basically what we use for NFS).  Any application opening a session
> > would have
> 
> Doesn't this just change the DOS vector? Now the attacker has to 
> delay execution of TPM commands long enough to force session leases 
> to time out. That isn't too hard to do, asking the TPM to make a RSA 
> key can take seconds, for instance.

I really don't think we can prevent all types of DoS in the TPM.  After
all, in a lot of current silicon, it can take up to 90 seconds to
generate an RSA key using the KDF ... the TPM is unavailable while this
is happening, so there's your DoS on a standard command.

What we need to aim for is effective resource sharing.  The 64 handle
limit is one of the nasty ones that a bunch of applications could
accidentally overflow.  A lease model bounds the TPM blocked time while
you're waiting for an available handle and coping with a lease timeout
can be done in the TSS.  TPM execution time could be added to lease
expiry, so even if someone's doing a sequence of RSA KDFs, you
eventually get your job executed as long as we do the execution of
blocked commands in a strict order.  In this model, you can "DoS" me by
substantially delaying the execution of my commands, but you can't
prevent it from executing within a bounded time.  I suppose we could
even make TPM execution time an RLIMIT.

James

