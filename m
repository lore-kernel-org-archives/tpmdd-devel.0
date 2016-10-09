From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] tpm_crb: expand struct
 crb_control_area to struct crb_regs
Date: Sun, 9 Oct 2016 21:06:13 +0300
Message-ID: <20161009180613.GA26794@intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475972112-2819-2-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20161009014256.GA8210@obsidianresearch.com>
	<20161009093818.GG31891@intel.com>
	<20161009164905.GA12551@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161009164905.GA12551-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 09, 2016 at 10:49:05AM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 09, 2016 at 12:38:18PM +0300, Jarkko Sakkinen wrote:
> > On Sat, Oct 08, 2016 at 07:42:56PM -0600, Jason Gunthorpe wrote:
> > > On Sun, Oct 09, 2016 at 03:15:09AM +0300, Jarkko Sakkinen wrote:
> > > > +	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address,
> > > > +			   sizeof(struct crb_regs) -
> > > > +			   offsetof(struct crb_regs, ctrl_req));
> > > > +	if (IS_ERR(ctrl))
> > > > +		return PTR_ERR(ctrl);
> > > > +
> > > > +	/* The control area always overrlaps IO memory mapped from the ACPI
> > > > +	 * object with CRB start only devices. Thus, this is perfectly safe.
> > > > +	 */
> > > > +	priv->regs = (void *)((unsigned long)ctrl -
> > > > +		offsetof(struct crb_regs, ctrl_req));
> > > 
> > > Hum. No, this makes bad assumptions about the structure of iomapping.
> > > 
> > > The map itself needs to be done with the adjustment:
> > > 
> > > 	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address -
> > > 		offsetof(struct crb_regs, ctrl_req),
> > > 	   	sizeof(struct crb_regs));
> > 
> > That would be wrong address for the control area as it does not start
> > from the beginning of CRB registers.
> 
> Of course, I just pointed out what the map call should look like
> 
> Something like this
> 
>  	priv->regs = crb_map_res(dev, priv, &io_res, buf->control_address -
>  		offsetof(struct crb_regs, ctrl_req),
>  	   	sizeof(struct crb_regs));
>         ctrl = &priv->regs.ctrl_req;
> 
> > I think the crb_map_io and crb_map_res are too generic. Better way to do
> > things would be to validate that assumptions for these two cases hold.
> 
> If the driver is going to be using a negative offset like this, then
> it very much should validate the assumptions before doing it.
> 
> and not even map these regsiters if they are not supported by
> hardware.

Yes, that's what the point I tried to make in my response in the part
that is not quoted here.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
