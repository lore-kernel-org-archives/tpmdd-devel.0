From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3] tpm: do not suspend/resume if power stays on
Date: Tue, 7 Mar 2017 20:52:20 +0200
Message-ID: <20170307185220.ag3hkthzeskg7le6@intel.com>
References: <20170303160959.27422-1-enric.balletbo@collabora.com>
 <20170306205925.ynkwmy7acsunpewd@intel.com>
 <15829d71-ceff-d1f6-3112-5df8897a97dc@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <15829d71-ceff-d1f6-3112-5df8897a97dc-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 07, 2017 at 09:44:55AM +0100, Enric Balletbo i Serra wrote:
> Hi Jarkko,
> 
> On 06/03/17 21:59, Jarkko Sakkinen wrote:
> > On Fri, Mar 03, 2017 at 05:09:59PM +0100, Enric Balletbo i Serra wrote:
> >> From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >>
> >> The suspend/resume behavior of the TPM can be controlled by setting
> >> "powered-while-suspended" in the DTS. This is useful for the cases
> >> when hardware does not power-off the TPM.
> >>
> >> Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> >> ---
> >> Changes since v2:
> >>  Jarkko Sakkinen
> >>   - Add a new TPM_CHIP_FLAG_ALWAYS_POWERED flag instead of using a boolean variable.
> >>   - Remove a trailing newline.
> >> Changes since v1:
> >>  Jason Gunthorpe :
> >>   - Move the code to handle suspend/resume in the common chip code.
> >>
> >>  Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt | 6 ++++++
> >>  drivers/char/tpm/tpm-interface.c                           | 3 +++
> >>  drivers/char/tpm/tpm.h                                     | 1 +
> >>  drivers/char/tpm/tpm_of.c                                  | 3 +++
> >>  4 files changed, 13 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> >> index 8cb638b..85c8216 100644
> >> --- a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> >> +++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
> >> @@ -8,6 +8,12 @@ Required properties:
> >>                     the firmware event log
> >>  - linux,sml-size : size of the memory allocated for the firmware event log
> >>  
> >> +Optional properties:
> >> +
> >> +- powered-while-suspended: present when the TPM is left powered on between
> >> +                           suspend and resume (makes the suspend/resume
> >> +                           callbacks do nothing).
> >> +
> >>  Example (for OpenPower Systems with Nuvoton TPM 2.0 on I2C)
> >>  ----------------------------------------------------------
> > 
> > Hey, just noticed something. Shouldn't this be a separate commit?
> 
> During my life submitting patches I saw the both options, sometimes
> the maintainer asked me to join the DT patch and the driver and
> sometimes he asked me to do in different patches, so I think this is
> more a maintainer option. Maybe Rob Herring or Mark Rutland can share
> their preferences?
> 
> I'll do what you want I do, TBH I don't have a strong opinion about this.

I'll add this to my tree and put it to my next branch so that
it will flow to linux-next since it only touch TPM specific
file in bindings.

I do not have perfect answer for this so I'll use common sense
(or try to).

Rob, is this OK?

/Jarkko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
