From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm: fix crash in tpm_tis deinitialization
Date: Thu, 14 Apr 2016 12:27:13 +0300
Message-ID: <20160414092713.GA5715@intel.com>
References: <1460532126-14435-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160413171127.GB28411@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413171127.GB28411@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 13, 2016 at 11:11:27AM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 13, 2016 at 10:22:06AM +0300, Jarkko Sakkinen wrote:
> > rmmod crashes the driver because tpm_chip_unregister() already sets ops
> > to NULL. This commit fixes the issue by moving tpm2_shutdown() to
> > tpm_chip_unregister(). This commit is also cleanup because it removes
> > duplicate code from tpm_crb and tpm_tis to the core.
> > 
> > v2: make sending shutdown command atomic with nulling ops
> > v3: forgot to amend updates, sorry :(
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Fixes: 4d3eac5e156a ("tpm: Provide strong locking for device
> > removal")
> 
> You patch got a little mangled.. The v2/v3 should be after the
> diffstat, not in the commit message and the --- after the SOB section
> is missing..
> 
> Otherwise it looks fine
> 
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks I'll apply this. 

/Jarkko

> >  extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
> > -extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
> > +void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
> 
> Drop this hunk though, doesn't do anything.
> 
> If you don't like the unnecessary externs on functions then get rid of
> them all in a patch.

[x]

> Jason

/Jarkko
