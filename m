From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix crash in tpm_tis deinitialization
Date: Tue, 12 Apr 2016 07:26:27 +0300
Message-ID: <20160412042627.GA6608@intel.com>
References: <1460390720-9509-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160411174037.GA371@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160411174037.GA371-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Mon, Apr 11, 2016 at 11:40:37AM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 11, 2016 at 07:05:20PM +0300, Jarkko Sakkinen wrote:
> > rmmod crashes the driver because tpm_chip_unregister() already sets ops
> > to NULL. This commit fixes the issue by moving tpm2_shutdown() to
> > tpm_chip_unregister(). This commit is also cleanup because it removes
> > duplicate code from tpm_crb and tpm_tis to the core.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Fixes: 4d3eac5e156a ("tpm: Provide strong locking for device removal")
> >  drivers/char/tpm/tpm-chip.c | 3 +++
> >  drivers/char/tpm/tpm_crb.c  | 3 ---
> >  drivers/char/tpm/tpm_tis.c  | 3 ---
> >  3 files changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index f62c851..2642cca 100644
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -361,6 +361,9 @@ void tpm_chip_unregister(struct tpm_chip *chip)
> >  	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
> >  		return;
> >  
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > +
> >  	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> >  		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
> 
> This needs to be after ops is fenced, something like this.

I would appreciate a supporting argument.

I guess the argument here is that this will prevent user space from
issuing TPM commands after the shutdown command has been sent?

/Jarkko

> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 2642cca05cac..2ea2f1561e59 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -269,6 +269,8 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  
>  	/* Make the driver uncallable. */
>  	down_write(&chip->ops_sem);
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  	chip->ops = NULL;
>  	up_write(&chip->ops_sem);
>  }
> @@ -361,9 +363,6 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>  	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
>  		return;
>  
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> -
>  	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>  		sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
>  

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
