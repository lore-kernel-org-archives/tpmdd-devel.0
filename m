From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [tpmdd-devel] [PATCH v2 2/3] tpm_crb: encapsulate
        crb_wait_for_reg_32
Date: Mon, 5 Dec 2016 21:34:50 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54336FFE@hasmsx108.ger.corp.intel.com>
References: <20161203175213.10210-1-jarkko.sakkinen@linux.intel.com>
        <20161203175213.10210-3-jarkko.sakkinen@linux.intel.com>
 <20161203184137.p4mk3gdldcflty5x@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161203184137.p4mk3gdldcflty5x@intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Cc: "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> CC linux-security-module
> 
> On Sat, Dec 03, 2016 at 07:52:12PM +0200, Jarkko Sakkinen wrote:
> > Encapsulated crb_wait_for_reg32() so that state changes in other CRB
> > registers than TPM_CRB_CTRL_REQ_x can be waited.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 37 +++++++++++++++++++++++--------------
> >  1 file changed, 23 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > index 8d81b66..f986d02 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -121,6 +121,25 @@ static int __maybe_unused crb_go_idle(struct
> device *dev, struct crb_priv *priv)
> >  	return 0;
> >  }
> >
> > +static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
> > +				unsigned long timeout)
> > +{
> > +	ktime_t start;
> > +	ktime_t stop;
> > +
> > +	start = ktime_get();
> > +	stop = ktime_add(start, ms_to_ktime(timeout));
> > +
> > +	do {
> > +		if ((ioread32(reg) & mask) == value)
> > +			return true;
> > +
> > +		usleep_range(50, 100);
This was tuned for power management, have you tuned it for locality? 

> > +	} while (ktime_before(ktime_get(), stop));
> > +
> > +	return false;
> > +}
> > +
> >  /**
> >   * crb_cmd_ready - request tpm crb device to enter ready state
> >   *
> > @@ -138,24 +157,14 @@ static int __maybe_unused crb_go_idle(struct
> > device *dev, struct crb_priv *priv)  static int __maybe_unused
> crb_cmd_ready(struct device *dev,
> >  					struct crb_priv *priv)
> >  {
> > -	ktime_t stop, start;
> > -	u32 req;
> > -
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		return 0;
> >
> >  	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
> > -
> > -	start = ktime_get();
> > -	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
> > -	do {
> > -		req = ioread32(&priv->regs_t->ctrl_req);
> > -		if (!(req & CRB_CTRL_REQ_CMD_READY))
> > -			return 0;
> > -		usleep_range(50, 100);
> > -	} while (ktime_before(ktime_get(), stop));
> > -
> > -	if (ioread32(&priv->regs_t->ctrl_req) & CRB_CTRL_REQ_CMD_READY)
> {
> > +	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
> > +				 CRB_CTRL_REQ_CMD_READY /* mask */,
> > +				 0, /* value */
> > +				 TPM2_TIMEOUT_C)) {
> >  		dev_warn(dev, "cmdReady timed out\n");
> >  		return -ETIME;
> >  	}
> > --
> > 2.9.3
> >
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
