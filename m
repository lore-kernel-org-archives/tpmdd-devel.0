From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: enter the low power state
 upon device suspend
Date: Mon, 6 Mar 2017 16:44:37 +0200
Message-ID: <20170306144437.vlrilvo33rxans5t@intel.com>
References: <1488758015-12681-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488758015-12681-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 06, 2017 at 01:53:35AM +0200, Tomas Winkler wrote:
> This fix enables a platform to enter the idle state (suspend-to-idle)
> 
> The driver needs to request explicitly go_idle upon completion
> from the pm suspend handler.
> The runtime pm is disabled on suspend during prepare state by calling
> pm_runtime_get_noresume, hence we cannot relay on runtime pm to leave
> the device in low power state. Symmetrically cmdReady is called
> upon resume.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

LGTM

Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

PS. What about Fixes? Does this need it?

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 86f355b6df1d..d8dfff0fdfce 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -479,10 +479,33 @@ static int crb_pm_runtime_resume(struct device *dev)
>  
>  	return crb_cmd_ready(dev, priv);
>  }
> +
> +static int crb_pm_suspend(struct device *dev)
> +{
> +	int ret;
> +
> +	ret = tpm_pm_suspend(dev);
> +	if (ret)
> +		return ret;
> +
> +	return crb_pm_runtime_suspend(dev);
> +}
> +
> +static int crb_pm_resume(struct device *dev)
> +{
> +	int ret;
> +
> +	ret = crb_pm_runtime_resume(dev);
> +	if (ret)
> +		return ret;
> +
> +	return tpm_pm_resume(dev);
> +}
> +
>  #endif /* CONFIG_PM */
>  
>  static const struct dev_pm_ops crb_pm = {
> -	SET_SYSTEM_SLEEP_PM_OPS(tpm_pm_suspend, tpm_pm_resume)
> +	SET_SYSTEM_SLEEP_PM_OPS(crb_pm_suspend, crb_pm_resume)
>  	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
>  };
>  
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
