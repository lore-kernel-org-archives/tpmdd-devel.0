From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: use devm_add_action_or_reset
Date: Tue, 26 Apr 2016 11:30:14 +0300
Message-ID: <20160426083014.GA29628@intel.com>
References: <1461617198-32351-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461617198-32351-1-git-send-email-sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 25, 2016 at 09:46:38PM +0100, Sudip Mukherjee wrote:
> If devm_add_action() fails we are explicitly calling the cleanup function
> in the error path. Lets use the helper function devm_add_action_or_reset()
> and return directly as we know the cleanup has been done by the helper.

Have you verified that this compiles against my tree?

/Jarkko

> Signed-off-by: Sudip Mukherjee <sudip.mukherjee-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 5bc530c..aca4505 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -212,11 +212,10 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
>  	if (IS_ERR(chip))
>  		return chip;
>  
> -	rc = devm_add_action(pdev, (void (*)(void *)) put_device, &chip->dev);
> -	if (rc) {
> -		put_device(&chip->dev);
> +	rc = devm_add_action_or_reset(pdev, (void (*)(void *)) put_device,
> +				      &chip->dev);
> +	if (rc)
>  		return ERR_PTR(rc);
> -	}
>  
>  	dev_set_drvdata(pdev, chip);
>  
> -- 
> 1.9.1
> 

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
