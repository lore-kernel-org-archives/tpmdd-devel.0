From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: drop 'base' from struct tpm_vendor_specific
Date: Thu, 24 Mar 2016 15:21:27 +0200
Message-ID: <20160324132127.GA8452@intel.com>
References: <1458713769-11800-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160323164542.GC16336@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160323164542.GC16336@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 23, 2016 at 10:45:42AM -0600, Jason Gunthorpe wrote:
> On Wed, Mar 23, 2016 at 08:16:09AM +0200, Jarkko Sakkinen wrote:
> > Dropped the field 'base' from struct tpm_vendor_specific and migrated
> > it to the private structures of tpm_atmel and tpm_nsc.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>   
> > +#define atmel_get_priv(chip) ((struct tpm_atmel_priv *) chip->vendor.priv)
> 
> This should be a static inline function not a define
> 
> > +#define tpm_nsc_get_priv(chip) ((struct tpm_nsc_priv *) chip->vendor.priv)
> 
> Ditto
> 
> Otherwise looks ok
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thank you. In my the commit now in my master branch they are now changed
as static inline functions.

> Jason

/Jarkko
