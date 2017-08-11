From: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Subject: Re: [PATCH] Do not disable driver and bus shutdown hook when class
 shutdown hook is set.
Date: Fri, 11 Aug 2017 07:04:03 +0200
Message-ID: <25eaf1ea1d44f7950dbca6b3c4598c48@suse.de>
References: <20170809213420.2391-1-msuchanek@suse.de>
 <20170809215202.GA21867@obsidianresearch.com>
 <20170810121811.2741dccc@kitsune.suse.cz>
 <20170810163057.GA21485@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170810163057.GA21485@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 2017-08-10 18:30, Jason Gunthorpe wrote:
> On Thu, Aug 10, 2017 at 12:18:11PM +0200, Michal Suchánek wrote:

>> > Existing bus implementations do properly chain to driver shutdown (eg
>> > look at mmc_bus_shutdown) and it appears to have been written like
>> 
>> Neither isa nor ibmebus does. These are two random buses I tried to
>> look at.
> 
> I'm not following, I see this:
> 
> static void ibmebus_bus_device_shutdown(struct device *dev)
> {
>         struct platform_device *of_dev = to_platform_device(dev);
>         struct platform_driver *drv = to_platform_driver(dev->driver);
> 
>         if (dev->driver && drv->shutdown)
>                 drv->shutdown(of_dev);
> }
> 
> It looks to me like in this case the struct device_driver shutdown is
> not used, and instead the struct platform_driver shutdown is called.

And it is not used even if a device driver sets it and expects it to 
run.

> 
>> > this so that the bus can insert code before and after calling the
>> > driver shutdown.
>> 
>> So basically there is bus pre-shutdown and post-shutdown hook jumbled
>> together in one function.
> 
> and a redirect, apparently.
> 
>> While I can understand the concept of post-shutdown hook I wonder
>> what gross hack would require a pre-shutdown hook.
> 
> TPM requires pre-shutdown.

Yes, a class pre-shutdown. Not a bus pre-shutdown, however.

I have no idea what business has a bus driver before a device shuts 
down.

> 
>> The Linux development process at its best. There is poor design
>> implemented so when touching the code it is extended to worse because
> 
> I'm not sure I completely agree, there is obviously a lot going on with
> bus->shutdown.
> 
> If you want to go ahead with your patch then please also rename the
> class shutdown to shutdown_pre to make it clear it is doing something
> different.

That makes sense.

Thanks

Michal
