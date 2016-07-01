From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RESEND][PATCH] tpm: read burstcount from TPM_STS
 in one 32-bit transaction
Date: Fri, 1 Jul 2016 11:45:45 +0300
Message-ID: <20160701084545.GA16059@intel.com>
References: <1467307543-44566-1-git-send-email-apronin@chromium.org>
	<20160701084323.GA15718@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160701084323.GA15718-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 01, 2016 at 11:43:23AM +0300, Jarkko Sakkinen wrote:
> On Thu, Jun 30, 2016 at 10:25:43AM -0700, apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org wrote:
> > From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > 
> > Some chips incorrectly support partial reads from TPM_STS register
> > at non-zero offsets. Read the entire 32-bits register instead of
> > making two 8-bit reads to support such devices and reduce the number
> > of bus transactions when obtaining the burstcount from TPM_STS.
> > 
> > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied to my master branch.

/Jarkko

> 
> /Jarkko
> 
> > ---
> > 
> > No changes. 
> > Re-sending to tpmdd-devel member-only list after subscribing.
> > 
> >  drivers/char/tpm/tpm_tis_core.c | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 03a06b3..8110b52 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -157,22 +157,17 @@ static int get_burstcount(struct tpm_chip *chip)
> >  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> >  	unsigned long stop;
> >  	int burstcnt, rc;
> > -	u8 value;
> > +	u32 value;
> >  
> >  	/* wait for burstcount */
> >  	/* which timeout value, spec has 2 answers (c & d) */
> >  	stop = jiffies + chip->timeout_d;
> >  	do {
> > -		rc = tpm_tis_read8(priv, TPM_STS(priv->locality) + 1, &value);
> > +		rc = tpm_tis_read32(priv, TPM_STS(priv->locality), &value);
> >  		if (rc < 0)
> >  			return rc;
> >  
> > -		burstcnt = value;
> > -		rc = tpm_tis_read8(priv, TPM_STS(priv->locality) + 2, &value);
> > -		if (rc < 0)
> > -			return rc;
> > -
> > -		burstcnt += value << 8;
> > +		burstcnt = (value >> 8) & 0xFFFF;
> >  		if (burstcnt)
> >  			return burstcnt;
> >  		msleep(TPM_TIMEOUT);
> > -- 
> > 2.6.6
> > 

------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
