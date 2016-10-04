From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Tue, 4 Oct 2016 17:10:57 -0600
Message-ID: <20161004231057.GA20062@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 04, 2016 at 09:55:36PM +0000, Winkler, Tomas wrote:
> 
> > On Tue, Oct 04, 2016 at 08:19:46AM +0300, Jarkko Sakkinen wrote:
> > 
> > > > Make the driver uncallable first. The worst race that can happen is
> > > > that open("/dev/tpm0", ...) returns -EPIPE. I do not consider this
> > > > fatal at all.
> > >
> > > No responses for this reasonable proposal so I'll show what I mean:
> > 
> > How is this any better than what Thomas proposed? It seems much worse to
> > me since now we have even more stuff in the wrong order.
> > 
> > There are three purposes to the ordering as it stands today
> >  1) To guarantee that tpm2_shutdown is the last command delivered to
> >     the TPM. When it is issued all other ways to access the device
> >     are hard fenced off.
> 
> I'm not sure where are you taking this requirements from simple bit
> is just enough to make the HW inaccessible if the interface is
> designed right.

I'm having a hard time understanding the english in your
email. (Jarkko do you know what Tomas is talking about??)

> The ordering can be resolved, like this 
> 
> down_write(&chip->ops_sem);
>         if (chip->flags & TPM_CHIP_FLAG_TPM2)
>                 tpm2_shutdown(chip, TPM2_SU_CLEAR);
> up_write(&chip->ops_sem);
> 
> device_del(&chip->dev);
> 
> down_write(&chip->ops_sem);
> chip->ops = NULL;
> up_write(&chip->ops_sem);

No, that is wrong as well, another thread can issue a TPM command
between the device_del and the ops = NULL. Presumably that will fail
the same as tpm2_shutdown does.

> > I still haven't heard an explanation why Thomas's other patches need this, or
> > why trying to change this ordering makes any sense at all considering how the
> > subsystem is constructed.
> 
> I thought it's quite clear form the commit message, the device_del

Not clear at all the commit message describes the 'solution' not the
problem.  This doesn't help..

> naturally toggles runtime_pm of the parent device, it tries to
> resume the parent device so it can perform denationalization and
> then suspend the parent device back which caused tpm2_shutdown to
> fail.

What code actually fails? I don't see anything in the runtime pm patch
that relies on chip->dev at all.

What code fails and why?

> I general we can not to implement power management via runtime_pm
> and resolve the issue within tpm_crb driver but it's not abouth
> tpm_crb.  tpm2_shutdown is a tpm stack call it's not tpm_crb
> function, it uses tpm_transmit_cmd and friends it should have valid
> tpm_chip initialized and valid.  I'm not sure what could be more
> clearer than that.

I'll say it again, the tpm_transmit_cmd path must not require a
registered chip->dev.

device_del only unregisters the dev, it does not deinitialize it, nor
does it free any memory. I still don't understand how this has any
impact on the pm stuff when all the pm stuff is attached only to the
pdev.

> I have to admit that I'm not sure what the vtpm does yet, but I have
> a feeling that a simple flag can fix this.

What flag? Fix what?

Jason
