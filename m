From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm, tpm_crb: remove redundant
 CRB_FL_CRB_START flag
Date: Wed, 19 Oct 2016 19:09:28 +0300
Message-ID: <20161019160928.n5fswy25t2ppdh73@intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
 <20161017225113.qnghq5vroxlmsurc@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 19, 2016 at 10:28:29AM +0000, Winkler, Tomas wrote:
> 
> 
> > 
> > On Mon, Oct 17, 2016 at 11:42:24PM +0300, Jarkko Sakkinen wrote:
> > > Because all the existing hardware have HID MSFT0101 we end up always
> > > setting CRB_FL_CRB_START flag as a workaround for 4th Gen Core CPUs.
> > > Even if ACPI start is used, the driver will always issue also CRB start.
> 
> Do you have some more historical data about this fix, I was wondering
> about this quirk before, when restructuring the start method parsing.
> The description is ' in practice seems to require both'  sounds not
> certain about the root cause of this.

I have a 4th Gen Core NUC where I experienced this issue. It reported
requiring only ACPI start but actually required ACPI + CRB start. The
comment could have been better.

/Jarkko
