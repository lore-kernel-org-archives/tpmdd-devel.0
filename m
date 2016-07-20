From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 1/2] tpm: devicetree: document
	properties for cr50
Date: Wed, 20 Jul 2016 12:49:12 -0700
Message-ID: <20160720194912.GA61154@apronin>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
	<cover.1468985673.git.apronin@chromium.org>
	<5274cc806888a709c639e701dad894543885b2c9.1468985673.git.apronin@chromium.org>
	<20160720190303.GA5620@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720190303.GA5620@rob-hp-laptop>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 20, 2016 at 02:03:03PM -0500, Rob Herring wrote:
> On Tue, Jul 19, 2016 at 08:41:24PM -0700, Andrey Pronin wrote:

Hi Rob,

> As I mentioned, there may be common properties. It doesn't seem you 
> looked, so I did:
> 
> - spi-rx-delay-us  - (optional) Microsecond delay after a read transfer.
> - spi-tx-delay-us  - (optional) Microsecond delay after a write transfer.
> 
> Seems to me setting one or both of these should work for you.
>

Yes, good catch, my fault I didn't see those.
But they are not exactly what I mean and need. I don't need delay after
each read or write transfer. What is needed is a guaranteed time
between transfers.

So, if the next transaction doesn't come withing the next X ms (or us),
we don't waste time on inserting a delays after this transaction at all.
Following the description and always inserting a delay must work well
for short microseconds-long delays. For longer milliseconds-long delays
a different strategy of checking the time when the previous transaction
was and only delaying if it was not too long ago is better.

Thus, I won't be able to re-use these properties anyways based on their
current description in bindings/spi/spi-bus.txt.

> > +- sleep-delay-ms: Time after the last SPI activity, after which the chip
> > +  may go to sleep.
> > +- wake-start-delay-ms: Time after initiating wake up before the chip is
> > +  ready to accept commands over SPI.
> 
> I also asked why these 2 can't be hard-coded in the driver?
>

Sorry, I just updated this patch description in v2 to indicate why they are not
hard-coded, but didn't answer explicitly. As the firmware changes, a different
revision of it can have a different time before it sleeps in its configuration,
or the time it takes it to startup may be different. Thus, there's a way to
set it here w/o changing the driver.

Andrey

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
