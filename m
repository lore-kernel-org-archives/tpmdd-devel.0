From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 4/7] tpm/tpm_i2c_atmel: Few code style
	fixes
Date: Tue, 29 Mar 2016 17:17:44 +0300
Message-ID: <20160329141744.GC12764@intel.com>
References: <1458975615-8095-1-git-send-email-christophe-h.ricard@st.com>
	<1458975615-8095-5-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458975615-8095-5-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

On Sat, Mar 26, 2016 at 08:00:12AM +0100, Christophe Ricard wrote:
> Few code style fixes.

Sorry but I don't care to apply this patch as there is much more
This just adds noise and brings almost no benefit.

/Jarkko

> Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/char/tpm/tpm_i2c_atmel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
> index 5426c9d..d357065 100644
> --- a/drivers/char/tpm/tpm_i2c_atmel.c
> +++ b/drivers/char/tpm/tpm_i2c_atmel.c
> @@ -125,8 +125,7 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
>  	/* Once the TPM has completed the command the command remains readable
>  	 * until another command is issued. */
>  	rc = i2c_master_recv(client, priv->buffer, sizeof(priv->buffer));
> -	dev_dbg(&chip->dev,
> -		"%s: sts=%d", __func__, rc);
> +	dev_dbg(&chip->dev, "%s: sts=%d", __func__, rc);
>  	if (rc <= 0)
>  		return 0;
>  
> @@ -192,6 +191,7 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  static int i2c_atmel_remove(struct i2c_client *client)
>  {
>  	struct tpm_chip *chip = i2c_get_clientdata(client);
> +
>  	tpm_chip_unregister(chip);
>  	return 0;
>  }
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
