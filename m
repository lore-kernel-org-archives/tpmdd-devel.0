From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 04/12] tpm_tis: Introduce intermediate
	layer for TPM access
Date: Tue, 19 Apr 2016 15:20:25 +0200
Message-ID: <CALD+uuxbqVYrPxpAz2gZo5+5hu+Yagt4XkinJUXfZm3fztfKLw@mail.gmail.com>
References: <1461017864-3903-1-git-send-email-christophe-h.ricard@st.com>
	<1461017864-3903-5-git-send-email-christophe-h.ricard@st.com>
	<20160419130747.GC4796@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6023072891593901827=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160419130747.GC4796-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

--===============6023072891593901827==
Content-Type: multipart/alternative; boundary=001a114b3d5e44971f0530d65897

--001a114b3d5e44971f0530d65897
Content-Type: text/plain; charset=UTF-8

Hi Jarkko,

Do you thing tpm_tis.c should be renamed tpm_tis_tcg.c as well ?

Best Regards
Christophe



2016-04-19 15:07 GMT+02:00 Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
:

> On Tue, Apr 19, 2016 at 12:17:36AM +0200, Christophe Ricard wrote:
> > This splits tpm_tis in a high-level protocol part and a low-level
> interface
> > for the actual TPM communication. The low-level interface can then be
> > implemented by additional drivers to provide access to TPMs using other
> > mechanisms, for example native I2C or SPI transfers, while still reusing
> > the same TIS protocol implementation.
>
> I do not see anything obviously wrong in this patch except the use
> of tpm_mem prefix. Earlier you used LPC which was incorrect. Now you
> refer to the same entity with this tpm_mem prefix.
>
> Maybe tpm_tcg would be the right choice in both cases...
>
> /Jarkko
>
> > Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_tis.c      | 201
> +++++++++++++++++++++-------------------
> >  drivers/char/tpm/tpm_tis_core.h |  64 +++++++++++++
> >  2 files changed, 168 insertions(+), 97 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index af53747..6df7ddc 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -131,11 +131,9 @@ static inline int is_itpm(struct acpi_device *dev)
> >   * correct values in the other bits.' */
> >  static int wait_startup(struct tpm_chip *chip, int l)
> >  {
> > -     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       unsigned long stop = jiffies + chip->timeout_a;
> >       do {
> > -             if (ioread8(phy->iobase + TPM_ACCESS(l)) &
> > +             if (tpm_read8(chip, TPM_ACCESS(l)) &
> >                   TPM_ACCESS_VALID)
> >                       return 0;
> >               msleep(TPM_TIMEOUT);
> > @@ -146,9 +144,8 @@ static int wait_startup(struct tpm_chip *chip, int l)
> >  static int check_locality(struct tpm_chip *chip, int l)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >
> > -     if ((ioread8(phy->iobase + TPM_ACCESS(l)) &
> > +     if ((tpm_read8(chip, TPM_ACCESS(l)) &
> >            (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> >           (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
> >               return priv->locality = l;
> > @@ -158,28 +155,23 @@ static int check_locality(struct tpm_chip *chip,
> int l)
> >
> >  static void release_locality(struct tpm_chip *chip, int l, int force)
> >  {
> > -     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > -
> > -     if (force || (ioread8(phy->iobase + TPM_ACCESS(l)) &
> > +     if (force || (tpm_read8(chip, TPM_ACCESS(l)) &
> >                     (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) ==
> >           (TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID))
> > -             iowrite8(TPM_ACCESS_ACTIVE_LOCALITY,
> > -                      phy->iobase + TPM_ACCESS(l));
> > +             tpm_write8(chip, TPM_ACCESS(l),
> TPM_ACCESS_ACTIVE_LOCALITY);
> > +
> >  }
> >
> >  static int request_locality(struct tpm_chip *chip, int l)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       unsigned long stop, timeout;
> >       long rc;
> >
> >       if (check_locality(chip, l) >= 0)
> >               return l;
> >
> > -     iowrite8(TPM_ACCESS_REQUEST_USE,
> > -              phy->iobase + TPM_ACCESS(l));
> > +     tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
> >
> >       stop = jiffies + chip->timeout_a;
> >
> > @@ -213,26 +205,21 @@ again:
> >  static u8 tpm_tis_status(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >
> > -     return ioread8(phy->iobase +
> > -                    TPM_STS(priv->locality));
> > +     return tpm_read8(chip, TPM_STS(priv->locality));
> >  }
> >
> >  static void tpm_tis_ready(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >
> >       /* this causes the current command to be aborted */
> > -     iowrite8(TPM_STS_COMMAND_READY,
> > -              phy->iobase + TPM_STS(priv->locality));
> > +     tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_COMMAND_READY);
> >  }
> >
> >  static int get_burstcount(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       unsigned long stop;
> >       int burstcnt;
> >
> > @@ -240,11 +227,8 @@ static int get_burstcount(struct tpm_chip *chip)
> >       /* which timeout value, spec has 2 answers (c & d) */
> >       stop = jiffies + chip->timeout_d;
> >       do {
> > -             burstcnt = ioread8(phy->iobase +
> > -                                TPM_STS(priv->locality) + 1);
> > -             burstcnt += ioread8(phy->iobase +
> > -                                 TPM_STS(priv->locality) +
> > -                                 2) << 8;
> > +             burstcnt = tpm_read8(chip, TPM_STS(priv->locality) + 1);
> > +             burstcnt += tpm_read8(chip, TPM_STS(priv->locality) + 2)
> << 8;
> >               if (burstcnt)
> >                       return burstcnt;
> >               msleep(TPM_TIMEOUT);
> > @@ -255,18 +239,16 @@ static int get_burstcount(struct tpm_chip *chip)
> >  static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       int size = 0, burstcnt;
> >       while (size < count &&
> >              wait_for_tpm_stat(chip,
> >                                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> >                                chip->timeout_c,
> > -                              &priv->read_queue, true)
> > -            == 0) {
> > -             burstcnt = get_burstcount(chip);
> > -             for (; burstcnt > 0 && size < count; burstcnt--)
> > -                     buf[size++] = ioread8(phy->iobase +
> > -
>  TPM_DATA_FIFO(priv->locality));
> > +                              &priv->read_queue, true) == 0) {
> > +             burstcnt = min_t(int, get_burstcount(chip), count - size);
> > +             tpm_read_bytes(chip, TPM_DATA_FIFO(priv->locality),
> > +                            burstcnt, buf + size);
> > +             size += burstcnt;
> >       }
> >       return size;
> >  }
> > @@ -330,7 +312,6 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds
> (found on some Lenovo laptops)");
> >  static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       int rc, status, burstcnt;
> >       size_t count = 0;
> >
> > @@ -349,12 +330,10 @@ static int tpm_tis_send_data(struct tpm_chip
> *chip, u8 *buf, size_t len)
> >       }
> >
> >       while (count < len - 1) {
> > -             burstcnt = get_burstcount(chip);
> > -             for (; burstcnt > 0 && count < len - 1; burstcnt--) {
> > -                     iowrite8(buf[count], phy->iobase +
> > -                              TPM_DATA_FIFO(priv->locality));
> > -                     count++;
> > -             }
> > +             burstcnt = min_t(int, get_burstcount(chip), len - count -
> 1);
> > +             tpm_write_bytes(chip, TPM_DATA_FIFO(priv->locality),
> > +                             burstcnt, buf + count);
> > +             count += burstcnt;
> >
> >               wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
> >                                 &priv->int_queue, false);
> > @@ -366,8 +345,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >       }
> >
> >       /* write last byte */
> > -     iowrite8(buf[count],
> > -              phy->iobase + TPM_DATA_FIFO(priv->locality));
> > +     tpm_write8(chip, TPM_DATA_FIFO(priv->locality), buf[count]);
> > +
> >       wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
> >                         &priv->int_queue, false);
> >       status = tpm_tis_status(chip);
> > @@ -387,15 +366,12 @@ out_err:
> >  static void disable_interrupts(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       u32 intmask;
> >
> > -     intmask =
> > -         ioread32(phy->iobase +
> > -                  TPM_INT_ENABLE(priv->locality));
> > +     intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
> >       intmask &= ~TPM_GLOBAL_INT_ENABLE;
> > -     iowrite32(intmask,
> > -               phy->iobase + TPM_INT_ENABLE(priv->locality));
> > +     tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
> > +
> >       devm_free_irq(&chip->dev, priv->irq, chip);
> >       priv->irq = 0;
> >       chip->flags &= ~TPM_CHIP_FLAG_IRQ;
> > @@ -409,7 +385,6 @@ static void disable_interrupts(struct tpm_chip *chip)
> >  static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       int rc;
> >       u32 ordinal;
> >       unsigned long dur;
> > @@ -419,8 +394,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip,
> u8 *buf, size_t len)
> >               return rc;
> >
> >       /* go and do it */
> > -     iowrite8(TPM_STS_GO,
> > -              phy->iobase + TPM_STS(priv->locality));
> > +     tpm_write8(chip, TPM_STS(priv->locality), TPM_STS_GO);
> >
> >       if (chip->flags & TPM_CHIP_FLAG_IRQ) {
> >               ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > @@ -481,12 +455,10 @@ static const struct tis_vendor_timeout_override
> vendor_timeout_overrides[] = {
> >  static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
> >                                   unsigned long *timeout_cap)
> >  {
> > -     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       int i;
> >       u32 did_vid;
> >
> > -     did_vid = ioread32(phy->iobase + TPM_DID_VID(0));
> > +     did_vid = tpm_read32(chip, TPM_DID_VID(0));
> >
> >       for (i = 0; i != ARRAY_SIZE(vendor_timeout_overrides); i++) {
> >               if (vendor_timeout_overrides[i].did_vid != did_vid)
> > @@ -507,7 +479,6 @@ static bool tpm_tis_update_timeouts(struct tpm_chip
> *chip,
> >  static int probe_itpm(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       int rc = 0;
> >       u8 cmd_getticks[] = {
> >               0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> > @@ -515,7 +486,7 @@ static int probe_itpm(struct tpm_chip *chip)
> >       };
> >       size_t len = sizeof(cmd_getticks);
> >       bool rem_itpm = itpm;
> > -     u16 vendor = ioread16(phy->iobase + TPM_DID_VID(0));
> > +     u16 vendor = tpm_read16(chip, TPM_DID_VID(0));
> >
> >       /* probe only iTPMS */
> >       if (vendor != TPM_VID_INTEL)
> > @@ -573,16 +544,66 @@ static const struct tpm_class_ops tpm_tis = {
> >       .req_canceled = tpm_tis_req_canceled,
> >  };
> >
> > +static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
> > +                            u8 *result)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > +
> > +     while (len--)
> > +             *result++ = ioread8(phy->iobase + addr);
> > +}
> > +
> > +static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16
> len,
> > +                             u8 *value)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > +
> > +     while (len--)
> > +             iowrite8(*value++, phy->iobase + addr);
> > +}
> > +
> > +static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > +
> > +     return ioread16(phy->iobase + addr);
> > +}
> > +
> > +static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > +
> > +     return ioread32(phy->iobase + addr);
> > +}
> > +
> > +static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 value)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > +
> > +     iowrite32(value, phy->iobase + addr);
> > +}
> > +
> > +static const struct tpm_tis_phy_ops tpm_mem = {
> > +     .read_bytes = tpm_mem_read_bytes,
> > +     .write_bytes = tpm_mem_write_bytes,
> > +     .read16 = tpm_mem_read16,
> > +     .read32 = tpm_mem_read32,
> > +     .write32 = tpm_mem_write32,
> > +};
> > +
> >  static irqreturn_t tis_int_handler(int dummy, void *dev_id)
> >  {
> >       struct tpm_chip *chip = dev_id;
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       u32 interrupt;
> >       int i;
> >
> > -     interrupt = ioread32(phy->iobase +
> > -                          TPM_INT_STATUS(priv->locality));
> > +     interrupt = tpm_read32(chip, TPM_INT_STATUS(priv->locality));
> >
> >       if (interrupt == 0)
> >               return IRQ_NONE;
> > @@ -600,10 +621,8 @@ static irqreturn_t tis_int_handler(int dummy, void
> *dev_id)
> >               wake_up_interruptible(&priv->int_queue);
> >
> >       /* Clear interrupts handled with TPM_EOI */
> > -     iowrite32(interrupt,
> > -               phy->iobase +
> > -               TPM_INT_STATUS(priv->locality));
> > -     ioread32(phy->iobase + TPM_INT_STATUS(priv->locality));
> > +     tpm_write32(chip, TPM_INT_STATUS(priv->locality), interrupt);
> > +     tpm_read32(chip, TPM_INT_STATUS(priv->locality));
> >       return IRQ_HANDLED;
> >  }
> >
> > @@ -615,7 +634,6 @@ static int tpm_tis_probe_irq_single(struct tpm_chip
> *chip, u32 intmask,
> >                                   int flags, int irq)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       u8 original_int_vec;
> >
> >       if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> > @@ -626,19 +644,16 @@ static int tpm_tis_probe_irq_single(struct
> tpm_chip *chip, u32 intmask,
> >       }
> >       priv->irq = irq;
> >
> > -     original_int_vec = ioread8(phy->iobase +
> > -                                TPM_INT_VECTOR(priv->locality));
> > -     iowrite8(irq,
> > -              phy->iobase + TPM_INT_VECTOR(priv->locality));
> > +     original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
> > +     tpm_write8(chip, TPM_INT_VECTOR(priv->locality), irq);
> >
> >       /* Clear all existing */
> > -     iowrite32(ioread32(phy->iobase +
> > -                        TPM_INT_STATUS(priv->locality)),
> > -               phy->iobase + TPM_INT_STATUS(priv->locality));
> > +     tpm_write32(chip, TPM_INT_STATUS(priv->locality),
> > +                 tpm_read32(chip, TPM_INT_STATUS(priv->locality)));
> >
> >       /* Turn on */
> > -     iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,
> > -               phy->iobase + TPM_INT_ENABLE(priv->locality));
> > +     tpm_write32(chip, TPM_INT_ENABLE(priv->locality),
> > +                 intmask | TPM_GLOBAL_INT_ENABLE);
> >
> >       priv->irq_tested = false;
> >
> > @@ -654,8 +669,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip
> *chip, u32 intmask,
> >        * will call disable_irq which undoes all of the above.
> >        */
> >       if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
> > -             iowrite8(original_int_vec,
> > -                      phy->iobase + TPM_INT_VECTOR(priv->locality));
> > +             tpm_write8(chip, TPM_INT_VECTOR(priv->locality),
> > +                        original_int_vec);
> > +
> >               return 1;
> >       }
> >
> > @@ -669,12 +685,10 @@ static int tpm_tis_probe_irq_single(struct
> tpm_chip *chip, u32 intmask,
> >  static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       u8 original_int_vec;
> >       int i;
> >
> > -     original_int_vec = ioread8(phy->iobase +
> > -                                TPM_INT_VECTOR(priv->locality));
> > +     original_int_vec = tpm_read8(chip, TPM_INT_VECTOR(priv->locality));
> >
> >       if (!original_int_vec) {
> >               if (IS_ENABLED(CONFIG_X86))
> > @@ -694,10 +708,9 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
> >  static void tpm_tis_remove(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> > -     void __iomem *reg = phy->iobase + TPM_INT_ENABLE(priv->locality);
> > +     u32 reg = TPM_INT_ENABLE(priv->locality);
> >
> > -     iowrite32(~TPM_GLOBAL_INT_ENABLE & ioread32(reg), reg);
> > +     tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE & tpm_read32(chip,
> reg));
> >       release_locality(chip, priv->locality, 1);
> >  }
> >
> > @@ -725,6 +738,8 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       if (IS_ERR(phy->iobase))
> >               return PTR_ERR(phy->iobase);
> >
> > +     phy->priv.phy_ops = &tpm_mem;
> > +
> >       /* Maximum timeouts */
> >       chip->timeout_a = TIS_TIMEOUT_A_MAX;
> >       chip->timeout_b = TIS_TIMEOUT_B_MAX;
> > @@ -739,13 +754,11 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       }
> >
> >       /* Take control of the TPM's interrupt hardware and shut it off */
> > -     intmask = ioread32(phy->iobase +
> > -                        TPM_INT_ENABLE(phy->priv.locality));
> > +     intmask = tpm_read32(chip, TPM_INT_ENABLE(phy->priv.locality));
> >       intmask |= TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
> >                  TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
> >       intmask &= ~TPM_GLOBAL_INT_ENABLE;
> > -     iowrite32(intmask,
> > -               phy->iobase + TPM_INT_ENABLE(phy->priv.locality));
> > +     tpm_write32(chip, TPM_INT_ENABLE(phy->priv.locality), intmask);
> >
> >       if (request_locality(chip, 0) != 0) {
> >               rc = -ENODEV;
> > @@ -756,12 +769,12 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >       if (rc)
> >               goto out_err;
> >
> > -     vendor = ioread32(phy->iobase + TPM_DID_VID(0));
> > +     vendor = tpm_read32(chip, TPM_DID_VID(0));
> >       phy->priv.manufacturer_id = vendor;
> >
> >       dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> >                (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> > -              vendor >> 16, ioread8(phy->iobase + TPM_RID(0)));
> > +              vendor >> 16, tpm_read8(chip, TPM_RID(0)));
> >
> >       if (!itpm) {
> >               probe = probe_itpm(chip);
> > @@ -777,9 +790,7 @@ static int tpm_tis_init(struct device *dev, struct
> tpm_info *tpm_info,
> >
> >
> >       /* Figure out the capabilities */
> > -     intfcaps =
> > -         ioread32(phy->iobase +
> > -                  TPM_INTF_CAPS(phy->priv.locality));
> > +     intfcaps = tpm_read32(chip, TPM_INTF_CAPS(phy->priv.locality));
> >       dev_dbg(dev, "TPM interface capabilities (0x%x):\n",
> >               intfcaps);
> >       if (intfcaps & TPM_INTF_BURST_COUNT_STATIC)
> > @@ -858,23 +869,19 @@ out_err:
> >  static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> >  {
> >       struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -     struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
> >       u32 intmask;
> >
> >       /* reenable interrupts that device may have lost or
> >          BIOS/firmware may have disabled */
> > -     iowrite8(priv->irq, phy->iobase +
> > -              TPM_INT_VECTOR(priv->locality));
> > +     tpm_write8(chip, TPM_INT_VECTOR(priv->locality), priv->irq);
> >
> > -     intmask =
> > -         ioread32(phy->iobase + TPM_INT_ENABLE(priv->locality));
> > +     intmask = tpm_read32(chip, TPM_INT_ENABLE(priv->locality));
> >
> >       intmask |= TPM_INTF_CMD_READY_INT
> >           | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
> >           | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
> >
> > -     iowrite32(intmask,
> > -               phy->iobase + TPM_INT_ENABLE(priv->locality));
> > +     tpm_write32(chip, TPM_INT_ENABLE(priv->locality), intmask);
> >  }
> >
> >  static int tpm_tis_resume(struct device *dev)
> > diff --git a/drivers/char/tpm/tpm_tis_core.h
> b/drivers/char/tpm/tpm_tis_core.h
> > index 2260f89..3e066eb 100644
> > --- a/drivers/char/tpm/tpm_tis_core.h
> > +++ b/drivers/char/tpm/tpm_tis_core.h
> > @@ -25,6 +25,16 @@
> >
> >  #include "tpm.h"
> >
> > +struct tpm_tis_phy_ops {
> > +     void (*read_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
> > +                        u8 *result);
> > +     void (*write_bytes)(struct tpm_chip *chip, u32 addr, u16 len,
> > +                         u8 *value);
> > +     u16 (*read16)(struct tpm_chip *chip, u32 addr);
> > +     u32 (*read32)(struct tpm_chip *chip, u32 addr);
> > +     void (*write32)(struct tpm_chip *chip, u32 addr, u32 src);
> > +};
> > +
> >  struct tpm_tis_data {
> >       u16 manufacturer_id;
> >       int locality;
> > @@ -32,6 +42,60 @@ struct tpm_tis_data {
> >       bool irq_tested;
> >       wait_queue_head_t int_queue;
> >       wait_queue_head_t read_queue;
> > +     const struct tpm_tis_phy_ops *phy_ops;
> >  };
> >
> > +static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16
> len,
> > +                               u8 *result)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     priv->phy_ops->read_bytes(chip, addr, len, result);
> > +}
> > +
> > +static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +     u8 result;
> > +
> > +     priv->phy_ops->read_bytes(chip, addr, 1, &result);
> > +     return result;
> > +}
> > +
> > +static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     return priv->phy_ops->read16(chip, addr);
> > +}
> > +
> > +static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     return priv->phy_ops->read32(chip, addr);
> > +}
> > +
> > +static inline void tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16
> len,
> > +                                u8 *value)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     priv->phy_ops->write_bytes(chip, addr, len, value);
> > +}
> > +
> > +static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     priv->phy_ops->write_bytes(chip, addr, 1, &value);
> > +}
> > +
> > +static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u32
> value)
> > +{
> > +     struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > +
> > +     priv->phy_ops->write32(chip, addr, value);
> > +}
> > +
> >  #endif
> > --
> > 2.1.4
> >
>

--001a114b3d5e44971f0530d65897
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi Jarkko,<br><br></div>Do you thing tpm_ti=
s.c should be renamed tpm_tis_tcg.c as well ?<br><br></div>Best Regards<br>=
</div>Christophe<br><div><div><br><br></div></div></div><div class=3D"gmail=
_extra"><br><div class=3D"gmail_quote">2016-04-19 15:07 GMT+02:00 Jarkko Sa=
kkinen <span dir=3D"ltr">&lt;<a href=3D"mailto:jarkko.sakkinen-VuQAYsv1562uYJLRA6qg5Q@public.gmane.org=
com" target=3D"_blank">jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org</a>&gt;</span>:<br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex"><span class=3D"">On Tue, Apr 19, 2016 at 12:1=
7:36AM +0200, Christophe Ricard wrote:<br>
&gt; This splits tpm_tis in a high-level protocol part and a low-level inte=
rface<br>
&gt; for the actual TPM communication. The low-level interface can then be<=
br>
&gt; implemented by additional drivers to provide access to TPMs using othe=
r<br>
&gt; mechanisms, for example native I2C or SPI transfers, while still reusi=
ng<br>
&gt; the same TIS protocol implementation.<br>
<br>
</span>I do not see anything obviously wrong in this patch except the use<b=
r>
of tpm_mem prefix. Earlier you used LPC which was incorrect. Now you<br>
refer to the same entity with this tpm_mem prefix.<br>
<br>
Maybe tpm_tcg would be the right choice in both cases...<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
/Jarkko<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Signed-off-by: Alexander Steffen &lt;<a href=3D"mailto:Alexander.Steff=
en-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org">Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org</a>&gt;<br>
&gt; Signed-off-by: Christophe Ricard &lt;<a href=3D"mailto:christophe-h.ri=
card-qxv4g6HH51o@public.gmane.org">christophe-h.ricard-qxv4g6HH51o@public.gmane.org</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/char/tpm/tpm_tis.c=C2=A0 =C2=A0 =C2=A0 | 201 +++++++++++=
++++++++++-------------------<br>
&gt;=C2=A0 drivers/char/tpm/tpm_tis_core.h |=C2=A0 64 +++++++++++++<br>
&gt;=C2=A0 2 files changed, 168 insertions(+), 97 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c<b=
r>
&gt; index af53747..6df7ddc 100644<br>
&gt; --- a/drivers/char/tpm/tpm_tis.c<br>
&gt; +++ b/drivers/char/tpm/tpm_tis.c<br>
&gt; @@ -131,11 +131,9 @@ static inline int is_itpm(struct acpi_device *dev=
)<br>
&gt;=C2=A0 =C2=A0* correct values in the other bits.&#39; */<br>
&gt;=C2=A0 static int wait_startup(struct tpm_chip *chip, int l)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop =3D jiffies + chip-&gt;ti=
meout_a;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ioread8(phy-&gt;i=
obase + TPM_ACCESS(l)) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tpm_read8(chip, T=
PM_ACCESS(l)) &amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TP=
M_ACCESS_VALID)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_TIMEO=
UT);<br>
&gt; @@ -146,9 +144,8 @@ static int wait_startup(struct tpm_chip *chip, int=
 l)<br>
&gt;=C2=A0 static int check_locality(struct tpm_chip *chip, int l)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if ((ioread8(phy-&gt;iobase + TPM_ACCESS(l)) &amp=
;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((tpm_read8(chip, TPM_ACCESS(l)) &amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (TPM_ACCESS_ACTIVE_LOCALITY |=
 TPM_ACCESS_VALID)) =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_ACTIVE_LOCALITY | =
TPM_ACCESS_VALID))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return priv-&gt;=
locality =3D l;<br>
&gt; @@ -158,28 +155,23 @@ static int check_locality(struct tpm_chip *chip,=
 int l)<br>
&gt;<br>
&gt;=C2=A0 static void release_locality(struct tpm_chip *chip, int l, int f=
orce)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (force || (ioread8(phy-&gt;iobase + TPM_ACCESS=
(l)) &amp;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (force || (tpm_read8(chip, TPM_ACCESS(l)) &amp=
;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0(TPM_ACCESS_REQUEST_PENDING | TPM_ACCESS_VALID)) =3D=3D<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(TPM_ACCESS_REQUEST_PENDING | =
TPM_ACCESS_VALID))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCESS_A=
CTIVE_LOCALITY,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 phy-&gt;iobase + TPM_ACCESS(l));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_=
ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);<br>
&gt; +<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int request_locality(struct tpm_chip *chip, int l)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop, timeout;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0long rc;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (check_locality(chip, l) &gt;=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return l;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_ACCESS_REQUEST_USE,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy-&gt;iobase + TPM=
_ACCESS(l));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_ACCESS(l), TPM_ACCESS_REQUES=
T_USE);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip-&gt;timeout_a;<br>
&gt;<br>
&gt; @@ -213,26 +205,21 @@ again:<br>
&gt;=C2=A0 static u8 tpm_tis_status(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return ioread8(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 TPM_STS(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return tpm_read8(chip, TPM_STS(priv-&gt;locality)=
);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static void tpm_tis_ready(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* this causes the current command to be abo=
rted */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_COMMAND_READY,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy-&gt;iobase + TPM=
_STS(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_STS(priv-&gt;locality), TPM_=
STS_COMMAND_READY);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int get_burstcount(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long stop;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int burstcnt;<br>
&gt;<br>
&gt; @@ -240,11 +227,8 @@ static int get_burstcount(struct tpm_chip *chip)<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* which timeout value, spec has 2 answers (=
c &amp; d) */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0stop =3D jiffies + chip-&gt;timeout_d;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D ioread8(=
phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_STS(priv-&gt;locality) + 1);=
<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D ioread8=
(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_STS(priv-&gt;locality)=
 +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02) &lt;&lt; 8;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D tpm_read=
8(chip, TPM_STS(priv-&gt;locality) + 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt +=3D tpm_rea=
d8(chip, TPM_STS(priv-&gt;locality) + 2) &lt;&lt; 8;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (burstcnt)<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return burstcnt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(TPM_TIMEO=
UT);<br>
&gt; @@ -255,18 +239,16 @@ static int get_burstcount(struct tpm_chip *chip)=
<br>
&gt;=C2=A0 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t coun=
t)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int size =3D 0, burstcnt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (size &lt; count &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_tpm_stat(chip=
,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_STS_DATA_AVAIL | TPM_STS_VALI=
D,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chip-&gt;timeout_c,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;priv-&gt;read_queue, true)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=3D 0) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get_burs=
tcount(chip);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt &gt; =
0 &amp;&amp; size &lt; count; burstcnt--)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0buf[size++] =3D ioread8(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0TPM_DATA_FIFO(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;priv-&gt;read_queue, true) =3D=3D =
0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min_t(in=
t, get_burstcount(chip), count - size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_read_bytes(chip, =
TPM_DATA_FIFO(priv-&gt;locality),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 burstcnt, buf + size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size +=3D burstcnt;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return size;<br>
&gt;=C2=A0 }<br>
&gt; @@ -330,7 +312,6 @@ MODULE_PARM_DESC(itpm, &quot;Force iTPM workaround=
s (found on some Lenovo laptops)&quot;);<br>
&gt;=C2=A0 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, siz=
e_t len)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc, status, burstcnt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D 0;<br>
&gt;<br>
&gt; @@ -349,12 +330,10 @@ static int tpm_tis_send_data(struct tpm_chip *ch=
ip, u8 *buf, size_t len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (count &lt; len - 1) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D get_burs=
tcount(chip);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; burstcnt &gt; =
0 &amp;&amp; count &lt; len - 1; burstcnt--) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0iowrite8(buf[count], phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_DATA_FIFO(priv-&gt;locality));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0count++;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt =3D min_t(in=
t, get_burstcount(chip), len - count - 1);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write_bytes(chip,=
 TPM_DATA_FIFO(priv-&gt;locality),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0burstcnt, buf + count);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0count +=3D burstcnt;<=
br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm_sta=
t(chip, TPM_STS_VALID, chip-&gt;timeout_c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&amp;priv-&gt;int_queue, fa=
lse);<br>
&gt; @@ -366,8 +345,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip=
, u8 *buf, size_t len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* write last byte */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(buf[count],<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy-&gt;iobase + TPM=
_DATA_FIFO(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_DATA_FIFO(priv-&gt;locality)=
, buf[count]);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_tpm_stat(chip, TPM_STS_VALID, chip-=
&gt;timeout_c,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&amp;priv-&gt;int_queue, false);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0status =3D tpm_tis_status(chip);<br>
&gt; @@ -387,15 +366,12 @@ out_err:<br>
&gt;=C2=A0 static void disable_interrupts(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0intmask =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_IN=
T_ENABLE(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip, TPM_INT_ENABLE(priv-=
&gt;locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &amp;=3D ~TPM_GLOBAL_INT_ENABLE;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 + TPM_INT_ENABLE(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv-&gt;localit=
y), intmask);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0devm_free_irq(&amp;chip-&gt;dev, priv-&gt;ir=
q, chip);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;irq =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;flags &amp;=3D ~TPM_CHIP_FLAG_IRQ;<=
br>
&gt; @@ -409,7 +385,6 @@ static void disable_interrupts(struct tpm_chip *ch=
ip)<br>
&gt;=C2=A0 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, siz=
e_t len)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 ordinal;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long dur;<br>
&gt; @@ -419,8 +394,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip=
, u8 *buf, size_t len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* go and do it */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(TPM_STS_GO,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy-&gt;iobase + TPM=
_STS(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_STS(priv-&gt;locality), TPM_=
STS_GO);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (chip-&gt;flags &amp; TPM_CHIP_FLAG_IRQ) =
{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ordinal =3D be32=
_to_cpu(*((__be32 *) (buf + 6)));<br>
&gt; @@ -481,12 +455,10 @@ static const struct tis_vendor_timeout_override =
vendor_timeout_overrides[] =3D {<br>
&gt;=C2=A0 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long *timeo=
ut_cap)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 did_vid;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0did_vid =3D ioread32(phy-&gt;iobase + TPM_DID_VID=
(0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0did_vid =3D tpm_read32(chip, TPM_DID_VID(0));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i !=3D ARRAY_SIZE(vendor_timeo=
ut_overrides); i++) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor_timeo=
ut_overrides[i].did_vid !=3D did_vid)<br>
&gt; @@ -507,7 +479,6 @@ static bool tpm_tis_update_timeouts(struct tpm_chi=
p *chip,<br>
&gt;=C2=A0 static int probe_itpm(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 cmd_getticks[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x00, 0xc1, 0x00=
, 0x00, 0x00, 0x0a,<br>
&gt; @@ -515,7 +486,7 @@ static int probe_itpm(struct tpm_chip *chip)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0};<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size_t len =3D sizeof(cmd_getticks);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool rem_itpm =3D itpm;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0u16 vendor =3D ioread16(phy-&gt;iobase + TPM_DID_=
VID(0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u16 vendor =3D tpm_read16(chip, TPM_DID_VID(0));<=
br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* probe only iTPMS */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (vendor !=3D TPM_VID_INTEL)<br>
&gt; @@ -573,16 +544,66 @@ static const struct tpm_class_ops tpm_tis =3D {<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0.req_canceled =3D tpm_tis_req_canceled,<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt; +static void tpm_mem_read_bytes(struct tpm_chip *chip, u32 addr, u16 l=
en,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 *result)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (len--)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*result++ =3D ioread8=
(phy-&gt;iobase + addr);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static void tpm_mem_write_bytes(struct tpm_chip *chip, u32 addr, u16 =
len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *value)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (len--)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(*value++, ph=
y-&gt;iobase + addr);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static u16 tpm_mem_read16(struct tpm_chip *chip, u32 addr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ioread16(phy-&gt;iobase + addr);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static u32 tpm_mem_read32(struct tpm_chip *chip, u32 addr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return ioread32(phy-&gt;iobase + addr);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static void tpm_mem_write32(struct tpm_chip *chip, u32 addr, u32 valu=
e)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0iowrite32(value, phy-&gt;iobase + addr);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static const struct tpm_tis_phy_ops tpm_mem =3D {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.read_bytes =3D tpm_mem_read_bytes,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.write_bytes =3D tpm_mem_write_bytes,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.read16 =3D tpm_mem_read16,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.read32 =3D tpm_mem_read32,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.write32 =3D tpm_mem_write32,<br>
&gt; +};<br>
&gt; +<br>
&gt;=C2=A0 static irqreturn_t tis_int_handler(int dummy, void *dev_id)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_chip *chip =3D dev_id;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 interrupt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0interrupt =3D ioread32(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 TPM_INT_STATUS(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0interrupt =3D tpm_read32(chip, TPM_INT_STATUS(pri=
v-&gt;locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (interrupt =3D=3D 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_NONE;=
<br>
&gt; @@ -600,10 +621,8 @@ static irqreturn_t tis_int_handler(int dummy, voi=
d *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0wake_up_interrup=
tible(&amp;priv-&gt;int_queue);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear interrupts handled with TPM_EOI */<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(interrupt,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TPM_INT_STATUS=
(priv-&gt;locality));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0ioread32(phy-&gt;iobase + TPM_INT_STATUS(priv-&gt=
;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_STATUS(priv-&gt;localit=
y), interrupt);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_read32(chip, TPM_INT_STATUS(priv-&gt;locality=
));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return IRQ_HANDLED;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -615,7 +634,6 @@ static int tpm_tis_probe_irq_single(struct tpm_chi=
p *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int flags, int irq)<=
br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (devm_request_irq(&amp;chip-&gt;dev, irq,=
 tis_int_handler, flags,<br>
&gt; @@ -626,19 +644,16 @@ static int tpm_tis_probe_irq_single(struct tpm_c=
hip *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;irq =3D irq;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(priv-&gt;locality=
));<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(irq,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 phy-&gt;iobase + TPM=
_INT_VECTOR(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D tpm_read8(chip, TPM_INT_VECT=
OR(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_INT_VECTOR(priv-&gt;locality=
), irq);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear all existing */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(ioread32(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 TPM_INT_STATUS(priv-&gt;locality)),<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 + TPM_INT_STATUS(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_STATUS(priv-&gt;localit=
y),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_rea=
d32(chip, TPM_INT_STATUS(priv-&gt;locality)));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Turn on */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask | TPM_GLOBAL_INT_ENABLE,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 + TPM_INT_ENABLE(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv-&gt;localit=
y),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intmask=
 | TPM_GLOBAL_INT_ENABLE);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0priv-&gt;irq_tested =3D false;<br>
&gt;<br>
&gt; @@ -654,8 +669,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chi=
p *chip, u32 intmask,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * will call disable_irq which undoes all of=
 the above.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(chip-&gt;flags &amp; TPM_CHIP_FLAG_IRQ=
)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iowrite8(original_int=
_vec,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 phy-&gt;iobase + TPM_INT_VECTOR(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_=
INT_VECTOR(priv-&gt;locality),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 original_int_vec);<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -669,12 +685,10 @@ static int tpm_tis_probe_irq_single(struct tpm_c=
hip *chip, u32 intmask,<br>
&gt;=C2=A0 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask=
)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 original_int_vec;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0original_int_vec =3D ioread8(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(priv-&gt;locality=
));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0original_int_vec =3D tpm_read8(chip, TPM_INT_VECT=
OR(priv-&gt;locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!original_int_vec) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ENABLED(C=
ONFIG_X86))<br>
&gt; @@ -694,10 +708,9 @@ MODULE_PARM_DESC(interrupts, &quot;Enable interru=
pts&quot;);<br>
&gt;=C2=A0 static void tpm_tis_remove(struct tpm_chip *chip)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0void __iomem *reg =3D phy-&gt;iobase + TPM_INT_EN=
ABLE(priv-&gt;locality);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u32 reg =3D TPM_INT_ENABLE(priv-&gt;locality);<br=
>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(~TPM_GLOBAL_INT_ENABLE &amp; ioread32(r=
eg), reg);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, reg, ~TPM_GLOBAL_INT_ENABLE &am=
p; tpm_read32(chip, reg));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0release_locality(chip, priv-&gt;locality, 1)=
;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; @@ -725,6 +738,8 @@ static int tpm_tis_init(struct device *dev, struct=
 tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (IS_ERR(phy-&gt;iobase))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return PTR_ERR(p=
hy-&gt;iobase);<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0phy-&gt;priv.phy_ops =3D &amp;tpm_mem;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Maximum timeouts */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;timeout_a =3D TIS_TIMEOUT_A_MAX;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0chip-&gt;timeout_b =3D TIS_TIMEOUT_B_MAX;<br=
>
&gt; @@ -739,13 +754,11 @@ static int tpm_tis_init(struct device *dev, stru=
ct tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Take control of the TPM&#39;s interrupt h=
ardware and shut it off */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0intmask =3D ioread32(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 TPM_INT_ENABLE(phy-&gt;priv.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip, TPM_INT_ENABLE(phy-&=
gt;priv.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT | TPM_IN=
TF_LOCALITY_CHANGE_INT |<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INTF=
_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask &amp;=3D ~TPM_GLOBAL_INT_ENABLE;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 + TPM_INT_ENABLE(phy-&gt;priv.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(phy-&gt;priv.loc=
ality), intmask);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (request_locality(chip, 0) !=3D 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -ENODEV;<=
br>
&gt; @@ -756,12 +769,12 @@ static int tpm_tis_init(struct device *dev, stru=
ct tpm_info *tpm_info,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_err;<br=
>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0vendor =3D ioread32(phy-&gt;iobase + TPM_DID_VID(=
0));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0vendor =3D tpm_read32(chip, TPM_DID_VID(0));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;priv.manufacturer_id =3D vendor;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_info(dev, &quot;%s TPM (device-id 0x%X, =
rev-id %d)\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (chip-&gt;flags=
 &amp; TPM_CHIP_FLAG_TPM2) ? &quot;2.0&quot; : &quot;1.2&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &gt;&gt; 16, =
ioread8(phy-&gt;iobase + TPM_RID(0)));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &gt;&gt; 16, =
tpm_read8(chip, TPM_RID(0)));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!itpm) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0probe =3D probe_=
itpm(chip);<br>
&gt; @@ -777,9 +790,7 @@ static int tpm_tis_init(struct device *dev, struct=
 tpm_info *tpm_info,<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Figure out the capabilities */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0intfcaps =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_IN=
TF_CAPS(phy-&gt;priv.locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0intfcaps =3D tpm_read32(chip, TPM_INTF_CAPS(phy-&=
gt;priv.locality));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dev_dbg(dev, &quot;TPM interface capabilitie=
s (0x%x):\n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intfcaps);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (intfcaps &amp; TPM_INTF_BURST_COUNT_STAT=
IC)<br>
&gt; @@ -858,23 +869,19 @@ out_err:<br>
&gt;=C2=A0 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)<b=
r>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdat=
a(&amp;chip-&gt;dev);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0struct tpm_tis_lpc_phy *phy =3D to_tpm_tis_lpc_ph=
y(priv);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u32 intmask;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* reenable interrupts that device may have =
lost or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BIOS/firmware may have disabled */<b=
r>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite8(priv-&gt;irq, phy-&gt;iobase +<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 TPM_INT_VECTOR(priv-=
&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write8(chip, TPM_INT_VECTOR(priv-&gt;locality=
), priv-&gt;irq);<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0intmask =3D<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioread32(phy-&gt;iobase + TPM_INT_E=
NABLE(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0intmask =3D tpm_read32(chip, TPM_INT_ENABLE(priv-=
&gt;locality));<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0intmask |=3D TPM_INTF_CMD_READY_INT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_LOCALITY_CHANGE_INT=
 | TPM_INTF_DATA_AVAIL_INT<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| TPM_INTF_STS_VALID_INT | TPM=
_GLOBAL_INT_ENABLE;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0iowrite32(intmask,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0phy-&gt;iobase=
 + TPM_INT_ENABLE(priv-&gt;locality));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0tpm_write32(chip, TPM_INT_ENABLE(priv-&gt;localit=
y), intmask);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt;=C2=A0 static int tpm_tis_resume(struct device *dev)<br>
&gt; diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_ti=
s_core.h<br>
&gt; index 2260f89..3e066eb 100644<br>
&gt; --- a/drivers/char/tpm/tpm_tis_core.h<br>
&gt; +++ b/drivers/char/tpm/tpm_tis_core.h<br>
&gt; @@ -25,6 +25,16 @@<br>
&gt;<br>
&gt;=C2=A0 #include &quot;tpm.h&quot;<br>
&gt;<br>
&gt; +struct tpm_tis_phy_ops {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0void (*read_bytes)(struct tpm_chip *chip, u32 add=
r, u16 len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 u8 *result);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0void (*write_bytes)(struct tpm_chip *chip, u32 ad=
dr, u16 len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0u8 *value);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u16 (*read16)(struct tpm_chip *chip, u32 addr);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0u32 (*read32)(struct tpm_chip *chip, u32 addr);<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0void (*write32)(struct tpm_chip *chip, u32 addr, =
u32 src);<br>
&gt; +};<br>
&gt; +<br>
&gt;=C2=A0 struct tpm_tis_data {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u16 manufacturer_id;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int locality;<br>
&gt; @@ -32,6 +42,60 @@ struct tpm_tis_data {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool irq_tested;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t int_queue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_queue_head_t read_queue;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const struct tpm_tis_phy_ops *phy_ops;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt; +static inline void tpm_read_bytes(struct tpm_chip *chip, u32 addr, u1=
6 len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 *result)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;phy_ops-&gt;read_bytes(chip, addr, len, =
result);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static inline u8 tpm_read8(struct tpm_chip *chip, u32 addr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u8 result;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;phy_ops-&gt;read_bytes(chip, addr, 1, &a=
mp;result);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return result;<br>
&gt; +}<br>
&gt; +<br>
&gt; +static inline u16 tpm_read16(struct tpm_chip *chip, u32 addr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return priv-&gt;phy_ops-&gt;read16(chip, addr);<b=
r>
&gt; +}<br>
&gt; +<br>
&gt; +static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return priv-&gt;phy_ops-&gt;read32(chip, addr);<b=
r>
&gt; +}<br>
&gt; +<br>
&gt; +static inline void tpm_write_bytes(struct tpm_chip *chip, u32 addr, u=
16 len,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u8 *value)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;phy_ops-&gt;write_bytes(chip, addr, len,=
 value);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static inline void tpm_write8(struct tpm_chip *chip, u32 addr, u8 val=
ue)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;phy_ops-&gt;write_bytes(chip, addr, 1, &=
amp;value);<br>
&gt; +}<br>
&gt; +<br>
&gt; +static inline void tpm_write32(struct tpm_chip *chip, u32 addr, u32 v=
alue)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct tpm_tis_data *priv =3D dev_get_drvdata(&am=
p;chip-&gt;dev);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0priv-&gt;phy_ops-&gt;write32(chip, addr, value);<=
br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 #endif<br>
&gt; --<br>
&gt; 2.1.4<br>
&gt;<br>
</div></div></blockquote></div><br></div>

--001a114b3d5e44971f0530d65897--


--===============6023072891593901827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
--===============6023072891593901827==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6023072891593901827==--
