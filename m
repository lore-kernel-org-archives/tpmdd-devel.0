From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Mon, 21 Nov 2016 22:30:59 +0200
Message-ID: <20161121203059.227bxfuemnp6z4ak@intel.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
 <20161120121451.awcraondhcvzpbig@intel.com>
 <20161121175520.GA24191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121175520.GA24191@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Nayna <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 10:55:20AM -0700, Jason Gunthorpe wrote:
> On Sun, Nov 20, 2016 at 12:14:51PM +0000, Jarkko Sakkinen wrote:
> > I was able to apply the patch after manually editing the mbox file.
> > Not nice. It'd be better to send these things with git-send-email
> > to simplify the mgmt (like getting them into patchwork for starters)
> > especially in a situation that is bit chaotic to begin with :-/
> 
> It is in patchwork just fine:
> 
> https://patchwork.kernel.org/patch/9438323/
> 
> git am is unfortunately much more limited than patchwork, but you can
> apply right out of patchwork.
> 
> You forgot to add your signed-off-by though.

It's not forgotten. I'm yet to test it properly. I just quickly wanted
to make it available...

/Jarkko

> 
> And this one fixes the sysfs problem
> 
> https://patchwork.kernel.org/patch/9438331/
> 
> Here is a commit message:
> 
> tpm: Do not call tpm_chip_unregister if register has not succeeded
> 
> This is no longer allowed, vtpm was relying on the check inside the
> tpm core which was removed. Fixes an oops during error unwind.
> 
> Fixes: a8ed92219a04 ("tpm: Get rid of TPM_CHIP_FLAG_REGISTERED")
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> 
> That just leaves the ACPI thing..
> 
> Jason
