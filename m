From: <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] adding tpm2.0 support to nuvoton drivers
 and adding npct6xx
Date: Sun, 5 Jun 2016 04:52:56 +0000
Message-ID: <de807509be0f482983fab61b37180b3c@NTILML02.nuvoton.com>
References: <20160602140634.6ab408bc@andrew-desktop>
	<20160603083001.GA30613@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160603083001.GA30613-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

hi Jarrko ,

what does it mean "proper patch set" ?
this is patch that was created in follow way :
1)i have downloaded kernel 4.6-rc7 .
2)applied Jason's patch .
3)created git repo.
4)made my changes
5)created patch with "git format-patch master -1"

andrew

> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> Sent: Friday, 03 June, 2016 11:30
> To: IS10 Andrew Zamansky Partner
> Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org;
> gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org; IS30 Dan Morav; stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH] adding tpm2.0 support to nuvoton drivers and adding =
npct6xx
>
> On Thu, Jun 02, 2016 at 02:06:34PM +0300, andrew wrote:
> > From 401214bfbece31e3ef783f13b762da6f83d10f84 Mon Sep 17 00:00:00 2001
> > From: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> > Date: Thu, 2 Jun 2016 09:13:28 +0300
> > Subject: [PATCH] adding tpm2.0 support to nuvoton drivers and adding np=
ct6xx
> >  to device tree
> >
> > Signed-off-by: Andrew Zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> >
> > ---
> >  Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
> >  drivers/char/tpm/tpm_i2c_nuvoton.c                        | 5 +++--
> >  drivers/char/tpm/tpm_tis.c                                | 2 +-
> >  3 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > index 5398744..0a07cbc 100644
> > --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > @@ -62,6 +62,7 @@ national,lm80Serial Interface ACPI-Compatible Micropr=
ocessor
> System Hardware M
> >  national,lm85Temperature sensor with integrated fan control
> >  national,lm92=B10.33=B0C Accurate, 12-Bit + Sign Temperature Sensor an=
d Thermal
> Window Comparator with Two-Wire Interface
> >  nuvoton,npct501i2c trusted platform module (TPM)
> > +nuvoton,npct6xxi2c trusted platform module (TPM) 6xx series
> >  nxp,pca9556Octal SMBus and I2C registered interface
> >  nxp,pca95578-bit I2C-bus and SMBus I/O port with reset
> >  nxp,pcf8563Real-time clock/calendar
> > diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_=
i2c_nuvoton.c
> > index b64effc..7fb0e6c 100644
> > --- a/drivers/char/tpm/tpm_i2c_nuvoton.c
> > +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> > @@ -1,5 +1,5 @@
> >
> /*************************************************************************
> *****
> > - * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
> > + * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,
> >   * based on the TCG TPM Interface Spec version 1.2.
> >   * Specifications at www.trustedcomputinggroup.org
> >   *
> > @@ -456,7 +456,7 @@ static bool i2c_nuvoton_req_canceled(struct tpm_chi=
p *chip, u8 status)
> >  }
> >
> >  static const struct tpm_class_ops tpm_i2c =3D {
> > -.flags =3D TPM_OPS_AUTO_STARTUP,
> > +.flags =3D TPM_OPS_AUTO_STARTUP | TPM_OPS_PROBE_TPM2,
> >  .status =3D i2c_nuvoton_read_status,
> >  .recv =3D i2c_nuvoton_recv,
> >  .send =3D i2c_nuvoton_send,
> > @@ -623,6 +623,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
> >  static const struct of_device_id i2c_nuvoton_of_match[] =3D {
> >  {.compatible =3D "nuvoton,npct501"},
> >  {.compatible =3D "winbond,wpct301"},
> > +{.compatible =3D "nuvoton,npct6xx"},
> >  {},
> >  };
> >  MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index 30aff5b..bc5fba3 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -524,7 +524,7 @@ static bool tpm_tis_req_canceled(struct tpm_chip *c=
hip, u8 status)
> >  }
> >
> >  static const struct tpm_class_ops tpm_tis =3D {
> > -.flags =3D TPM_OPS_AUTO_STARTUP,
> > +.flags =3D TPM_OPS_AUTO_STARTUP  | TPM_OPS_PROBE_TPM2,
> >  .status =3D tpm_tis_status,
> >  .recv =3D tpm_tis_recv,
> >  .send =3D tpm_tis_send,
> > --
> > 1.9.1
> >
> > this patch requires Jason's latest patch
>
> Then you should create a proper patch set with a cover letter.
>
> /Jarkko


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The privileged confidential information contained in this email is intended=
 for use only by the addressees as indicated by the original sender of this=
 email. If you are not the addressee indicated in this email or are not res=
ponsible for delivery of the email to such a person, please kindly reply to=
 the sender indicating this fact and delete all copies of it from your comp=
uter and network server immediately. Your cooperation is highly appreciated=
. It is advised that any unauthorized use of confidential information of Nu=
voton is strictly prohibited; and any information in this email irrelevant =
to the official business of Nuvoton shall be deemed as neither given nor en=
dorsed by Nuvoton.

---------------------------------------------------------------------------=
---
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols ar=
e =

consuming the most bandwidth. Provides multi-vendor support for NetFlow, =

J-Flow, sFlow and other flows. Make informed decisions using capacity =

planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
