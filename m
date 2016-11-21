From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 2/2] tpm: Fix error code handling after tpm_bios_log_setup
Date: Mon, 21 Nov 2016 13:56:13 -0700
Message-ID: <20161121205613.GA21652@obsidianresearch.com>
References: <1479429004-7962-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1479429004-7962-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20161118155249.sdxp2qfjfzfw4tzt@intel.com>
 <20161119182228.GA22775@obsidianresearch.com>
 <20161120121451.awcraondhcvzpbig@intel.com>
 <20161121175520.GA24191@obsidianresearch.com>
 <20161121203244.iwx2wa2zcilqd5ao@intel.com>
 <20161121203708.GA7294@obsidianresearch.com>
 <20161121204610.v56fhxfxibhsvzss@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121204610.v56fhxfxibhsvzss@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Nayna <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 10:46:10PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 21, 2016 at 01:37:08PM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 21, 2016 at 10:32:44PM +0200, Jarkko Sakkinen wrote:
> > 
> > > > And this one fixes the sysfs problem
> > > > 
> > > > https://patchwork.kernel.org/patch/9438331/
> > > > 
> > > > Here is a commit message:
> > > > 
> > > > tpm: Do not call tpm_chip_unregister if register has not succeeded
> > > > 
> > > > This is no longer allowed, vtpm was relying on the check inside the
> > > > tpm core which was removed. Fixes an oops during error unwind.
> > > > 
> > > > Fixes: a8ed92219a04 ("tpm: Get rid of TPM_CHIP_FLAG_REGISTERED")
> > > > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > > > Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> > > > 
> > > > That just leaves the ACPI thing..
> > > 
> > > I like the original commit message more. It documents the change.
> > 
> > ??
> > 
> > This is for  https://patchwork.kernel.org/patch/9438331/ which didn't
> > have a message yet.
> 
> This was the commit message when I did git am:

Well, that is just a conversation from email, not a commit message,
you need to edit it. The above I gave you is much better.

Jason
