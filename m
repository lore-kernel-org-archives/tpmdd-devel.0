From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 11:11:32 -0600
Message-ID: <20161005171132.GE18636@obsidianresearch.com>
References: <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
 <20161004231057.GA20062@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 05, 2016 at 07:48:59AM +0000, Winkler, Tomas wrote:
> > > down_write(&chip->ops_sem);
> > > chip->ops = NULL;
> > > up_write(&chip->ops_sem);
> > 
> > No, that is wrong as well, another thread can issue a TPM command between
> > the device_del and the ops = NULL. Presumably that will fail the same as
> > tpm2_shutdown does.
> 
> Right, but that's why we need the TPM_CHIP_FLAG_REGISTERED bit to
> stay.

How does that help?

We already null ops to signal the driver is removed, but we don't
check ops in all places today. Notably sysfs doesn't do the test, and
relies on the hard fence device_del provides.

So at a minimum to go forward with this approach you have to fix sysfs
to be safe - which I don't think is worthwhile..

> Second, tmp2_shutdown only assure that the tpm state is saved, we
> are taking too hardline here.  If another command is issued, this is
> a problem of the upper layers and it has to be fixed in the upper
> layer.

We can't fix it at the upper layers, this is classic removal
race. Whatever happens it must not cause the kernel to malfunction.

> This is the problem statement form the commit message: 
> 
> ' But with the introduction of runtime power management it will result in
> shutting down the parent device while it still in use.' 

> https://sourceforge.net/p/tpmdd/mailman/message/35395799/

Great, your commit message should include the klog message this patch
is fixing.

> > But again, the real bug is in design, where a device is used after
> > device_del()  is called.

No, I don't think so..

> > What code actually fails? I don't see anything in the runtime pm patch that
> > relies on chip->dev at all.
> 
>  "chip-dev.parent''
>  dev_get_drvdata(&chip->dev);

Also chip->dev.name because we can call dev_log/etc(&chip->dev..)

These are all fine, obviously. Todays kernel retains those values
across device_del and we set those values in tpmm_chip_alloc/etc. So
correct values are present as long as the chip memory exists. tpm
continues to hold a kref on the chip so the memory will be around.

'dev' values are only being used for clarity and convenience, if ever
the kernel changes behavior and nulls those values during device_del
then we will copy the values into chip and stop using dev. No
algorithm needs to change, and we don't need a registered 'dev'
to function.

However, I find such a possible change to be deeply unlikely. If you
look around the kernel I think you will find that many subsystems
subtly depend on these same invariants for corectness during various
unregister races.

> > What code fails and why?
> 
>    device_del(dev)
>           bus_remove_device(dev)
>                 device_release_driver(dev)
>                        __device_release_driver(dev)
>                                       pm_runtime_reinit(dev) {
>                                             if (dev->parent)
>                                                    pm_runtime_put(dev->parent);

Eh?? The full code is:

void pm_runtime_reinit(struct device *dev)
{
 if (!pm_runtime_enabled(dev)) {
     if (dev->power.irq_safe) {
         if (dev->parent)
              pm_runtime_put(dev->parent);

And irq_safe is only set by pm_runtime_irq_safe(). I can't find
any place that looks like that is called on chip->dev

Is there some other PM path where dev->parent becomes invovled?

Are you just guessing this solves a problem, or were you able to
reproduce Jarkko's report?

Considering that Jarkko cannot reliably reproduce the original bug,
I'm deeply skeptical this patch actually does anything more than
fiddle with timing around some kind of undiscovered race condition
scenario.

Even if that pm_runtime_put is happening, why doesn't the

+    pm_runtime_get_sync(chip->dev.parent);

The runtime_pm patch adds to tpm_transmit take care of bringing the
device back?

I'm still not hearing from you an explanation for what is actually
happening to cause the 325 error.. What does that error code decode
to anyhow?

Jason
