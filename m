From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/3] tpm2-cmd: Trigger only missing self
 tests
Date: Sun, 20 Aug 2017 21:25:17 +0300
Message-ID: <20170820182517.3oaow2fumhfk5she@linux.intel.com>
References: <20170818121532.5764-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170818121532.5764-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
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

On Fri, Aug 18, 2017 at 02:15:30PM +0200, Alexander Steffen wrote:
> tpm2_do_selftest is only used during initialization of the TPM to ensure
> that the device functions correctly. Therefore, it is sufficient to request
> only missing self tests (parameter full_test=0), not a reexecution of all
> self tests, as was done before. This allows for a faster execution of this
> command.
> 
> Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/char/tpm/tpm2-cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index f7f34b2a..7e328d6 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -865,7 +865,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
>  }
>  
>  /**
> - * tpm2_do_selftest() - run a full self test
> + * tpm2_do_selftest() - ensure that all self tests have passed
>   *
>   * @chip: TPM chip to use
>   *
> @@ -886,7 +886,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  
>  	loops = jiffies_to_msecs(duration) / delay_msec;
>  
> -	rc = tpm2_start_selftest(chip, true);
> +	rc = tpm2_start_selftest(chip, false);
>  	if (rc)
>  		return rc;
>  
> -- 
> 2.7.4
> 

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
