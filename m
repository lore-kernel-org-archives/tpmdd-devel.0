From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/6] tpm: drop 'iobase' from struct
	tpm_vendor_specific
Date: Thu, 31 Mar 2016 10:29:11 +0200
Message-ID: <CALD+uuxRKmGHoNcyOv7kSTVccFpmi6AzKxecHWPFcER=VR1zhA@mail.gmail.com>
References: <1459373895-17704-1-git-send-email-christophe-h.ricard@st.com>
	<1459373895-17704-2-git-send-email-christophe-h.ricard@st.com>
	<20160331064500.GB6393@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4987119047912143718=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160331064500.GB6393-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

--===============4987119047912143718==
Content-Type: multipart/alternative; boundary=089e0141a190b38d74052f540fe6

--089e0141a190b38d74052f540fe6
Content-Type: text/plain; charset=UTF-8

[Resending to the mailing list]

Hi Jarkko,

I don't mind fixing:

WARNING: line over 80 characters
#465: FILE: drivers/char/tpm/tpm_tis.c:685:
+                          priv->iobase +
TPM_INT_ENABLE(chip->vendor.locality));

However i wonder if:
WARNING: macros should not use a trailing semicolon
#175: FILE: drivers/char/tpm/tpm_atmel.h:41:
+#define atmel_getb(priv, offset) readb(priv->iobase + offset);

Shouldn't be fixed in a separated patch.

What's your preferred option ? (e.g fix this warning directly in this patch
or in a separate one).

Best Regards

2016-03-31 8:45 GMT+02:00 Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>:

> On Wed, Mar 30, 2016 at 11:38:10PM +0200, Christophe Ricard wrote:
> > Dropped the field 'iobase' from struct tpm_vendor_specific and migrated
> > it to the private structures of tpm_atmel and tpm_tis.
>
> Found couple of issues:
>
> $ scripts/checkpatch.pl
> ~/Downloads/v3-1-6-tpm-drop-iobase-from-struct-tpm_vendor_specific.patch
> WARNING: macros should not use a trailing semicolon
> #175: FILE: drivers/char/tpm/tpm_atmel.h:41:
> +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
>
> WARNING: line over 80 characters
> #465: FILE: drivers/char/tpm/tpm_tis.c:685:
> +                          priv->iobase +
> TPM_INT_ENABLE(chip->vendor.locality));
>
> total: 0 errors, 2 warnings, 465 lines checked
>
> /Jarkko
>
> > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm.h       |   2 -
> >  drivers/char/tpm/tpm_atmel.c |  28 +++++++-----
> >  drivers/char/tpm/tpm_atmel.h |   5 ++-
> >  drivers/char/tpm/tpm_tis.c   | 104
> +++++++++++++++++++++++++------------------
> >  4 files changed, 80 insertions(+), 59 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index cd780c7..357ac14 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -131,8 +131,6 @@ enum tpm2_startup_types {
> >  struct tpm_chip;
> >
> >  struct tpm_vendor_specific {
> > -     void __iomem *iobase;           /* ioremapped address */
> > -
> >       int irq;
> >
> >       int locality;
> > diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> > index 68d5c09..b769299 100644
> > --- a/drivers/char/tpm/tpm_atmel.c
> > +++ b/drivers/char/tpm/tpm_atmel.c
> > @@ -37,6 +37,7 @@ enum tpm_atmel_read_status {
> >
> >  static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> >  {
> > +     struct tpm_atmel_priv *priv = chip->vendor.priv;
> >       u8 status, *hdr = buf;
> >       u32 size;
> >       int i;
> > @@ -47,12 +48,12 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >               return -EIO;
> >
> >       for (i = 0; i < 6; i++) {
> > -             status = ioread8(chip->vendor.iobase + 1);
> > +             status = ioread8(priv->iobase + 1);
> >               if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
> >                       dev_err(&chip->dev, "error reading header\n");
> >                       return -EIO;
> >               }
> > -             *buf++ = ioread8(chip->vendor.iobase);
> > +             *buf++ = ioread8(priv->iobase);
> >       }
> >
> >       /* size of the data received */
> > @@ -63,7 +64,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >               dev_err(&chip->dev,
> >                       "Recv size(%d) less than available space\n", size);
> >               for (; i < size; i++) { /* clear the waiting data anyway */
> > -                     status = ioread8(chip->vendor.iobase + 1);
> > +                     status = ioread8(priv->iobase + 1);
> >                       if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
> >                               dev_err(&chip->dev, "error reading
> data\n");
> >                               return -EIO;
> > @@ -74,16 +75,16 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >
> >       /* read all the data available */
> >       for (; i < size; i++) {
> > -             status = ioread8(chip->vendor.iobase + 1);
> > +             status = ioread8(priv->iobase + 1);
> >               if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
> >                       dev_err(&chip->dev, "error reading data\n");
> >                       return -EIO;
> >               }
> > -             *buf++ = ioread8(chip->vendor.iobase);
> > +             *buf++ = ioread8(priv->iobase);
> >       }
> >
> >       /* make sure data available is gone */
> > -     status = ioread8(chip->vendor.iobase + 1);
> > +     status = ioread8(priv->iobase + 1);
> >
> >       if (status & ATML_STATUS_DATA_AVAIL) {
> >               dev_err(&chip->dev, "data available is stuck\n");
> > @@ -95,12 +96,13 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8
> *buf, size_t count)
> >
> >  static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
> >  {
> > +     struct tpm_atmel_priv *priv = chip->vendor.priv;
> >       int i;
> >
> >       dev_dbg(&chip->dev, "tpm_atml_send:\n");
> >       for (i = 0; i < count; i++) {
> >               dev_dbg(&chip->dev, "%d 0x%x(%d)\n",  i, buf[i], buf[i]);
> > -             iowrite8(buf[i], chip->vendor.iobase);
> > +             iowrite8(buf[i], priv->iobase);
> >       }
> >
> >       return count;
> > @@ -108,12 +110,16 @@ static int tpm_atml_send(struct tpm_chip *chip, u8
> *buf, size_t count)
> >
> >  static void tpm_atml_cancel(struct tpm_chip *chip)
> >  {
> > -     iowrite8(ATML_STATUS_ABORT, chip->vendor.iobase + 1);
> > +     struct tpm_atmel_priv *priv = chip->vendor.priv;
> > +
> > +     iowrite8(ATML_STATUS_ABORT, priv->iobase + 1);
> >  }
> >
> >  static u8 tpm_atml_status(struct tpm_chip *chip)
> >  {
> > -     return ioread8(chip->vendor.iobase + 1);
> > +     struct tpm_atmel_priv *priv = chip->vendor.priv;
> > +
> > +     return ioread8(priv->iobase + 1);
> >  }
> >
> >  static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 status)
> > @@ -142,7 +148,7 @@ static void atml_plat_remove(void)
> >               tpm_chip_unregister(chip);
> >               if (priv->have_region)
> >                       atmel_release_region(priv->base,
> priv->region_size);
> > -             atmel_put_base_addr(chip->vendor.iobase);
> > +             atmel_put_base_addr(priv->iobase);
> >               platform_device_unregister(pdev);
> >       }
> >  }
> > @@ -190,6 +196,7 @@ static int __init init_atmel(void)
> >               goto err_unreg_dev;
> >       }
> >
> > +     priv->iobase = iobase;
> >       priv->base = base;
> >       priv->have_region = have_region;
> >       priv->region_size = region_size;
> > @@ -200,7 +207,6 @@ static int __init init_atmel(void)
> >               goto err_unreg_dev;
> >       }
> >
> > -     chip->vendor.iobase = iobase;
> >       chip->vendor.priv = priv;
> >
> >       rc = tpm_chip_register(chip);
> > diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
> > index bced678..7e37c16 100644
> > --- a/drivers/char/tpm/tpm_atmel.h
> > +++ b/drivers/char/tpm/tpm_atmel.h
> > @@ -26,6 +26,7 @@ struct tpm_atmel_priv {
> >       int region_size;
> >       int have_region;
> >       unsigned long base;
> > +     void __iomem *iobase;
> >  };
> >
> >  static inline struct tpm_atmel_priv *atmel_get_priv(struct tpm_chip
> *chip)
> > @@ -37,8 +38,8 @@ static inline struct tpm_atmel_priv
> *atmel_get_priv(struct tpm_chip *chip)
> >
> >  #include <asm/prom.h>
> >
> > -#define atmel_getb(chip, offset) readb(chip->vendor->iobase + offset);
> > -#define atmel_putb(val, chip, offset) writeb(val, chip->vendor->iobase
> + offset)
> > +#define atmel_getb(priv, offset) readb(priv->iobase + offset);
> > +#define atmel_putb(val, priv, offset) writeb(val, priv->iobase + offset)
> >  #define atmel_request_region request_mem_region
> >  #define atmel_release_region release_mem_region
> >
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index 068f021..19dac62 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -94,6 +94,7 @@ struct tpm_info {
> >  #define      TPM_RID(l)                      (0x0F04 | ((l) << 12))
> >
> >  struct priv_data {
> > +     void __iomem *iobase;
> >       u16 manufacturer_id;
> >       bool irq_tested;
> >       wait_queue_head_t int_queue;
> > @@ -128,9 +129,10 @@ static inline int is_itpm(struct acpi_device *dev)
> >   * correct values in the other bits.' */
> >  static int wait_startup(struct tpm_chip *chip, int l)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       unsigned long stop = jiffies + chip->vendor.timeout_a;
> >       do {
> > -             if (ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
> > +             if (ioread8(priv->iobase + TPM_ACCESS(l)) &
> >                   TPM_ACCESS_VALID)
> >                       return 0;
> >               msleep(TPM_TIMEOUT);
> > @@ -140,7 +142,9 @@ static int wait_startup(struct tpm_chip *chip, int l)
> >
> >  static int check_locality(struct tpm_chip *chip, int l)
> >  {
> > -     if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
> > +     struct priv_data *priv = chip->vendor.priv;
> > +
> > +     if ((ioread8(priv->iobase + TPM_ACCESS(l)) &
> >            (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> >           (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
> >               return chip->vendor.locality = l;
> > @@ -150,11 +154,13 @@ static int check_locality(struct tpm_chip *chip,
> int l)
> >
> >  static void release_locality(struct tpm_chip *chip, int l, int force)
> >  {
> > -     if (force || (ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
> > +     struct priv_data *priv = chip->vendor.priv;
> > +
> > +     if (force || (ioread8(priv->iobase + TPM_ACCESS(l)) &
> >                     (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
> >           (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
> >               iowrite8(TPM_ACCESS_ACTIVE_LOCALITY,
> > -                      chip->vendor.iobase + TPM_ACCESS(l));
> > +                      priv->iobase + TPM_ACCESS(l));
> >  }
> >
> >  static int request_locality(struct tpm_chip *chip, int l)
> > @@ -167,7 +173,7 @@ static int request_locality(struct tpm_chip *chip,
> int l)
> >               return l;
> >
> >       iowrite8(TPM_ACCESS_REQUEST_USE,
> > -              chip->vendor.iobase + TPM_ACCESS(l));
> > +              priv->iobase + TPM_ACCESS(l));
> >
> >       stop = jiffies + chip->vendor.timeout_a;
> >
> > @@ -200,19 +206,24 @@ again:
> >
> >  static u8 tpm_tis_status(struct tpm_chip *chip)
> >  {
> > -     return ioread8(chip->vendor.iobase +
> > +     struct priv_data *priv = chip->vendor.priv;
> > +
> > +     return ioread8(priv->iobase +
> >                      TPM_STS(chip->vendor.locality));
> >  }
> >
> >  static void tpm_tis_ready(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> > +
> >       /* this causes the current command to be aborted */
> >       iowrite8(TPM_STS_COMMAND_READY,
> > -              chip->vendor.iobase + TPM_STS(chip->vendor.locality));
> > +              priv->iobase + TPM_STS(chip->vendor.locality));
> >  }
> >
> >  static int get_burstcount(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       unsigned long stop;
> >       int burstcnt;
> >
> > @@ -220,9 +231,9 @@ static int get_burstcount(struct tpm_chip *chip)
> >       /* which timeout value, spec has 2 answers (c & d) */
> >       stop = jiffies + chip->vendor.timeout_d;
> >       do {
> > -             burstcnt = ioread8(chip->vendor.iobase +
> > +             burstcnt = ioread8(priv->iobase +
> >                                  TPM_STS(chip->vendor.locality) + 1);
> > -             burstcnt += ioread8(chip->vendor.iobase +
> > +             burstcnt += ioread8(priv->iobase +
> >                                   TPM_STS(chip->vendor.locality) +
> >                                   2) << 8;
> >               if (burstcnt)
> > @@ -234,6 +245,7 @@ static int get_burstcount(struct tpm_chip *chip)
> >
> >  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       int size = 0, burstcnt;
> >       while (size < count &&
> >              wait_for_tpm_stat(chip,
> > @@ -243,7 +255,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf,
> size_t count)
> >              == 0) {
> >               burstcnt = get_burstcount(chip);
> >               for (; burstcnt > 0 && size < count; burstcnt--)
> > -                     buf[size++] = ioread8(chip->vendor.iobase +
> > +                     buf[size++] = ioread8(priv->iobase +
> >                                             TPM_DATA_FIFO(chip->vendor.
> >                                                           locality));
> >       }
> > @@ -329,7 +341,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >       while (count < len - 1) {
> >               burstcnt = get_burstcount(chip);
> >               for (; burstcnt > 0 && count < len - 1; burstcnt--) {
> > -                     iowrite8(buf[count], chip->vendor.iobase +
> > +                     iowrite8(buf[count], priv->iobase +
> >                                TPM_DATA_FIFO(chip->vendor.locality));
> >                       count++;
> >               }
> > @@ -345,7 +357,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >
> >       /* write last byte */
> >       iowrite8(buf[count],
> > -              chip->vendor.iobase +
> TPM_DATA_FIFO(chip->vendor.locality));
> > +              priv->iobase + TPM_DATA_FIFO(chip->vendor.locality));
> >       wait_for_tpm_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
> >                         &priv->int_queue, false);
> >       status = tpm_tis_status(chip);
> > @@ -364,15 +376,15 @@ out_err:
> >
> >  static void disable_interrupts(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       u32 intmask;
> >
> >       intmask =
> > -         ioread32(chip->vendor.iobase +
> > +         ioread32(priv->iobase +
> >                    TPM_INT_ENABLE(chip->vendor.locality));
> >       intmask &= ~TPM_GLOBAL_INT_ENABLE;
> >       iowrite32(intmask,
> > -               chip->vendor.iobase +
> > -               TPM_INT_ENABLE(chip->vendor.locality));
> > +               priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> >       devm_free_irq(&chip->dev, chip->vendor.irq, chip);
> >       chip->vendor.irq = 0;
> >  }
> > @@ -384,6 +396,7 @@ static void disable_interrupts(struct tpm_chip *chip)
> >   */
> >  static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       int rc;
> >       u32 ordinal;
> >       unsigned long dur;
> > @@ -394,7 +407,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >
> >       /* go and do it */
> >       iowrite8(TPM_STS_GO,
> > -              chip->vendor.iobase + TPM_STS(chip->vendor.locality));
> > +              priv->iobase + TPM_STS(chip->vendor.locality));
> >
> >       if (chip->vendor.irq) {
> >               ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > @@ -453,10 +466,11 @@ static const struct tis_vendor_timeout_override
> vendor_timeout_overrides[] = {
> >  static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
> >                                   unsigned long *timeout_cap)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       int i;
> >       u32 did_vid;
> >
> > -     did_vid = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> > +     did_vid = ioread32(priv->iobase + TPM_DID_VID(0));
> >
> >       for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
> >               if (vendor_timeout_overrides[i].did_vid != did_vid)
> > @@ -476,6 +490,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip
> *chip,
> >   */
> >  static int probe_itpm(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       int rc = 0;
> >       u8 cmd_getticks[] = {
> >               0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> > @@ -483,7 +498,7 @@ static int probe_itpm(struct tpm_chip *chip)
> >       };
> >       size_t len = sizeof(cmd_getticks);
> >       bool rem_itpm = itpm;
> > -     u16 vendor = ioread16(chip->vendor.iobase + TPM_DID_VID(0));
> > +     u16 vendor = ioread16(priv->iobase + TPM_DID_VID(0));
> >
> >       /* probe only iTPMS */
> >       if (vendor != TPM_VID_INTEL)
> > @@ -548,7 +563,7 @@ static irqreturn_t tis_int_handler(int dummy, void
> *dev_id)
> >       u32 interrupt;
> >       int i;
> >
> > -     interrupt = ioread32(chip->vendor.iobase +
> > +     interrupt = ioread32(priv->iobase +
> >                            TPM_INT_STATUS(chip->vendor.locality));
> >
> >       if (interrupt == 0)
> > @@ -568,9 +583,9 @@ static irqreturn_t tis_int_handler(int dummy, void
> *dev_id)
> >
> >       /* Clear interrupts handled with TPM_EOI */
> >       iowrite32(interrupt,
> > -               chip->vendor.iobase +
> > +               priv->iobase +
> >                 TPM_INT_STATUS(chip->vendor.locality));
> > -     ioread32(chip->vendor.iobase +
> TPM_INT_STATUS(chip->vendor.locality));
> > +     ioread32(priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
> >       return IRQ_HANDLED;
> >  }
> >
> > @@ -592,19 +607,19 @@ static int tpm_tis_probe_irq_single(struct
> tpm_chip *chip, u32 intmask,
> >       }
> >       chip->vendor.irq = irq;
> >
> > -     original_int_vec = ioread8(chip->vendor.iobase +
> > +     original_int_vec = ioread8(priv->iobase +
> >                                  TPM_INT_VECTOR(chip->vendor.locality));
> >       iowrite8(irq,
> > -              chip->vendor.iobase +
> TPM_INT_VECTOR(chip->vendor.locality));
> > +              priv->iobase + TPM_INT_VECTOR(chip->vendor.locality));
> >
> >       /* Clear all existing */
> > -     iowrite32(ioread32(chip->vendor.iobase +
> > +     iowrite32(ioread32(priv->iobase +
> >                          TPM_INT_STATUS(chip->vendor.locality)),
> > -               chip->vendor.iobase +
> TPM_INT_STATUS(chip->vendor.locality));
> > +               priv->iobase + TPM_INT_STATUS(chip->vendor.locality));
> >
> >       /* Turn on */
> >       iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
> > -               chip->vendor.iobase +
> TPM_INT_ENABLE(chip->vendor.locality));
> > +               priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> >
> >       priv->irq_tested = false;
> >
> > @@ -621,8 +636,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip
> *chip, u32 intmask,
> >        */
> >       if (!chip->vendor.irq) {
> >               iowrite8(original_int_vec,
> > -                      chip->vendor.iobase +
> > -                          TPM_INT_VECTOR(chip->vendor.locality));
> > +                      priv->iobase +
> TPM_INT_VECTOR(chip->vendor.locality));
> >               return 1;
> >       }
> >
> > @@ -635,10 +649,11 @@ static int tpm_tis_probe_irq_single(struct
> tpm_chip *chip, u32 intmask,
> >   */
> >  static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       u8 original_int_vec;
> >       int i;
> >
> > -     original_int_vec = ioread8(chip->vendor.iobase +
> > +     original_int_vec = ioread8(priv->iobase +
> >                                  TPM_INT_VECTOR(chip->vendor.locality));
> >
> >       if (!original_int_vec) {
> > @@ -658,15 +673,16 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
> >
> >  static void tpm_tis_remove(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> > +
> >       if (chip->flags & TPM_CHIP_FLAG_TPM2)
> >               tpm2_shutdown(chip, TPM2_SU_CLEAR);
> >
> >       iowrite32(~TPM_GLOBAL_INT_ENABLE &
> > -               ioread32(chip->vendor.iobase +
> > +               ioread32(priv->iobase +
> >                          TPM_INT_ENABLE(chip->vendor.
> >                                         locality)),
> > -               chip->vendor.iobase +
> > -               TPM_INT_ENABLE(chip->vendor.locality));
> > +                        priv->iobase +
> TPM_INT_ENABLE(chip->vendor.locality));
> >       release_locality(chip, chip->vendor.locality, 1);
> >  }
> >
> > @@ -691,9 +707,9 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       chip->acpi_dev_handle = acpi_dev_handle;
> >  #endif
> >
> > -     chip->vendor.iobase = devm_ioremap_resource(dev, &tpm_info->res);
> > -     if (IS_ERR(chip->vendor.iobase))
> > -             return PTR_ERR(chip->vendor.iobase);
> > +     priv->iobase = devm_ioremap_resource(dev, &tpm_info->res);
> > +     if (IS_ERR(priv->iobase))
> > +             return PTR_ERR(priv->iobase);
> >
> >       /* Maximum timeouts */
> >       chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
> > @@ -707,13 +723,13 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       }
> >
> >       /* Take control of the TPM's interrupt hardware and shut it off */
> > -     intmask = ioread32(chip->vendor.iobase +
> > +     intmask = ioread32(priv->iobase +
> >                          TPM_INT_ENABLE(chip->vendor.locality));
> >       intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
> >                  TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
> >       intmask &= ~TPM_GLOBAL_INT_ENABLE;
> >       iowrite32(intmask,
> > -               chip->vendor.iobase +
> TPM_INT_ENABLE(chip->vendor.locality));
> > +               priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> >
> >       if (request_locality(chip, 0) != 0) {
> >               rc = -ENODEV;
> > @@ -724,12 +740,12 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       if (rc)
> >               goto out_err;
> >
> > -     vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
> > +     vendor = ioread32(priv->iobase + TPM_DID_VID(0));
> >       priv->manufacturer_id = vendor;
> >
> >       dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> >                (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> > -              vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
> > +              vendor >> 16, ioread8(priv->iobase + TPM_RID(0)));
> >
> >       if (!itpm) {
> >               probe = probe_itpm(chip);
> > @@ -746,7 +762,7 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >
> >       /* Figure out the capabilities */
> >       intfcaps =
> > -         ioread32(chip->vendor.iobase +
> > +         ioread32(priv->iobase +
> >                    TPM_INTF_CAPS(chip->vendor.locality));
> >       dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
> >               intfcaps);
> > @@ -825,23 +841,23 @@ out_err:
> >  #ifdef CONFIG_PM_SLEEP
> >  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> >  {
> > +     struct priv_data *priv = chip->vendor.priv;
> >       u32 intmask;
> >
> >       /* reenable interrupts that device may have lost or
> >          BIOS/firmware may have disabled */
> > -     iowrite8(chip->vendor.irq, chip->vendor.iobase +
> > +     iowrite8(chip->vendor.irq, priv->iobase +
> >                TPM_INT_VECTOR(chip->vendor.locality));
> >
> >       intmask =
> > -         ioread32(chip->vendor.iobase +
> > -                  TPM_INT_ENABLE(chip->vendor.locality));
> > +         ioread32(priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> >
> >       intmask |= TPM_INTF_CMD_READY_INT
> >           | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
> >           | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
> >
> >       iowrite32(intmask,
> > -               chip->vendor.iobase +
> TPM_INT_ENABLE(chip->vendor.locality));
> > +               priv->iobase + TPM_INT_ENABLE(chip->vendor.locality));
> >  }
> >
> >  static int tpm_tis_resume(struct device *dev)
> > --
> > 2.5.0
> >
>

--089e0141a190b38d74052f540fe6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><span style=3D"font-size:12.8000001907349px">[Resendi=
ng to the mailing list]</span></div><div><span style=3D"font-size:12.800000=
1907349px"><br></span></div><span style=3D"font-size:12.8000001907349px">Hi=
 Jarkko,</span><div style=3D"font-size:12.8000001907349px"><br></div><div s=
tyle=3D"font-size:12.8000001907349px">I don&#39;t mind fixing:</div><span c=
lass=3D"im" style=3D"font-size:12.8000001907349px"><div><br></div><div><spa=
n style=3D"font-size:12.8000001907349px">WARNING: line over 80 characters</=
span><br style=3D"font-size:12.8000001907349px"><span style=3D"font-size:12=
.8000001907349px">#465: FILE: drivers/char/tpm/tpm_tis.c:</span><span style=
=3D"font-size:12.8000001907349px">685:</span><br style=3D"font-size:12.8000=
001907349px"><span style=3D"font-size:12.8000001907349px">+=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 priv-&gt;iobase +<br>TPM_INT_ENABLE(chip-&gt;vendor.locality));</span><=
br></div><div><span style=3D"font-size:12.8000001907349px"><br></span></div=
></span><div style=3D"font-size:12.8000001907349px"><span style=3D"font-siz=
e:12.8000001907349px">However i wonder if:</span></div><span class=3D"im" s=
tyle=3D"font-size:12.8000001907349px"><div><span style=3D"font-size:12.8000=
001907349px"><span style=3D"color:rgb(34,34,34);font-size:12.8000001907349p=
x">WARNING: macros should not use a trailing semicolon</span><br style=3D"c=
olor:rgb(34,34,34);font-size:12.8000001907349px"><span style=3D"color:rgb(3=
4,34,34);font-size:12.8000001907349px">#175: FILE: drivers/char/tpm/tpm_atm=
el.h:</span><span style=3D"color:rgb(34,34,34);font-size:12.8000001907349px=
">41:</span><br style=3D"color:rgb(34,34,34);font-size:12.8000001907349px">=
<span style=3D"font-size:12.8000001907349px">+#define atmel_getb(priv, offs=
et) readb(priv-&gt;iobase + offset);<br></span></span></div><div><span styl=
e=3D"font-size:12.8000001907349px"><br></span></div></span><div style=3D"fo=
nt-size:12.8000001907349px"><span style=3D"font-size:12.8000001907349px">Sh=
ouldn&#39;t be fixed in a separated patch.</span></div><div style=3D"font-s=
ize:12.8000001907349px"><span style=3D"font-size:12.8000001907349px"><br></=
span></div><div style=3D"font-size:12.8000001907349px"><span style=3D"font-=
size:12.8000001907349px">What&#39;s your preferred option ? (e.g fix this w=
arning directly in this patch or in a separate one).</span></div><div style=
=3D"font-size:12.8000001907349px"><span style=3D"font-size:12.8000001907349=
px"><br></span></div><div style=3D"font-size:12.8000001907349px"><span styl=
e=3D"font-size:12.8000001907349px">Best Regards</span></div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">2016-03-31 8:45 GMT+02:00 =
Jarkko Sakkinen <span dir=3D"ltr">&lt;<a href=3D"mailto:jarkko.sakkinen@lin=
ux.intel.com" target=3D"_blank">jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;</sp=
an>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, Mar 30, 201=
6 at 11:38:10PM +0200, Christophe Ricard wrote:<br>
&gt; Dropped the field &#39;iobase&#39; from struct tpm_vendor_specific and=
 migrated<br>
&gt; it to the private structures of tpm_atmel and tpm_tis.<br>
<br>
</span>Found couple of issues:<br>
<br>
$ scripts/<a href=3D"http://checkpatch.pl" rel=3D"noreferrer" target=3D"_bl=
ank">checkpatch.pl</a><br>
~/Downloads/v3-1-6-tpm-drop-iobase-from-struct-tpm_vendor_specific.patch<br=
>
WARNING: macros should not use a trailing semicolon<br>
#175: FILE: drivers/char/tpm/tpm_atmel.h:41:<br>
<span class=3D"">+#define atmel_getb(priv, offset) readb(priv-&gt;iobase + =
offset);<br>
<br>
</span>WARNING: line over 80 characters<br>
#465: FILE: drivers/char/tpm/tpm_tis.c:685:<br>
<span class=3D"">+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase +<br>
TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
<br>
</span>total: 0 errors, 2 warnings, 465 lines checked<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
/Jarkko<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Signed-off-by: Christophe Ricard &lt;<a href=3D"mailto:christophe-h.ri=
card-qxv4g6HH51o@public.gmane.org">christophe-h.ricard-qxv4g6HH51o@public.gmane.org</a>&gt;<br>
&gt; Reviewed-by: Jason Gunthorpe &lt;<a href=3D"mailto:jgunthorpe@obsidian=
research.com">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;<br>
&gt; Reviewed-by: Jarkko Sakkinen &lt;<a href=3D"mailto:jarkko.sakkinen@lin=
ux.intel.com">jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/char/tpm/tpm.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02=
 -<br>
&gt;=C2=A0 drivers/char/tpm/tpm_atmel.c |=C2=A0 28 +++++++-----<br>
&gt;=C2=A0 drivers/char/tpm/tpm_atmel.h |=C2=A0 =C2=A05 ++-<br>
&gt;=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0| 104 +++++++++++++++++++=
++++++------------------<br>
&gt;=C2=A0 4 files changed, 80 insertions(+), 59 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h<br>
&gt; index cd780c7..357ac14 100644<br>
&gt; --- a/drivers/char/tpm/tpm.h<br>
&gt; +++ b/drivers/char/tpm/tpm.h<br>
&gt; @@ -131,8 +131,6 @@ enum tpm2_startup_types {<br>
&gt;=C2=A0 struct tpm_chip;<br>
&gt;<br>
&gt;=C2=A0 struct tpm_vendor_specific {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* ioremapped address */<br>
&gt; -<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int irq;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int locality;<br>
&gt; diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel=
.c<br>
&gt; index 68d5c09..b769299 100644<br>
&gt; --- a/drivers/char/tpm/tpm_atmel.c<br>
&gt; +++ b/drivers/char/tpm/tpm_atmel.c<br>
&gt; @@ -37,6 +37,7 @@ enum tpm_atmel_read_status {<br>
&gt;<br>
&gt;=C2=A0 static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t =
count)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip-&gt;vendor.p=
riv;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 status, *hdr =3D buf;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 size;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt; @@ -47,12 +48,12 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8=
 *buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; 6; i++) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread8(ch=
ip-&gt;vendor.iobase + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread8(pr=
iv-&gt;iobase + 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((status &amp=
; ATML_STATUS_DATA_AVAIL) =3D=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0dev_err(&amp;chip-&gt;dev, &quot;error reading header\n&quot;)=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EIO;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread8(ch=
ip-&gt;vendor.iobase);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread8(pr=
iv-&gt;iobase);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* size of the data received */<br>
&gt; @@ -63,7 +64,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *=
buf, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;chi=
p-&gt;dev,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0&quot;Recv size(%d) less than available space\n&quot;, size);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; i &lt; si=
ze; i++) { /* clear the waiting data anyway */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0status =3D ioread8(chip-&gt;vendor.iobase + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0status =3D ioread8(priv-&gt;iobase + 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if ((status &amp; ATML_STATUS_DATA_AVAIL) =3D=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;chip-&gt;dev, &quot;e=
rror reading data\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;<br>
&gt; @@ -74,16 +75,16 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8=
 *buf, size_t count)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* read all the data available */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for (; i &lt; size; i++) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread8(ch=
ip-&gt;vendor.iobase + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D ioread8(pr=
iv-&gt;iobase + 1);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((status &amp=
; ATML_STATUS_DATA_AVAIL) =3D=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0dev_err(&amp;chip-&gt;dev, &quot;error reading data\n&quot;);<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EIO;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread8(ch=
ip-&gt;vendor.iobase);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*buf++ =3D ioread8(pr=
iv-&gt;iobase);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* make sure data available is gone */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0status =3D ioread8(chip-&gt;vendor.iobase + 1);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0status =3D ioread8(priv-&gt;iobase + 1);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (status &amp; ATML_STATUS_DATA_AVAIL) {<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_err(&amp;chi=
p-&gt;dev, &quot;data available is stuck\n&quot;);<br>
&gt; @@ -95,12 +96,13 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8=
 *buf, size_t count)<br>
&gt;<br>
&gt;=C2=A0 static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t =
count)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip-&gt;vendor.p=
riv;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(&amp;chip-&gt;dev, &quot;tpm_atml_se=
nd:\n&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; count; i++) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(&amp;chi=
p-&gt;dev, &quot;%d 0x%x(%d)\n&quot;,=C2=A0 i, buf[i], buf[i]);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[i], chip=
-&gt;vendor.iobase);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[i], priv=
-&gt;iobase);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return count;<br>
&gt; @@ -108,12 +110,16 @@ static int tpm_atml_send(struct tpm_chip *chip, =
u8 *buf, size_t count)<br>
&gt;<br>
&gt;=C2=A0 static void tpm_atml_cancel(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(ATML_STATUS_ABORT, chip-&gt;vendor.iobas=
e + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip-&gt;vendor.p=
riv;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0iowrite8(ATML_STATUS_ABORT, priv-&gt;iobase + 1);=
<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static u8 tpm_atml_status(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ioread8(chip-&gt;vendor.iobase + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_atmel_priv *priv =3D chip-&gt;vendor.p=
riv;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ioread8(priv-&gt;iobase + 1);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static bool tpm_atml_req_canceled(struct tpm_chip *chip, u8 stat=
us)<br>
&gt; @@ -142,7 +148,7 @@ static void atml_plat_remove(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_chip_unregis=
ter(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (priv-&gt;hav=
e_region)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0atmel_release_region(priv-&gt;base, priv-&gt;region_size);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atmel_put_base_addr(c=
hip-&gt;vendor.iobase);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atmel_put_base_addr(p=
riv-&gt;iobase);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0platform_device_=
unregister(pdev);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 }<br>
&gt; @@ -190,6 +196,7 @@ static int __init init_atmel(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unreg_d=
ev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;iobase =3D iobase;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;base =3D base;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;have_region =3D have_region;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;region_size =3D region_size;<br>
&gt; @@ -200,7 +207,6 @@ static int __init init_atmel(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto err_unreg_d=
ev;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.iobase =3D iobase;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.priv =3D priv;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D tpm_chip_register(chip);<br>
&gt; diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel=
.h<br>
&gt; index bced678..7e37c16 100644<br>
&gt; --- a/drivers/char/tpm/tpm_atmel.h<br>
&gt; +++ b/drivers/char/tpm/tpm_atmel.h<br>
&gt; @@ -26,6 +26,7 @@ struct tpm_atmel_priv {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int region_size;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int have_region;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long base;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt;=C2=A0 static inline struct tpm_atmel_priv *atmel_get_priv(struct tpm_c=
hip *chip)<br>
&gt; @@ -37,8 +38,8 @@ static inline struct tpm_atmel_priv *atmel_get_priv(=
struct tpm_chip *chip)<br>
&gt;<br>
&gt;=C2=A0 #include &lt;asm/prom.h&gt;<br>
&gt;<br>
&gt; -#define atmel_getb(chip, offset) readb(chip-&gt;vendor-&gt;iobase + o=
ffset);<br>
&gt; -#define atmel_putb(val, chip, offset) writeb(val, chip-&gt;vendor-&gt=
;iobase + offset)<br>
&gt; +#define atmel_getb(priv, offset) readb(priv-&gt;iobase + offset);<br>
&gt; +#define atmel_putb(val, priv, offset) writeb(val, priv-&gt;iobase + o=
ffset)<br>
&gt;=C2=A0 #define atmel_request_region request_mem_region<br>
&gt;=C2=A0 #define atmel_release_region release_mem_region<br>
&gt;<br>
&gt; diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c<b=
r>
&gt; index 068f021..19dac62 100644<br>
&gt; --- a/drivers/char/tpm/tpm_tis.c<br>
&gt; +++ b/drivers/char/tpm/tpm_tis.c<br>
&gt; @@ -94,6 +94,7 @@ struct tpm_info {<br>
&gt;=C2=A0 #define=C2=A0 =C2=A0 =C2=A0 TPM_RID(l)=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (0x0F04 | ((l) &lt;&lt=
; 12))<br>
&gt;<br>
&gt;=C2=A0 struct priv_data {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0void __iomem *iobase;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool irq_tested;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t int_queue;<br>
&gt; @@ -128,9 +129,10 @@ static inline int is_itpm(struct acpi_device *dev=
)<br>
&gt;=C2=A0 =C2=A0* correct values in the other bits.&#39; */<br>
&gt;=C2=A0 static int wait_startup(struct tpm_chip *chip, int l)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop =3D jiffies + chip-&gt;ve=
ndor.timeout_a;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(chip-&gt;=
vendor.iobase + TPM_ACCESS(l)) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(priv-&gt;=
iobase + TPM_ACCESS(l)) &amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TP=
M_ACCESS_VALID)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_TIMEO=
UT);<br>
&gt; @@ -140,7 +142,9 @@ static int wait_startup(struct tpm_chip *chip, int=
 l)<br>
&gt;<br>
&gt;=C2=A0 static int check_locality(struct tpm_chip *chip, int l)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if ((ioread8(chip-&gt;vendor.iobase + TPM_ACCESS(=
l)) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((ioread8(priv-&gt;iobase + TPM_ACCESS(l)) &am=
p;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (TPM_ACCESS_ACTIVE_LOCALITY |=
 TPM_ACCESS_VALID)) =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_ACTIVE_LOCALITY | =
TPM_ACCESS_VALID))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return chip-&gt;=
vendor.locality =3D l;<br>
&gt; @@ -150,11 +154,13 @@ static int check_locality(struct tpm_chip *chip,=
 int l)<br>
&gt;<br>
&gt;=C2=A0 static void release_locality(struct tpm_chip *chip, int l, int f=
orce)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(chip-&gt;vendor.iobase + TP=
M_ACCESS(l)) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(priv-&gt;iobase + TPM_ACCES=
S(l)) &amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0(TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDING | =
TPM_ACCESS_VALID))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACC=
ESS_ACTIVE_LOCALITY,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 chip-&gt;vendor.iobase + TPM_ACCESS(l));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 priv-&gt;iobase + TPM_ACCESS(l));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int request_locality(struct tpm_chip *chip, int l)<br>
&gt; @@ -167,7 +173,7 @@ static int request_locality(struct tpm_chip *chip,=
 int l)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return l;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCESS_REQUEST_USE,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.ioba=
se + TPM_ACCESS(l));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase + TP=
M_ACCESS(l));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip-&gt;vendor.timeout_a=
;<br>
&gt;<br>
&gt; @@ -200,19 +206,24 @@ again:<br>
&gt;<br>
&gt;=C2=A0 static u8 tpm_tis_status(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ioread8(chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ioread8(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 TPM_STS(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static void tpm_tis_ready(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* this causes the current command to be abo=
rted */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_COMMAND_READY,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.ioba=
se + TPM_STS(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase + TP=
M_STS(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int get_burstcount(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int burstcnt;<br>
&gt;<br>
&gt; @@ -220,9 +231,9 @@ static int get_burstcount(struct tpm_chip *chip)<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* which timeout value, spec has 2 answers (=
c &amp; d) */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip-&gt;vendor.timeout_d=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D ioread8(=
chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D ioread8(=
priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_STS(chip-&gt;vendor.lo=
cality) + 1);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ioread8=
(chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ioread8=
(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_STS(chip-&gt;ven=
dor.locality) +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02) &lt;&lt; 8;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt)<br=
>
&gt; @@ -234,6 +245,7 @@ static int get_burstcount(struct tpm_chip *chip)<b=
r>
&gt;<br>
&gt;=C2=A0 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t coun=
t)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, burstcnt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size &lt; count &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_tpm_stat(chip=
,<br>
&gt; @@ -243,7 +255,7 @@ static int recv_data(struct tpm_chip *chip, u8 *bu=
f, size_t count)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get=
_burstcount(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt =
&gt; 0 &amp;&amp; size &lt; count; burstcnt--)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0buf[size++] =3D ioread8(chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0buf[size++] =3D ioread8(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0TPM_DATA_FIFO(chip-&gt;vendor.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0locality)=
);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; @@ -329,7 +341,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip=
, u8 *buf, size_t len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (count &lt; len - 1) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get=
_burstcount(chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt =
&gt; 0 &amp;&amp; count &lt; len - 1; burstcnt--) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0iowrite8(buf[count], chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0iowrite8(buf[count], priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_DATA_FIFO(chip-&gt;vendor.loc=
ality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0count++;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; @@ -345,7 +357,7 @@ static int tpm_tis_send_data(struct tpm_chip *chip=
, u8 *buf, size_t len)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* write last byte */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(buf[count],<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.ioba=
se + TPM_DATA_FIFO(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase + TP=
M_DATA_FIFO(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm_stat(chip, TPM_STS_VALID, chip-=
&gt;vendor.timeout_c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&amp;priv-&gt;int_queue, false);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_tis_status(chip);<br>
&gt; @@ -364,15 +376,15 @@ out_err:<br>
&gt;<br>
&gt;=C2=A0 static void disable_interrupts(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip-&gt;vendor.iobase +<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 T=
PM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &amp;=3D ~TPM_GLOBAL_INT_ENABLE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_ENABLE=
(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0devm_free_irq(&amp;chip-&gt;dev, chip-&gt;ve=
ndor.irq, chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.irq =3D 0;<br>
&gt;=C2=A0 }<br>
&gt; @@ -384,6 +396,7 @@ static void disable_interrupts(struct tpm_chip *ch=
ip)<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, siz=
e_t len)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 ordinal;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long dur;<br>
&gt; @@ -394,7 +407,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip=
, u8 *buf, size_t len)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* go and do it */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_GO,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.ioba=
se + TPM_STS(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase + TP=
M_STS(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip-&gt;vendor.irq) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ordinal =3D be32=
_to_cpu(*((__be32 *) (buf + 6)));<br>
&gt; @@ -453,10 +466,11 @@ static const struct tis_vendor_timeout_override =
vendor_timeout_overrides[] =3D {<br>
&gt;=C2=A0 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long *timeo=
ut_cap)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 did_vid;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(chip-&gt;vendor.iobase + TPM=
_DID_VID(0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(priv-&gt;iobase + TPM_DID_VI=
D(0));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i !=3D ARRAY_SIZE(vendor_timeo=
ut_overrides); i++) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor_timeo=
ut_overrides[i].did_vid !=3D did_vid)<br>
&gt; @@ -476,6 +490,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chi=
p *chip,<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 static int probe_itpm(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 cmd_getticks[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0xc1, 0x00=
, 0x00, 0x00, 0x0a,<br>
&gt; @@ -483,7 +498,7 @@ static int probe_itpm(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0};<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t len =3D sizeof(cmd_getticks);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool rem_itpm =3D itpm;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(chip-&gt;vendor.iobase + =
TPM_DID_VID(0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(priv-&gt;iobase + TPM_DID=
_VID(0));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* probe only iTPMS */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor !=3D TPM_VID_INTEL)<br>
&gt; @@ -548,7 +563,7 @@ static irqreturn_t tis_int_handler(int dummy, void=
 *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 interrupt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(chip-&gt;vendor.iobase +<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_STATUS(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (interrupt =3D=3D 0)<br>
&gt; @@ -568,9 +583,9 @@ static irqreturn_t tis_int_handler(int dummy, void=
 *dev_id)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear interrupts handled with TPM_EOI */<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(interrupt,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_S=
TATUS(chip-&gt;vendor.locality));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0ioread32(chip-&gt;vendor.iobase + TPM_INT_STATUS(=
chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ioread32(priv-&gt;iobase + TPM_INT_STATUS(chip-&g=
t;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_HANDLED;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -592,19 +607,19 @@ static int tpm_tis_probe_irq_single(struct tpm_c=
hip *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.irq =3D irq;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(chip-&gt;vendor.ioba=
se +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(priv-&gt;iobase +<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(chip-&gt;ve=
ndor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(irq,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;vendor.ioba=
se + TPM_INT_VECTOR(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 priv-&gt;iobase + TP=
M_INT_VECTOR(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear all existing */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 TPM_INT_STATUS(chip-&gt;vendor.locality)),<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase + TPM_INT_STATUS(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e + TPM_INT_STATUS(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Turn on */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;irq_tested =3D false;<br>
&gt;<br>
&gt; @@ -621,8 +636,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chi=
p *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!chip-&gt;vendor.irq) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(origina=
l_int_vec,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 chip-&gt;vendor.iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 priv-&gt;iobase + TPM_INT_VECTOR(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -635,10 +649,11 @@ static int tpm_tis_probe_irq_single(struct tpm_c=
hip *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask=
)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(chip-&gt;vendor.ioba=
se +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(priv-&gt;iobase +<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(chip-&gt;ve=
ndor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!original_int_vec) {<br>
&gt; @@ -658,15 +673,16 @@ MODULE_PARM_DESC(interrupts, &quot;Enable interr=
upts&quot;);<br>
&gt;<br>
&gt;=C2=A0 static void tpm_tis_remove(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip-&gt;flags &amp; TPM_CHIP_FLAG_TPM2)=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm2_shutdown(ch=
ip, TPM2_SU_CLEAR);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(~TPM_GLOBAL_INT_ENABLE &amp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip-=
&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv-=
&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 TPM_INT_ENABLE(chip-&gt;vendor.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0locality)),<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_ENABLE=
(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 priv-&gt;iobase + TPM_INT_ENABLE(chip-&gt;vendor.locality));=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0release_locality(chip, chip-&gt;vendor.local=
ity, 1);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -691,9 +707,9 @@ static int tpm_tis_init(struct device *dev, struct=
 tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;acpi_dev_handle =3D acpi_dev_handle=
;<br>
&gt;=C2=A0 #endif<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.iobase =3D devm_ioremap_resource(=
dev, &amp;tpm_info-&gt;res);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (IS_ERR(chip-&gt;vendor.iobase))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(chip-&=
gt;vendor.iobase);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;iobase =3D devm_ioremap_resource(dev, &a=
mp;tpm_info-&gt;res);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (IS_ERR(priv-&gt;iobase))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(priv-&=
gt;iobase);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Maximum timeouts */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendor.timeout_a =3D TIS_TIMEOUT_A_=
MAX;<br>
&gt; @@ -707,13 +723,13 @@ static int tpm_tis_init(struct device *dev, stru=
ct tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Take control of the TPM&#39;s interrupt h=
ardware and shut it off */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(chip-&gt;vendor.iobase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT | TPM_IN=
TF_LOCALITY_CHANGE_INT |<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INTF=
_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &amp;=3D ~TPM_GLOBAL_INT_ENABLE;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (request_locality(chip, 0) !=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENODEV;<=
br>
&gt; @@ -724,12 +740,12 @@ static int tpm_tis_init(struct device *dev, stru=
ct tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;<br=
>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(chip-&gt;vendor.iobase + TPM_=
DID_VID(0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(priv-&gt;iobase + TPM_DID_VID=
(0));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;manufacturer_id =3D vendor;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_info(dev, &quot;%s TPM (device-id 0x%X, =
rev-id %d)\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (chip-&gt;flags=
 &amp; TPM_CHIP_FLAG_TPM2) ? &quot;2.0&quot; : &quot;1.2&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &gt;&gt; 16, =
ioread8(chip-&gt;vendor.iobase + TPM_RID(0)));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &gt;&gt; 16, =
ioread8(priv-&gt;iobase + TPM_RID(0)));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!itpm) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0probe =3D probe_=
itpm(chip);<br>
&gt; @@ -746,7 +762,7 @@ static int tpm_tis_init(struct device *dev, struct=
 tpm_info *tpm_info,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Figure out the capabilities */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip-&gt;vendor.iobase +<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv-&gt;iobase +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 T=
PM_INTF_CAPS(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(dev, &quot;TPM interface capabilitie=
s (0x%x):\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps);<br>
&gt; @@ -825,23 +841,23 @@ out_err:<br>
&gt;=C2=A0 #ifdef CONFIG_PM_SLEEP<br>
&gt;=C2=A0 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)<b=
r>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct priv_data *priv =3D chip-&gt;vendor.priv;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* reenable interrupts that device may have =
lost or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BIOS/firmware may have disabled */<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(chip-&gt;vendor.irq, chip-&gt;vendor.iob=
ase +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0iowrite8(chip-&gt;vendor.irq, priv-&gt;iobase +<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(=
chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(chip-&gt;vendor.iobase +<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_IN=
T_ENABLE(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(priv-&gt;iobase + TPM_INT_=
ENABLE(chip-&gt;vendor.locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_LOCALITY_CHANGE_INT=
 | TPM_INTF_DATA_AVAIL_INT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_STS_VALID_INT | TPM=
_GLOBAL_INT_ENABLE;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;vendo=
r.iobase + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;iobas=
e + TPM_INT_ENABLE(chip-&gt;vendor.locality));<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int tpm_tis_resume(struct device *dev)<br>
&gt; --<br>
&gt; 2.5.0<br>
&gt;<br>
</div></div></blockquote></div><br></div>

--089e0141a190b38d74052f540fe6--


--===============4987119047912143718==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
--===============4987119047912143718==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4987119047912143718==--
