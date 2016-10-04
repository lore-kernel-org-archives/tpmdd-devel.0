From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH] tpm: don't destroy chip device prematurely
Date: Tue, 4 Oct 2016 21:55:36 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F4C92@hasmsx108.ger.corp.intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com> <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com> <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161004164738.GA17149@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> On Tue, Oct 04, 2016 at 08:19:46AM +0300, Jarkko Sakkinen wrote:
> 
> > > Make the driver uncallable first. The worst race that can happen is
> > > that open("/dev/tpm0", ...) returns -EPIPE. I do not consider this
> > > fatal at all.
> >
> > No responses for this reasonable proposal so I'll show what I mean:
> 
> How is this any better than what Thomas proposed? It seems much worse to
> me since now we have even more stuff in the wrong order.
> 
> There are three purposes to the ordering as it stands today
>  1) To guarantee that tpm2_shutdown is the last command delivered to
>     the TPM. When it is issued all other ways to access the device
>     are hard fenced off.

I'm not sure where are you taking this requirements from simple bit is just enough to make the HW inaccessible if the interface is designed right.

>  2) To hard fence the tpm subsystem for the 'platform' driver. Once
>     tpm_del_char_device completes no callback into the driver
>     is possible *at all*. The driver can destroy everything
>     (iounmap, dereg irq, etc) and the driver module can be unloaded.

There is some wrong terminology character device is related to user space only,  a device driver can function w/o it. 

>  3) To prevent oopsing with the sysfs code. Recall this comment

> 
>         /* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
>          * is called before ops is null'd and the sysfs core synchronizes this
>          * removal so that no callbacks are running or can run again
>          */
> 
>     device_del is what eliminates the sysfs access path, so
>     ordering device_del after ops = null is just unconditionally
>     wrong.

The ordering can be resolved, like this 

down_write(&chip->ops_sem);
        if (chip->flags & TPM_CHIP_FLAG_TPM2)
                tpm2_shutdown(chip, TPM2_SU_CLEAR);
up_write(&chip->ops_sem);

device_del(&chip->dev);

down_write(&chip->ops_sem);
chip->ops = NULL;
up_write(&chip->ops_sem);

> 
> I still haven't heard an explanation why Thomas's other patches need this, or
> why trying to change this ordering makes any sense at all considering how the
> subsystem is constructed.

I thought it's quite clear form the commit message, the device_del naturally toggles runtime_pm of the parent device, it tries to resume the parent device so it can perform denationalization  and then suspend the parent device back which caused tpm2_shutdown to fail. 
> 
> Further, if tpm_crb now needs a registered device, how on earth do all the
> chip ops we call work *before* registration? Or is that another bug?
> 
> Why can't tpm_crb return to the pre-registration operating state in the driver
> remove function before calling unregister?
> 
> None of this makes any sense to me. 

I general we can not to implement power management via runtime_pm and resolve the issue within tpm_crb driver but it's not abouth tpm_crb.
tpm2_shutdown is a  tpm stack call it's not tpm_crb function, it uses tpm_transmit_cmd and friends it should have valid  tpm_chip initialized and valid.
I'm not sure what could be more clearer than that. 

> This whole thing was very carefully constructed to work *correctly* during
> unregister. Many other subsystems have races and bugs during remove (eg see
> the securityfs discussion). TPM has a hard requirement to support safe
> unregister due to the vtpm stuff, so we don't get to screw it up just to support
> one driver.

I have to admit that I'm not sure what the vtpm does yet,  but I have a feeling that a simple flag can fix this. 


Thanks
Tomas
