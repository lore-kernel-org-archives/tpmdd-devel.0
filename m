From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Tue, 17 Jan 2017 15:00:53 -0800
Message-ID: <20170117230053.GA16227@apronin>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
	<20170117205933.GA9604@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117205933.GA9604-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, Jan 17, 2017 at 01:59:33PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2017 at 12:13:36PM -0800, Andrey Pronin wrote:
> > > Is there some way we can have the TPM core do this without requiring
> > > the driver to add a shutdown the struct driver?
> > > 
> > > Maybe we could put something in chip->dev->driver? Not sure..
> > 
> > I can play more with it. We can check in tpm_chip_register() if
> > chip->dev->driver->shutdown is NULL, and, if so, set it to a default
> > handler. Or, do register_reboot_notifier() instead, to avoid messing
> > with struct device_driver from tpm-chip.c. Not sure if that's a
> > consideration at alli - any reason not to mess with those structures?
> 
> I think ordering is important here, the TPM core has to do any
> shutdown before the driver shutdown method. That restriction might
> entirely preclude using a reboot_notifier.

Actually, reboot_notifier is called before the driver shutdown method,
so if TPM core registers it, it does its thing first.

However, if the driver wants to send vendor-specific commands (using
tpm_send to avoid re-implementing tpm_transmit_cmd on its side), it
actually wants to do it in the following order:
1) Send vendor specific commands.
2) Call common tpm_shutdown to send Shutdown(CLEAR) and prevent further
access to the device.
3) Close the low-level interface in the device-specific way, if/as
needed.
And for this sequence reboot_notifier gets in the way.

So, I'd still allow the driver to explicitly call tpm_shutdown from
its shutdown handler, or signal to tpm_tis_core that it wants the
default handler - either by leaving .shutdown = NULL, or, for example,
by setting a new flag in tpm_tis_data.

> 
> > Whatever we do, we should allow the drivers to still send
> > (vendor-specific) commands from their shutdown handlers.
> 
> A vendor specific command should be done via a new core TPM
> mechanism. I really want to keep access drivers (eg i2c, lpc, spi,
> etc) out of the buisness of *assuming* they are connected to any
> specific chip.
>

Here I was talking not about tpm_tis_spi or tpm_tis. Those can
continue relying on the core, or register the default handler using
.shutdown = tpm_shutdown.
I'm talking about the driver like tpm_i2c_infineon, which although
uses the core, is created for a specific family of chips. So, it
can assume that it needs to send vendor-specific commands.

> So, the core should detect chip XYZ and then issue the required
> vendor-specific command in some way.
> 

Do I get it right that you propose to create this new core tpm
mechanism for handling shutdowns? I didn't find anything that'd
allow to call vendor-specifc hooks from the core during shutdown,
but may be I'm missing something.

> The driver shutdown would be used to close the access interface in
> some way.
> 
> > But, yes, setting a default handler through chip->dev->driver
> > might just be good enough.
> 
> Probably the *best* thing would be to add shutdown to 'struct class'
> in the driver core like suspend/resume?
>

Yes, if that could be added to struct class, and then device_shutdown()
would call the class suspend, if the driver suspend is NULL, that'd
solve it. Then the core can register the default shutdown in class,
and an individual access driver can override it by registering its own
shutdown callback. Still, due to the ordering issues discussed above,
it should be either/or, not first-driver-then-class, if both exist.

So, we still need to export the common tpm_shutdown(). So, I'd suggest
to start with that: create and export the common tpm_shutdown() from
the core, that send Shutdown(CLEAR) for 2.0 and null-ifies chip->ops
(and fix sysfs to acquire chip->ops_sem) and let the interested drivers
call it. If we end up with having class shutdown, we can also register
the default handler through that mechanism. For now, we may or may not
register the default callback from core through register_reboot_notifier
iff chip->dev->driver->shutdown == NULL. That can be debated further.

WDYT?

Andrey

> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
