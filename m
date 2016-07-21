From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm: devicetree: document properties for cr50
Date: Thu, 21 Jul 2016 16:03:12 -0500
Message-ID: <20160721210312.GA10605@rob-hp-laptop>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <cover.1468985673.git.apronin@chromium.org>
 <5274cc806888a709c639e701dad894543885b2c9.1468985673.git.apronin@chromium.org>
 <20160720190303.GA5620@rob-hp-laptop>
 <20160720194912.GA61154@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720194912.GA61154@apronin>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 20, 2016 at 12:49:12PM -0700, Andrey Pronin wrote:
> On Wed, Jul 20, 2016 at 02:03:03PM -0500, Rob Herring wrote:
> > On Tue, Jul 19, 2016 at 08:41:24PM -0700, Andrey Pronin wrote:
> 
> Hi Rob,
> 
> > As I mentioned, there may be common properties. It doesn't seem you 
> > looked, so I did:
> > 
> > - spi-rx-delay-us  - (optional) Microsecond delay after a read transfer.
> > - spi-tx-delay-us  - (optional) Microsecond delay after a write transfer.
> > 
> > Seems to me setting one or both of these should work for you.
> >
> 
> Yes, good catch, my fault I didn't see those.
> But they are not exactly what I mean and need. I don't need delay after
> each read or write transfer. What is needed is a guaranteed time
> between transfers.
> 
> So, if the next transaction doesn't come withing the next X ms (or us),
> we don't waste time on inserting a delays after this transaction at all.
> Following the description and always inserting a delay must work well
> for short microseconds-long delays. For longer milliseconds-long delays
> a different strategy of checking the time when the previous transaction
> was and only delaying if it was not too long ago is better.

I'd guess that the intent is the same for all. A simple delay is 
just much easier to implement. I would think implementing the more 
sophisticated algorithm would work for all users. Perhaps with some 
threshold for a simple delay.

> Thus, I won't be able to re-use these properties anyways based on their
> current description in bindings/spi/spi-bus.txt.
> 
> > > +- sleep-delay-ms: Time after the last SPI activity, after which the chip
> > > +  may go to sleep.
> > > +- wake-start-delay-ms: Time after initiating wake up before the chip is
> > > +  ready to accept commands over SPI.
> > 
> > I also asked why these 2 can't be hard-coded in the driver?
> >
> 
> Sorry, I just updated this patch description in v2 to indicate why they are not
> hard-coded, but didn't answer explicitly. As the firmware changes, a different
> revision of it can have a different time before it sleeps in its configuration,
> or the time it takes it to startup may be different. Thus, there's a way to
> set it here w/o changing the driver.

The firmware and DT may not be updated in sync especially if you are 
loading the firmware from the rootfs. Are you doing DT and firmware 
updates without changing the kernel?

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
