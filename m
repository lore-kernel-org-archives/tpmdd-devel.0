From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 09/12] tpm/tpm_tis: Rework interrupt
 management for phy compatibility
Date: Sun, 20 Mar 2016 19:37:22 -0600
Message-ID: <20160321013722.GB9417@obsidianresearch.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-10-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458502483-16887-10-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 20, 2016 at 08:34:40PM +0100, Christophe Ricard wrote:
> Rework interrupt handling in order to be compatible with every phy.

You need to describe this much more.

> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -881,7 +881,9 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  	unsigned long stop;
>  	long rc;
>  	u8 status;
> +	u32 cur_intrs;
>  	bool canceled = false;
> +	bool condition;
>  
>  	/* check current status */
>  	status = chip->ops->status(chip);
> @@ -892,14 +894,17 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  
>  	if (chip->vendor.irq) {
>  again:
> +		cur_intrs = chip->vendor.intrs;
>  		timeout = stop - jiffies;
>  		if ((long)timeout <= 0)
>  			return -ETIME;
>  		rc = wait_event_interruptible_timeout(*queue,
> -			wait_for_tpm_stat_cond(chip, mask, check_cancel,
> -					       &canceled),
> +			cur_intrs != chip->vendor.intrs,
>  			timeout);
> -		if (rc > 0) {
> +		condition = wait_for_tpm_stat_cond(chip, mask,
> +						   check_cancel,
> +						   &canceled);
> +		if (rc > 0 && condition) {
>  			if (canceled)
>  				return -ECANCELED;
>  			return 0;

This should not be buried into a packet to tpm_tis.

How does this even work for other drivers?

> +static void tpm_tis_clear_int(struct tpm_chip *chip)

All these changes look a little unsettling.. Ordering is really
important when working with interrupts and this changes all sorts of
things.

I'd be alot happier if the current flow wasn't being changed to add
the new interfaces.

> -	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
> -			     dev_name(&chip->dev), chip) != 0) {
> +	if (devm_request_threaded_irq(&chip->dev, irq, NULL, tis_int_handler, flags,
> +				      dev_name(&chip->dev), chip) != 0) {

This shouldn't be changed for the lpc case either.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
