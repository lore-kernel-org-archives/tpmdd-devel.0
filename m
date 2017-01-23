From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Mon, 23 Jan 2017 12:02:46 -0800
Message-ID: <20170123200246.GA63214@apronin>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
	<20170117205933.GA9604@obsidianresearch.com>
	<20170117230053.GA16227@apronin>
	<20170117232207.GA12127@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117232207.GA12127-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, Jan 17, 2017 at 04:22:07PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 17, 2017 at 03:00:53PM -0800, Andrey Pronin wrote:
> 
> > Here I was talking not about tpm_tis_spi or tpm_tis. Those can
> > continue relying on the core, or register the default handler using
> > .shutdown = tpm_shutdown.  I'm talking about the driver like
> > tpm_i2c_infineon, which although uses the core, is created for a
> > specific family of chips. So, it can assume that it needs to send
> > vendor-specific commands.
> 
> But this is exactly what I'm talking about, infineon chips come in
> lots of interface types, and if their legacy i2c interface need a
> vendor command then likely their chips that use a common interface do
> as well.
> 
> Conflating interface and bus is something I have been ripping out over
> the years..
> 

Thanks, Jason. OK, I'll try to follow that path then with my patches.

> > > So, the core should detect chip XYZ and then issue the required
> > > vendor-specific command in some way.
> > 
> > Do I get it right that you propose to create this new core tpm
> > mechanism for handling shutdowns? I didn't find anything that'd
> > allow to call vendor-specifc hooks from the core during shutdown,
> > but may be I'm missing something.
> 
> It would be simple to add to the core path:
> 
> if (chip->id == 1234)
>     tpm_vendor_1234_shutdown(...);
> 
> We don't need to involve the driver in this. If it becomes a very
> complex thing down then road then we may need *bus* and *chip*
> drivers, but for now the 'chip' driver(s) are just inlined in the core
> code..
> 
> But if there is no actual need to do this right now then don't worry
> about overdesigning things..

OK, I can live with chip->id specific logic in probe/shutdown, if that's
the current approach.

> 
> > > Probably the *best* thing would be to add shutdown to 'struct class'
> > > in the driver core like suspend/resume?
> > 
> > Yes, if that could be added to struct class, and then device_shutdown()
> > would call the class suspend, if the driver suspend is NULL, that'd
> > solve it.
> 
> Won't know if it is possible until someone sends a patch to Greg/etc :)
> 
> > Then the core can register the default shutdown in class, and an
> > individual access driver can override it by registering its own
> > shutdown callback. Still, due to the ordering issues discussed
> > above, it should be either/or, not first-driver-then-class, if both
> > exist.
> 
> First class then driver is the usual model, which is OK for TPM.

If "first class then driver", then the already existing
register_reboot_notifier() can play the role of the class handler,
since those hooks are called before drivers' shutdown handlers.

> 
> > So, we still need to export the common tpm_shutdown().
> 
> No need to export if no driver is calling it, like I said don't
> overdesign here, it is trivial to change if someone needs to do
> something different later.
> 

So, I started putting together an alternative patch (decided to go
with a new patch instead of a new version for this one, since it's
no longer limited to Infineon driver). The new patch is just going
to do the following
	down_write(&chip->ops_sem);
	if (chip->ops) {
		if (chip->flags & TPM_CHIP_FLAG_TPM2)
			tpm2_shutdown(chip, TPM2_SU_CLEAR);
		chip->ops = NULL;
	}
	up_write(&chip->ops_sem);
on shutdown in registered "reboot notifier".

I went through the places that access chip->ops to see what's
going on at the moment with protecting them with tpm_try_get_ops().
Here is the current state:

 - tpm_transmit/tpm_transmit_cmd. Not exported and are only called
   by the core after tpm_try_get_ops() except for one place in
   sysfs - pubek_show().

 - sysfs also directly accesses chip->ops in cancel_store(), but
   that routine doesn't seem to be used anywhere. Shall it be
   just removed?

 - tpm_get_timeouts. Besides the core is called by xen-tpmfront,
   but before tpm_chip_register(), so no harm possible as of now.

 - wait_for_tpm_stat. Besides the core is called by xen-tpmfront.
   It is called from inside chip->ops handlers only, which presumably
   can happen only when the ops_sem is hold (once sysfs is fixed).

 - st33zp24 has it's own wait_for_stat() function that goes directly
   to chip->ops. It happens inside chip->ops->recv/send (as for Xen),
   which is fine. And also inside its resume handler, which is fine
   as long as resume can never happen after shutdown (I believe it's
   true).

So, if I add going through tpm_try_get_ops() to pubek_show and
delete cancel_store(), that'll fix sysfs, and be enough for the things
to work for now.

But it looks a bit brittle. So, before I submit my next patch:
Do you think it's ok to leave wait_for_tpm_stat() and
tpm_get_timeouts() and just continue be mindful when using those
low-level functions? Or, shall we instead move acquiring ops_sem
and checking for ops == NULL inside those low-level functions:
tpm_transmit, wait_for_tpm_stat, tpm_get_timeout. It then should
probably be separated from get_device(), which can be kept inside
tpm_try_get_ops().

> > to start with that: create and export the common tpm_shutdown() from
> > the core, that send Shutdown(CLEAR) for 2.0 and null-ifies chip->ops
> > (and fix sysfs to acquire chip->ops_sem) and let the interested drivers
> > call it.
> 
> I think you should do this and use the reboot_notifier or
> class->shutdown approach
> 
> I'm not completely sure why you are worrying about sending a
> vendor-specific command at shutdown. Do you actually need that?
>

Yes, I do need that to send sleep-control vendor commands to the
device in my case during shutdown (as well as suspend and resume).
It makes much more sense to send them using tpm_transfer_cmd, which
relies on chip->ops, than reimplementing the same functionality in
the device driver.

Again, I can live with "if (chip->id == 1234)" logic in core to
achieve that for now, if that's the chosen course. (Or, just
register a device-specific "reboot notifier" with lower priority
to be called before the "class-level" shutdown logic.)

> 
> Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
