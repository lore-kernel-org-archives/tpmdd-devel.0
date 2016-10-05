From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 15:16:56 -0600
Message-ID: <20161005211656.GA20920@obsidianresearch.com>
References: <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
 <20161004231057.GA20062@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
 <20161005171132.GE18636@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F54E9@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F54E9@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 05, 2016 at 08:09:17PM +0000, Winkler, Tomas wrote:

> It could, but that patch was not merged yet, and I believe even if
> the issue is exposed only with runtime_pm currently, we have a bug
> in design even w/o runtime pm.

Please don't make changes without any justification :(

> > These are all fine, obviously. Todays kernel retains those values across
> > device_del and we set those values in tpmm_chip_alloc/etc. So correct values
> > are present as long as the chip memory exists. tpm continues to hold a kref on
> > the chip so the memory will be around.
> 
> I'm not saying they are not, but calling deep into the tpm stack and
> even to the parent device with unutilized device is not sane.

You keep asserting that, but it just isn't true at all.

For a long time the tpm subsystem didn't even have a
'struct device'. That is something Jarkko and I added.

The *ONLY* thing it does is act as the anchor for user space - eg it
holds the sysfs, contains the 'dev' file for the cdev, etc, etc. This
was an important clean up.

Internally to the tpm core, and the drivers, the chip->dev does
*NOTHING* except hold the few variables you pointed out. That is it.

We could go back to the old code, without the 'dev' and things
could still work correctly.

This is why your assertion the struct device needs to be registered
makes no sense.

If the runtime_pm patches change this, then we have a very serious
problem. Removing this assumption is much harder than a one line patch
moving device_del.

I actually have no idea how you'd do it, since we call all sorts of
tpm ops between device_init and device_add - again device_del is the
least of the problems if runtime pm insists the chip->dev be
registered when running transmit_cmd.

So, I again, strongly advise you to give up on this idea, it is too
hard for TPM, and does not seem technically needed at this time. Even
it it does seem to make some kind of intuitive sense.

> > Is there some other PM path where dev->parent becomes invovled?
> 
> Of course, the power management utilize the device hierarch, it
> assumes there is power dependencies between parents and child
> devices, such as bus controllers and the devices on that bus.

Sure, but that relationship only maters if something does a PM call on
the chip->dev, and AFAIK, nothing does that.

Do you know differently?

You pointed at something that isn't even run and said it is the source
of the problem.. You really need to set up here and explain exactly
what is happening.

> > Are you just guessing this solves a problem, or were you able to reproduce
> > Jarkko's report?
> 
> No, guesses are not my style :), this solves the issue, as you see
> this was also validated by Jarrko on his setup.

In the thread you pointed to Jarkko said he could not reproduce the
original issue. Jarkko can you clarify??

> > Even if that pm_runtime_put is happening, why doesn't the
> > 
> > +    pm_runtime_get_sync(chip->dev.parent);
> > 
> > The runtime_pm patch adds to tpm_transmit take care of bringing the device
> > back?
> 
> Unfortunately not because, because it gets out of sync and what is
> actually happening is that idle callback is called and device is put
> to idle between send and receive.

What? As far as I understand this PM stuff, I would call that a very
serious bug.

If a PM transition during transmit_cmd causes the TPM to abort/fail
command execution then it *MUST* be prevented. Period.

pm_runtime_get_sync appears to be the correct thing to get the
guarentee, so I'm very confused by your statement.

> Now we can find a trick to fix this, but this would be rather w/o
> while we know what the real issue is.

don't understand this.. Are you saying that going into idle during
tpm_transmit is not a bug?

Sounds like there is some sort of race condition with the pm stuff
that needs fixing.

I still don't see what your actual bug is, other than what I already
knew - somehow PM causes transmit_cmd to fail.

Jason
