From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm_crb: map locality registers
Date: Tue, 11 Oct 2016 11:01:43 -0600
Message-ID: <20161011170143.GC6881@obsidianresearch.com>
References: <1476177787-15003-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1476177787-15003-3-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476177787-15003-3-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Tue, Oct 11, 2016 at 12:23:04PM +0300, Jarkko Sakkinen wrote:
> In order to provide access to locality registers, this commits adds
> mapping of the head of the CRB registers, which are located right
> before the control area.

I think you should squash this into the prior patch, no sense in
changing all these lines twice

But looks better to me.

> -	priv->cca = crb_map_res(dev, priv, &io_res, buf->control_address,
> -				sizeof(struct crb_control_area));
> -	if (IS_ERR(priv->cca))
> -		return PTR_ERR(priv->cca);
> +	if (priv->flags & CRB_FL_CRB_START) {
> +		priv->regs_h = crb_map_res(dev, priv, &io_res, io_res.start,
> +					   sizeof(struct crb_regs_head));
> +		if (IS_ERR(priv->regs_h))
> +			return PTR_ERR(priv->regs_h);
> +	}
> +
> +	priv->regs_t = crb_map_res(dev, priv, &io_res, buf->control_address,
> +				   sizeof(struct crb_regs_tail));
> +	if (IS_ERR(priv->regs_t))
> +		return PTR_ERR(priv->regs_t);

So.. The ACPI IO region starts at the head area and continues to
include the control area, as one nice sane region - except for some
older stuff that puts the control area outside the ACPI IO region?

That makes a lot more sense..

Maybe chuck in a

   if (priv->flags & CRB_FL_CRB_START) {
      if (buf->control_address != io_res.start + sizeof(struct
          crb_regs_head))
          dev_warn(dev, FIRMWARE_BUG "Bad ACPI memory layout")

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
