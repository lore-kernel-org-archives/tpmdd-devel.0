From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] Do not disable driver and bus shutdown hook when class
 shutdown hook is set.
Date: Fri, 11 Aug 2017 14:50:56 +0300
Message-ID: <20170811115056.oegv6ziahja56cp4@linux.intel.com>
References: <20170809213420.2391-1-msuchanek@suse.de>
 <20170809215202.GA21867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170809215202.GA21867@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michal Suchanek <msuchanek@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Aug 09, 2017 at 03:52:02PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 09, 2017 at 11:34:20PM +0200, Michal Suchanek wrote:
> > Disabling the driver hook by setting class hook is totally sound design
> > not prone to error as evidenced by the single implementation of the
> > class hook.
> 
> It was done this was for consistency, if you look at the full code:
> 
>                 if (dev->class && dev->class->shutdown) {
>                         if (initcall_debug)
>                                 dev_info(dev, "shutdown\n");
>                         dev->class->shutdown(dev);
>                 } else if (dev->bus && dev->bus->shutdown) {
>                         if (initcall_debug)
>                                 dev_info(dev, "shutdown\n");
>                         dev->bus->shutdown(dev);
>                 } else if (dev->driver && dev->driver->shutdown) {
>                         if (initcall_debug)
>                                 dev_info(dev, "shutdown\n");
>                         dev->driver->shutdown(dev);
>                 }
> 
> The bus disables the driver callback, on the expectation that the bus
> implementation will do it.
> 
> Existing bus implementations do properly chain to driver shutdown (eg
> look at mmc_bus_shutdown) and it appears to have been written like
> this so that the bus can insert code before and after calling the
> driver shutdown.
> 
> Making class act differently from bus seems very confusing, IHMO,
> which why the TPM patch was written to follow the existing pattern.
> 
> Jason

There's also more fundamental problem. There are Fixes tags but no
real regression. Even if this patch made sense I would not consider
it as a bug fix.

/Jarkko
