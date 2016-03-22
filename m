From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 04/12] tpm/st33zp24: Remove unneeded
 tpm_reg in get_burstcount
Date: Tue, 22 Mar 2016 08:16:50 +0200
Message-ID: <20160322061650.GA4058@intel.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-5-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458502483-16887-5-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Sun, Mar 20, 2016 at 08:34:35PM +0100, Christophe Ricard wrote:
> We can get rid of tpm_reg variable in get_burstcount.

Maybe you should send these st33zp24 fixes as a separate patch set
as they are all unrelated to the rework.

/Jarkko

> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/st33zp24/st33zp24.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
> index 944d279..9e91ca7 100644
> --- a/drivers/char/tpm/st33zp24/st33zp24.c
> +++ b/drivers/char/tpm/st33zp24/st33zp24.c
> @@ -208,21 +208,21 @@ static int get_burstcount(struct tpm_chip *chip)
>  {
>  	unsigned long stop;
>  	int burstcnt, status;
> -	u8 tpm_reg, temp;
> +	u8 temp;
>  	struct st33zp24_dev *tpm_dev;
>  
>  	tpm_dev = (struct st33zp24_dev *)TPM_VPRIV(chip);
>  
>  	stop = jiffies + chip->vendor.timeout_d;
>  	do {
> -		tpm_reg = TPM_STS + 1;
> -		status = tpm_dev->ops->recv(tpm_dev->phy_id, tpm_reg, &temp, 1);
> +		status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS + 1,
> +					    &temp, 1);
>  		if (status < 0)
>  			return -EBUSY;
>  
> -		tpm_reg = TPM_STS + 2;
>  		burstcnt = temp;
> -		status = tpm_dev->ops->recv(tpm_dev->phy_id, tpm_reg, &temp, 1);
> +		status = tpm_dev->ops->recv(tpm_dev->phy_id, TPM_STS + 2,
> +					    &temp, 1);
>  		if (status < 0)
>  			return -EBUSY;
>  
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
