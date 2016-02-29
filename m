From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 04/10] tpm: Get rid of module locking
Date: Mon, 29 Feb 2016 22:35:50 +0200
Message-ID: <20160229203550.GB26296@intel.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1456766996-9300-5-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456766996-9300-5-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 29, 2016 at 12:29:50PM -0500, Stefan Berger wrote:
> Now that the tpm core has strong locking around 'ops' it is possible
> to remove a TPM driver, module and all, even while user space still
> has things like /dev/tpmX open. For consistency and simplicity, drop
> the module locking entirely.

I don't understand why the user visible behavior of /dev/tpmX should
be changed if there are no life and death reasons to do it. Do you
think that this patch is absolutely crucial for the feature
implemented?

/Jarkko

> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 1ae30f2..8f4b5f2 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -57,9 +57,6 @@ int tpm_try_get_ops(struct tpm_chip *chip)
>  	if (!chip->ops)
>  		goto out_lock;
>  
> -	if (!try_module_get(chip->dev.parent->driver->owner))
> -		goto out_lock;
> -
>  	return 0;
>  out_lock:
>  	up_read(&chip->ops_sem);
> @@ -77,7 +74,6 @@ EXPORT_SYMBOL_GPL(tpm_try_get_ops);
>   */
>  void tpm_put_ops(struct tpm_chip *chip)
>  {
> -	module_put(chip->dev.parent->driver->owner);
>  	up_read(&chip->ops_sem);
>  	put_device(&chip->dev);
>  }
> @@ -183,7 +179,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
>  		goto out;
>  
>  	cdev_init(&chip->cdev, &tpm_fops);
> -	chip->cdev.owner = dev->driver->owner;
> +	chip->cdev.owner = THIS_MODULE;
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
>  
>  	rc = devm_add_action(dev, (void (*)(void *)) put_device, &chip->dev);
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
