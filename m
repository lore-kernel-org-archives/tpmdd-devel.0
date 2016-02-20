From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm_crb: fix bad name pointer usage with
 struct resource
Date: Sat, 20 Feb 2016 10:04:22 +0200
Message-ID: <20160220080422.GA6833@intel.com>
References: <1455668874-13261-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160217045219.GA26086@obsidianresearch.com>
 <20160217093623.GA9831@intel.com>
 <20160217142016.GA6951@intel.com>
 <20160218173140.GA5899@obsidianresearch.com>
 <20160219150606.GB7474@intel.com>
 <20160219174434.GA15013@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160219174434.GA15013@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 19, 2016 at 10:44:34AM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 19, 2016 at 05:06:06PM +0200, Jarkko Sakkinen wrote:
> 
> > Can you quickly check the two top-most patches:
> > 
> > https://github.com/jsakkine/linux-tpmdd/commits/master
> 
> Drop the change to crb_map_res, the memset is not needed.

Left-over from when I tried to catch the issue. Removed.

> The shutdown change is probably OK for a rc fix, but it is still wrong.
> The shutdown has to be done inside the code after the core has removed
> all access to the tpm but before it has torn down so much that the
> driver doesn't work anymore.

I made the modifications you asked and run my smoke tests. Can I apply
your Reviewed-by's?

> Jason

/Jarkko
