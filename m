From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Mon, 12 Sep 2016 12:25:21 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542CDCB7@hasmsx108.ger.corp.intel.com>
References: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
	<1473670501-29281-2-git-send-email-tomas.winkler@intel.com>
	<20160912120109.GA957@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160912120109.GA957-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> -----Original Message-----
> From: Jarkko Sakkinen [mailto:jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org]
> Sent: Monday, September 12, 2016 15:01
> To: Winkler, Tomas <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Subject: Re: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb idle state
> 
> Could you also put this into linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org?
> 
> On Mon, Sep 12, 2016 at 11:54:58AM +0300, Tomas Winkler wrote:
> > The register TPM_CRB_CTRL_REQ_x contains bits goIdle and cmdReady for
> > SW to indicate that the device can enter or should exit the idle state.
> >
> > The legacy ACPI-start (SMI + DMA) based devices do not support these
> > bits and the idle state management is not exposed to the host SW.
> > Thus, this functionality only is enabled only for a CRB start (MMIO)
> > based devices.
> >
> > Based on Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> oringal
> > patch:
> > 'tpm_crb: implement power tpm crb power management'
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > V2: do not export the functions via tpm ops
> 
> I'm not sure about this. Even if callbacks are there tpm_crb and other device
> drivers can use runtime PM internally (if they want).
> 
> >  drivers/char/tpm/tpm_crb.c | 62
> > ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> >
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > index 6e9d1bca712f..49023ac3dea1 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -83,6 +83,68 @@ struct crb_priv {
> >  	u32 cmd_size;
> >  };
> >
> > +/**
> > + * crb_go_idle - write crb_ctrl_req_go_idle to tpm_crb_ctrl_req
> > + *    the device should respond within timeout_c by clearing the bit.
> > + *    anyhow, we do not wait here as a consequent cmd_ready request
> > + *    will be handled correctly even if idle was not completed.
> 
> Why the function descriptions have different formatting than elsewhere in
> the subsystem?
Oops c&p error, moved the code to much around. 
 
> 
> > + *
> > + * @dev:  crb device
> 
> 'pdev' would be a better name to differentiate from character device.  I
> know that in crb_acpi_add the name of the local is dev but it was just a bad
> choice by me.
> 
> Also documentation could be:
> 
> @pdev:	CRB platform device

I find pdev here  a bit misleading this is not a platform device, also if we want to clean up the variable names this should not be mixed within these patches. 
> 
> > + * @priv: crb private data
> 
> @priv:	CRB private data
> 
> > + * return:  0 always
> 
> According to
> 
> https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
> 
> it should be 'Return:'.
Opps, wrong 'vi' sequence :)
> 
> Why this isn't a void function?

In general we can fail here on timeout, we just ignore it for this particular hardware.

> 	
> > + */
> > +static int __maybe_unused crb_go_idle(struct device *dev, struct
> > +crb_priv *priv) {
> > +	if (priv->flags & crb_fl_acpi_start)
> > +		return 0;
> > +
> > +	iowrite32(crb_ctrl_req_go_idle, &priv->cca->req);
> > +	/* we don't really care when this settles */
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * crb_cmd_ready - write crb_ctrl_req_cmd_ready to tpm_crb_ctrl_req
> > + *      and poll till the device acknowledge it by clearing the bit.
> > + *      the device should respond within timeout_c.
> > + *
> > + *      the function does nothing for devices with acpi-start method
> > + *
> > + * @dev:  crb device
> > + * @priv: crb private data
> > + *
> > + * return:  0 on success -etime on timeout;
> 
> Same stuff about the documentation as for the previous function.
Same here 'vi' sequence while pasting, will fix 

> Also, I don't like the naming. I would rather have the names I did for [1].
> There I have 'go_to_idle' and 'go_to_ready', which are much more obvious.
> I'm can live also with go_ready and go_idle if you prefer that.

go_idle and cmd_ready follow the TMP2 spec 

> > + */
> > +static int __maybe_unused crb_cmd_ready(struct device *dev,
> > +					struct crb_priv *priv)
> > +{
> > +	ktime_t stop, start;
> > +
> > +	if (priv->flags & crb_fl_acpi_start)
> > +		return 0;
> > +
> > +	iowrite32(crb_ctrl_req_cmd_ready, &priv->cca->req);
> > +
> > +	start = ktime_get();
> > +	stop = ktime_add(start, ms_to_ktime(tpm2_timeout_c));
> > +	do {
> > +		if (!(ioread32(&priv->cca->req) & crb_ctrl_req_cmd_ready)) {
> > +			dev_dbg(dev, "cmdready in %lld usecs\n",
> > +				ktime_to_us(ktime_sub(ktime_get(),
> start)));
> > +			return 0;
> > +		}
> > +		usleep_range(50, 100);
> > +	} while (ktime_before(ktime_get(), stop));
> > +
> > +	if (ioread32(&priv->cca->req) & crb_ctrl_req_cmd_ready) {
> > +		dev_warn(dev, "cmdready timed out\n");
> > +		return -etime;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> Please use wait_for_tpm_stat(). Please argument in th commit message if
> you don't. So far the arguments haven't made sense to me.

I say it again this should not go via tpm_stat this is conceptually wrong.
Second why would you want to use such complex function that also cumulates side effects 
for simple polling of register that should be used at one place. Plus other reason I've mentioned before.

Last you need 'struct tpm_chip' available which just not the case here.

> I think the whole status thing should be redesigned to have common
> synthetized status code shared by all TPM drivers but the way I use it in [1]
> works. It's bit ugly but I rather have that than duplicate code.

Sorry but the such polling loops is duplicated on many places just in the tpm subsystem, 
This is not case of code duplication. 
> 
> >  static simple_dev_pm_ops(crb_pm, tpm_pm_suspend,
> tpm_pm_resume);
> >
> >  static u8 crb_status(struct tpm_chip *chip)
> > --
> > 2.7.4
> >
> 
> [1] http://git.infradead.org/users/jjs/linux-
> tpmdd.git/commitdiff/7a1172b5b3cb38083ae931309db216db3c528efe
> 
> /Jarkko

Will resend. 


------------------------------------------------------------------------------
