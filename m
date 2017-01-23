From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing commands on
 shutdown
Date: Mon, 23 Jan 2017 14:19:29 -0800
Message-ID: <20170123221929.GA75281@apronin>
References: <20170114004230.GA21035@apronin>
 <20170116161919.GA20238@obsidianresearch.com>
 <20170117175827.GA124090@apronin>
 <20170117192728.GF27528@obsidianresearch.com>
 <20170117201336.GA140854@apronin>
 <20170117205933.GA9604@obsidianresearch.com>
 <20170117230053.GA16227@apronin>
 <20170117232207.GA12127@obsidianresearch.com>
 <20170123200246.GA63214@apronin>
 <20170123203901.GA13029@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170123203901.GA13029@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, semenzato@chromium.org, groeck@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 01:39:01PM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 23, 2017 at 12:02:46PM -0800, Andrey Pronin wrote:
> 
> > > But if there is no actual need to do this right now then don't worry
> > > about overdesigning things..
> > 
> > OK, I can live with chip->id specific logic in probe/shutdown, if that's
> > the current approach.
> 
> It is where we are heading.. If it becomes prevelent we will need chip
> and bus drivers.
> 
> > > First class then driver is the usual model, which is OK for TPM.
> > 
> > If "first class then driver", then the already existing
> > register_reboot_notifier() can play the role of the class handler,
> > since those hooks are called before drivers' shutdown handlers.
> 
> Okay.. But maybe fire off patch doing this via the device code, as if
> that is accepted it is better than the reboot handler in terms of
> guaranteeing ordering/etc.
>

You mean introducing shutdown in struct class? Hmm, we can try,
but...

If we do something in 'struct class' for shutdown, that should
probably be modeled after power management, for which class
handlers are already supported. So, I looked more closely at
how this logic is implemented for suspend in
drivers/base/power/main.c.

Simplifying to class vs driver handlers, it checks class suspend
first. And if it exists, calls it. Otherwise, it calls driver
suspend. So, it's "either-or", not "first one, then another".
Unless I'm missing something obvious, of course...

If we want "first one, then another" it might be better to
go the register_reboot_notifier() path, instead of trying
to add something inconsistent with how it is handled for
power management to the core logic. I suspect those
notifiers is the mechanism of choice if we need to do
both class-level and device-level handling.

And I don't want to implement a class-level handler that'd
prevent driver handlers from doing device-specific handling,
if it is needed. Even if we reverse the order and do "driver
first, and iff it doesn't exist, then class", we'd still
need to create and export 'tpm_shutdown' for drivers to use
in their custom handlers. Otherwise, there's no way for
them to zero out chip->ops and prevent further access to
the chip.

Thus, after looking at that, I'd still suggest doing one of
the following:

We can go the register_reboot_notifier() route. Which already
explicitly supports priorites for those notify handlers, so one
can be sure that lower-prio handlers are called first. And,
in any case, all these handlers are called before driver->shutdown
routines. So, the ordering is very predictable, and we can design
whatever fits our needs with it.

Or, again, keep it even simpler, but require changes to all tpm
drivers. Create and export 'tpm_shutdown' in the core, and let
all the tpm drivers register their own shutdown handlers and
call it from there, adding their own logic to it, if they want.
Sorry, f we go this way, looks like we made the full cycle. But
I only now got to checking what's there in kernel for power
management.

I don't have strong preferences. In both cases, driver writers
need to be aware of the shutdown convention. Either (1) know
that there's a registered notifier, and they won't be able to
use tpm_transmit from driver->shutdown. Or, (2) know that they
need to implement driver->shutdown if they support TPM 2.0 or
can have problems if the chip is reset in the middle of command.
(1) sounds better (fewer drivers will be affected), but not
decisively.

> 
> > 	down_write(&chip->ops_sem);
> > 	if (chip->ops) {
> > 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > 			tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > 		chip->ops = NULL;
> > 	}
> > 	up_write(&chip->ops_sem);
> > on shutdown in registered "reboot notifier".
> 
> Sure, seems like a good starting point.
> 
> > I went through the places that access chip->ops to see what's
> > going on at the moment with protecting them with tpm_try_get_ops().
> > Here is the current state:
> > 
> >  - tpm_transmit/tpm_transmit_cmd. Not exported and are only called
> >    by the core after tpm_try_get_ops() except for one place in
> >    sysfs - pubek_show().
> 
> Most of sysfs calls functions like tpm_pcr_read_dev, tpm_getcap, etc,
> etc that boil down the tpm_transmit_cmd, so many more need it than you
> listed.
> 

Yes, you're right, of course. I definitely needed more coffee before
writing that. I ended up adding tpm_try_get_ops/tpm_put_ops to almost
every sysfs call once I started looking into them.

> > But it looks a bit brittle. So, before I submit my next patch:
> > Do you think it's ok to leave wait_for_tpm_stat() and
> > tpm_get_timeouts() and just continue be mindful when using those
> > low-level functions?
> 
> For xenfront we should someday move it to use TPM_OPS_AUTO_STARTUP and
> drop the tpm_get_timeouts.
> 
> I think it is fine to leave those two low level commands as is..
> 
> Like I said, it would be more robust to acquire a lock directly in
> places like transmit_cmd, but I suspect that is too hard to retrofit
> at this time...
> 
> > and checking for ops == NULL inside those low-level functions:
> > tpm_transmit, wait_for_tpm_stat, tpm_get_timeout. It then should
> > probably be separated from get_device(), which can be kept inside
> > tpm_try_get_ops().
> 
> No sense checking for ops=null if you also can't guarentee the lock is
> held, it is just confusing.

Oh, absolutely. I just meant calling tpm_try_get_ops(), which does both:
acquires the lock and checks that ops != NULL.

> 
> Jason
