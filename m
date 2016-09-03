From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: move struct tpm_class_ops to drivers/char/tpm/tpm.h
Date: Sat, 3 Sep 2016 09:26:05 +0300
Message-ID: <20160903062605.GB2061@intel.com>
References: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160902221122.GA1897@obsidianresearch.com>
 <20160902223522.GA27454@intel.com>
 <20160902224531.GC1897@obsidianresearch.com>
 <20160903062221.GA2061@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160903062221.GA2061@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Sep 03, 2016 at 09:22:21AM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2016 at 04:45:31PM -0600, Jason Gunthorpe wrote:
> > On Sat, Sep 03, 2016 at 01:35:22AM +0300, Jarkko Sakkinen wrote:
> > > On Fri, Sep 02, 2016 at 04:11:22PM -0600, Jason Gunthorpe wrote:
> > > > On Sat, Sep 03, 2016 at 12:48:03AM +0300, Jarkko Sakkinen wrote:
> > > > > The struct tpm_class_ops is not used outside the TPM driver. Thus,
> > > > > it can be safely move to drivers/char/tpm/tpm.h.
> > > > 
> > > > No, this is the wrong direction.
> > > > 
> > > > The goal is to make things more like other subsystems, so we should be
> > > > moving struct tpm_chip into the public header, and that requires ops
> > > > to be in the public header.
> > > > 
> > > > This is why I put ops here in the first place.
> > > 
> > > I'm OK with it as long as you explain why this is necessary. I see no
> > > use for them outside the TPM subsystem.
> > 
> > That is because the users out side the subsystem are Doing it Wrong.
> > 
> > eg this:
> > 
> >  extern int tpm_is_tpm2(u32 chip_num);
> > 
> > Should be:
> > 
> >  extern int tpm_is_tpm2(struct tpm_chip *chip);
> > 
> > And same for all other examples.
> > 
> > The 'chip_num' thing is bonkers.
> 
> OK, how would one get the chip instance?

This still doesn't explain why moving the structures inside the driver
would be wrong. Even if outside callers would use a pointer the
structure could be opaque.

/Jarkko
