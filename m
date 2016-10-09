From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 3/3] tpm_crb: request and relinquish
 locality 0
Date: Sun, 9 Oct 2016 09:43:59 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F71A7@hasmsx108.ger.corp.intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475972112-2819-4-git-send-email-jarkko.sakkinen@linux.intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F6C98@hasmsx108.ger.corp.intel.com>
	<20161009092522.GE31891@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161009092522.GE31891-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net


> >
> > >
> > > Request and relinquish locality for the driver use in order to be a better
> citizen
> > > in a multi locality environment like with TXT as it uses locality 2.
> >
> > >
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > ---
> > >  drivers/char/tpm/tpm_crb.c | 36
> > > ++++++++++++++++++++++++------------
> > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > > index
> > > ffd3a6c..9e07cf3 100644
> > > --- a/drivers/char/tpm/tpm_crb.c
> > > +++ b/drivers/char/tpm/tpm_crb.c
> > > @@ -34,6 +34,15 @@ enum crb_defaults {
> > >  	CRB_ACPI_START_INDEX = 1,
> > >  };
> > >
> > > +enum crb_loc_ctrl {
> > > +	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
> > > +	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
> > > +};
> > > +
> > > +enum crb_loc_state {
> > > +	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
> > > +};
> > > +
> > >  enum crb_ctrl_req {
> > >  	CRB_CTRL_REQ_CMD_READY	= BIT(0),
> > >  	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
> > > @@ -98,12 +107,8 @@ struct crb_priv {
> > >   * @dev:  crb device
> > >   * @priv: crb private data
> > >   *
> > > - * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
> > > - * The device should respond within TIMEOUT_C by clearing the bit.
> > > - * Anyhow, we do not wait here as a consequent CMD_READY request
> > > - * will be handled correctly even if idle was not completed.
> > > - *
> > > - * The function does nothing for devices with ACPI-start method.
> > > + * Put device to the idle state and relinquish locality. The
> > > + function does
> > > + * nothing for devices with the ACPI-start method.
> > >   *
> > >   * Return: 0 always
> > >   */
> > > @@ -112,6 +117,7 @@ static int __maybe_unused crb_go_idle(struct
> > > device *dev, struct crb_priv *priv)
> > >  	if (priv->flags & CRB_FL_ACPI_START)
> > >  		return 0;
> > >
> > > +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs->loc_ctrl);
> >
> >
> > Please don't mix different functionalities in one function
> 
> ??
> 
> > Also those functions are called from runtime pm, this has nothing to
> > do with the power management
> 
> It all depends on granularity. If you want to make an argument, could you
> propose a better granularity? Do you think it'd be better to do it for each
> transmission?

Not sure, I don't believe we closed the design here with all the parties, you are jumping ahead. 

> You are saying that this is all bad without saying really backing up your
> statements by any means.

You are right,  I assumed it's pretty obvious, I'm taking this to my attention not do it again.

So my point is if you have a function which is named go_idle  it probably does go idle flow and no other things like relinquish functionality that's for code readability and style.
Also you lost degree  of freedom even now you may want perform each of these operation for each tpm request, that might not be true in general, we would like to witch to runtime auto suspend it won't work anymore, for example. Also as you pointed right now we are not clear on the granularity of the locality access. 

Thanks
Tomas


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
