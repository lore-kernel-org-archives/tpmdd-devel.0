From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Tue, 4 Oct 2016 10:47:38 -0600
Message-ID: <20161004164738.GA17149@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004051946.GA10572@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 04, 2016 at 08:19:46AM +0300, Jarkko Sakkinen wrote:

> > Make the driver uncallable first. The worst race that can happen is that
> > open("/dev/tpm0", ...) returns -EPIPE. I do not consider this fatal at
> > all.
> 
> No responses for this reasonable proposal so I'll show what I mean:

How is this any better than what Thomas proposed? It seems much worse
to me since now we have even more stuff in the wrong order.

There are three purposes to the ordering as it stands today
 1) To guarantee that tpm2_shutdown is the last command delivered to
    the TPM. When it is issued all other ways to access the device
    are hard fenced off.
 2) To hard fence the tpm subsystem for the 'platform' driver. Once
    tpm_del_char_device completes no callback into the driver
    is possible *at all*. The driver can destroy everything
    (iounmap, dereg irq, etc) and the driver module can be unloaded.
 3) To prevent oopsing with the sysfs code. Recall this comment

        /* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
         * is called before ops is null'd and the sysfs core synchronizes this
         * removal so that no callbacks are running or can run again
         */

    device_del is what eliminates the sysfs access path, so
    ordering device_del after ops = null is just unconditionally
    wrong.

I still haven't heard an explanation why Thomas's other patches need
this, or why trying to change this ordering makes any sense at
all considering how the subsystem is constructed.

Further, if tpm_crb now needs a registered device, how on earth do all
the chip ops we call work *before* registration? Or is that another
bug?

Why can't tpm_crb return to the pre-registration operating state
in the driver remove function before calling unregister?

None of this makes any sense to me.

This whole thing was very carefully constructed to work *correctly*
during unregister. Many other subsystems have races and bugs during
remove (eg see the securityfs discussion). TPM has a hard requirement
to support safe unregister due to the vtpm stuff, so we don't get to
screw it up just to support one driver.

Jason
