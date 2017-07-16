From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 RESEND 1/2] Documentation: tpm: add
 powered-while-suspended binding documentation
Date: Sun, 16 Jul 2017 14:23:58 +0300
Message-ID: <1500204238.8397.3.camel@linux.intel.com>
References: <20170627102724.23861-1-enric.balletbo@collabora.com>
         <20170703125735.dsrl6bs7ttj27zrt@linux.intel.com>
         <CAPz6YkWN8jQcJdah8wqM+O-5ST+eZ1qpzQvGerXX_u1Tm6soFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPz6YkWN8jQcJdah8wqM+O-5ST+eZ1qpzQvGerXX_u1Tm6soFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Guenter Roeck <groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-07-05 at 10:19 -0700, Sonny Rao wrote:
> On Mon, Jul 3, 2017 at 5:57 AM, Jarkko Sakkinen
> <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > On Tue, Jun 27, 2017 at 12:27:23PM +0200, Enric Balletbo i Serra
> > wrote:
> > > Add a new powered-while-suspended property to control the
> > > behavior of the
> > > TPM suspend/resume.
> > > 
> > > Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.c
> > > om>
> > > Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > > Changes since v3.
> > >   - Rebased on top of linux-next
> > >  Rob Herring
> > >   - Split DT binding from code patch as is preferred.
> > > 
> > > Did not exist on previous versions.
> > > 
> > >  Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt | 6
> > > ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-
> > > i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-
> > > i2c.txt
> > > index 8cb638b..85c8216 100644
> > > --- a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> > > +++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> > > @@ -8,6 +8,12 @@ Required properties:
> > >                     the firmware event log
> > >  - linux,sml-size : size of the memory allocated for the firmware
> > > event log
> > > 
> > > +Optional properties:
> > > +
> > > +- powered-while-suspended: present when the TPM is left powered
> > > on between
> > > +                           suspend and resume (makes the
> > > suspend/resume
> > > +                           callbacks do nothing).
> > > +
> > >  Example (for OpenPower Systems with Nuvoton TPM 2.0 on I2C)
> > >  ----------------------------------------------------------
> > > 
> > > --
> > > 2.9.3
> > > 
> > 
> > So... should I apply this?
> 
> Hi, since you applied the code part, it would make sense to apply the
> documentation too.
> 
> > 
> > /Jarkko

Applied. Sorry for the delay.

/Jarkko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
