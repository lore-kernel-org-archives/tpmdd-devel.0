From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm, tpm_crb: remove redundant
 CRB_FL_CRB_START flag
Date: Fri, 21 Oct 2016 18:11:41 +0300
Message-ID: <20161021151141.oyxtjkfgn26nznty@intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
 <20161017225113.qnghq5vroxlmsurc@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
 <20161019160928.n5fswy25t2ppdh73@intel.com>
 <20161020135906.ah4rjympz3wq6g3t@intel.com>
 <20161020140011.s5mu3atjjwnwqda4@intel.com>
 <20161020202421.GA13459@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161020202421.GA13459@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 20, 2016 at 02:24:21PM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 20, 2016 at 05:00:11PM +0300, Jarkko Sakkinen wrote:
> 
> > > > I have a 4th Gen Core NUC where I experienced this issue. It reported
> > > > requiring only ACPI start but actually required ACPI + CRB start. The
> > > > comment could have been better.
> 
> Shouldn't bios work arounds be keyed on something? What happens if a
> system rolls around that cannot do ACPI + CRB start? How does this
> system work in windows?

I didn't find anything better to key it on at the time and it has been
working for two years now without any problems.

/Jarkko
