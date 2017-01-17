From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Tue, 17 Jan 2017 09:58:27 -0800
Message-ID: <20170117175827.GA124090@apronin>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170116161919.GA20238-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Mon, Jan 16, 2017 at 09:19:19AM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 13, 2017 at 04:42:30PM -0800, Andrey Pronin wrote:
> > On Fri, Jan 13, 2017 at 05:28:57PM -0700, Jason Gunthorpe wrote:
> > > On Fri, Jan 13, 2017 at 04:09:54PM -0800, Andrey Pronin wrote:
> > > > Resetting TPM while processing a command may lead to issues
> > > > on the next boot. Ensure that we don't have any ongoing
> > > > commands, and that no further commands can be sent to the chip
> > > > by unregistering the device in the shutdown handler.
> > > > tpm_chip_unregister() waits for the completion of an ongoing
> > > > command, if any, and then clears out chip->ops and unregisters
> > > > sysfs entities.
> > > 
> > > Unregistering in a shutdown handler seems very strange, it also waits
> > > for userspace things, so I wonder if it could be problematic?
> > > 
> > > Maybe just use
> > > 
> > >    down_write(&chip->ops_sem);
> > >    chip->ops = NULL;
> > >    up_write(&chip->ops_sem);
> > > 
> > > In the shutdown handler?
> > 
> > down_write(&chip->ops_sem) would still wait for completing the initiated
> > writes, since tpm_write() in tpm-dev.c calls tpm_try_get_ops().
> 
> Yes, but that is a timeout limited wait. unregister waits for sysfs
> files to be closed which is potentially unbounded.
> 
> > Yes, but it doesn't wait for sysfs
> > Also, tpm-sysfs.c calls chip->ops directly, so sysfs should be
> > unregistered first.
> 
> Yes, sorry, I should have mentioned that.. Maybe that is too much to
> fix..
> 

If we fix sysfs to go through tpm_try_get_ops, then all we can do for
shutdown is indeed something like

	down_write(&chip->ops_sem);
	if (chip->ops && chip->flags & TPM_CHIP_FLAG_TPM2)
		tpm2_shutdown(chip, TPM2_SU_CLEAR);
	chip->ops = NULL;
	up_write(&chip->ops_sem);

Does that sound like a good plan?
If we don't want sysfs to increment/decrement the reference count for
the device, we can still make it go through

	down_write(&chip->ops_sem);
	if (chip->ops) {
		...
	}
	up_write(&chip->ops_sem);


> > And the last thing, this driver supports TPM 1.2, but if it was a 2.0
> > chip, it'd also need to send TPM2_Shutdown(CLEAR) from its shutdown
> > handler (or get an unorderly shutdown and DA counter increment).
> 
> I'm confused - doesn't your system reset the TPM when it reboots?
> Isn't that required so the firmware starts with known PCRs? Doesn't
> reset trump unorderly shutdown?
> 

That's right, the TPM is reset when the system reboots. However, for
TPM 2.0, if it resets w/o Shutdown(CLEAR) first, it will detect it
during Startup, and mark as unorderly shutdown. Shutdown(CLEAR) is
the signal to the TPM to save its state to nvram and prepare to reset.
If it was not done, it is possible that something was not saved (e.g.
the DA counter), and the chip correctly marks it as a potential DA
problem.

> In any event that seems like an all-chips problem not a chip specific
> bug fix?
>
The part about TPM 2.0 Shutdown(CLEAR) above is an all-chip (actually,
all-2.0-chip) problem. The part where we prevent TPM from being reset
in the middle of a command (potentially) may or may not affect other
chips - I simply have no knowledge if it leads to issues anywhere else.

> 
> > All these things are handled by tpm_chip_unregister(). I thought about
> > creating a tpm_chip_shutdown routine that could be called from shutdown
> > handlers of the drivers that need it (and I'd do it for every driver,
> > especially in 2.0 case). But decided that it's better to reuse the
> > existing tpm_chip_unregister() that already does what's needed.
> 
> If for some reason we need this for every driver then this is probably
> a better approach - but that seems very, very strange to me.

As described above, we can do a smaller tpm_chip_shutdown() that the
drivers that need it (2.0 or susceptible to issues if reset in the
middle of command) can call.
I'll do it, if it sounds like the right plan to you.

Andrey

> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
