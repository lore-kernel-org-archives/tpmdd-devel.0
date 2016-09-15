From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Thu, 15 Sep 2016 13:53:47 +0300
Message-ID: <20160915105347.GB22431@intel.com>
References: <1473685461-6540-1-git-send-email-tomas.winkler@intel.com>
	<1473685461-6540-2-git-send-email-tomas.winkler@intel.com>
	<20160915062204.GA12289@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542DBC0D@hasmsx108.ger.corp.intel.com>
	<20160915082037.GA16233@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542DBD21@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542DBD21-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 15, 2016 at 08:23:03AM +0000, Winkler, Tomas wrote:
> > > > Subject: Re: [PATCH v3 1/4] tpm/tpm_crb: implement tpm crb idle
> > > > state
> > > >
> > > > On Mon, Sep 12, 2016 at 04:04:18PM +0300, Tomas Winkler wrote:
> > > > > The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady
> > > > > for SW to indicate that the device can enter or should exit the idle state.
> > > > >
> > > > > The legacy ACPI-start (SMI + DMA) based devices do not support
> > > > > these bits and the idle state management is not exposed to the host
> > SW.
> > > > > Thus, this functionality only is enabled only for a CRB start
> > > > > (MMIO) based devices.
> > > > >
> > > > > Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> oringal
> > > > > patch:
> > > > > 'tpm_crb: implement power tpm crb power management'
> > > > >
> > > > >
> > > > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > ---
> > > > > V2: do not export the functions via tpm ops
> > > > > V3: fix lower case corruption; adjust function documentation
> > > > >
> > > > >  drivers/char/tpm/tpm_crb.c | 69
> > > > > ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  1 file changed, 69 insertions(+)
> > > > >
> > > > > diff --git a/drivers/char/tpm/tpm_crb.c
> > > > > b/drivers/char/tpm/tpm_crb.c index 6e9d1bca712f..b6923a8b3ff7
> > > > > 100644
> > > > > --- a/drivers/char/tpm/tpm_crb.c
> > > > > +++ b/drivers/char/tpm/tpm_crb.c
> > > > > @@ -83,6 +83,75 @@ struct crb_priv {
> > > > >  	u32 cmd_size;
> > > > >  };
> > > > >
> > > > > +/**
> > > > > + * crb_go_idle - request tpm crb device to go the idle state
> > > > > + *
> > > > > + * @dev:  crb device
> > > > > + * @priv: crb private data
> > > > > + *
> > > > > + * Write CRB_CTRL_REQ_GO_IDLE to TPM_CRB_CTRL_REQ
> > > > > + * The device should respond within TIMEOUT_C by clearing the bit.
> > > > > + * Anyhow, we do not wait here as a consequent CMD_READY request
> > > > > + * will be handled correctly even if idle was not completed.
> > > > > + *
> > > > > + * The function does nothing for devices with ACPI-start method.
> > > > > + *
> > > > > + * Return: 0 always
> > > > > + */
> > > > > +static int __maybe_unused crb_go_idle(struct device *dev, struct
> > > > > +crb_priv *priv) {
> > > > > +	if (priv->flags & CRB_FL_ACPI_START)
> > > > > +		return 0;
> > > > > +
> > > > > +	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
> > > > > +	/* we don't really care when this settles */
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * crb_cmd_ready - request tpm crb device to enter ready state
> > > > > + *
> > > > > + * @dev:  crb device
> > > > > + * @priv: crb private data
> > > > > + *
> > > > > + * Write CRB_CTRL_REQ_CMD_READY to TPM_CRB_CTRL_REQ
> > > > > + * and poll till the device acknowledge it by clearing the bit.
> > > > > + * The device should respond within TIMEOUT_C.
> > > > > + *
> > > > > + * The function does nothing for devices with ACPI-start method
> > > > > + *
> > > > > + * Return: 0 on success -ETIME on timeout;  */ static int
> > > > > +__maybe_unused crb_cmd_ready(struct device *dev,
> > > > > +					struct crb_priv *priv)
> > > > > +{
> > > > > +	ktime_t stop, start;
> > > > > +
> > > > > +	if (priv->flags & CRB_FL_ACPI_START)
> > > > > +		return 0;
> > > > > +
> > > > > +	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
> > > > > +
> > > > > +	start = ktime_get();
> > > > > +	stop = ktime_add(start, ms_to_ktime(TPM2_TIMEOUT_C));
> > > > > +	do {
> > > > > +		if (!(ioread32(&priv->cca->req) &
> > > > CRB_CTRL_REQ_CMD_READY)) {
> > > > > +			dev_dbg(dev, "cmdReady in %lld usecs\n",
> > > > > +				ktime_to_us(ktime_sub(ktime_get(), start)));
> > > > > +			return 0;
> > > > > +		}
> > > > > +		usleep_range(50, 100);
> > > > > +	} while (ktime_before(ktime_get(), stop));
> > > >
> > > > Since this is HW specific this is right thing to do and not abuse
> > > > wait_for_tpm_stat. However, this should be documented to the commit
> > > > message.
> > > I will respin just this patch and not the whole series, as the fix is only in the
> > commit message.
> > > Tomas
> > 
> > Works for me. I can update pm_runtime_sync(). Then I'm ready to apply
> > these.
> 
> What do you mean by pm_runtime_sync()?

Typo. I already commente v2 of the series that pm_runtime_put should be
used instead of pm_runtime_put_sync.

/Jarkko

------------------------------------------------------------------------------
