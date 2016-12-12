From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v3 1/3] tpm_crb: map locality registers
Date: Mon, 12 Dec 2016 17:20:01 +0200
Message-ID: <20161212152001.53ewps3jczs4jdld@intel.com>
References: <20161207115001.18332-1-jarkko.sakkinen@linux.intel.com>
 <20161207115001.18332-2-jarkko.sakkinen@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B5433A4BD@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5433A4BD@hasmsx108.ger.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, open list <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Dec 12, 2016 at 02:25:32PM +0000, Winkler, Tomas wrote:
> > 
> > In order to provide access to locality registers, this commits adds mapping of
> > the head of the CRB registers, which are located right before the control area.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 89 +++++++++++++++++++++++++++++------------
> > -----
> >  1 file changed, 57 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c index
> > 717b6b4..80b9759 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -52,18 +52,28 @@ enum crb_cancel {
> >  	CRB_CANCEL_INVOKE	= BIT(0),
> >  };
> > 
> > -struct crb_control_area {
> > -	u32 req;
> > -	u32 sts;
> > -	u32 cancel;
> > -	u32 start;
> > -	u32 int_enable;
> > -	u32 int_sts;
> > -	u32 cmd_size;
> > -	u32 cmd_pa_low;
> > -	u32 cmd_pa_high;
> > -	u32 rsp_size;
> > -	u64 rsp_pa;
> > +struct crb_regs_head {
> > +	u32 loc_state;
> > +	u32 reserved1;
> > +	u32 loc_ctrl;
> > +	u32 loc_sts;
> > +	u8 reserved2[32];
> > +	u64 intf_id;
> > +	u64 ctrl_ext;
> > +} __packed;
> > +
> 
> > +struct crb_regs_tail {
> Why to change the name this is still control_area 
> > +	u32 ctrl_req;
> > +	u32 ctrl_sts;
> > +	u32 ctrl_cancel;
> > +	u32 ctrl_start;
> > +	u32 ctrl_int_enable;
> > +	u32 ctrl_int_sts;
> > +	u32 ctrl_cmd_size;
> > +	u32 ctrl_cmd_pa_low;
> > +	u32 ctrl_cmd_pa_high;
> > +	u32 ctrl_rsp_size;
> > +	u64 ctrl_rsp_pa;
> >  } __packed;
> > 
> >  enum crb_status {
> > @@ -78,7 +88,8 @@ enum crb_flags {
> >  struct crb_priv {
> >  	unsigned int flags;
> >  	void __iomem *iobase;
> > -	struct crb_control_area __iomem *cca;
> > +	struct crb_regs_head __iomem *regs_h;
> > +	struct crb_regs_tail __iomem *regs_t;
> 
> Same here, why to change the name, let's keep it cca it will reduce the size of patch and make it more back portable. 
> 
> >  	u8 __iomem *cmd;
> >  	u8 __iomem *rsp;
> >  	u32 cmd_size;
> > @@ -104,7 +115,7 @@ static int __maybe_unused crb_go_idle(struct device
> > *dev, struct crb_priv *priv)
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		return 0;
> > 
> > -	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
> > +	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
> >  	/* we don't really care when this settles */
> > 
> >  	return 0;
> > @@ -128,21 +139,23 @@ static int __maybe_unused crb_cmd_ready(struct
> > device *dev,
> >  					struct crb_priv *priv)
> >  {
> >  	ktime_t stop, start;
> > +	u32 req;
> > 
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		return 0;
> > 
> > -	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
> > +	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
> > 
> >  	start = ktime_get();
> >  	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
> >  	do {
> > -		if (!(ioread32(&priv->cca->req) &
> > CRB_CTRL_REQ_CMD_READY))
> > +		req = ioread32(&priv->regs_t->ctrl_req);
> > +		if (!(req & CRB_CTRL_REQ_CMD_READY))
> >  			return 0;
> >  		usleep_range(50, 100);
> >  	} while (ktime_before(ktime_get(), stop));
> > 
> > -	if (ioread32(&priv->cca->req) & CRB_CTRL_REQ_CMD_READY) {
> > +	if (ioread32(&priv->regs_t->ctrl_req) & CRB_CTRL_REQ_CMD_READY)
> > {
> >  		dev_warn(dev, "cmdReady timed out\n");
> >  		return -ETIME;
> >  	}
> > @@ -155,7 +168,7 @@ static u8 crb_status(struct tpm_chip *chip)
> >  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> >  	u8 sts = 0;
> > 
> > -	if ((ioread32(&priv->cca->start) & CRB_START_INVOKE) !=
> > +	if ((ioread32(&priv->regs_t->ctrl_start) & CRB_START_INVOKE) !=
> >  	    CRB_START_INVOKE)
> >  		sts |= CRB_DRV_STS_COMPLETE;
> > 
> > @@ -171,7 +184,7 @@ static int crb_recv(struct tpm_chip *chip, u8 *buf,
> > size_t count)
> >  	if (count < 6)
> >  		return -EIO;
> > 
> > -	if (ioread32(&priv->cca->sts) & CRB_CTRL_STS_ERROR)
> > +	if (ioread32(&priv->regs_t->ctrl_sts) & CRB_CTRL_STS_ERROR)
> >  		return -EIO;
> > 
> >  	memcpy_fromio(buf, priv->rsp, 6);
> > @@ -210,7 +223,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf,
> > size_t len)
> >  	/* Zero the cancel register so that the next command will not get
> >  	 * canceled.
> >  	 */
> > -	iowrite32(0, &priv->cca->cancel);
> > +	iowrite32(0, &priv->regs_t->ctrl_cancel);
> > 
> >  	if (len > priv->cmd_size) {
> >  		dev_err(&chip->dev, "invalid command count value %zd %d\n",
> > @@ -224,7 +237,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf,
> > size_t len)
> >  	wmb();
> > 
> >  	if (priv->flags & CRB_FL_CRB_START)
> > -		iowrite32(CRB_START_INVOKE, &priv->cca->start);
> > +		iowrite32(CRB_START_INVOKE, &priv->regs_t->ctrl_start);
> > 
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		rc = crb_do_acpi_start(chip);
> > @@ -236,7 +249,7 @@ static void crb_cancel(struct tpm_chip *chip)  {
> >  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > 
> > -	iowrite32(CRB_CANCEL_INVOKE, &priv->cca->cancel);
> > +	iowrite32(CRB_CANCEL_INVOKE, &priv->regs_t->ctrl_cancel);
> > 
> >  	if ((priv->flags & CRB_FL_ACPI_START) && crb_do_acpi_start(chip))
> >  		dev_err(&chip->dev, "ACPI Start failed\n"); @@ -245,7 +258,7
> > @@ static void crb_cancel(struct tpm_chip *chip)  static bool
> > crb_req_canceled(struct tpm_chip *chip, u8 status)  {
> >  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > -	u32 cancel = ioread32(&priv->cca->cancel);
> > +	u32 cancel = ioread32(&priv->regs_t->ctrl_cancel);
> > 
> >  	return (cancel & CRB_CANCEL_INVOKE) == CRB_CANCEL_INVOKE;  }
> > @@ -322,10 +335,22 @@ static int crb_map_io(struct acpi_device *device,
> > struct crb_priv *priv,
> >  	if (IS_ERR(priv->iobase))
> >  		return PTR_ERR(priv->iobase);
> > 
> > -	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
> > -				sizeof(struct crb_control_area));
> > -	if (IS_ERR(priv->cca))
> > -		return PTR_ERR(priv->cca);
> > +	/* The ACPI IO region starts at the head area and continues to include
> > +	 * the control area, as one nice sane region except for some older
> > +	 * stuff that puts the control area outside the ACPI IO region.
> 
> 
> This is not explained correctly.  BDW and older platforms implement  only a PC subset of the spec. 
> On those platforms there are only CCA registers, other registers are not implemented. 

The region pointed by the TPM2 table at least in some (if not all) old
platforms I've tested is completley disjoint from the region pointed by
the ACPI device tree (SSDT in PTT's case). 

Here's example device from my x250:

Device (TPM)
{
Name (_HID, "MSFT0101" /* TPM 2.0 Security Device */)  // _HID: Hardware ID
Name (_STR, Unicode ("TPM 2.0 Device"))  // _STR: Description String
Name (CRS, ResourceTemplate ()
{
Memory32Fixed (ReadOnly,
    0x00000000,         // Address Base
    0x00001000,         // Address Length
    _Y00)
Memory32Fixed (ReadOnly,
    0xFED70000,         // Address Base
    0x00001000,         // Address Length
    )
})


This is from TPM2.dsl:

[028h 0040   8]              Control Address : 00000000CCDFF000

/Jarkko
