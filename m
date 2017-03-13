From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm_crb: request and relinquish locality 0
Date: Mon, 13 Mar 2017 13:58:24 +0200
Message-ID: <20170313115824.el7aoo46hwszrfac@intel.com>
References: <20170311130216.21419-1-jarkko.sakkinen@linux.intel.com>
 <87tw6ys2dt.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tw6ys2dt.fsf@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, gang.wei@intel.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 12, 2017 at 12:47:58PM -0700, Jerry Snitselaar wrote:
> 
> Jarkko Sakkinen @ 2017-03-11 13:02 GMT:
> 
> > Added two new callbacks to struct tpm_class_ops:
> >
> > - request_locality
> > - relinquish_locality
> >
> > These are called before sending and receiving data from the TPM.  We
> > update also tpm_tis_core to use these callbacks. Small modification to
> > request_locality() is done so that it returns -EBUSY instead of locality
> > number when check_locality() fails.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm-interface.c |  9 +++++++++
> >  drivers/char/tpm/tpm_crb.c       | 41 +++++++++++++++++++++++++++++++++++++++-
> >  drivers/char/tpm/tpm_tis_core.c  | 12 ++++--------
> >  include/linux/tpm.h              |  3 ++-
> >  4 files changed, 55 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > index e38c792..9c56581 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -407,6 +407,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> >  	if (chip->dev.parent)
> >  		pm_runtime_get_sync(chip->dev.parent);
> >  
> > +	if (chip->ops->request_locality)  {
> > +		rc = chip->ops->request_locality(chip, 0);
> > +		if (rc)
> > +			goto out;
> > +	}
> > +
> >  	rc = tpm2_prepare_space(chip, space, ordinal, buf);
> >  	if (rc)
> >  		goto out;
> > @@ -466,6 +472,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> >  	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
> >  
> >  out:
> > +	if (chip->ops->relinquish_locality)
> > +		chip->ops->relinquish_locality(chip, 0, false);
> > +
> >  	if (chip->dev.parent)
> >  		pm_runtime_put_sync(chip->dev.parent);
> >  
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > index 3245618..15b22a0 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -34,6 +34,15 @@ enum crb_defaults {
> >  	CRB_ACPI_START_INDEX = 1,
> >  };
> >  
> > +enum crb_loc_ctrl {
> > +	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
> > +	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
> > +};
> > +
> > +enum crb_loc_state {
> > +	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
> > +};
> > +
> >  enum crb_ctrl_req {
> >  	CRB_CTRL_REQ_CMD_READY	= BIT(0),
> >  	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
> > @@ -172,6 +181,35 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
> >  	return 0;
> >  }
> >  
> > +static int crb_request_locality(struct tpm_chip *chip, int loc)
> > +{
> > +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> > +
> > +	if (!priv->regs_h)
> > +		return 0;
> > +
> > +	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
> > +	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state,
> > +				 CRB_LOC_STATE_LOC_ASSIGNED, /* mask */
> > +				 CRB_LOC_STATE_LOC_ASSIGNED, /* value */
> 
> Should this mask and check bit 7 as well (tpmRegValidSts)? The
> table with the definition in the PTP spec says it indicates whether
> all other bits contain valid values, but the text above it doesn't
> discuss the locAssigned and activeLocality bits with respect to
> tpmRegValidSts, so not completely clear.

You are probably right. There's also regression with the resource
manager (in this patch not in RM) that I'll fix. Thaks for reporting
this.

/Jarkko
