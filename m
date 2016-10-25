From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm, tpm_crb: remove redundant
 CRB_FL_CRB_START flag
Date: Tue, 25 Oct 2016 23:31:52 +0300
Message-ID: <20161025203152.o4p3gmxeare6idpz@intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
 <20161017225113.qnghq5vroxlmsurc@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
 <20161019160928.n5fswy25t2ppdh73@intel.com>
 <20161020135906.ah4rjympz3wq6g3t@intel.com>
 <20161020140011.s5mu3atjjwnwqda4@intel.com>
 <20161020202421.GA13459@obsidianresearch.com>
 <20161021151141.oyxtjkfgn26nznty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161021151141.oyxtjkfgn26nznty@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 21, 2016 at 06:11:41PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 20, 2016 at 02:24:21PM -0600, Jason Gunthorpe wrote:
> > On Thu, Oct 20, 2016 at 05:00:11PM +0300, Jarkko Sakkinen wrote:
> > 
> > > > > I have a 4th Gen Core NUC where I experienced this issue. It reported
> > > > > requiring only ACPI start but actually required ACPI + CRB start. The
> > > > > comment could have been better.
> > 
> > Shouldn't bios work arounds be keyed on something? What happens if a
> > system rolls around that cannot do ACPI + CRB start? How does this
> > system work in windows?
> 
> I didn't find anything better to key it on at the time and it has been
> working for two years now without any problems.

I've though about this and came to conclusion that maybe I won't apply
this patch because it is good to keep this robustness in for now. I
think your point is valid.

/Jarkko
