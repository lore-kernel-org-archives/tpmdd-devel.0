From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm_tis_core: convert max timeouts from
	msec to jiffies
Date: Mon, 18 Jul 2016 21:48:50 +0300
Message-ID: <20160718184850.GI31463@intel.com>
References: <1468542580-5296-1-git-send-email-apronin@chromium.org>
	<20160718184532.GH31463@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160718184532.GH31463-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jul 18, 2016 at 09:45:32PM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 14, 2016 at 05:29:40PM -0700, Andrey Pronin wrote:
> > tpm_tis_core was missing conversion from msec when assigning
> > max timeouts from constants.
> > 
> > Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Fixes: 41a5e1cf1fe1

Applied.

/Jarkko

> /Jarkko
> 
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 8110b52..fb8c3de 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -666,10 +666,10 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
> >  #endif
> >  
> >  	/* Maximum timeouts */
> > -	chip->timeout_a = TIS_TIMEOUT_A_MAX;
> > -	chip->timeout_b = TIS_TIMEOUT_B_MAX;
> > -	chip->timeout_c = TIS_TIMEOUT_C_MAX;
> > -	chip->timeout_d = TIS_TIMEOUT_D_MAX;
> > +	chip->timeout_a = msecs_to_jiffies(TIS_TIMEOUT_A_MAX);
> > +	chip->timeout_b = msecs_to_jiffies(TIS_TIMEOUT_B_MAX);
> > +	chip->timeout_c = msecs_to_jiffies(TIS_TIMEOUT_C_MAX);
> > +	chip->timeout_d = msecs_to_jiffies(TIS_TIMEOUT_D_MAX);
> >  	priv->phy_ops = phy_ops;
> >  	dev_set_drvdata(&chip->dev, priv);
> >  
> > -- 
> > 2.6.6
> > 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
