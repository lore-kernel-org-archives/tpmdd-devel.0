From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Tue, 17 Jan 2017 16:22:07 -0700
Message-ID: <20170117232207.GA12127@obsidianresearch.com>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
	<20170117205933.GA9604@obsidianresearch.com>
	<20170117230053.GA16227@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117230053.GA16227@apronin>
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

On Tue, Jan 17, 2017 at 03:00:53PM -0800, Andrey Pronin wrote:

> Here I was talking not about tpm_tis_spi or tpm_tis. Those can
> continue relying on the core, or register the default handler using
> .shutdown = tpm_shutdown.  I'm talking about the driver like
> tpm_i2c_infineon, which although uses the core, is created for a
> specific family of chips. So, it can assume that it needs to send
> vendor-specific commands.

But this is exactly what I'm talking about, infineon chips come in
lots of interface types, and if their legacy i2c interface need a
vendor command then likely their chips that use a common interface do
as well.

Conflating interface and bus is something I have been ripping out over
the years..

> > So, the core should detect chip XYZ and then issue the required
> > vendor-specific command in some way.
> 
> Do I get it right that you propose to create this new core tpm
> mechanism for handling shutdowns? I didn't find anything that'd
> allow to call vendor-specifc hooks from the core during shutdown,
> but may be I'm missing something.

It would be simple to add to the core path:

if (chip->id == 1234)
    tpm_vendor_1234_shutdown(...);

We don't need to involve the driver in this. If it becomes a very
complex thing down then road then we may need *bus* and *chip*
drivers, but for now the 'chip' driver(s) are just inlined in the core
code..

But if there is no actual need to do this right now then don't worry
about overdesigning things..

> > Probably the *best* thing would be to add shutdown to 'struct class'
> > in the driver core like suspend/resume?
> 
> Yes, if that could be added to struct class, and then device_shutdown()
> would call the class suspend, if the driver suspend is NULL, that'd
> solve it.

Won't know if it is possible until someone sends a patch to Greg/etc :)

> Then the core can register the default shutdown in class, and an
> individual access driver can override it by registering its own
> shutdown callback. Still, due to the ordering issues discussed
> above, it should be either/or, not first-driver-then-class, if both
> exist.

First class then driver is the usual model, which is OK for TPM.

> So, we still need to export the common tpm_shutdown().

No need to export if no driver is calling it, like I said don't
overdesign here, it is trivial to change if someone needs to do
something different later.

> to start with that: create and export the common tpm_shutdown() from
> the core, that send Shutdown(CLEAR) for 2.0 and null-ifies chip->ops
> (and fix sysfs to acquire chip->ops_sem) and let the interested drivers
> call it.

I think you should do this and use the reboot_notifier or
class->shutdown approach

I'm not completely sure why you are worrying about sending a
vendor-specific command at shutdown. Do you actually need that?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
