From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] tpm_crb: expand struct
 crb_control_area to struct crb_regs
Date: Sun, 9 Oct 2016 12:38:18 +0300
Message-ID: <20161009093818.GG31891@intel.com>
References: <1475972112-2819-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1475972112-2819-2-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20161009014256.GA8210@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161009014256.GA8210-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Sat, Oct 08, 2016 at 07:42:56PM -0600, Jason Gunthorpe wrote:
> On Sun, Oct 09, 2016 at 03:15:09AM +0300, Jarkko Sakkinen wrote:
> > +	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address,
> > +			   sizeof(struct crb_regs) -
> > +			   offsetof(struct crb_regs, ctrl_req));
> > +	if (IS_ERR(ctrl))
> > +		return PTR_ERR(ctrl);
> > +
> > +	/* The control area always overrlaps IO memory mapped from the ACPI
> > +	 * object with CRB start only devices. Thus, this is perfectly safe.
> > +	 */
> > +	priv->regs = (void *)((unsigned long)ctrl -
> > +		offsetof(struct crb_regs, ctrl_req));
> 
> Hum. No, this makes bad assumptions about the structure of iomapping.
> 
> The map itself needs to be done with the adjustment:
> 
> 	ctrl = crb_map_res(dev, priv, &io_res, buf->control_address -
> 		offsetof(struct crb_regs, ctrl_req),
> 	   	sizeof(struct crb_regs));

That would be wrong address for the control area as it does not start
from the beginning of CRB registers.

> .. and nothing actually proves that control_address follows anything
> in the driver, so this seems like a terrifying blind assumption, but
> everything about the iomap in this ACPI binding seems totally bonkers
> so that is in good company I guess.

There are basically two kinds of CRB devices in the wild:

1. ACPI start devices that use DMA
2. CRB MMIO devices

For 1 you always iomap control area. For 2 the ACPI object given buffer
covers the control area.

I think the crb_map_io and crb_map_res are too generic. Better way to do
things would be to validate that assumptions for these two cases hold.

> .. and the comment says this only holds for 'crb start only' devices,
> but the code doesn't actually act differently based on what sort of
> device we have..
> 
> Your commit message also seems to imply the new registers are only on
> newer hardware, but nothing seems to check for that before acessing
> them?  Confusing.

That's why there's this thing called RFC :)

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
