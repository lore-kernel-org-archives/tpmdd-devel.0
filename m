From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Tue, 17 Jan 2017 12:13:36 -0800
Message-ID: <20170117201336.GA140854@apronin>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117192728.GF27528-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, semenzato-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 17, 2017 at 12:27:28PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2017 at 09:58:27AM -0800, Andrey Pronin wrote:
> > > Yes, sorry, I should have mentioned that.. Maybe that is too much to
> > > fix..
> > 
> > If we fix sysfs to go through tpm_try_get_ops, then all we can do for
> > shutdown is indeed something like
> 
> Maybe yes, I also had at one point a thought to push the read side of
> the ops_sem all the way down to the transmit_cmd level... But that
> complicates calling shutdown.
> 
> > 	down_write(&chip->ops_sem);
> > 	if (chip->ops && chip->flags & TPM_CHIP_FLAG_TPM2)
> > 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > 	chip->ops = NULL;
> > 	up_write(&chip->ops_sem);
> > 
> > Does that sound like a good plan?
> > If we don't want sysfs to increment/decrement the reference count for
> > the device, we can still make it go through
> 
> Grabbing the extra kref is harmless..
> 
> > > I'm confused - doesn't your system reset the TPM when it reboots?
> > > Isn't that required so the firmware starts with known PCRs? Doesn't
> > > reset trump unorderly shutdown?
> > > 
> > 
> > That's right, the TPM is reset when the system reboots. However, for
> > TPM 2.0, if it resets w/o Shutdown(CLEAR) first, it will detect it
> > during Startup, and mark as unorderly shutdown. Shutdown(CLEAR) is
> > the signal to the TPM to save its state to nvram and prepare to reset.
> > If it was not done, it is possible that something was not saved (e.g.
> > the DA counter), and the chip correctly marks it as a potential DA
> > problem.
> 
> Okay, that makes sense, and needs to go in a comment someplace!
> 
> > > > All these things are handled by tpm_chip_unregister(). I thought about
> > > > creating a tpm_chip_shutdown routine that could be called from shutdown
> > > > handlers of the drivers that need it (and I'd do it for every driver,
> > > > especially in 2.0 case). But decided that it's better to reuse the
> > > > existing tpm_chip_unregister() that already does what's needed.
> > > 
> > > If for some reason we need this for every driver then this is probably
> > > a better approach - but that seems very, very strange to me.
> > 
> > As described above, we can do a smaller tpm_chip_shutdown() that the
> > drivers that need it (2.0 or susceptible to issues if reset in the
> > middle of command) can call.
> > I'll do it, if it sounds like the right plan to you.
> 
> Yes please..
> 
> Is there some way we can have the TPM core do this without requiring
> the driver to add a shutdown the struct driver?
> 
> Maybe we could put something in chip->dev->driver? Not sure..

I can play more with it. We can check in tpm_chip_register() if
chip->dev->driver->shutdown is NULL, and, if so, set it to a default
handler. Or, do register_reboot_notifier() instead, to avoid messing
with struct device_driver from tpm-chip.c. Not sure if that's a
consideration at alli - any reason not to mess with those structures?

In any case, driver->shutdown or register_reboot_notifier, if we
still export that same common tpm_shutdown for those drivers that
want to do their custom shutdown handlers and register them through
module_driver(), we should be ok.

Whatever we do, we should allow the drivers to still send
(vendor-specific) commands from their shutdown handlers.

At some point, we actually used to have a register_reboot_notifier()
in the common tpm-chip.c code to make sure that it is done during
shutdown. But it is called before .shutdown, so a driver can't do
device-specific things with the device (or it can, but through
re-implementing the common transfer routines). That's why I
switched to a solution where a driver calls this common handler
itself, when it is ready for it. Similarly to what's done for
tpm_pm_suspend/resume().

But, yes, setting a default handler through chip->dev->driver
might just be good enough.

> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
