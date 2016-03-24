From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Thu, 24 Mar 2016 15:27:32 +0200
Message-ID: <20160324132732.GF8452@intel.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
	<20160322062001.GB4058@intel.com>
	<CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Wed, Mar 23, 2016 at 02:11:26PM +0100, Christophe Ricard wrote:
>    Hi Jarkko,
> =

>    Just coming back to you on this one. My intention was mainly align the
>    "code style" from my eyes with other similar functions from other
>    subsystems.
>    For example and coming to my mind:
>    i2c: i2c_get_clientdata/i2c_set_clientdata
>    spi: spi_get_drvdata/spi_set_drvdata
>    nfc: nfc_get_drvdata/nfc_set_drvdata
> =

>    In the mean time when trying to cleanup the code i found helpers with =
the
>    exact same purpose in tpm_atmel.h (atmel_get_priv) or tpm_nsc.c
>    (tpm_nsc_get_priv).
> =

>    When working on the tpm_vendor_specific cleanup, i came also through t=
he
>    conclusion that moving priv from tpm_vendor_specific to tpm_chip struc=
ture
>    would the most
>    simple and appropriate solution in short term.
> =

>    ...priv field may be renamed data...
>    Do you see anything against a serie removing atmel_get_priv and
>    tpm_nsc_get_priv and with a common helper replacing TPM_VPRIV ?

Yes I do. The current problem is that HW specific stuff lives in the
framework and not in the drivers for that HW. I would like to see HW
drivers to use priv for their internal and get rid off
tpm_vendor_specific completely.

/Jarkko

>    Best Regards
>    Christophe
>    2016-03-22 7:20 GMT+01:00 Jarkko Sakkinen
>    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> =

>      On Sun, Mar 20, 2016 at 08:34:36PM +0100, Christophe Ricard wrote:
>      > Remove TPM_VPRIV macro and replace with tpm_set_vendordata and
>      > tpm_get_vendordata.
> =

>      NAK. These unnecessary wrapper functions make code just harder to re=
ad.
>      I'd rather accept a patch that would drop TPM_VPRIV and not introduce
>      new clutter.
>      /Jarkko
>      > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
>      > ---
>      >=C2=A0 drivers/char/tpm/st33zp24/st33zp24.c | 26 +++++++++++++-----=
--------
>      >=C2=A0 drivers/char/tpm/tpm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0| 12 ++++++++++--
>      >=C2=A0 drivers/char/tpm/tpm_ibmvtpm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 8 ++++----
>      >=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0|=C2=A0 2 +-
>      >=C2=A0 drivers/char/tpm/xen-tpmfront.c=C2=A0 =C2=A0 =C2=A0 | 14 +++=
++++-------
>      >=C2=A0 5 files changed, 35 insertions(+), 27 deletions(-)
>      >
>      > diff --git a/drivers/char/tpm/st33zp24/st33zp24.c
>      b/drivers/char/tpm/st33zp24/st33zp24.c
>      > index 9e91ca7..dc2d0f3 100644
>      > --- a/drivers/char/tpm/st33zp24/st33zp24.c
>      > +++ b/drivers/char/tpm/st33zp24/st33zp24.c
>      > @@ -105,7 +105,7 @@ static void st33zp24_cancel(struct tpm_chip *c=
hip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_STS_COMMAND_READY;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->ops->send(tpm_dev->phy_id, TPM_=
STS, &data, 1);
>      > @@ -121,7 +121,7 @@ static u8 st33zp24_status(struct tpm_chip *chi=
p)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->ops->recv(tpm_dev->phy_id, TPM_=
STS, &data, 1);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return data;
>      > @@ -138,7 +138,7 @@ static int check_locality(struct tpm_chip *chi=
p)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_dev->ops->recv(tpm_dev->p=
hy_id, TPM_ACCESS,
>      &data, 1);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (status && (data &
>      > @@ -164,7 +164,7 @@ static int request_locality(struct tpm_chip *c=
hip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_locality(chip) =3D=3D chip->ve=
ndor.locality)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return chip-=
>vendor.locality;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_ACCESS_REQUEST_USE;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D tpm_dev->ops->send(tpm_dev->phy_=
id, TPM_ACCESS, &data,
>      1);
>      > @@ -193,7 +193,7 @@ static void release_locality(struct tpm_chip
>      *chip)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_ACCESS_ACTIVE_LOCALITY;
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->ops->send(tpm_dev->phy_id, TPM_=
ACCESS, &data, 1);
>      > @@ -211,7 +211,7 @@ static int get_burstcount(struct tpm_chip *chi=
p)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 temp;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip->vendor.timeout_=
d;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0do {
>      > @@ -279,7 +279,7 @@ static int wait_for_stat(struct tpm_chip *chip=
, u8
>      mask, unsigned long timeout,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0/* check current status */
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D st33zp24_status(chip);
>      > @@ -340,7 +340,7 @@ static int recv_data(struct tpm_chip *chip, u8
>      *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, burstcnt, len, ret;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size < count &&
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_stat(chip,
>      > @@ -372,7 +372,7 @@ static irqreturn_t tpm_ioserirq_handler(int ir=
q,
>      void *dev_id)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *chip =3D dev_id;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->intrs++;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up_interruptible(&chip->vendor.read=
_queue);
>      > @@ -404,7 +404,7 @@ static int st33zp24_send(struct tpm_chip *chip,
>      unsigned char *buf,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (len < TPM_HEADER_SIZE)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EBUS=
Y;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D request_locality(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0)
>      > @@ -565,7 +565,7 @@ int st33zp24_probe(void *phy_id, const struct
>      st33zp24_phy_ops *ops,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tpm_dev)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOM=
EM;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D tpm_dev;
>      > +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip, tpm_dev);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->phy_id =3D phy_id;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev->ops =3D ops;
>      >
>      > @@ -653,7 +653,7 @@ int st33zp24_pm_suspend(struct device *dev)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gpio_is_valid(tpm_dev->io_lpcpd))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gpio_set_val=
ue(tpm_dev->io_lpcpd, 0);
>      > @@ -675,7 +675,7 @@ int st33zp24_pm_resume(struct device *dev)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev *tpm_dev;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)TPM_VPRIV(=
chip);
>      > +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33zp24_dev *)tpm_get_ve=
ndordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gpio_is_valid(tpm_dev->io_lpcpd)) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0gpio_set_val=
ue(tpm_dev->io_lpcpd, 1);
>      > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>      > index 28a0c17..6a973b9 100644
>      > --- a/drivers/char/tpm/tpm.h
>      > +++ b/drivers/char/tpm/tpm.h
>      > @@ -157,8 +157,6 @@ struct tpm_vendor_specific {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id;
>      >=C2=A0 };
>      >
>      > -#define TPM_VPRIV(c)=C2=A0 =C2=A0 =C2=A0((c)->vendor.priv)
>      > -
>      >=C2=A0 #define TPM_VID_INTEL=C2=A0 =C2=A0 0x8086
>      >=C2=A0 #define TPM_VID_WINBOND=C2=A0 0x1050
>      >=C2=A0 #define TPM_VID_STM=C2=A0 =C2=A0 =C2=A0 0x104A
>      > @@ -203,6 +201,16 @@ struct tpm_chip {
>      >
>      >=C2=A0 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
>      >
>      > +static inline void tpm_set_vendordata(struct tpm_chip *chip, void
>      *data)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0chip->vendor.priv =3D data;
>      > +}
>      > +
>      > +static inline void *tpm_get_vendordata(struct tpm_chip *chip)
>      > +{
>      > +=C2=A0 =C2=A0 =C2=A0return chip->vendor.priv;
>      > +}
>      > +
>      >=C2=A0 static inline int tpm_read_index(int base, int index)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0outb(index, base);
>      > diff --git a/drivers/char/tpm/tpm_ibmvtpm.c
>      b/drivers/char/tpm/tpm_ibmvtpm.c
>      > index b0a9a9e..c8b1643 100644
>      > --- a/drivers/char/tpm/tpm_ibmvtpm.c
>      > +++ b/drivers/char/tpm/tpm_ibmvtpm.c
>      > @@ -64,7 +64,7 @@ static struct ibmvtpm_dev *ibmvtpm_get_data(const
>      struct device *dev)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *chip =3D dev_get_drvdat=
a(dev);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip)
>      > -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (struct ib=
mvtpm_dev *)TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return (struct ib=
mvtpm_dev
>      *)tpm_get_vendordata(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
>      >=C2=A0 }
>      >
>      > @@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip *chi=
p,
>      u8 *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 len;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int sig;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmvtpm_dev *)TPM_VPRIV(c=
hip);
>      > +=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmvtpm_dev *)tpm_get_ven=
dordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ibmvtpm->rtce_buf) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(ibmv=
tpm->dev, "ibmvtpm device is not
>      ready\n");
>      > @@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip *c=
hip,
>      u8 *buf, size_t count)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0__be64 *word =3D (__be64 *)&crq;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc, sig;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmvtpm_dev *)TPM_VPRIV(c=
hip);
>      > +=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmvtpm_dev *)tpm_get_ven=
dordata(chip);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ibmvtpm->rtce_buf) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(ibmv=
tpm->dev, "ibmvtpm device is not
>      ready\n");
>      > @@ -643,7 +643,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev
>      *vio_dev,
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0crq_q->index =3D 0;
>      >
>      > -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D (void *)ibmvtpm;
>      > +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip, (void *)ibmvtpm);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&ibmvtpm->rtce_lock);
>      >
>      > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis=
.c
>      > index eed3bf5..607fa3f 100644
>      > --- a/drivers/char/tpm/tpm_tis.c
>      > +++ b/drivers/char/tpm/tpm_tis.c
>      > @@ -678,7 +678,7 @@ static int tpm_tis_init(struct device *dev, st=
ruct
>      tpm_info *tpm_info,
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(chip))
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_E=
RR(chip);
>      >
>      > -=C2=A0 =C2=A0 =C2=A0chip->vendor.priv =3D priv;
>      > +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip, priv);
>      >=C2=A0 #ifdef CONFIG_ACPI
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0chip->acpi_dev_handle =3D acpi_dev_handl=
e;
>      >=C2=A0 #endif
>      > diff --git a/drivers/char/tpm/xen-tpmfront.c
>      b/drivers/char/tpm/xen-tpmfront.c
>      > index 3111f27..c472fd8 100644
>      > --- a/drivers/char/tpm/xen-tpmfront.c
>      > +++ b/drivers/char/tpm/xen-tpmfront.c
>      > @@ -39,7 +39,7 @@ enum status_bits {
>      >
>      >=C2=A0 static u8 vtpm_status(struct tpm_chip *chip)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D tpm_get_vendorda=
ta(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (priv->shr->state) {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0case VTPM_STATE_IDLE:
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return VTPM_=
STATUS_IDLE | VTPM_STATUS_CANCELED;
>      > @@ -60,7 +60,7 @@ static bool vtpm_req_canceled(struct tpm_chip *c=
hip,
>      u8 status)
>      >
>      >=C2=A0 static void vtpm_cancel(struct tpm_chip *chip)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D tpm_get_vendorda=
ta(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->shr->state =3D VTPM_STATE_CANCEL;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0wmb();
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0notify_remote_via_evtchn(priv->evtchn);
>      > @@ -73,7 +73,7 @@ static unsigned int shr_data_offset(struct
>      vtpm_shared_page *shr)
>      >
>      >=C2=A0 static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t =
count)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D tpm_get_vendorda=
ta(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vtpm_shared_page *shr =3D priv->s=
hr;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int offset =3D shr_data_offset(=
shr);
>      >
>      > @@ -115,7 +115,7 @@ static int vtpm_send(struct tpm_chip *chip, u8
>      *buf, size_t count)
>      >
>      >=C2=A0 static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t =
count)
>      >=C2=A0 {
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D tpm_get_vendorda=
ta(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vtpm_shared_page *shr =3D priv->s=
hr;
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int offset =3D shr_data_offset(=
shr);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t length =3D shr->length;
>      > @@ -182,7 +182,7 @@ static int setup_chip(struct device *dev, stru=
ct
>      tpm_private *priv)
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0init_waitqueue_head(&chip->vendor.read_q=
ueue);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0priv->chip =3D chip;
>      > -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D priv;
>      > +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip, priv);
>      >
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
>      >=C2=A0 }
>      > @@ -318,10 +318,10 @@ static int tpmfront_probe(struct xenbus_devi=
ce
>      *dev,
>      >=C2=A0 static int tpmfront_remove(struct xenbus_device *dev)
>      >=C2=A0 {
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *chip =3D dev_get_drvdat=
a(&dev->dev);
>      > -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D TPM_VPRIV(chip);
>      > +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv =3D tpm_get_vendorda=
ta(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_chip_unregister(chip);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0ring_free(priv);
>      > -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D NULL;
>      > +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip, NULL);
>      >=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
>      >=C2=A0 }
>      >
>      > --
>      > 2.5.0
>      >

---------------------------------------------------------------------------=
---
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=3D278785351&iu=3D/4140
