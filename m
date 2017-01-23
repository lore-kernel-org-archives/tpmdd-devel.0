From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Mon, 23 Jan 2017 13:39:01 -0700
Message-ID: <20170123203901.GA13029@obsidianresearch.com>
References: <20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
	<20170117205933.GA9604@obsidianresearch.com>
	<20170117230053.GA16227@apronin>
	<20170117232207.GA12127@obsidianresearch.com>
	<20170123200246.GA63214@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170123200246.GA63214@apronin>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, semenzato-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 12:02:46PM -0800, Andrey Pronin wrote:

> > But if there is no actual need to do this right now then don't worry
> > about overdesigning things..
> 
> OK, I can live with chip->id specific logic in probe/shutdown, if that's
> the current approach.

It is where we are heading.. If it becomes prevelent we will need chip
and bus drivers.

> > First class then driver is the usual model, which is OK for TPM.
> 
> If "first class then driver", then the already existing
> register_reboot_notifier() can play the role of the class handler,
> since those hooks are called before drivers' shutdown handlers.

Okay.. But maybe fire off patch doing this via the device code, as if
that is accepted it is better than the reboot handler in terms of
guaranteeing ordering/etc.

> 	down_write(&chip->ops_sem);
> 	if (chip->ops) {
> 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> 			tpm2_shutdown(chip, TPM2_SU_CLEAR);
> 		chip->ops = NULL;
> 	}
> 	up_write(&chip->ops_sem);
> on shutdown in registered "reboot notifier".

Sure, seems like a good starting point.

> I went through the places that access chip->ops to see what's
> going on at the moment with protecting them with tpm_try_get_ops().
> Here is the current state:
> 
>  - tpm_transmit/tpm_transmit_cmd. Not exported and are only called
>    by the core after tpm_try_get_ops() except for one place in
>    sysfs - pubek_show().

Most of sysfs calls functions like tpm_pcr_read_dev, tpm_getcap, etc,
etc that boil down the tpm_transmit_cmd, so many more need it than you
listed.

> But it looks a bit brittle. So, before I submit my next patch:
> Do you think it's ok to leave wait_for_tpm_stat() and
> tpm_get_timeouts() and just continue be mindful when using those
> low-level functions?

For xenfront we should someday move it to use TPM_OPS_AUTO_STARTUP and
drop the tpm_get_timeouts.

I think it is fine to leave those two low level commands as is..

Like I said, it would be more robust to acquire a lock directly in
places like transmit_cmd, but I suspect that is too hard to retrofit
at this time...

> and checking for ops == NULL inside those low-level functions:
> tpm_transmit, wait_for_tpm_stat, tpm_get_timeout. It then should
> probably be separated from get_device(), which can be kept inside
> tpm_try_get_ops().

No sense checking for ops=null if you also can't guarentee the lock is
held, it is just confusing.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
