From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: mark PM functions as
	__maybe_unused
Date: Wed, 22 Mar 2017 12:21:23 +0200
Message-ID: <20170322102123.7ssqn5v4ulklsg5r@intel.com>
References: <20170320091755.1043811-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170320091755.1043811-1-arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 20, 2017 at 10:17:19AM +0100, Arnd Bergmann wrote:
> When CONFIG_PM_SLEEP is disabled, we get a warning about unused functions:
> 
> drivers/char/tpm/tpm_crb.c:551:12: error: 'crb_pm_resume' defined but not used [-Werror=unused-function]
> drivers/char/tpm/tpm_crb.c:540:12: error: 'crb_pm_suspend' defined but not used [-Werror=unused-function]
> 
> We could solve this with more sophistated #ifdefs, but a simpler and safer
> way is to just mark them as __maybe_unused.
> 
> Fixes: 848efcfb560c ("tpm/tpm_crb: enter the low power state upon device suspend")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Hi, I somehow missed this and applied very similar patch. Sorry about
that.

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 1dfc37e33c02..15f1118982a6 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -519,8 +519,7 @@ static int crb_acpi_remove(struct acpi_device *device)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM
> -static int crb_pm_runtime_suspend(struct device *dev)
> +static __maybe_unused int crb_pm_runtime_suspend(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> @@ -528,7 +527,7 @@ static int crb_pm_runtime_suspend(struct device *dev)
>  	return crb_go_idle(dev, priv);
>  }
>  
> -static int crb_pm_runtime_resume(struct device *dev)
> +static __maybe_unused int crb_pm_runtime_resume(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
> @@ -536,7 +535,7 @@ static int crb_pm_runtime_resume(struct device *dev)
>  	return crb_cmd_ready(dev, priv);
>  }
>  
> -static int crb_pm_suspend(struct device *dev)
> +static __maybe_unused int crb_pm_suspend(struct device *dev)
>  {
>  	int ret;
>  
> @@ -547,7 +546,7 @@ static int crb_pm_suspend(struct device *dev)
>  	return crb_pm_runtime_suspend(dev);
>  }
>  
> -static int crb_pm_resume(struct device *dev)
> +static __maybe_unused int crb_pm_resume(struct device *dev)
>  {
>  	int ret;
>  
> @@ -558,8 +557,6 @@ static int crb_pm_resume(struct device *dev)
>  	return tpm_pm_resume(dev);
>  }
>  
> -#endif /* CONFIG_PM */
> -
>  static const struct dev_pm_ops crb_pm = {
>  	SET_SYSTEM_SLEEP_PM_OPS(crb_pm_suspend, crb_pm_resume)
>  	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
> -- 
> 2.9.0
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
