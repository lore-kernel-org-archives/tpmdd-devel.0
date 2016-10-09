From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC 1/3] tpm_crb: expand struct crb_control_area to
 struct crb_regs
Date: Sun, 9 Oct 2016 21:33:58 +0300
Message-ID: <20161009183358.GB27764@intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475972112-2819-2-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20161009014256.GA8210@obsidianresearch.com>
 <20161009093818.GG31891@intel.com>
 <20161009164905.GA12551@obsidianresearch.com>
 <20161009183232.GA27764@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161009183232.GA27764@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Oct 09, 2016 at 09:32:32PM +0300, Jarkko Sakkinen wrote:
> On Sun, Oct 09, 2016 at 10:49:05AM -0600, Jason Gunthorpe wrote:
> > On Sun, Oct 09, 2016 at 12:38:18PM +0300, Jarkko Sakkinen wrote:
> > > On Sat, Oct 08, 2016 at 07:42:56PM -0600, Jason Gunthorpe wrote:
> > > > On Sun, Oct 09, 2016 at 03:15:09AM +0300, Jarkko Sakkinen wrote:
> > > > > +	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address,
> > > > > +			   sizeof(struct crb_regs) -
> > > > > +			   offsetof(struct crb_regs, ctrl_req));
> > > > > +	if (IS_ERR(ctrl))
> > > > > +		return PTR_ERR(ctrl);
> > > > > +
> > > > > +	/* The control area always overrlaps IO memory mapped from the ACPI
> > > > > +	 * object with CRB start only devices. Thus, this is perfectly safe.
> > > > > +	 */
> > > > > +	priv->regs = (void *)((unsigned long)ctrl -
> > > > > +		offsetof(struct crb_regs, ctrl_req));
> > > > 
> > > > Hum. No, this makes bad assumptions about the structure of iomapping.
> > > > 
> > > > The map itself needs to be done with the adjustment:
> > > > 
> > > > 	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address -
> > > > 		offsetof(struct crb_regs, ctrl_req),
> > > > 	   	sizeof(struct crb_regs));
> > > 
> > > That would be wrong address for the control area as it does not start
> > > from the beginning of CRB registers.
> > 
> > Of course, I just pointed out what the map call should look like
> > 
> > Something like this
> > 
> >  	priv->regs = crb_map_res(dev, priv, &io_res, buf->control_address -
> >  		offsetof(struct crb_regs, ctrl_req),
> >  	   	sizeof(struct crb_regs));
> >         ctrl = &priv->regs.ctrl_req;
> 
> Sorry I missed this part.
> 
> Here are the constraints for existing hardware:
> 
> 1. All the existing CRB start only hardware has the iomem covering the
>    control area and registers for multiple localities.
> 2. All the existing ACPI start hardware has only the control area.
> 
> If you assume that SSDT does not have malicous behavior caused by either
> a BIOS bug or maybe a rootkit, then the current patch works for all the
> existing hardware.
> 
> To counter-measure for unexpected behavior in non-existing hardware and
> buggy or malicious firmware it probably make sense to use crb_map_res to
> validate the part of the CRB registers that is not part of the control
> area.
> 
> Doing it in the way you proposed does not work for ACPI start devices.
> 
> For them it should be done in the same way as I'm doing in the existing
> patch as for ACPI start devices the address below the control area are
> never accessed. Having a separate crb_map_res for CRB start only devices
> is sane thing to do for validation.

Alternative is to do two structures crb_regs_head and crb_regs_tail,
which might be cleaner. I'm fine with going either route.


/Jarkko
