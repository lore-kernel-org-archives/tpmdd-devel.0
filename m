From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Re: [PATCH] tpm, tpm_infineon: remove useless snprintf() calls
Date: Thu, 25 May 2017 09:44:16 -0700
Message-ID: <20170525164416.5dn7l3eu4tkudypn@intel.com>
References: <20170524212916.9106-1-jarkko.sakkinen@linux.intel.com>
 <20170524215259.xkaqrnhcb44jpyd5@intel.com>
 <trinity-b171219a-5a85-4fd0-9bc7-f5ecde2598f4-1495690145148@3capp-gmx-bs66>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <trinity-b171219a-5a85-4fd0-9bc7-f5ecde2598f4-1495690145148@3capp-gmx-bs66>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, jmorris@namei.org, linux-security-module@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 07:29:05AM +0200, Peter Huewe wrote:
> > The memory copy from rodata to stack is useless.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> After review, yes that should work.
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Yes, the string gets stored to rodata section where it is copied to
stack :-)

Thanx!

/Jarkko
