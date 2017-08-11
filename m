From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [PATCH] Do not disable driver and bus shutdown hook when class
 shutdown hook is set.
Date: Fri, 11 Aug 2017 19:01:02 +0200
Message-ID: <20170811190102.1e26c51a@kitsune.suse.cz>
References: <20170809213420.2391-1-msuchanek@suse.de>
        <20170809215202.GA21867@obsidianresearch.com>
        <20170810121811.2741dccc@kitsune.suse.cz>
        <20170810163057.GA21485@obsidianresearch.com>
        <25eaf1ea1d44f7950dbca6b3c4598c48@suse.de>
        <20170811152857.cgjvlkiilskv76o3@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170811152857.cgjvlkiilskv76o3@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 11 Aug 2017 12:28:57 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Fri, 11 Aug 2017, Michal Suchánek wrote:
> > On 2017-08-10 18:30, Jason Gunthorpe wrote:  
> > > On Thu, Aug 10, 2017 at 12:18:11PM +0200, Michal Suchánek wrote:  
> > > > > Existing bus implementations do properly chain to driver
> > > > > shutdown (eg look at mmc_bus_shutdown) and it appears to have
> > > > > been written like  
> > > > 
> > > > Neither isa nor ibmebus does. These are two random buses I
> > > > tried to look at.  
> > > 
> > > I'm not following, I see this:
> > > 
> > > static void ibmebus_bus_device_shutdown(struct device *dev)
> > > {
> > >         struct platform_device *of_dev = to_platform_device(dev);
> > >         struct platform_driver *drv =
> > > to_platform_driver(dev->driver);
> > > 
> > >         if (dev->driver && drv->shutdown)
> > >                 drv->shutdown(of_dev);
> > > }
> > > 
> > > It looks to me like in this case the struct device_driver
> > > shutdown is not used, and instead the struct platform_driver
> > > shutdown is called.  
> > 
> > And it is not used even if a device driver sets it and expects it
> > to run.  
> 
> Which is the kind of landmine it is best avoided in drivers/, so it
> would be nice to get WARN_ON() during device register when
> dev->shutdown() methods *that are going to be ignored* because of
> class/bus handlers are non-NULL...

We actually have the warning:

int driver_register(struct device_driver *drv)
{
        int ret;
        struct device_driver *other;

        BUG_ON(!drv->bus->p);

        if ((drv->bus->probe && drv->probe) ||
            (drv->bus->remove && drv->remove) ||
            (drv->bus->shutdown && drv->shutdown))
                printk(KERN_WARNING "Driver '%s' needs updating -
        please use " "bus_type methods\n", drv->name);

So presumably setting both bus and driver shutdown is bogus while
setting both class and bus shutdown is fine and expected. So the logic
in the initial class shutdown addition that disables driver and
bus shutdown is bogus - there is no reason to disable them.

Given that nobody pointed out this shows how well understood this
interface is :/

Thanks

Michal
