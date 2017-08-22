From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm2-cmd: Use dynamic delay to wait
 for self test result
Date: Tue, 22 Aug 2017 20:44:16 +0300
Message-ID: <20170822174416.63ym53nfbrx4eq4x@linux.intel.com>
References: <20170818121532.5764-1-Alexander.Steffen@infineon.com>
 <20170818121532.5764-2-Alexander.Steffen@infineon.com>
 <20170820182632.ik4d5nfm2ggashiy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170820182632.ik4d5nfm2ggashiy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Aug 20, 2017 at 09:26:32PM +0300, Jarkko Sakkinen wrote:
> On Fri, Aug 18, 2017 at 02:15:31PM +0200, Alexander Steffen wrote:
> > In order to avoid delaying the code longer than necessary while still
> > giving the TPM enough time to execute the self tests asynchronously, start
> > with a small delay between two polls and increase it each round.
> > 
> > Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm2-cmd.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index 7e328d6..e3d4cc3 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -877,20 +877,17 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
> >  static int tpm2_do_selftest(struct tpm_chip *chip)
> >  {
> >  	int rc;
> > -	unsigned int loops;
> > -	unsigned int delay_msec = 100;
> > -	unsigned long duration;
> > -	int i;
> > -
> > -	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
> > +	unsigned int delay_msec = 20;
> > +	long duration;
> >  
> > -	loops = jiffies_to_msecs(duration) / delay_msec;
> > +	duration = jiffies_to_msecs(
> > +		tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST));
> >  
> >  	rc = tpm2_start_selftest(chip, false);
> >  	if (rc)
> >  		return rc;
> >  
> > -	for (i = 0; i < loops; i++) {
> > +	while (duration > 0) {
> >  		/* Attempt to read a PCR value */
> >  		rc = tpm2_pcr_read(chip, 0, NULL);
> >  		if (rc < 0)
> > @@ -900,6 +897,10 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
> >  			break;
> >  
> >  		msleep(delay_msec);
> > +		duration -= delay_msec;
> > +
> > +		/* wait longer the next round */
> > +		delay_msec *= 2;
> >  	}
> >  
> >  	return rc;
> > -- 
> > 2.7.4
> > 
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> /Jarkko


Applying: tpm2-cmd: Use dynamic delay to wait for self test result
error: sha1 information is lacking or useless (drivers/char/tpm/tpm2-cmd.c).
error: could not build fake ancestor
Patch failed at 0001 tpm2-cmd: Use dynamic delay to wait for self test result
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Please rebase your patches.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
