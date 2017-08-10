From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] Do not disable driver and bus shutdown hook when class
 shutdown hook is set.
Date: Thu, 10 Aug 2017 10:30:57 -0600
Message-ID: <20170810163057.GA21485@obsidianresearch.com>
References: <20170809213420.2391-1-msuchanek@suse.de>
 <20170809215202.GA21867@obsidianresearch.com>
 <20170810121811.2741dccc@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170810121811.2741dccc@kitsune.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 10, 2017 at 12:18:11PM +0200, Michal Suchánek wrote:
> > The bus disables the driver callback, on the expectation that the bus
> > implementation will do it.
> 
> Which is totally sound design not prone to errors.

Well, I agree it isn't the easiest...

> > Existing bus implementations do properly chain to driver shutdown (eg
> > look at mmc_bus_shutdown) and it appears to have been written like
> 
> Neither isa nor ibmebus does. These are two random buses I tried to
> look at.

I'm not following, I see this:

static void ibmebus_bus_device_shutdown(struct device *dev)
{
        struct platform_device *of_dev = to_platform_device(dev);
        struct platform_driver *drv = to_platform_driver(dev->driver);

        if (dev->driver && drv->shutdown)
                drv->shutdown(of_dev);
}

It looks to me like in this case the struct device_driver shutdown is
not used, and instead the struct platform_driver shutdown is called.

> > this so that the bus can insert code before and after calling the
> > driver shutdown.
> 
> So basically there is bus pre-shutdown and post-shutdown hook jumbled
> together in one function.

and a redirect, apparently.

> While I can understand the concept of post-shutdown hook I wonder
> what gross hack would require a pre-shutdown hook.

TPM requires pre-shutdown. It fences off access to the TPM so the TPM
can have a clean shutdown. We cannot do a clean TPM shutdown if there
is a possibility of another transaction being send to the TPM. TPM's
have non-volatile state and record if they were not shut down
properly, so doing this is actually quite important.

> The Linux development process at its best. There is poor design
> implemented so when touching the code it is extended to worse because

I'm not sure I completely agree, there is obviously a lot going on with
bus->shutdown.

If you want to go ahead with your patch then please also rename the
class shutdown to shutdown_pre to make it clear it is doing something
different.

> it is smaller patch more likely to get past maintainers than fixing the
> mess.

Yes, this is probably true, the TPM fix needed to be back ported to -stable.

Jason
