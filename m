From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 03 Jan 2017 14:03:43 -0800
Message-ID: <1483481023.2464.27.camel@HansenPartnership.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
         <1483374980.2458.13.camel@HansenPartnership.com>
         <20170103213234.GB29656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170103213234.GB29656@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-03 at 14:32 -0700, Jason Gunthorpe wrote:
> On Mon, Jan 02, 2017 at 08:36:20AM -0800, James Bottomley wrote:
> > On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> > > This patch set adds support for TPM spaces that provide a context
> > > for isolating and swapping transient objects. This patch set does
> > > not yet include support for isolating policy and HMAC sessions 
> > > but it is trivial to add once the basic approach is settled (and
> > > that's why I created an RFC patch set).
> > 
> > The approach looks fine to me.  The only basic query I have is 
> > about the default: shouldn't it be with resource manager on rather 
> > than off?  I can't really think of a use case that wants the RM off 
> > (even if you're running your own, having another doesn't hurt 
> > anything, and it's still required to share with in-kernel uses).
> 
> I haven't looked too closely at TPM 2.0 stuff, but at least for 1.2 
> we should have a kernel white-list of allowed commands within a RM
> context, so having the RM on by default would break all of the user
> space.
> 
> I really think the only way forward here is a new char dev that is
> safe for unprivileged/concurrent use and migrate the user space stack
> to use it instead.

That's effectively what /dev/tpms0 would be, with /dev/tpm0 giving full
fledged access.

> > And with that, I've TPM 2 enabled both gnome-keyring and openssl:
> > 
> > https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/gnome
> > -keyring
> > https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/opens
> > sl_tpm_engine
>  
> > I'm running them in production on my day to day laptop and so far
> > everything's working nicely (better than 1.2, in fact, since tcsd
> > periodically crashes necessitating a restart of everything).
> 
> You granted your unprivileged user access to /dev/tpm0 then? FYI I
> think that is a dangerous idea..

No, I granted access to the resource manager device (I'm running with a
combination of Jarkko's and my patches).

James


