From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2] tpm_tis: fix stall after iowrite*()s
Date: Sat, 19 Aug 2017 20:03:46 +0300
Message-ID: <20170819170346.6mytggeq3rgu6b2q@linux.intel.com>
References: <20170804215651.29247-1-haris.okanovic@ni.com>
 <20170815201308.20024-1-haris.okanovic@ni.com>
 <13741b28-1b5c-de55-3945-e05911e5a4e2@linux.vnet.ibm.com>
 <20170817103807.ubrbylnud6wxod3s@linutronix.de>
 <20170817171732.GA22792@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170817171732.GA22792@obsidianresearch.com>
Sender: linux-rt-users-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sebastian Andrzej Siewior <sebastian.siewior@linutronix.de>, Ken Goldman <kgold@linux.vnet.ibm.com>, Haris Okanovic <haris.okanovic@ni.com>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, harisokn@gmail.com, julia.cartwright@ni.com, gratian.crisan@ni.com, scott.hartman@ni.com, chris.graf@ni.com, brad.mouring@ni.com, jonathan.david@ni.com, peterhuewe@gmx.de, tpmdd@selhorst.net, eric.gardiner@ni.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 17, 2017 at 11:17:32AM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 17, 2017 at 12:38:07PM +0200, Sebastian Andrzej Siewior wrote:
> 
> > > I worry a bit about "appears to fix".  It seems odd that the TPM device
> > > driver would be the first code to uncover this.  Can anyone confirm that the
> > > chipset does indeed have this bug?
> > 
> > What Haris says makes sense. It is just not all architectures
> > accumulate/ batch writes to HW.
> 
> It doesn't seem that odd to me.. In modern Intel chipsets the physical
> LPC bus is used for very little. Maybe some flash and possibly a
> winbond super IO at worst?  Plus the TPM.
> 
> I can't confirm what Intel has done, but if writes are posted, then it
> is not a 'bug', but expected operation for a PCI/LPC bridge device to
> have an ordered queue of posted writes, and thus higher latency when
> processing reads due to ordering requirments.
> 
> Other drivers may not see it because most LPC usages would not be
> write heavy, or might use IO instructions which are not posted..
> 
> I can confirm that my ARM systems with a custom PCI-LPC bridge will
> have exactly the same problem, and that the readl is the only
> solution.
> 
> This is becuase writes to LPC are posted over PCI and will be buffered
> in the root complex, device end port and internally in the LPC
> bridge. Since they are posted there is no way for the CPU to know when
> the complete and when it would be 'low latency' to issue a read.

What you say makes sense to me but wasn't the patch tried with SPI-TPM,
not LPC? Anyway, what you're saying probably still applies.

/Jarkko
