From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] tpm_tis regression in 4.9?
Date: Thu, 3 Nov 2016 06:53:55 -0600
Message-ID: <20161103125355.mo6pmlvswyo7h2jg@intel.com>
References: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
 <20161028030916.GA29851@obsidianresearch.com>
 <20161028143745.3iaevn4sunbmuiln@intel.com>
 <20161028171043.GA18206@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B54312DCD@hasmsx108.ger.corp.intel.com>
 <20161101122627.covzsouqcooudk3j@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B5431396E@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5431396E@hasmsx108.ger.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 01, 2016 at 08:56:47PM +0000, Winkler, Tomas wrote:
> > 
> > On Mon, Oct 31, 2016 at 08:16:59PM +0000, Winkler, Tomas wrote:
> > > >
> > > > On Fri, Oct 28, 2016 at 05:37:45PM +0300, Jarkko Sakkinen wrote:
> > > >
> > > > > > I think this patch from Jarkko's next is the fix:
> > > > > >
> > > > > > http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7dd
> > > > > > cdd8990e4783d09c7e86d90ccb4121
> > > > > >
> > > > > > Jarkko? Can you hurry that along to go in for -rc?
> > > > >
> > > > > Do you think I should resend the pull request?
> > > >
> > > > That or a ping. This patch needs to land right away since it is breaking 4.9.
> > > >
> > > > Jason
> > >
> > > Jarrko, why we didn't request pull for fix Intel PTT patches, as well for 4.9?
> > 
> > Which patches are you talking about?
> 
> 213ebc81ac3f tmp/tpm_crb: implement runtime pm for tpm_crb
> a0cb67590dff tpm/tpm_crb: open code the crb_init into acpi_add
> 4d73afd9c0fd tmp/tpm_crb: fix Intel PTT hw bug during idle state
> 34483fbffd83 tpm/tpm_crb: implement tpm crb idle state

I can propose these to the stable series. Not having power gating is not
a kernel regression but important enough for the stable IMHO.

I wonder what is the process of proposing something to stable if you do
not have a commit ID for regression?

> Thanks
> Tomas

/Jarkko
