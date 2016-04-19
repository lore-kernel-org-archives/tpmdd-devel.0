From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 04/12] tpm_tis: Introduce intermediate
 layer for TPM access
Date: Tue, 19 Apr 2016 20:16:25 +0300
Message-ID: <20160419171625.GA11619@intel.com>
References: <1461017864-3903-1-git-send-email-christophe-h.ricard@st.com>
	<1461017864-3903-5-git-send-email-christophe-h.ricard@st.com>
	<20160419130747.GC4796@intel.com>
	<CALD+uuxbqVYrPxpAz2gZo5+5hu+Yagt4XkinJUXfZm3fztfKLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALD+uuxbqVYrPxpAz2gZo5+5hu+Yagt4XkinJUXfZm3fztfKLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Tue, Apr 19, 2016 at 03:20:25PM +0200, Christophe Ricard wrote:
>    Hi Jarkko,
> =

>    Do you thing tpm_tis.c should be renamed tpm_tis_tcg.c as well ?

Yeah.

I would structure things like this:

* tpm_tis.ko (core stuff)
* tpm_tis_tcg.ko
* tpm_tis_spi.ko
* ...

This would also as a side-effect considerably shrink the code line
changes since you would not have move generic stuff out of tpm_tis.
In my opinion this would be more logical way to structure and name
things.

In this framework you should probably have tpm_tis.h/c for generic
stuff instead of tpm_tis_core.h/c.

/Jarkko

>    Best Regards
>    Christophe
> =

>    2016-04-19 15:07 GMT+02:00 Jarkko Sakkinen
>    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> =

>      On Tue, Apr 19, 2016 at 12:17:36AM +0200, Christophe Ricard wrote:
>      > This splits tpm_tis in a high-level protocol part and a low-level
>      interface
>      > for the actual TPM communication. The low-level interface can then=
 be
>      > implemented by additional drivers to provide access to TPMs using
>      other
>      > mechanisms, for example native I2C or SPI transfers, while still
>      reusing
>      > the same TIS protocol implementation.
> =

>      I do not see anything obviously wrong in this patch except the use
>      of tpm_mem prefix. Earlier you used LPC which was incorrect. Now you
>      refer to the same entity with this tpm_mem prefix.
> =

>      Maybe tpm_tcg would be the right choice in both cases...
>      /Jarkko
>      > Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
>      > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
>      > ---
>      >=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0 =C2=A0 | 201
>      +++++++++++++++++++++-------------------
>      >=C2=A0 drivers/char/tpm/tpm_tis_core.h |=C2=A0 64 +++++++++++++
>      >=C2=A0 2 files changed, 168 insertions(+), 97 deletions(-)
>      >
>      > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis=
.c
>      > index af53747..6df7ddc 100644
>      > --- a/drivers/char/tpm/tpm_tis.c
>      > +++ b/drivers/char/tpm/tpm_tis.c
>      > @@ -131,11 +131,9 @@ static inline int is_itpm(struct acpi_device
>      *dev)
>      >=C2=A0 =C2=A0* correct values in the other bits.' */
>      >=C2=A0 static int wait_startup(struct tpm_chip *chip, int l)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop =3D jiffies + chip->t=
imeout_a;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0do {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(phy->=
iobase + TPM_ACCESS(l)) &
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tpm_read8(chi=
p, TPM_ACCESS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0TPM_ACCESS_VALID)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return 0;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_T=
IMEOUT);
>      > @@ -146,9 +144,8 @@ static int wait_startup(struct tpm_chip *chip,=
 int
>      l)
>      >=C2=A0 static int check_locality(struct tpm_chip *chip, int l)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >
>      > -=C2=A0 =C2=A0 =C2=A0if ((ioread8(phy->iobase + TPM_ACCESS(l)) &
>      > +=C2=A0 =C2=A0 =C2=A0if ((tpm_read8(chip, TPM_ACCESS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (TPM_ACCESS_ACTIVE_LOCALI=
TY | TPM_ACCESS_VALID)) =3D=3D
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_ACTIVE_LOCALIT=
Y | TPM_ACCESS_VALID))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return priv-=
>locality =3D l;
>      > @@ -158,28 +155,23 @@ static int check_locality(struct tpm_chip *c=
hip,
>      int l)
>      >
>      >=C2=A0 static void release_locality(struct tpm_chip *chip, int l, i=
nt
>      force)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > -
>      > -=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(phy->iobase + TPM_ACCES=
S(l)) &
>      > +=C2=A0 =C2=A0 =C2=A0if (force || (tpm_read8(chip, TPM_ACCESS(l)) &
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDING |
>      TPM_ACCESS_VALID)) =3D=3D
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDIN=
G | TPM_ACCESS_VALID))
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCE=
SS_ACTIVE_LOCALITY,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 phy->iobase + TPM_ACCESS(l));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write8(chip, =
TPM_ACCESS(l),
>      TPM_ACCESS_ACTIVE_LOCALITY);
>      > +
>      >=C2=A0 }
>      >
>      >=C2=A0 static int request_locality(struct tpm_chip *chip, int l)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop, timeout;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0long rc;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_locality(chip, l) >=3D 0)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return l;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCESS_REQUEST_USE,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy->iobase + TP=
M_ACCESS(l));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_RE=
QUEST_USE);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip->timeout_a;
>      >
>      > @@ -213,26 +205,21 @@ again:
>      >=C2=A0 static u8 tpm_tis_status(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >
>      > -=C2=A0 =C2=A0 =C2=A0return ioread8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 TPM_STS(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0return tpm_read8(chip, TPM_STS(priv->locality=
));
>      >=C2=A0 }
>      >
>      >=C2=A0 static void tpm_tis_ready(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* this causes the current command to be=
 aborted */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_COMMAND_READY,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy->iobase + TP=
M_STS(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_STS(priv->locality),
>      TPM_STS_COMMAND_READY);
>      >=C2=A0 }
>      >
>      >=C2=A0 static int get_burstcount(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int burstcnt;
>      >
>      > @@ -240,11 +227,8 @@ static int get_burstcount(struct tpm_chip *ch=
ip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* which timeout value, spec has 2 answe=
rs (c & d) */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip->timeout_d;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0do {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D iore=
ad8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_STS(priv->locality) + 1);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ior=
ead8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      =C2=A0TPM_STS(priv->locality) +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02) << 8;
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D tpm_=
read8(chip,
>      TPM_STS(priv->locality) + 1);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D tpm=
_read8(chip,
>      TPM_STS(priv->locality) + 2) << 8;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0return burstcnt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_T=
IMEOUT);
>      > @@ -255,18 +239,16 @@ static int get_burstcount(struct tpm_chip *c=
hip)
>      >=C2=A0 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t =
count)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, burstcnt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size < count &&
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_tpm_stat(=
chip,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_STS_DATA_AVAIL |
>      TPM_STS_VALID,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip->timeout_c,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &priv->read_queue, true)
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=3D 0) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get_=
burstcount(chip);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt >=
 0 && size < count; burstcnt--)
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0buf[size++] =3D ioread8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0
>      =C2=A0TPM_DATA_FIFO(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &priv->read_queue, true)
>      =3D=3D 0) {
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min_=
t(int, get_burstcount(chip), count
>      - size);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_read_bytes(ch=
ip,
>      TPM_DATA_FIFO(priv->locality),
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 burstcnt, buf + size);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size +=3D burstcn=
t;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return size;
>      >=C2=A0 }
>      > @@ -330,7 +312,6 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds
>      (found on some Lenovo laptops)");
>      >=C2=A0 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf,=
 size_t
>      len)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc, status, burstcnt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D 0;
>      >
>      > @@ -349,12 +330,10 @@ static int tpm_tis_send_data(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0while (count < len - 1) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get_=
burstcount(chip);
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt >=
 0 && count < len - 1;
>      burstcnt--) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0iowrite8(buf[count], phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_DATA_FIFO(priv->locality));
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0count++;
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min_=
t(int, get_burstcount(chip), len -
>      count - 1);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write_bytes(c=
hip,
>      TPM_DATA_FIFO(priv->locality),
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt, buf + count);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0count +=3D burstc=
nt;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm=
_stat(chip, TPM_STS_VALID,
>      chip->timeout_c,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&priv->int_queue,
>      false);
>      > @@ -366,8 +345,8 @@ static int tpm_tis_send_data(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* write last byte */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(buf[count],
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy->iobase + TP=
M_DATA_FIFO(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_DATA_FIFO(priv->locality=
), buf[count]);
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm_stat(chip, TPM_STS_VALID, c=
hip->timeout_c,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0&priv->int_queue, false);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_tis_status(chip);
>      > @@ -387,15 +366,12 @@ out_err:
>      >=C2=A0 static void disable_interrupts(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0intmask =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TP=
M_INT_ENABLE(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip, TPM_INT_ENABLE(p=
riv->locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &=3D ~TPM_GLOBAL_INT_ENABLE;
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e + TPM_INT_ENABLE(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv->locali=
ty), intmask);
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0devm_free_irq(&chip->dev, priv->irq, chi=
p);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->irq =3D 0;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->flags &=3D ~TPM_CHIP_FLAG_IRQ;
>      > @@ -409,7 +385,6 @@ static void disable_interrupts(struct tpm_chip
>      *chip)
>      >=C2=A0 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf,=
 size_t
>      len)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 ordinal;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long dur;
>      > @@ -419,8 +394,7 @@ static int tpm_tis_send_main(struct tpm_chip
>      *chip, u8 *buf, size_t len)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* go and do it */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_GO,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy->iobase + TP=
M_STS(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_STS(priv->locality), TPM=
_STS_GO);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip->flags & TPM_CHIP_FLAG_IRQ) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ordinal =3D =
be32_to_cpu(*((__be32 *) (buf + 6)));
>      > @@ -481,12 +455,10 @@ static const struct tis_vendor_timeout_overr=
ide
>      vendor_timeout_overrides[] =3D {
>      >=C2=A0 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long
>      *timeout_cap)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 did_vid;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(phy->iobase + TPM_DID_VI=
D(0));
>      > +=C2=A0 =C2=A0 =C2=A0did_vid =3D tpm_read32(chip, TPM_DID_VID(0));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i !=3D ARRAY_SIZE(vendor_t=
imeout_overrides); i++)
>      {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor_t=
imeout_overrides[i].did_vid !=3D
>      did_vid)
>      > @@ -507,7 +479,6 @@ static bool tpm_tis_update_timeouts(struct
>      tpm_chip *chip,
>      >=C2=A0 static int probe_itpm(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 cmd_getticks[] =3D {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0xc1, =
0x00, 0x00, 0x00, 0x0a,
>      > @@ -515,7 +486,7 @@ static int probe_itpm(struct tpm_chip *chip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0};
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t len =3D sizeof(cmd_getticks);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0bool rem_itpm =3D itpm;
>      > -=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(phy->iobase + TPM_DID=
_VID(0));
>      > +=C2=A0 =C2=A0 =C2=A0u16 vendor =3D tpm_read16(chip, TPM_DID_VID(0=
));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* probe only iTPMS */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor !=3D TPM_VID_INTEL)
>      > @@ -573,16 +544,66 @@ static const struct tpm_class_ops tpm_tis =
=3D {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0.req_canceled =3D tpm_tis_req_canceled,
>      >=C2=A0 };
>      >
>      > +static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u=
16
>      len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 *result)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0while (len--)
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*result++ =3D ior=
ead8(phy->iobase + addr);
>      > +}
>      > +
>      > +static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, =
u16
>      len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *value)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0while (len--)
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(*value++=
, phy->iobase + addr);
>      > +}
>      > +
>      > +static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return ioread16(phy->iobase + addr);
>      > +}
>      > +
>      > +static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return ioread32(phy->iobase + addr);
>      > +}
>      > +
>      > +static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32
>      value)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0iowrite32(value, phy->iobase + addr);
>      > +}
>      > +
>      > +static const struct tpm_tis_phy_ops tpm_mem =3D {
>      > +=C2=A0 =C2=A0 =C2=A0.read_bytes =3D tpm_mem_read_bytes,
>      > +=C2=A0 =C2=A0 =C2=A0.write_bytes =3D tpm_mem_write_bytes,
>      > +=C2=A0 =C2=A0 =C2=A0.read16 =3D tpm_mem_read16,
>      > +=C2=A0 =C2=A0 =C2=A0.read32 =3D tpm_mem_read32,
>      > +=C2=A0 =C2=A0 =C2=A0.write32 =3D tpm_mem_write32,
>      > +};
>      > +
>      >=C2=A0 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *chip =3D dev_id;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 interrupt;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_STATUS(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0interrupt =3D tpm_read32(chip, TPM_INT_STATUS=
(priv->locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (interrupt =3D=3D 0)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_N=
ONE;
>      > @@ -600,10 +621,8 @@ static irqreturn_t tis_int_handler(int dummy,
>      void *dev_id)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up_inte=
rruptible(&priv->int_queue);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear interrupts handled with TPM_EOI=
 */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(interrupt,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_ST=
ATUS(priv->locality));
>      > -=C2=A0 =C2=A0 =C2=A0ioread32(phy->iobase + TPM_INT_STATUS(priv->l=
ocality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_STATUS(priv->locali=
ty), interrupt);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_read32(chip, TPM_INT_STATUS(priv->localit=
y));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_HANDLED;
>      >=C2=A0 }
>      >
>      > @@ -615,7 +634,6 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flags, int
>      irq)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (devm_request_irq(&chip->dev, irq, ti=
s_int_handler,
>      flags,
>      > @@ -626,19 +644,16 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->irq =3D irq;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_VECTOR(priv->locality));
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(irq,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy->iobase + TP=
M_INT_VECTOR(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D tpm_read8(chip,
>      TPM_INT_VECTOR(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_INT_VECTOR(priv->localit=
y), irq);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear all existing */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 TPM_INT_STATUS(priv->locality)),
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e + TPM_INT_STATUS(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_STATUS(priv->locali=
ty),
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm=
_read32(chip,
>      TPM_INT_STATUS(priv->locality)));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Turn on */
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e + TPM_INT_ENABLE(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv->locali=
ty),
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int=
mask | TPM_GLOBAL_INT_ENABLE);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->irq_tested =3D false;
>      >
>      > @@ -654,8 +669,9 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 * will call disable_irq which undoes al=
l of the above.
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(original=
_int_vec,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 phy->iobase +
>      TPM_INT_VECTOR(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write8(chip, =
TPM_INT_VECTOR(priv->locality),
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 original_int_vec);
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      > @@ -669,12 +685,10 @@ static int tpm_tis_probe_irq_single(struct
>      tpm_chip *chip, u32 intmask,
>      >=C2=A0 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 int=
mask)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0
>      TPM_INT_VECTOR(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D tpm_read8(chip,
>      TPM_INT_VECTOR(priv->locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!original_int_vec) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ENABL=
ED(CONFIG_X86))
>      > @@ -694,10 +708,9 @@ MODULE_PARM_DESC(interrupts, "Enable
>      interrupts");
>      >=C2=A0 static void tpm_tis_remove(struct tpm_chip *chip)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      > -=C2=A0 =C2=A0 =C2=A0void __iomem *reg =3D phy->iobase +
>      TPM_INT_ENABLE(priv->locality);
>      > +=C2=A0 =C2=A0 =C2=A0u32 reg =3D TPM_INT_ENABLE(priv->locality);
>      >
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(r=
eg), reg);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE=
 &
>      tpm_read32(chip, reg));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0release_locality(chip, priv->locality, 1=
);
>      >=C2=A0 }
>      >
>      > @@ -725,6 +738,8 @@ static int tpm_tis_init(struct device *dev, st=
ruct
>      tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(phy->iobase))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_E=
RR(phy->iobase);
>      >
>      > +=C2=A0 =C2=A0 =C2=A0phy->priv.phy_ops =3D &tpm_mem;
>      > +
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Maximum timeouts */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->timeout_a =3D TIS_TIMEOUT_A_MAX;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->timeout_b =3D TIS_TIMEOUT_B_MAX;
>      > @@ -739,13 +754,11 @@ static int tpm_tis_init(struct device *dev,
>      struct tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0}
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Take control of the TPM's interrupt h=
ardware and shut it
>      off */
>      > -=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0
>      TPM_INT_ENABLE(phy->priv.locality));
>      > +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip,
>      TPM_INT_ENABLE(phy->priv.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT |
>      TPM_INTF_LOCALITY_CHANGE_INT |
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_=
INTF_DATA_AVAIL_INT |
>      TPM_INTF_STS_VALID_INT;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &=3D ~TPM_GLOBAL_INT_ENABLE;
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e +
>      TPM_INT_ENABLE(phy->priv.locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(phy->priv.lo=
cality),
>      intmask);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (request_locality(chip, 0) !=3D 0) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENOD=
EV;
>      > @@ -756,12 +769,12 @@ static int tpm_tis_init(struct device *dev,
>      struct tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(phy->iobase + TPM_DID_VID=
(0));
>      > +=C2=A0 =C2=A0 =C2=A0vendor =3D tpm_read32(chip, TPM_DID_VID(0));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0phy->priv.manufacturer_id =3D vendor;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_info(dev, "%s TPM (device-id 0x%X, r=
ev-id %d)\n",
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (chip->flag=
s & TPM_CHIP_FLAG_TPM2) ? "2.0" :
>      "1.2",
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor >> 16, io=
read8(phy->iobase +
>      TPM_RID(0)));
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor >> 16, tp=
m_read8(chip, TPM_RID(0)));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!itpm) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0probe =3D pr=
obe_itpm(chip);
>      > @@ -777,9 +790,7 @@ static int tpm_tis_init(struct device *dev, st=
ruct
>      tpm_info *tpm_info,
>      >
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Figure out the capabilities */
>      > -=C2=A0 =C2=A0 =C2=A0intfcaps =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TP=
M_INTF_CAPS(phy->priv.locality));
>      > +=C2=A0 =C2=A0 =C2=A0intfcaps =3D tpm_read32(chip,
>      TPM_INTF_CAPS(phy->priv.locality));
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(dev, "TPM interface capabilities=
 (0x%x):\n",
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (intfcaps & TPM_INTF_BURST_COUNT_STAT=
IC)
>      > @@ -858,23 +869,19 @@ out_err:
>      >=C2=A0 static void tpm_tis_reenable_interrupts(struct tpm_chip *chi=
p)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_dr=
vdata(&chip->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lp=
c_phy(priv);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* reenable interrupts that device may h=
ave lost or
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BIOS/firmware may have disabled =
*/
>      > -=C2=A0 =C2=A0 =C2=A0iowrite8(priv->irq, phy->iobase +
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(p=
riv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_INT_VECTOR(priv->localit=
y), priv->irq);
>      >
>      > -=C2=A0 =C2=A0 =C2=A0intmask =3D
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy->iobase + TPM_INT_=
ENABLE(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip, TPM_INT_ENABLE(p=
riv->locality));
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_LOCALITY_CHANGE=
_INT |
>      TPM_INTF_DATA_AVAIL_INT
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_STS_VALID_INT |=
 TPM_GLOBAL_INT_ENABLE;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy->iobas=
e + TPM_INT_ENABLE(priv->locality));
>      > +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv->locali=
ty), intmask);
>      >=C2=A0 }
>      >
>      >=C2=A0 static int tpm_tis_resume(struct device *dev)
>      > diff --git a/drivers/char/tpm/tpm_tis_core.h
>      b/drivers/char/tpm/tpm_tis_core.h
>      > index 2260f89..3e066eb 100644
>      > --- a/drivers/char/tpm/tpm_tis_core.h
>      > +++ b/drivers/char/tpm/tpm_tis_core.h
>      > @@ -25,6 +25,16 @@
>      >
>      >=C2=A0 #include "tpm.h"
>      >
>      > +struct tpm_tis_phy_ops {
>      > +=C2=A0 =C2=A0 =C2=A0void (*read_bytes)(struct tpm_chip *chip, u32=
 addr, u16 len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 u8 *result);
>      > +=C2=A0 =C2=A0 =C2=A0void (*write_bytes)(struct tpm_chip *chip, u3=
2 addr, u16 len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *value);
>      > +=C2=A0 =C2=A0 =C2=A0u16 (*read16)(struct tpm_chip *chip, u32 addr=
);
>      > +=C2=A0 =C2=A0 =C2=A0u32 (*read32)(struct tpm_chip *chip, u32 addr=
);
>      > +=C2=A0 =C2=A0 =C2=A0void (*write32)(struct tpm_chip *chip, u32 ad=
dr, u32 src);
>      > +};
>      > +
>      >=C2=A0 struct tpm_tis_data {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int locality;
>      > @@ -32,6 +42,60 @@ struct tpm_tis_data {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0bool irq_tested;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t int_queue;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t read_queue;
>      > +=C2=A0 =C2=A0 =C2=A0const struct tpm_tis_phy_ops *phy_ops;
>      >=C2=A0 };
>      >
>      > +static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr,
>      u16 len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *result)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0priv->phy_ops->read_bytes(chip, addr, len, re=
sult);
>      > +}
>      > +
>      > +static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +=C2=A0 =C2=A0 =C2=A0u8 result;
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0priv->phy_ops->read_bytes(chip, addr, 1, &res=
ult);
>      > +=C2=A0 =C2=A0 =C2=A0return result;
>      > +}
>      > +
>      > +static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return priv->phy_ops->read16(chip, addr);
>      > +}
>      > +
>      > +static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0return priv->phy_ops->read32(chip, addr);
>      > +}
>      > +
>      > +static inline void tpm_write_bytes(struct tpm_chip *chip, u32 add=
r,
>      u16 len,
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 *value)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0priv->phy_ops->write_bytes(chip, addr, len, v=
alue);
>      > +}
>      > +
>      > +static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8
>      value)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0priv->phy_ops->write_bytes(chip, addr, 1, &va=
lue);
>      > +}
>      > +
>      > +static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u=
32
>      value)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata=
(&chip->dev);
>      > +
>      > +=C2=A0 =C2=A0 =C2=A0priv->phy_ops->write32(chip, addr, value);
>      > +}
>      > +
>      >=C2=A0 #endif
>      > --
>      > 2.1.4
>      >

---------------------------------------------------------------------------=
---
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers=
 of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
