From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 3/3] tpm_crb: request and relinquish
 locality 0
Date: Sun, 9 Oct 2016 12:25:22 +0300
Message-ID: <20161009092522.GE31891@intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475972112-2819-4-git-send-email-jarkko.sakkinen@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F6C98@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F6C98@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 09, 2016 at 06:35:28AM +0000, Winkler, Tomas wrote:
> 
> 
> > 
> > Request and relinquish locality for the driver use in order to be a better citizen
> > in a multi locality environment like with TXT as it uses locality 2.	
> 
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c index
> > ffd3a6c..9e07cf3 100644
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
> > @@ -98,12 +107,8 @@ struct crb_priv {
> >   * @dev:  crb device
> >   * @priv: crb private data
> >   *
> > - * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
> > - * The device should respond within TIMEOUT_C by clearing the bit.
> > - * Anyhow, we do not wait here as a consequent CMD_READY request
> > - * will be handled correctly even if idle was not completed.
> > - *
> > - * The function does nothing for devices with ACPI-start method.
> > + * Put device to the idle state and relinquish locality. The function
> > + does
> > + * nothing for devices with the ACPI-start method.
> >   *
> >   * Return: 0 always
> >   */
> > @@ -112,6 +117,7 @@ static int __maybe_unused crb_go_idle(struct device
> > *dev, struct crb_priv *priv)
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		return 0;
> > 
> > +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs->loc_ctrl);
> 
> 
> Please don't mix different functionalities in one function 

??

> Also those functions are called from runtime pm, this has nothing to
> do with the power management 

It all depends on granularity. If you want to make an argument, could
you propose a better granularity? Do you think it'd be better to do it
for each transmission?

You are saying that this is all bad without saying really backing up
your statements by any means.

/Jarkko
