From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Thu, 24 Mar 2016 14:30:24 +0100
Message-ID: <CALD+uuwVG_84dY4rCOjecZXxS4LZoE+Kh=CyhmVwyT2U0bAMrg@mail.gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
	<20160322062001.GB4058@intel.com>
	<CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ@mail.gmail.com>
	<20160324132732.GF8452@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3332841387811418747=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160324132732.GF8452-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============3332841387811418747==
Content-Type: multipart/alternative; boundary=001a11407e6019d80b052ecb7490

--001a11407e6019d80b052ecb7490
Content-Type: text/plain; charset=UTF-8

Hi Jarkko,

I am currently working at removing this TPM_VPRIV and priv field as
requested previously.
As pointed by you or Jason, i succeeded to go the dev_get_drvdata way :).

Will send a new serie asap once ready.

Best Regards
Christophe

2016-03-24 14:27 GMT+01:00 Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
:

> On Wed, Mar 23, 2016 at 02:11:26PM +0100, Christophe Ricard wrote:
> >    Hi Jarkko,
> >
> >    Just coming back to you on this one. My intention was mainly align the
> >    "code style" from my eyes with other similar functions from other
> >    subsystems.
> >    For example and coming to my mind:
> >    i2c: i2c_get_clientdata/i2c_set_clientdata
> >    spi: spi_get_drvdata/spi_set_drvdata
> >    nfc: nfc_get_drvdata/nfc_set_drvdata
> >
> >    In the mean time when trying to cleanup the code i found helpers with
> the
> >    exact same purpose in tpm_atmel.h (atmel_get_priv) or tpm_nsc.c
> >    (tpm_nsc_get_priv).
> >
> >    When working on the tpm_vendor_specific cleanup, i came also through
> the
> >    conclusion that moving priv from tpm_vendor_specific to tpm_chip
> structure
> >    would the most
> >    simple and appropriate solution in short term.
> >
> >    ...priv field may be renamed data...
> >    Do you see anything against a serie removing atmel_get_priv and
> >    tpm_nsc_get_priv and with a common helper replacing TPM_VPRIV ?
>
> Yes I do. The current problem is that HW specific stuff lives in the
> framework and not in the drivers for that HW. I would like to see HW
> drivers to use priv for their internal and get rid off
> tpm_vendor_specific completely.
>
> /Jarkko
>
> >    Best Regards
> >    Christophe
> >    2016-03-22 7:20 GMT+01:00 Jarkko Sakkinen
> >    <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:
> >
> >      On Sun, Mar 20, 2016 at 08:34:36PM +0100, Christophe Ricard wrote:
> >      > Remove TPM_VPRIV macro and replace with tpm_set_vendordata and
> >      > tpm_get_vendordata.
> >
> >      NAK. These unnecessary wrapper functions make code just harder to
> read.
> >      I'd rather accept a patch that would drop TPM_VPRIV and not
> introduce
> >      new clutter.
> >      /Jarkko
> >      > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> >      > ---
> >      >  drivers/char/tpm/st33zp24/st33zp24.c | 26
> +++++++++++++-------------
> >      >  drivers/char/tpm/tpm.h               | 12 ++++++++++--
> >      >  drivers/char/tpm/tpm_ibmvtpm.c       |  8 ++++----
> >      >  drivers/char/tpm/tpm_tis.c           |  2 +-
> >      >  drivers/char/tpm/xen-tpmfront.c      | 14 +++++++-------
> >      >  5 files changed, 35 insertions(+), 27 deletions(-)
> >      >
> >      > diff --git a/drivers/char/tpm/st33zp24/st33zp24.c
> >      b/drivers/char/tpm/st33zp24/st33zp24.c
> >      > index 9e91ca7..dc2d0f3 100644
> >      > --- a/drivers/char/tpm/st33zp24/st33zp24.c
> >      > +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> >      > @@ -105,7 +105,7 @@ static void st33zp24_cancel(struct tpm_chip
> *chip)
> >      >       struct st33zp24_dev *tpm_dev;
> >      >       u8 data;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       data = TPM_STS_COMMAND_READY;
> >      >       tpm_dev->ops->send(tpm_dev->phy_id, TPM_STS, &data, 1);
> >      > @@ -121,7 +121,7 @@ static u8 st33zp24_status(struct tpm_chip
> *chip)
> >      >       struct st33zp24_dev *tpm_dev;
> >      >       u8 data;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS, &data, 1);
> >      >       return data;
> >      > @@ -138,7 +138,7 @@ static int check_locality(struct tpm_chip
> *chip)
> >      >       u8 data;
> >      >       u8 status;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_ACCESS,
> >      &data, 1);
> >      >       if (status && (data &
> >      > @@ -164,7 +164,7 @@ static int request_locality(struct tpm_chip
> *chip)
> >      >       if (check_locality(chip) == chip->vendor.locality)
> >      >               return chip->vendor.locality;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       data = TPM_ACCESS_REQUEST_USE;
> >      >       ret = tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data,
> >      1);
> >      > @@ -193,7 +193,7 @@ static void release_locality(struct tpm_chip
> >      *chip)
> >      >       struct st33zp24_dev *tpm_dev;
> >      >       u8 data;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >       data = TPM_ACCESS_ACTIVE_LOCALITY;
> >      >
> >      >       tpm_dev->ops->send(tpm_dev->phy_id, TPM_ACCESS, &data, 1);
> >      > @@ -211,7 +211,7 @@ static int get_burstcount(struct tpm_chip
> *chip)
> >      >       u8 temp;
> >      >       struct st33zp24_dev *tpm_dev;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       stop = jiffies + chip->vendor.timeout_d;
> >      >       do {
> >      > @@ -279,7 +279,7 @@ static int wait_for_stat(struct tpm_chip
> *chip, u8
> >      mask, unsigned long timeout,
> >      >       u8 status;
> >      >       struct st33zp24_dev *tpm_dev;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       /* check current status */
> >      >       status = st33zp24_status(chip);
> >      > @@ -340,7 +340,7 @@ static int recv_data(struct tpm_chip *chip, u8
> >      *buf, size_t count)
> >      >       int size = 0, burstcnt, len, ret;
> >      >       struct st33zp24_dev *tpm_dev;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       while (size < count &&
> >      >              wait_for_stat(chip,
> >      > @@ -372,7 +372,7 @@ static irqreturn_t tpm_ioserirq_handler(int
> irq,
> >      void *dev_id)
> >      >       struct tpm_chip *chip = dev_id;
> >      >       struct st33zp24_dev *tpm_dev;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       tpm_dev->intrs++;
> >      >       wake_up_interruptible(&chip->vendor.read_queue);
> >      > @@ -404,7 +404,7 @@ static int st33zp24_send(struct tpm_chip
> *chip,
> >      unsigned char *buf,
> >      >       if (len < TPM_HEADER_SIZE)
> >      >               return -EBUSY;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       ret = request_locality(chip);
> >      >       if (ret < 0)
> >      > @@ -565,7 +565,7 @@ int st33zp24_probe(void *phy_id, const struct
> >      st33zp24_phy_ops *ops,
> >      >       if (!tpm_dev)
> >      >               return -ENOMEM;
> >      >
> >      > -     TPM_VPRIV(chip) = tpm_dev;
> >      > +     tpm_set_vendordata(chip, tpm_dev);
> >      >       tpm_dev->phy_id = phy_id;
> >      >       tpm_dev->ops = ops;
> >      >
> >      > @@ -653,7 +653,7 @@ int st33zp24_pm_suspend(struct device *dev)
> >      >       struct st33zp24_dev *tpm_dev;
> >      >       int ret = 0;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       if (gpio_is_valid(tpm_dev->io_lpcpd))
> >      >               gpio_set_value(tpm_dev->io_lpcpd, 0);
> >      > @@ -675,7 +675,7 @@ int st33zp24_pm_resume(struct device *dev)
> >      >       struct st33zp24_dev *tpm_dev;
> >      >       int ret = 0;
> >      >
> >      > -     tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
> >      > +     tpm_dev = (struct st33zp24_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       if (gpio_is_valid(tpm_dev->io_lpcpd)) {
> >      >               gpio_set_value(tpm_dev->io_lpcpd, 1);
> >      > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> >      > index 28a0c17..6a973b9 100644
> >      > --- a/drivers/char/tpm/tpm.h
> >      > +++ b/drivers/char/tpm/tpm.h
> >      > @@ -157,8 +157,6 @@ struct tpm_vendor_specific {
> >      >       u16 manufacturer_id;
> >      >  };
> >      >
> >      > -#define TPM_VPRIV(c)     ((c)->vendor.priv)
> >      > -
> >      >  #define TPM_VID_INTEL    0x8086
> >      >  #define TPM_VID_WINBOND  0x1050
> >      >  #define TPM_VID_STM      0x104A
> >      > @@ -203,6 +201,16 @@ struct tpm_chip {
> >      >
> >      >  #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
> >      >
> >      > +static inline void tpm_set_vendordata(struct tpm_chip *chip, void
> >      *data)
> >      > +{
> >      > +     chip->vendor.priv = data;
> >      > +}
> >      > +
> >      > +static inline void *tpm_get_vendordata(struct tpm_chip *chip)
> >      > +{
> >      > +     return chip->vendor.priv;
> >      > +}
> >      > +
> >      >  static inline int tpm_read_index(int base, int index)
> >      >  {
> >      >       outb(index, base);
> >      > diff --git a/drivers/char/tpm/tpm_ibmvtpm.c
> >      b/drivers/char/tpm/tpm_ibmvtpm.c
> >      > index b0a9a9e..c8b1643 100644
> >      > --- a/drivers/char/tpm/tpm_ibmvtpm.c
> >      > +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> >      > @@ -64,7 +64,7 @@ static struct ibmvtpm_dev
> *ibmvtpm_get_data(const
> >      struct device *dev)
> >      >  {
> >      >       struct tpm_chip *chip = dev_get_drvdata(dev);
> >      >       if (chip)
> >      > -             return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> >      > +             return (struct ibmvtpm_dev
> >      *)tpm_get_vendordata(chip);
> >      >       return NULL;
> >      >  }
> >      >
> >      > @@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv(struct tpm_chip
> *chip,
> >      u8 *buf, size_t count)
> >      >       u16 len;
> >      >       int sig;
> >      >
> >      > -     ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> >      > +     ibmvtpm = (struct ibmvtpm_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       if (!ibmvtpm->rtce_buf) {
> >      >               dev_err(ibmvtpm->dev, "ibmvtpm device is not
> >      ready\n");
> >      > @@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_chip
> *chip,
> >      u8 *buf, size_t count)
> >      >       __be64 *word = (__be64 *)&crq;
> >      >       int rc, sig;
> >      >
> >      > -     ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> >      > +     ibmvtpm = (struct ibmvtpm_dev *)tpm_get_vendordata(chip);
> >      >
> >      >       if (!ibmvtpm->rtce_buf) {
> >      >               dev_err(ibmvtpm->dev, "ibmvtpm device is not
> >      ready\n");
> >      > @@ -643,7 +643,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev
> >      *vio_dev,
> >      >
> >      >       crq_q->index = 0;
> >      >
> >      > -     TPM_VPRIV(chip) = (void *)ibmvtpm;
> >      > +     tpm_set_vendordata(chip, (void *)ibmvtpm);
> >      >
> >      >       spin_lock_init(&ibmvtpm->rtce_lock);
> >      >
> >      > diff --git a/drivers/char/tpm/tpm_tis.c
> b/drivers/char/tpm/tpm_tis.c
> >      > index eed3bf5..607fa3f 100644
> >      > --- a/drivers/char/tpm/tpm_tis.c
> >      > +++ b/drivers/char/tpm/tpm_tis.c
> >      > @@ -678,7 +678,7 @@ static int tpm_tis_init(struct device *dev,
> struct
> >      tpm_info *tpm_info,
> >      >       if (IS_ERR(chip))
> >      >               return PTR_ERR(chip);
> >      >
> >      > -     chip->vendor.priv = priv;
> >      > +     tpm_set_vendordata(chip, priv);
> >      >  #ifdef CONFIG_ACPI
> >      >       chip->acpi_dev_handle = acpi_dev_handle;
> >      >  #endif
> >      > diff --git a/drivers/char/tpm/xen-tpmfront.c
> >      b/drivers/char/tpm/xen-tpmfront.c
> >      > index 3111f27..c472fd8 100644
> >      > --- a/drivers/char/tpm/xen-tpmfront.c
> >      > +++ b/drivers/char/tpm/xen-tpmfront.c
> >      > @@ -39,7 +39,7 @@ enum status_bits {
> >      >
> >      >  static u8 vtpm_status(struct tpm_chip *chip)
> >      >  {
> >      > -     struct tpm_private *priv = TPM_VPRIV(chip);
> >      > +     struct tpm_private *priv = tpm_get_vendordata(chip);
> >      >       switch (priv->shr->state) {
> >      >       case VTPM_STATE_IDLE:
> >      >               return VTPM_STATUS_IDLE | VTPM_STATUS_CANCELED;
> >      > @@ -60,7 +60,7 @@ static bool vtpm_req_canceled(struct tpm_chip
> *chip,
> >      u8 status)
> >      >
> >      >  static void vtpm_cancel(struct tpm_chip *chip)
> >      >  {
> >      > -     struct tpm_private *priv = TPM_VPRIV(chip);
> >      > +     struct tpm_private *priv = tpm_get_vendordata(chip);
> >      >       priv->shr->state = VTPM_STATE_CANCEL;
> >      >       wmb();
> >      >       notify_remote_via_evtchn(priv->evtchn);
> >      > @@ -73,7 +73,7 @@ static unsigned int shr_data_offset(struct
> >      vtpm_shared_page *shr)
> >      >
> >      >  static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t
> count)
> >      >  {
> >      > -     struct tpm_private *priv = TPM_VPRIV(chip);
> >      > +     struct tpm_private *priv = tpm_get_vendordata(chip);
> >      >       struct vtpm_shared_page *shr = priv->shr;
> >      >       unsigned int offset = shr_data_offset(shr);
> >      >
> >      > @@ -115,7 +115,7 @@ static int vtpm_send(struct tpm_chip *chip, u8
> >      *buf, size_t count)
> >      >
> >      >  static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t
> count)
> >      >  {
> >      > -     struct tpm_private *priv = TPM_VPRIV(chip);
> >      > +     struct tpm_private *priv = tpm_get_vendordata(chip);
> >      >       struct vtpm_shared_page *shr = priv->shr;
> >      >       unsigned int offset = shr_data_offset(shr);
> >      >       size_t length = shr->length;
> >      > @@ -182,7 +182,7 @@ static int setup_chip(struct device *dev,
> struct
> >      tpm_private *priv)
> >      >       init_waitqueue_head(&chip->vendor.read_queue);
> >      >
> >      >       priv->chip = chip;
> >      > -     TPM_VPRIV(chip) = priv;
> >      > +     tpm_set_vendordata(chip, priv);
> >      >
> >      >       return 0;
> >      >  }
> >      > @@ -318,10 +318,10 @@ static int tpmfront_probe(struct
> xenbus_device
> >      *dev,
> >      >  static int tpmfront_remove(struct xenbus_device *dev)
> >      >  {
> >      >       struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
> >      > -     struct tpm_private *priv = TPM_VPRIV(chip);
> >      > +     struct tpm_private *priv = tpm_get_vendordata(chip);
> >      >       tpm_chip_unregister(chip);
> >      >       ring_free(priv);
> >      > -     TPM_VPRIV(chip) = NULL;
> >      > +     tpm_set_vendordata(chip, NULL);
> >      >       return 0;
> >      >  }
> >      >
> >      > --
> >      > 2.5.0
> >      >
>

--001a11407e6019d80b052ecb7490
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Jarkko,<div><br></div><div>I am currently working at re=
moving this TPM_VPRIV and priv field as requested previously.</div><div>As =
pointed by you or Jason, i succeeded to go the dev_get_drvdata way :).</div=
><div><br></div><div>Will send a new serie asap once ready.</div><div><br><=
/div><div>Best Regards</div><div>Christophe</div></div><div class=3D"gmail_=
extra"><br><div class=3D"gmail_quote">2016-03-24 14:27 GMT+01:00 Jarkko Sak=
kinen <span dir=3D"ltr">&lt;<a href=3D"mailto:jarkko.sakkinen-VuQAYsv1563A2t4k+OOtxA@public.gmane.org=
om" target=3D"_blank">jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;</span>:<br><b=
lockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px =
#ccc solid;padding-left:1ex"><span class=3D"">On Wed, Mar 23, 2016 at 02:11=
:26PM +0100, Christophe Ricard wrote:<br>
</span><span class=3D"">&gt;=C2=A0 =C2=A0 Hi Jarkko,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Just coming back to you on this one. My intention was mai=
nly align the<br>
&gt;=C2=A0 =C2=A0 &quot;code style&quot; from my eyes with other similar fu=
nctions from other<br>
&gt;=C2=A0 =C2=A0 subsystems.<br>
&gt;=C2=A0 =C2=A0 For example and coming to my mind:<br>
&gt;=C2=A0 =C2=A0 i2c: i2c_get_clientdata/i2c_set_clientdata<br>
&gt;=C2=A0 =C2=A0 spi: spi_get_drvdata/spi_set_drvdata<br>
&gt;=C2=A0 =C2=A0 nfc: nfc_get_drvdata/nfc_set_drvdata<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 In the mean time when trying to cleanup the code i found =
helpers with the<br>
&gt;=C2=A0 =C2=A0 exact same purpose in tpm_atmel.h (atmel_get_priv) or tpm=
_nsc.c<br>
&gt;=C2=A0 =C2=A0 (tpm_nsc_get_priv).<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 When working on the tpm_vendor_specific cleanup, i came a=
lso through the<br>
&gt;=C2=A0 =C2=A0 conclusion that moving priv from tpm_vendor_specific to t=
pm_chip structure<br>
&gt;=C2=A0 =C2=A0 would the most<br>
&gt;=C2=A0 =C2=A0 simple and appropriate solution in short term.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 ...priv field may be renamed data...<br>
&gt;=C2=A0 =C2=A0 Do you see anything against a serie removing atmel_get_pr=
iv and<br>
&gt;=C2=A0 =C2=A0 tpm_nsc_get_priv and with a common helper replacing TPM_V=
PRIV ?<br>
<br>
</span>Yes I do. The current problem is that HW specific stuff lives in the=
<br>
framework and not in the drivers for that HW. I would like to see HW<br>
drivers to use priv for their internal and get rid off<br>
tpm_vendor_specific completely.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
/Jarkko<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;=C2=A0 =C2=A0 Best Regards<br>
&gt;=C2=A0 =C2=A0 Christophe<br>
&gt;=C2=A0 =C2=A0 2016-03-22 7:20 GMT+01:00 Jarkko Sakkinen<br>
&gt;=C2=A0 =C2=A0 &lt;<a href=3D"mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org">ja=
rkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 On Sun, Mar 20, 2016 at 08:34:36PM +0100, Christop=
he Ricard wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; Remove TPM_VPRIV macro and replace with tpm_s=
et_vendordata and<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; tpm_get_vendordata.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 NAK. These unnecessary wrapper functions make code=
 just harder to read.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 I&#39;d rather accept a patch that would drop TPM_=
VPRIV and not introduce<br>
&gt;=C2=A0 =C2=A0 =C2=A0 new clutter.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 /Jarkko<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; Signed-off-by: Christophe Ricard &lt;<a href=
=3D"mailto:christophe-h.ricard-qxv4g6HH51o@public.gmane.org">christophe-h.ricard-qxv4g6HH51o@public.gmane.org</a>&gt;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; ---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/st33zp24/st33zp24.c | =
26 +++++++++++++-------------<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/tpm.h=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 12 ++++++++++--<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/tpm_ibmvtpm.c=C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 8 ++++----<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 drivers/char/tpm/xen-tpmfront.c=C2=A0 =
=C2=A0 =C2=A0 | 14 +++++++-------<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 5 files changed, 35 insertions(+), 27 d=
eletions(-)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/st33zp24/st33zp=
24.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 b/drivers/char/tpm/st33zp24/st33zp24.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; index 9e91ca7..dc2d0f3 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --- a/drivers/char/tpm/st33zp24/st33zp24.c<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/st33zp24/st33zp24.c<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -105,7 +105,7 @@ static void st33zp24_canc=
el(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_STS_CO=
MMAND_READY;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;ops-&gt=
;send(tpm_dev-&gt;phy_id, TPM_STS, &amp;data, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -121,7 +121,7 @@ static u8 st33zp24_status=
(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;ops-&gt=
;recv(tpm_dev-&gt;phy_id, TPM_STS, &amp;data, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -138,7 +138,7 @@ static int check_locality=
(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_dev-=
&gt;ops-&gt;recv(tpm_dev-&gt;phy_id, TPM_ACCESS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &amp;data, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (status &amp;&am=
p; (data &amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -164,7 +164,7 @@ static int request_locali=
ty(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_locality(=
chip) =3D=3D chip-&gt;vendor.locality)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return chip-&gt;vendor.locality;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_ACCESS=
_REQUEST_USE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D tpm_dev-&gt=
;ops-&gt;send(tpm_dev-&gt;phy_id, TPM_ACCESS, &amp;data,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -193,7 +193,7 @@ static void release_local=
ity(struct tpm_chip<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0data =3D TPM_ACCESS=
_ACTIVE_LOCALITY;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;ops-&gt=
;send(tpm_dev-&gt;phy_id, TPM_ACCESS, &amp;data, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -211,7 +211,7 @@ static int get_burstcount=
(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 temp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + =
chip-&gt;vendor.timeout_d;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -279,7 +279,7 @@ static int wait_for_stat(=
struct tpm_chip *chip, u8<br>
&gt;=C2=A0 =C2=A0 =C2=A0 mask, unsigned long timeout,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* check current st=
atus */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D st33zp24=
_status(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -340,7 +340,7 @@ static int recv_data(stru=
ct tpm_chip *chip, u8<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, bur=
stcnt, len, ret;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size &lt; co=
unt &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 wait_for_stat(chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -372,7 +372,7 @@ static irqreturn_t tpm_io=
serirq_handler(int irq,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 void *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *ch=
ip =3D dev_id;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;intrs++=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up_interruptib=
le(&amp;chip-&gt;vendor.read_queue);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -404,7 +404,7 @@ static int st33zp24_send(=
struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 unsigned char *buf,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (len &lt; TPM_HE=
ADER_SIZE)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EBUSY;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D request_loc=
ality(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &lt; 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -565,7 +565,7 @@ int st33zp24_probe(void *=
phy_id, const struct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 st33zp24_phy_ops *ops,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tpm_dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -ENOMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D tpm_=
dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip,=
 tpm_dev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;phy_id =
=3D phy_id;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_dev-&gt;ops =3D=
 ops;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -653,7 +653,7 @@ int st33zp24_pm_suspend(s=
truct device *dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gpio_is_valid(t=
pm_dev-&gt;io_lpcpd))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0gpio_set_value(tpm_dev-&gt;io_lpcpd, 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -675,7 +675,7 @@ int st33zp24_pm_resume(st=
ruct device *dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct st33zp24_dev=
 *tpm_dev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_dev =3D (struct st33=
zp24_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (gpio_is_valid(t=
pm_dev-&gt;io_lpcpd)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0gpio_set_value(tpm_dev-&gt;io_lpcpd, 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/tpm.h b/drivers=
/char/tpm/tpm.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; index 28a0c17..6a973b9 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --- a/drivers/char/tpm/tpm.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/tpm.h<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -157,8 +157,6 @@ struct tpm_vendor_specifi=
c {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 };<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -#define TPM_VPRIV(c)=C2=A0 =C2=A0 =C2=A0((c)=
-&gt;vendor.priv)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #define TPM_VID_INTEL=C2=A0 =C2=A0 0x80=
86<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #define TPM_VID_WINBOND=C2=A0 0x1050<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #define TPM_VID_STM=C2=A0 =C2=A0 =C2=A0=
 0x104A<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -203,6 +201,16 @@ struct tpm_chip {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #define to_tpm_chip(d) container_of(d, =
struct tpm_chip, dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +static inline void tpm_set_vendordata(struct=
 tpm_chip *chip, void<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *data)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.priv =3D=
 data;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +static inline void *tpm_get_vendordata(struc=
t tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0return chip-&gt;vendor.p=
riv;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static inline int tpm_read_index(int ba=
se, int index)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0outb(index, base);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/tpm_ibmvtpm.c<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 b/drivers/char/tpm/tpm_ibmvtpm.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; index b0a9a9e..c8b1643 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --- a/drivers/char/tpm/tpm_ibmvtpm.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/tpm_ibmvtpm.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -64,7 +64,7 @@ static struct ibmvtpm_dev *=
ibmvtpm_get_data(const<br>
&gt;=C2=A0 =C2=A0 =C2=A0 struct device *dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *ch=
ip =3D dev_get_drvdata(dev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0return (struct ibmvtpm_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0return (struct ibmvtpm_dev<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv=
(struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 u8 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 len;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int sig;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmv=
tpm_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmv=
tpm_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ibmvtpm-&gt;rt=
ce_buf) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dev_err(ibmvtpm-&gt;dev, &quot;ibmvtpm device is not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ready\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -127,7 +127,7 @@ static int tpm_ibmvtpm_se=
nd(struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 u8 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__be64 *word =3D (_=
_be64 *)&amp;crq;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc, sig;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmv=
tpm_dev *)TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0ibmvtpm =3D (struct ibmv=
tpm_dev *)tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ibmvtpm-&gt;rt=
ce_buf) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0dev_err(ibmvtpm-&gt;dev, &quot;ibmvtpm device is not<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ready\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -643,7 +643,7 @@ static int tpm_ibmvtpm_pr=
obe(struct vio_dev<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *vio_dev,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0crq_q-&gt;index =3D=
 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D (voi=
d *)ibmvtpm;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip,=
 (void *)ibmvtpm);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&amp=
;ibmvtpm-&gt;rtce_lock);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/tpm_tis.c b/dri=
vers/char/tpm/tpm_tis.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; index eed3bf5..607fa3f 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --- a/drivers/char/tpm/tpm_tis.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/tpm_tis.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -678,7 +678,7 @@ static int tpm_tis_init(s=
truct device *dev, struct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(chip))<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return PTR_ERR(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.priv =3D=
 priv;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip,=
 priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #ifdef CONFIG_ACPI<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;acpi_dev_h=
andle =3D acpi_dev_handle;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; diff --git a/drivers/char/tpm/xen-tpmfront.c<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 b/drivers/char/tpm/xen-tpmfront.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; index 3111f27..c472fd8 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --- a/drivers/char/tpm/xen-tpmfront.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +++ b/drivers/char/tpm/xen-tpmfront.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -39,7 +39,7 @@ enum status_bits {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static u8 vtpm_status(struct tpm_chip *=
chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (priv-&gt;sh=
r-&gt;state) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0case VTPM_STATE_IDL=
E:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return VTPM_STATUS_IDLE | VTPM_STATUS_CANCELED;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -60,7 +60,7 @@ static bool vtpm_req_cancel=
ed(struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 u8 status)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static void vtpm_cancel(struct tpm_chip=
 *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;shr-&gt;st=
ate =3D VTPM_STATE_CANCEL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wmb();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0notify_remote_via_e=
vtchn(priv-&gt;evtchn);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -73,7 +73,7 @@ static unsigned int shr_dat=
a_offset(struct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 vtpm_shared_page *shr)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static int vtpm_send(struct tpm_chip *c=
hip, u8 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vtpm_shared_=
page *shr =3D priv-&gt;shr;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int offset=
 =3D shr_data_offset(shr);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -115,7 +115,7 @@ static int vtpm_send(stru=
ct tpm_chip *chip, u8<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static int vtpm_recv(struct tpm_chip *c=
hip, u8 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct vtpm_shared_=
page *shr =3D priv-&gt;shr;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int offset=
 =3D shr_data_offset(shr);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t length =3D s=
hr-&gt;length;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -182,7 +182,7 @@ static int setup_chip(str=
uct device *dev, struct<br>
&gt;=C2=A0 =C2=A0 =C2=A0 tpm_private *priv)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0init_waitqueue_head=
(&amp;chip-&gt;vendor.read_queue);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;chip =3D c=
hip;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D priv=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip,=
 priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; @@ -318,10 +318,10 @@ static int tpmfront_pro=
be(struct xenbus_device<br>
&gt;=C2=A0 =C2=A0 =C2=A0 *dev,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 static int tpmfront_remove(struct xenbu=
s_device *dev)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *ch=
ip =3D dev_get_drvdata(&amp;dev-&gt;dev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D TPM_VPRIV(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_private *priv=
 =3D tpm_get_vendordata(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_chip_unregister=
(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ring_free(priv);<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; -=C2=A0 =C2=A0 =C2=A0TPM_VPRIV(chip) =3D NULL=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; +=C2=A0 =C2=A0 =C2=A0tpm_set_vendordata(chip,=
 NULL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; --<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt; 2.5.0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 &gt;<br>
</div></div></blockquote></div><br></div>

--001a11407e6019d80b052ecb7490--


--===============3332841387811418747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
--===============3332841387811418747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3332841387811418747==--
