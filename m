From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/4] tmp/tpm_crb: fix Intel PTT hw bug
	during idle state
Date: Sat, 8 Oct 2016 19:00:06 +0300
Message-ID: <20161008160006.GA25893@intel.com>
References: <1475927979-23484-1-git-send-email-tomas.winkler@intel.com>
	<1475927979-23484-3-git-send-email-tomas.winkler@intel.com>
	<20161008125003.GB10317@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542F6768@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F6768-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
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

On Sat, Oct 08, 2016 at 02:27:06PM +0000, Winkler, Tomas wrote:
> > 
> > On Sat, Oct 08, 2016 at 02:59:37PM +0300, Tomas Winkler wrote:
> > > From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > There is a HW bug in Skylake, Kabylake, and Broxton PCH Intel PTT
> > > device, where most of the registers in the control area except START,
> > > REQUEST, CANCEL, and LOC_CTRL lost retention when the device is in the
> > idle state.
> > > Hence we need to bring the device to ready state before accessing the
> > > other registers. The fix brings device to ready state before trying to
> > > read command and response buffer addresses in order to remap the for
> > access.
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > > V2: cmd read need to be called also before crb_init as this will run
> > > self test.
> > > V3: resend.
> > > V4: add Kabylake to the list of effected platforms
> > >
> > >  drivers/char/tpm/tpm_crb.c | 47
> > > ++++++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 39 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > > index 0f3b3f3d12d3..4eb96b85c653 100644
> > > --- a/drivers/char/tpm/tpm_crb.c
> > > +++ b/drivers/char/tpm/tpm_crb.c
> > > @@ -319,6 +319,7 @@ static int crb_map_io(struct acpi_device *device,
> > struct crb_priv *priv,
> > >  	struct list_head resources;
> > >  	struct resource io_res;
> > >  	struct device *dev = &device->dev;
> > > +	u32 pa_high, pa_low;
> > >  	u64 cmd_pa;
> > >  	u32 cmd_size;
> > >  	u64 rsp_pa;
> > > @@ -346,12 +347,27 @@ static int crb_map_io(struct acpi_device *device,
> > struct crb_priv *priv,
> > >  	if (IS_ERR(priv->cca))
> > >  		return PTR_ERR(priv->cca);
> > >
> > > -	cmd_pa = ((u64) ioread32(&priv->cca->cmd_pa_high) << 32) |
> > > -		  (u64) ioread32(&priv->cca->cmd_pa_low);
> > > +	/*
> > > +	 * PTT HW bug w/a: wake up the device to access
> > > +	 * possibly not retained registers.
> > > +	 */
> > > +	ret = crb_cmd_ready(dev, priv);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	pa_high = ioread32(&priv->cca->cmd_pa_high);
> > > +	pa_low  = ioread32(&priv->cca->cmd_pa_low);
> > > +	cmd_pa = ((u64)pa_high << 32) | pa_low;
> > >  	cmd_size = ioread32(&priv->cca->cmd_size);
> > > +
> > > +	dev_dbg(dev, "cmd_hi = %X cmd_low = %X cmd_size %X\n",
> > > +		pa_high, pa_low, cmd_size);
> > > +
> > >  	priv->cmd = crb_map_res(dev, priv, &io_res, cmd_pa, cmd_size);
> > > -	if (IS_ERR(priv->cmd))
> > > -		return PTR_ERR(priv->cmd);
> > > +	if (IS_ERR(priv->cmd)) {
> > > +		ret = PTR_ERR(priv->cmd);
> > > +		goto out;
> > > +	}
> > >
> > >  	memcpy_fromio(&rsp_pa, &priv->cca->rsp_pa, 8);
> > >  	rsp_pa = le64_to_cpu(rsp_pa);
> > > @@ -359,7 +375,8 @@ static int crb_map_io(struct acpi_device *device,
> > > struct crb_priv *priv,
> > >
> > >  	if (cmd_pa != rsp_pa) {
> > >  		priv->rsp = crb_map_res(dev, priv, &io_res, rsp_pa, rsp_size);
> > > -		return PTR_ERR_OR_ZERO(priv->rsp);
> > > +		ret = PTR_ERR_OR_ZERO(priv->rsp);
> > > +		goto out;
> > >  	}
> > >
> > >  	/* According to the PTP specification, overlapping command and
> > > response @@ -367,12 +384,18 @@ static int crb_map_io(struct acpi_device
> > *device, struct crb_priv *priv,
> > >  	 */
> > >  	if (cmd_size != rsp_size) {
> > >  		dev_err(dev, FW_BUG "overlapping command and response
> > buffer sizes are not identical");
> > > -		return -EINVAL;
> > > +		ret = -EINVAL;
> > > +		goto out;
> > >  	}
> > > +
> > >  	priv->cmd_size = cmd_size;
> > >
> > >  	priv->rsp = priv->cmd;
> > > -	return 0;
> > > +
> > > +out:
> > > +	crb_go_idle(dev, priv);
> > > +
> > > +	return ret;
> > >  }
> > >
> > >  static int crb_acpi_add(struct acpi_device *device) @@ -416,7 +439,15
> > > @@ static int crb_acpi_add(struct acpi_device *device)
> > >  	if (rc)
> > >  		return rc;
> > >
> > > -	return crb_init(device, priv);
> > > +	rc  = crb_cmd_ready(dev, priv);
> > > +	if (rc)
> > > +		return rc;
> > 
> > I cannot find any valid reason why crb_map_io calls crb_go_idle in the except
> > in the case of a failure. This is something I complained earlier.
> 
> Haven't I've already explained that?  Each flow has to be enclosed by
> cmdReady and goIdle.  There is nothing different here from the other
> flows in that matter.  The assumption here is that we are starting in
> the idle state bug because of the HW bug we cannot access the
> registers. So the whole w/o is enclosed in the crb_map_io.  After that
> we are starting from new, from the idle state. 

But why you have to do crb_go_idle upon returning from crb_map_io()?

> > A minor thing but the extra crb_cmd_ready is basically clutter to the
> > initialization.
> 
> The extra cmdReady is here in case runtime pm is not compiled into the
> kernel and assumption here is that we are starting in the idle state.
> Please remember that unfortunately we cannot detect whether we are in
> ready on idle state as the status register is not retained, so
> everything has to be ordered properly. 

Rather you it would be better not to use cmdReady/goIdle at all if
kernel is not compiled with CONFIG_PM.

> Thanks
> Tomas

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
