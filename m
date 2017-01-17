From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
 commands on shutdown
Date: Tue, 17 Jan 2017 13:59:33 -0700
Message-ID: <20170117205933.GA9604@obsidianresearch.com>
References: <20170114000954.17728-1-apronin@chromium.org>
	<20170114002857.GA5851@obsidianresearch.com>
	<20170114004230.GA21035@apronin>
	<20170116161919.GA20238@obsidianresearch.com>
	<20170117175827.GA124090@apronin>
	<20170117192728.GF27528@obsidianresearch.com>
	<20170117201336.GA140854@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117201336.GA140854@apronin>
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

On Tue, Jan 17, 2017 at 12:13:36PM -0800, Andrey Pronin wrote:
> > Is there some way we can have the TPM core do this without requiring
> > the driver to add a shutdown the struct driver?
> > 
> > Maybe we could put something in chip->dev->driver? Not sure..
> 
> I can play more with it. We can check in tpm_chip_register() if
> chip->dev->driver->shutdown is NULL, and, if so, set it to a default
> handler. Or, do register_reboot_notifier() instead, to avoid messing
> with struct device_driver from tpm-chip.c. Not sure if that's a
> consideration at alli - any reason not to mess with those structures?

I think ordering is important here, the TPM core has to do any
shutdown before the driver shutdown method. That restriction might
entirely preclude using a reboot_notifier.

> Whatever we do, we should allow the drivers to still send
> (vendor-specific) commands from their shutdown handlers.

A vendor specific command should be done via a new core TPM
mechanism. I really want to keep access drivers (eg i2c, lpc, spi,
etc) out of the buisness of *assuming* they are connected to any
specific chip.

So, the core should detect chip XYZ and then issue the required
vendor-specific command in some way.

The driver shutdown would be used to close the access interface in
some way.

> But, yes, setting a default handler through chip->dev->driver
> might just be good enough.

Probably the *best* thing would be to add shutdown to 'struct class'
in the driver core like suspend/resume?

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
