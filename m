From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 1/6] tpm: drop 'iobase' from struct
	tpm_vendor_specific
Date: Thu, 31 Mar 2016 12:48:17 +0300
Message-ID: <20160331094817.GA12189@intel.com>
References: <1459373895-17704-1-git-send-email-christophe-h.ricard@st.com>
	<1459373895-17704-2-git-send-email-christophe-h.ricard@st.com>
	<20160331064500.GB6393@intel.com>
	<CALD+uuxRKmGHoNcyOv7kSTVccFpmi6AzKxecHWPFcER=VR1zhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALD+uuxRKmGHoNcyOv7kSTVccFpmi6AzKxecHWPFcER=VR1zhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This and 3/6 had minor style issues.

If there are nothing biggger in the patch I guess I adjust the patches
myself. I'll still hold for other comments (maybe from Jason) and test
the patches.

If there are bigger reasons to fix the series then you could fix also
style issues.

/Jarkko


On Thu, Mar 31, 2016 at 10:29:11AM +0200, Christophe Ricard wrote:
>    [Resending to the mailing list]
>    Hi Jarkko,
>    I don't mind fixing:
>    WARNING: line over 80 characters
>    #465: FILE: drivers/char/tpm/tpm_tis.c:685:
>    +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 priv->iobase +
>    TPM_INT_ENABLE(chip->vendor.locality));
>    However i wonder if:
>    WARNING: macros should not use a trailing semicolon
>    #175: FILE: drivers/char/tpm/tpm_atmel.h:41:
>    +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
>    Shouldn't be fixed in a separated patch.
>    What's your preferred option ? (e.g fix this warning directly in this
>    patch or in a separate one).
>    Best Regards
>    2016-03-31 8:45 GMT+02:00 Jarkko Sakkinen
>    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> =

>      On Wed, Mar 30, 2016 at 11:38:10PM +0200, Christophe Ricard wrote:
>      > Dropped the field 'iobase' from struct tpm_vendor_specific and
>      migrated
>      > it to the private structures of tpm_atmel and tpm_tis.
> =

>      Found couple of issues:
> =

>      $ scripts/checkpatch.pl
>      ~/Downloads/v3-1-6-tpm-drop-iobase-from-struct-tpm_vendor_specific.p=
atch
>      WARNING: macros should not use a trailing semicolon
>      #175: FILE: drivers/char/tpm/tpm_atmel.h:41:
>      +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
> =

>      WARNING: line over 80 characters
>      #465: FILE: drivers/char/tpm/tpm_tis.c:685:
>      +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
> =

>      total: 0 errors, 2 warnings, 465 lines checked
>      /Jarkko
>      > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
>      > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>      > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>      > ---
>      >=C2=A0 drivers/char/tpm/tpm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A02 -
>      >=C2=A0 drivers/char/tpm/tpm_atmel.c |=C2=A0 28 +++++++-----
>      >=C2=A0 drivers/char/tpm/tpm_atmel.h |=C2=A0 =C2=A05 ++-
>      >=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0| 104
>      +++++++++++++++++++++++++------------------
>      >=C2=A0 4 files changed, 80 insertions(+), 59 deletions(-)
>      >
>      > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>      > index cd780c7..357ac14 100644
>      > --- a/drivers/char/tpm/tpm.h
>      > +++ b/drivers/char/tpm/tpm.h
>      > @@ -131,8 +131,6 @@ enum tpm2_startup_types {
>      >=C2=A0 struct tpm_chip;
>      >
>      >=C2=A0 struct tpm_vendor_specific {
>      > -=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0/* ioremapped address
>      */
>      > -
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int irq;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int locality;
>      > diff --git a/drivers/char/tpm/tpm_atmel.c
>      b/drivers/char/tpm/tpm_atmel.c
>      > index 68d5c09..b769299 100644
>      > --- a/drivers/char/tpm/tpm_atmel.c
>      > +++ b/drivers/char/tpm/tpm_atmel.c
>      > @@ -37,6 +37,7 @@ enum tpm_atmel_read_status {
>      >
>      >=C2=A0 static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, siz=
e_t
>      count)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip->vendor.=
priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status, *hdr =3D buf;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 size;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      > @@ -47,12 +48,12 @@ static int tpm_atml_recv(struct tpm_chip *chip=
, u8
>      *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < 6; i++) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread=
8(chip->vendor.iobase + 1);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread=
8(priv->iobase + 1);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((status =
& ATML_STATUS_DATA_AVAIL) =3D=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0dev_err(&chip->dev, "error reading
>      header\n");
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return -EIO;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread=
8(chip->vendor.iobase);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread=
8(priv->iobase);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* size of the data received */
>      > @@ -63,7 +64,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, =
u8
>      *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&chi=
p->dev,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0"Recv size(%d) less than available
>      space\n", size);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; i < s=
ize; i++) { /* clear the waiting
>      data anyway */
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0status =3D ioread8(chip->vendor.iobase
>      + 1);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0status =3D ioread8(priv->iobase + 1);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0if ((status &
>      ATML_STATUS_DATA_AVAIL) =3D=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&chip->dev,
>      "error reading data\n");
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;
>      > @@ -74,16 +75,16 @@ static int tpm_atml_recv(struct tpm_chip *chip=
, u8
>      *buf, size_t count)
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* read all the data available */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0for (; i < size; i++) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread=
8(chip->vendor.iobase + 1);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread=
8(priv->iobase + 1);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((status =
& ATML_STATUS_DATA_AVAIL) =3D=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0dev_err(&chip->dev, "error reading
>      data\n");
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return -EIO;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread=
8(chip->vendor.iobase);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread=
8(priv->iobase);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* make sure data available is gone */
>      > -=C2=A0 =C2=A0 =C2=A0status =3D ioread8(chip->vendor.iobase + 1);
>      > +=C2=A0 =C2=A0 =C2=A0status =3D ioread8(priv->iobase + 1);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (status & ATML_STATUS_DATA_AVAIL) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&chi=
p->dev, "data available is
>      stuck\n");
>      > @@ -95,12 +96,13 @@ static int tpm_atml_recv(struct tpm_chip *chip=
, u8
>      *buf, size_t count)
>      >
>      >=C2=A0 static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, siz=
e_t
>      count)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip->vendor.=
priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(&chip->dev, "tpm_atml_send:\n");
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < count; i++) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(&chi=
p->dev, "%d 0x%x(%d)\n",=C2=A0 i,
>      buf[i], buf[i]);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[i], =
chip->vendor.iobase);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[i], =
priv->iobase);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return count;
>      > @@ -108,12 +110,16 @@ static int tpm_atml_send(struct tpm_chip *ch=
ip,
>      u8 *buf, size_t count)
>      >
>      >=C2=A0 static void tpm_atml_cancel(struct tpm_chip *chip)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(ATML_STATUS_ABORT, chip->vendor.ioba=
se + 1);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip->vendor.=
priv;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0iowrite8(ATML_STATUS_ABORT, priv->iobase + 1);
>      >=C2=A0 }
>      >
>      >=C2=A0 static u8 tpm_atml_status(struct tpm_chip *chip)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0return ioread8(chip->vendor.iobase + 1);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip->vendor.=
priv;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return ioread8(priv->iobase + 1);
>      >=C2=A0 }
>      >
>      >=C2=A0 static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 =
status)
>      > @@ -142,7 +148,7 @@ static void atml_plat_remove(void)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_chip_unr=
egister(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (priv->ha=
ve_region)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0atmel_release_region(priv->base,
>      priv->region_size);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atmel_put_base_ad=
dr(chip->vendor.iobase);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atmel_put_base_ad=
dr(priv->iobase);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0platform_dev=
ice_unregister(pdev);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >=C2=A0 }
>      > @@ -190,6 +196,7 @@ static int __init init_atmel(void)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unr=
eg_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      > +=C2=A0 =C2=A0 =C2=A0priv->iobase =3D iobase;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->base =3D base;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->have_region =3D have_region;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->region_size =3D region_size;
>      > @@ -200,7 +207,6 @@ static int __init init_atmel(void)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unr=
eg_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      > -=C2=A0 =C2=A0 =C2=A0chip->vendor.iobase =3D iobase;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vendor.priv =3D priv;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D tpm_chip_register(chip);
>      > diff --git a/drivers/char/tpm/tpm_atmel.h
>      b/drivers/char/tpm/tpm_atmel.h
>      > index bced678..7e37c16 100644
>      > --- a/drivers/char/tpm/tpm_atmel.h
>      > +++ b/drivers/char/tpm/tpm_atmel.h
>      > @@ -26,6 +26,7 @@ struct tpm_atmel_priv {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int region_size;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int have_region;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long base;
>      > +=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;
>      >=C2=A0 };
>      >
>      >=C2=A0 static inline struct tpm_atmel_priv *atmel_get_priv(struct t=
pm_chip
>      *chip)
>      > @@ -37,8 +38,8 @@ static inline struct tpm_atmel_priv
>      *atmel_get_priv(struct tpm_chip *chip)
>      >
>      >=C2=A0 #include <asm/prom.h>
>      >
>      > -#define atmel_getb(chip, offset) readb(chip->vendor->iobase +
>      offset);
>      > -#define atmel_putb(val, chip, offset) writeb(val,
>      chip->vendor->iobase + offset)
>      > +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
>      > +#define atmel_putb(val, priv, offset) writeb(val, priv->iobase +
>      offset)
>      >=C2=A0 #define atmel_request_region request_mem_region
>      >=C2=A0 #define atmel_release_region release_mem_region
>      >
>      > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis=
.c
>      > index 068f021..19dac62 100644
>      > --- a/drivers/char/tpm/tpm_tis.c
>      > +++ b/drivers/char/tpm/tpm_tis.c
>      > @@ -94,6 +94,7 @@ struct tpm_info {
>      >=C2=A0 #define=C2=A0 =C2=A0 =C2=A0 TPM_RID(l)=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (0x0F04 |
>      ((l) << 12))
>      >
>      >=C2=A0 struct priv_data {
>      > +=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0bool irq_tested;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t int_queue;
>      > @@ -128,9 +129,10 @@ static inline int is_itpm(struct acpi_device
>      *dev)
>      >=C2=A0 =C2=A0* correct values in the other bits.' */
>      >=C2=A0 static int wait_startup(struct tpm_chip *chip, int l)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop =3D jiffies + chip->v=
endor.timeout_a;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0do {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(chip-=
>vendor.iobase + TPM_ACCESS(l))
>      &
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(priv-=
>iobase + TPM_ACCESS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0TPM_ACCESS_VALID)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return 0;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_T=
IMEOUT);
>      > @@ -140,7 +142,9 @@ static int wait_startup(struct tpm_chip *chip,=
 int
>      l)
>      >
>      >=C2=A0 static int check_locality(struct tpm_chip *chip, int l)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0if ((ioread8(chip->vendor.iobase + TPM_ACCESS=
(l)) &
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (TPM_ACCESS_ACTIVE_LOCALI=
TY | TPM_ACCESS_VALID)) =3D=3D
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_ACTIVE_LOCALIT=
Y | TPM_ACCESS_VALID))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return chip-=
>vendor.locality =3D l;
>      > @@ -150,11 +154,13 @@ static int check_locality(struct tpm_chip *c=
hip,
>      int l)
>      >
>      >=C2=A0 static void release_locality(struct tpm_chip *chip, int l, i=
nt
>      force)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(chip->vendor.iobase + T=
PM_ACCESS(l)) &
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(priv->iobase + TPM_ACCE=
SS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDING |
>      TPM_ACCESS_VALID)) =3D=3D
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDIN=
G | TPM_ACCESS_VALID))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM=
_ACCESS_ACTIVE_LOCALITY,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 chip->vendor.iobase +
>      TPM_ACCESS(l));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 priv->iobase + TPM_ACCESS(l));
>      >=C2=A0 }
>      >
>      >=C2=A0 static int request_locality(struct tpm_chip *chip, int l)
>      > @@ -167,7 +173,7 @@ static int request_locality(struct tpm_chip *c=
hip,
>      int l)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return l;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCESS_REQUEST_USE,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->vendor.iob=
ase + TPM_ACCESS(l));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase + T=
PM_ACCESS(l));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip->vendor.timeout_=
a;
>      >
>      > @@ -200,19 +206,24 @@ again:
>      >
>      >=C2=A0 static u8 tpm_tis_status(struct tpm_chip *chip)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0return ioread8(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return ioread8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 TPM_STS(chip->vendor.locality));
>      >=C2=A0 }
>      >
>      >=C2=A0 static void tpm_tis_ready(struct tpm_chip *chip)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* this causes the current command to be=
 aborted */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_COMMAND_READY,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->vendor.iob=
ase +
>      TPM_STS(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase + T=
PM_STS(chip->vendor.locality));
>      >=C2=A0 }
>      >
>      >=C2=A0 static int get_burstcount(struct tpm_chip *chip)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int burstcnt;
>      >
>      > @@ -220,9 +231,9 @@ static int get_burstcount(struct tpm_chip *chi=
p)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* which timeout value, spec has 2 answe=
rs (c & d) */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip->vendor.timeout_=
d;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0do {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D iore=
ad8(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D iore=
ad8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_STS(chip->vendor.locality) + 1);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ior=
ead8(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ior=
ead8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      =C2=A0TPM_STS(chip->vendor.locality) +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02) << 8;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt)
>      > @@ -234,6 +245,7 @@ static int get_burstcount(struct tpm_chip *chi=
p)
>      >
>      >=C2=A0 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t =
count)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, burstcnt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size < count &&
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_tpm_stat(=
chip,
>      > @@ -243,7 +255,7 @@ static int recv_data(struct tpm_chip *chip, u8
>      *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D=
 get_burstcount(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burst=
cnt > 0 && size < count; burstcnt--)
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0buf[size++] =3D
>      ioread8(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0buf[size++] =3D ioread8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0
>      =C2=A0TPM_DATA_FIFO(chip->vendor.
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0
>      =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      > @@ -329,7 +341,7 @@ static int tpm_tis_send_data(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0while (count < len - 1) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D=
 get_burstcount(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burst=
cnt > 0 && count < len - 1;
>      burstcnt--) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0iowrite8(buf[count],
>      chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0iowrite8(buf[count], priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_DATA_FIFO(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0count++;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      > @@ -345,7 +357,7 @@ static int tpm_tis_send_data(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* write last byte */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[count],
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->vendor.iob=
ase +
>      TPM_DATA_FIFO(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase +
>      TPM_DATA_FIFO(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm_stat(chip, TPM_STS_VALID,
>      chip->vendor.timeout_c,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&priv->int_queue, false);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_tis_status(chip);
>      > @@ -364,15 +376,15 @@ out_err:
>      >
>      >=C2=A0 static void disable_interrupts(struct tpm_chip *chip)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 TPM_INT_ENABLE(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &=3D ~TPM_GLOBAL_INT_ENABLE;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_EN=
ABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0devm_free_irq(&chip->dev, chip->vendor.i=
rq, chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vendor.irq =3D 0;
>      >=C2=A0 }
>      > @@ -384,6 +396,7 @@ static void disable_interrupts(struct tpm_chip
>      *chip)
>      >=C2=A0 =C2=A0*/
>      >=C2=A0 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf,=
 size_t
>      len)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 ordinal;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long dur;
>      > @@ -394,7 +407,7 @@ static int tpm_tis_send_main(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* go and do it */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_GO,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->vendor.iob=
ase +
>      TPM_STS(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase + T=
PM_STS(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip->vendor.irq) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ordinal =3D =
be32_to_cpu(*((__be32 *) (buf + 6)));
>      > @@ -453,10 +466,11 @@ static const struct tis_vendor_timeout_overr=
ide
>      vendor_timeout_overrides[] =3D {
>      >=C2=A0 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long
>      *timeout_cap)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 did_vid;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(chip->vendor.iobase + TP=
M_DID_VID(0));
>      > +=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(priv->iobase + TPM_DID_V=
ID(0));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i !=3D ARRAY_SIZE(vendor_t=
imeout_overrides); i++)
>      {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor_t=
imeout_overrides[i].did_vid !=3D
>      did_vid)
>      > @@ -476,6 +490,7 @@ static bool tpm_tis_update_timeouts(struct
>      tpm_chip *chip,
>      >=C2=A0 =C2=A0*/
>      >=C2=A0 static int probe_itpm(struct tpm_chip *chip)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 cmd_getticks[] =3D {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0xc1, =
0x00, 0x00, 0x00, 0x0a,
>      > @@ -483,7 +498,7 @@ static int probe_itpm(struct tpm_chip *chip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0};
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t len =3D sizeof(cmd_getticks);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0bool rem_itpm =3D itpm;
>      > -=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(chip->vendor.iobase +=
 TPM_DID_VID(0));
>      > +=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(priv->iobase + TPM_DI=
D_VID(0));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* probe only iTPMS */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor !=3D TPM_VID_INTEL)
>      > @@ -548,7 +563,7 @@ static irqreturn_t tis_int_handler(int dummy, =
void
>      *dev_id)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 interrupt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_STATUS(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (interrupt =3D=3D 0)
>      > @@ -568,9 +583,9 @@ static irqreturn_t tis_int_handler(int dummy, =
void
>      *dev_id)
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear interrupts handled with TPM_EOI=
 */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(interrupt,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_I=
NT_STATUS(chip->vendor.locality));
>      > -=C2=A0 =C2=A0 =C2=A0ioread32(chip->vendor.iobase +
>      TPM_INT_STATUS(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0ioread32(priv->iobase +
>      TPM_INT_STATUS(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_HANDLED;
>      >=C2=A0 }
>      >
>      > @@ -592,19 +607,19 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vendor.irq =3D irq;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(chip->vendor.iob=
ase +
>      > +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_VECTOR(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(irq,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->vendor.iob=
ase +
>      TPM_INT_VECTOR(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv->iobase +
>      TPM_INT_VECTOR(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear all existing */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_STATUS(chip->vendor.locality)),
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      TPM_INT_STATUS(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      TPM_INT_STATUS(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Turn on */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask | TPM_GLOBAL_INT_ENABL=
E,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->irq_tested =3D false;
>      >
>      > @@ -621,8 +636,7 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!chip->vendor.irq) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(ori=
ginal_int_vec,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 chip->vendor.iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_VECTOR(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 priv->iobase +
>      TPM_INT_VECTOR(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      > @@ -635,10 +649,11 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0*/
>      >=C2=A0 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 int=
mask)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(chip->vendor.iob=
ase +
>      > +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_VECTOR(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!original_int_vec) {
>      > @@ -658,15 +673,16 @@ MODULE_PARM_DESC(interrupts, "Enable
>      interrupts");
>      >
>      >=C2=A0 static void tpm_tis_remove(struct tpm_chip *chip)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip->flags & TPM_CHIP_FLAG_TPM2)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm2_shutdow=
n(chip, TPM2_SU_CLEAR);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(~TPM_GLOBAL_INT_ENABLE &
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(c=
hip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(p=
riv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_ENABLE(chip->vendor.
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      =C2=A0locality)),
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_EN=
ABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 priv->iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0release_locality(chip, chip->vendor.loca=
lity, 1);
>      >=C2=A0 }
>      >
>      > @@ -691,9 +707,9 @@ static int tpm_tis_init(struct device *dev, st=
ruct
>      tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->acpi_dev_handle =3D acpi_dev_handl=
e;
>      >=C2=A0 #endif
>      >
>      > -=C2=A0 =C2=A0 =C2=A0chip->vendor.iobase =3D devm_ioremap_resource=
(dev,
>      &tpm_info->res);
>      > -=C2=A0 =C2=A0 =C2=A0if (IS_ERR(chip->vendor.iobase))
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(ch=
ip->vendor.iobase);
>      > +=C2=A0 =C2=A0 =C2=A0priv->iobase =3D devm_ioremap_resource(dev, &=
tpm_info->res);
>      > +=C2=A0 =C2=A0 =C2=A0if (IS_ERR(priv->iobase))
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(pr=
iv->iobase);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Maximum timeouts */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vendor.timeout_a =3D TIS_TIMEOUT_A=
_MAX;
>      > @@ -707,13 +723,13 @@ static int tpm_tis_init(struct device *dev,
>      struct tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Take control of the TPM's interrupt h=
ardware and shut it
>      off */
>      > -=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT |
>      TPM_INTF_LOCALITY_CHANGE_INT |
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_=
INTF_DATA_AVAIL_INT |
>      TPM_INTF_STS_VALID_INT;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &=3D ~TPM_GLOBAL_INT_ENABLE;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (request_locality(chip, 0) !=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENOD=
EV;
>      > @@ -724,12 +740,12 @@ static int tpm_tis_init(struct device *dev,
>      struct tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(chip->vendor.iobase + TPM=
_DID_VID(0));
>      > +=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(priv->iobase + TPM_DID_VI=
D(0));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->manufacturer_id =3D vendor;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_info(dev, "%s TPM (device-id 0x%X, r=
ev-id %d)\n",
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (chip->flag=
s & TPM_CHIP_FLAG_TPM2) ? "2.0" :
>      "1.2",
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor >> 16, io=
read8(chip->vendor.iobase +
>      TPM_RID(0)));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor >> 16, io=
read8(priv->iobase +
>      TPM_RID(0)));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!itpm) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0probe =3D pr=
obe_itpm(chip);
>      > @@ -746,7 +762,7 @@ static int tpm_tis_init(struct device *dev, st=
ruct
>      tpm_info *tpm_info,
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Figure out the capabilities */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip->vendor.iobase +
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 TPM_INTF_CAPS(chip->vendor.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(dev, "TPM interface capabilities=
 (0x%x):\n",
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps);
>      > @@ -825,23 +841,23 @@ out_err:
>      >=C2=A0 #ifdef CONFIG_PM_SLEEP
>      >=C2=A0 static void tpm_tis_reenable_interrupts(struct tpm_chip *chi=
p)
>      >=C2=A0 {
>      > +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip->vendor.priv;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* reenable interrupts that device may h=
ave lost or
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BIOS/firmware may have disabled =
*/
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(chip->vendor.irq, chip->vendor.iobas=
e +
>      > +=C2=A0 =C2=A0 =C2=A0iowrite8(chip->vendor.irq, priv->iobase +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VEC=
TOR(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip->vendor.iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TP=
M_INT_ENABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv->iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_LOCALITY_CHANGE=
_INT |
>      TPM_INTF_DATA_AVAIL_INT
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_STS_VALID_INT |=
 TPM_GLOBAL_INT_ENABLE;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip->vend=
or.iobase +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv->ioba=
se +
>      TPM_INT_ENABLE(chip->vendor.locality));
>      >=C2=A0 }
>      >
>      >=C2=A0 static int tpm_tis_resume(struct device *dev)
>      > --
>      > 2.5.0
>      >

---------------------------------------------------------------------------=
---
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=3D278785471&iu=3D/4140
