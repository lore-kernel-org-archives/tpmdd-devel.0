From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5] tpm_tis: Check return values from
	get_burstcount.
Date: Wed, 2 Nov 2016 04:40:06 -0600
Message-ID: <20161102104006.ob5s7bidpafo6b6b@intel.com>
References: <20161027215009.GA12733@google.com>
	<20161028162815.e2ssrzwq62i5rorn@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161028162815.e2ssrzwq62i5rorn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 28, 2016 at 07:28:15PM +0300, Jarkko Sakkinen wrote:
> On Thu, Oct 27, 2016 at 02:50:09PM -0700, Josh Zimmerman wrote:
> > If the TPM we're connecting to uses a static burst count, it will report
> > a burst count of zero throughout the response read. However, get_burstcount
> > assumes that a response of zero indicates that the TPM is not ready to
> > receive more data. In this case, it returns a negative error code, which
> > is passed on to tpm_tis_{write,read}_bytes as a u16, causing
> > them to read/write far too many bytes.
> > 
> > This patch checks for negative return codes and bails out from recv_data
> > and tpm_tis_send_data.
> > 
> > Fixes: 1107d065fdf1 (tpm_tis: Introduce intermediate layer for TPM access)
> > Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > ---
> > Changelog v5:
> >  - Move burstcnt < 0 check to before the min_t() call for enhanced readability.
> > Changelog v4:
> >  - Add short description to Fixes tag line.
> >  - Remove some unnecessary information in dev_err statements.
> > Changelog v3:
> >  - Add signed-off-by.
> > Changelog v2:
> >  - Fix typo (rc->burstcnt)
> > 
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index e3bf31b..a1ce060 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -185,7 +185,12 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> >  				 TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> >  				 chip->timeout_c,
> >  				 &priv->read_queue, true) == 0) {
> > -		burstcnt = min_t(int, get_burstcount(chip), count - size);
> > +		burstcnt = get_burstcount(chip);
> > +		if (burstcnt < 0) {
> > +			dev_err(&chip->dev, "Unable to read burstcount\n");
> > +			return burstcnt;
> > +		}
> > +		burstcnt = min_t(int, burstcnt, count - size);
> >  
> >  		rc = tpm_tis_read_bytes(priv, TPM_DATA_FIFO(priv->locality),
> >  					burstcnt, buf + size);
> > @@ -271,7 +276,13 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
> >  	}
> >  
> >  	while (count < len - 1) {
> > -		burstcnt = min_t(int, get_burstcount(chip), len - count - 1);
> > +		burstcnt = get_burstcount(chip);
> > +		if (burstcnt < 0) {
> > +			dev_err(&chip->dev, "Unable to read burstcount\n");
> > +			rc = burstcnt;
> > +			goto out_err;
> > +		}
> > +		burstcnt = min_t(int, burstcnt, len - count - 1);
> >  		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> >  					 burstcnt, buf + count);
> >  		if (rc < 0)
> > -- 
> > 2.8.0.rc3.226.g39d4020
> > 
> 
> LGTM
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

I'm sorry for the delay with testing but I cannot test this during this
week. The network connection is terrible at the Linux Plumbers
Conference and also at the hotel. I can barely read my email and LWN.

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
