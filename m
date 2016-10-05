From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Wed, 5 Oct 2016 07:48:59 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F5084@hasmsx108.ger.corp.intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
	<20161002101755.GA25844@intel.com> <20161002102455.GA27464@intel.com>
	<20161002212126.GA25872@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
	<20161003124836.GE9990@intel.com> <20161004051946.GA10572@intel.com>
	<20161004164738.GA17149@obsidianresearch.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
	<20161004231057.GA20062@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161004231057.GA20062-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> >
> > > On Tue, Oct 04, 2016 at 08:19:46AM +0300, Jarkko Sakkinen wrote:
> > >
> > > > > Make the driver uncallable first. The worst race that can happen
> > > > > is that open("/dev/tpm0", ...) returns -EPIPE. I do not consider
> > > > > this fatal at all.
> > > >
> > > > No responses for this reasonable proposal so I'll show what I mean:
> > >
> > > How is this any better than what Thomas proposed? It seems much
> > > worse to me since now we have even more stuff in the wrong order.
> > >
> > > There are three purposes to the ordering as it stands today
> > >  1) To guarantee that tpm2_shutdown is the last command delivered to
> > >     the TPM. When it is issued all other ways to access the device
> > >     are hard fenced off.
> >
> > I'm not sure where are you taking this requirements from simple bit is
> > just enough to make the HW inaccessible if the interface is designed
> > right.
> 
> I'm having a hard time understanding the english in your email. (Jarkko do you
> know what Tomas is talking about??)

Will try to do better. 

> 
> > The ordering can be resolved, like this
> >
> > down_write(&chip->ops_sem);
> >         if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >                 tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > up_write(&chip->ops_sem);
> >
> > device_del(&chip->dev);
> >
> > down_write(&chip->ops_sem);
> > chip->ops = NULL;
> > up_write(&chip->ops_sem);
> 
> No, that is wrong as well, another thread can issue a TPM command between
> the device_del and the ops = NULL. Presumably that will fail the same as
> tpm2_shutdown does.
>

Right, but that's why we need the TPM_CHIP_FLAG_REGISTERED bit to stay.
Second, tmp2_shutdown only assure that the tpm state is saved,  we are taking too hardline here.  If another command is issued, this is a problem of the upper layers and it has to be fixed in the upper layer.
On the other hand it is much worse if tpm2_shutdown is not sent at all.

> > > I still haven't heard an explanation why Thomas's other patches need
> > > this, or why trying to change this ordering makes any sense at all
> > > considering how the subsystem is constructed.
> >
> > I thought it's quite clear form the commit message, the device_del
> 
> Not clear at all the commit message describes the 'solution' not the problem.
> This doesn't help..

This is the problem statement form the commit message: 

' But with the introduction of runtime power management it will result in
shutting down the parent device while it still in use.' 

We are talking about 
https://lkml.org/lkml/2016/9/12/352 
https://sourceforge.net/p/tpmdd/mailman/message/35395799/

But again, the real bug is in design, where a device is used after device_del()  is called.

> 
> > naturally toggles runtime_pm of the parent device, it tries to resume
> > the parent device so it can perform denationalization and then suspend
> > the parent device back which caused tpm2_shutdown to fail.
> 
> What code actually fails? I don't see anything in the runtime pm patch that
> relies on chip->dev at all.

 "chip-dev.parent''
 dev_get_drvdata(&chip->dev);

> 
> What code fails and why?

   device_del(dev)
          bus_remove_device(dev)
                device_release_driver(dev)
                       __device_release_driver(dev)
                                      pm_runtime_reinit(dev) {
                                            if (dev->parent)
                                                   pm_runtime_put(dev->parent);
                                       }

 
> > I general we can not to implement power management via runtime_pm and
> > resolve the issue within tpm_crb driver but it's not abouth tpm_crb.
> > tpm2_shutdown is a tpm stack call it's not tpm_crb function, it uses
> > tpm_transmit_cmd and friends it should have valid tpm_chip initialized
> > and valid.  I'm not sure what could be more clearer than that.
> 
> I'll say it again, the tpm_transmit_cmd path must not require a registered chip-
> >dev.

I rephrase it again as well, this requirement is  just abusing of the device interface.

> device_del only unregisters the dev, it does not deinitialize it, nor does it free
> any memory. 

Someone will do a legitimate fix in device_del and all you house will crash on you, the device should not be used after device_del is called. 
There is nothing in the interface that promises that nothing is destructed. 

I still don't understand how this has any impact on the pm stuff
> when all the pm stuff is attached only to the pdev.

There is device hierarchy which is important for power management, please read the code.

> > I have to admit that I'm not sure what the vtpm does yet, but I have a
> > feeling that a simple flag can fix this.
> 
> What flag? Fix what?

TPM_CHIP_FLAG_REGISTERED

Tomas


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
