From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH] Do not disable driver and bus shutdown hook when class
 shutdown hook is set.
Date: Thu, 10 Aug 2017 12:18:11 +0200
Message-ID: <20170810121811.2741dccc@kitsune.suse.cz>
References: <20170809213420.2391-1-msuchanek@suse.de>
        <20170809215202.GA21867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170809215202.GA21867@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 9 Aug 2017 15:52:02 -0600
Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Wed, Aug 09, 2017 at 11:34:20PM +0200, Michal Suchanek wrote:
> > Disabling the driver hook by setting class hook is totally sound
> > design not prone to error as evidenced by the single implementation
> > of the class hook.  
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

Which is totally sound design not prone to errors.

> 
> Existing bus implementations do properly chain to driver shutdown (eg
> look at mmc_bus_shutdown) and it appears to have been written like

Neither isa nor ibmebus does. These are two random buses I tried to
look at.

> this so that the bus can insert code before and after calling the
> driver shutdown.

So basically there is bus pre-shutdown and post-shutdown hook jumbled
together in one function. While I can understand the concept of
post-shutdown hook I wonder what gross hack would require a
pre-shutdown hook.

> 
> Making class act differently from bus seems very confusing, IHMO,
> which why the TPM patch was written to follow the existing pattern.

The Linux development process at its best. There is poor design
implemented so when touching the code it is extended to worse because
it is smaller patch more likely to get past maintainers than fixing the
mess.

If you argue the existing way is the best could you please give an
actual technical argument for implementing the hooks this way?

Thanks

Michal
