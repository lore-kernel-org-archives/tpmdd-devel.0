From: Guenter Roeck <groeck-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: devicetree: document properties for cr50
Date: Fri, 15 Jul 2016 11:28:31 -0700
Message-ID: <CABXOdTeFcE3L_0vO+DKpQpUdoNMG=z6b34rs+tWWF6KgYtcY0A@mail.gmail.com>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <1468549218-19215-2-git-send-email-apronin@chromium.org> <CABXOdTcVcZ10c6uShN2AXUZfOuK=FESeo73Assi0sziMZJ_+Fw@mail.gmail.com>
 <20160715173107.GD109276@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160715173107.GD109276@apronin>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Douglas Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 15, 2016 at 10:31 AM, Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Thu, Jul 14, 2016 at 09:05:53PM -0700, Guenter Roeck wrote:
>> On Thu, Jul 14, 2016 at 7:20 PM, Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> > +
>> > +Required properties:
>> > +- compatible: Should be "google,cr50_spi".
>>
>> google,cr50, maybe ? The "_spi" seems redundant.
>>
>
> I believe "_spi" is warranted. It's the driver that handles the SPI
> interface for Cr50 specifically.
> But if the same firmware ever talks through a different interface (say,
> I2C), this driver will not be compatible.
>
I meant in the context of it being attached to a spi device, which
implies that it is connected through a spi bus.

Guenter

>> Also, I agree with comments from others - the term cr50 really needs
>> an explanation (Google thinks that it is a motor bike, a scanner, or a
>> coffee roaster).
>>
>
> Yes, will add a better description of what it is. My original one was
> too brief and imprecise at the same time.
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
