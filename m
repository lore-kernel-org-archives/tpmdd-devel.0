From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/4 v2] tpm/tpm_crb: cache cmd_size
	register value.
Date: Mon, 12 Sep 2016 13:49:16 +0300
Message-ID: <20160912104916.GB15636@intel.com>
References: <1473635035-14443-1-git-send-email-tomas.winkler@intel.com>
	<1473635035-14443-3-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473635035-14443-3-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 12, 2016 at 02:03:53AM +0300, Tomas Winkler wrote:
> Instead of expensive register access on retrieving cmd_size
> on each send, save the value during initialization in the private
> context. The value doesn't change.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

$ git am -3 ~/Downloads/2-4-v2-tpm-tpm_crb-cache-cmd_size-register-value..patch
Applying: tpm/tpm_crb: cache cmd_size register value.
fatal: sha1 information is lacking or useless (drivers/char/tpm/tpm_crb.c).
error: could not build fake ancestor
Patch failed at 0001 tpm/tpm_crb: cache cmd_size register value.
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
VCS_INFO_get_data_git:225: no such file or directory: .git/rebase-apply/msg-clean                                                                           

/Jarkko

> 
> ---
> V2: rebased
> 
>  drivers/char/tpm/tpm_crb.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 6a4b32599869..f066810bfc03 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -80,6 +80,7 @@ struct crb_priv {
>  	struct crb_control_area __iomem *cca;
>  	u8 __iomem *cmd;
>  	u8 __iomem *rsp;
> +	u32 cmd_size;
>  };
>  
>  static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
> @@ -141,11 +142,9 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>  	int rc = 0;
>  
> -	if (len > ioread32(&priv->cca->cmd_size)) {
> -		dev_err(&chip->dev,
> -			"invalid command count value %x %zx\n",
> -			(unsigned int) len,
> -			(size_t) ioread32(&priv->cca->cmd_size));
> +	if (len > priv->cmd_size) {
> +		dev_err(&chip->dev, "invalid command count value %zd %d\n",
> +			len, priv->cmd_size);
>  		return -E2BIG;
>  	}
>  
> @@ -301,6 +300,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>  		dev_err(dev, FW_BUG "overlapping command and response buffer sizes are not identical");
>  		return -EINVAL;
>  	}
> +	priv->cmd_size = cmd_size;
>  
>  	priv->rsp = priv->cmd;
>  	return 0;
> -- 
> 2.7.4
> 

------------------------------------------------------------------------------
