From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] vTPM: Fix missing NULL check
Date: Wed, 15 Mar 2017 18:43:10 +0200
Message-ID: <20170315164310.f2rlyev77nd3fsev@intel.com>
References: <1489555687-27943-1-git-send-email-honclo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489555687-27943-1-git-send-email-honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, g@intel.com
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 15, 2017 at 01:28:07AM -0400, Hon Ching(Vicky) Lo wrote:
> The current code passes the address of tpm_chip as the argument to
> dev_get_drvdata() without prior NULL check in
> tpm_ibmvtpm_get_desired_dma.  This resulted an oops during kernel
> boot when vTPM is enabled in Power partition configured in active
> memory sharing mode.
> 
> The vio_driver's get_desired_dma() is called before the probe(), which
> for vtpm is tpm_ibmvtpm_probe, and it's this latter function that
> initializes the driver and set data.  Attempting to get data before
> the probe() caused the problem.
> 
> This patch adds a NULL check to the tpm_ibmvtpm_get_desired_dma.
> 
> fixes: 9e0d39d8a6a0 ("tpm: Remove useless priv field in struct tpm_vendor_specific")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Hon Ching(Vicky) Lo <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Jarkko Sakkine <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm_ibmvtpm.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index 1b9d61f..f01d083 100644
> --- a/drivers/char/tpm/tpm_ibmvtpm.c
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -299,6 +299,8 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>  	}
>  
>  	kfree(ibmvtpm);
> +	/* For tpm_ibmvtpm_get_desired_dma */
> +	dev_set_drvdata(&vdev->dev, NULL);
>  
>  	return 0;
>  }
> @@ -313,14 +315,16 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
>  static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
> -	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
> +	struct ibmvtpm_dev *ibmvtpm;
>  
>  	/*
>  	 * ibmvtpm initializes at probe time, so the data we are
>  	 * asking for may not be set yet. Estimate that 4K required
>  	 * for TCE-mapped buffer in addition to CRQ.
>  	 */
> -	if (!ibmvtpm)
> +	if (chip)
> +		ibmvtpm = dev_get_drvdata(&chip->dev);
> +	else
>  		return CRQ_RES_BUF_SIZE + PAGE_SIZE;
>  
>  	return CRQ_RES_BUF_SIZE + ibmvtpm->rtce_size;
> -- 
> 1.7.1
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
