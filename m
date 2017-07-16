From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] msleep() delays - replace with
 usleep_range() in TPM 1.2/2.0 generic drivers
Date: Sun, 16 Jul 2017 13:49:07 +0300
Message-ID: <20170716104907.foav6tnuda6gubca@linux.intel.com>
References: <DF4PR84MB0028CFD4B5EBE9F929B83476F2A90@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
	<20170710191527.qlurrqit6naoaotp@linux.intel.com>
	<DF4PR84MB0028BA4AE9C3E4A6E8122D60F2AF0@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DF4PR84MB0028BA4AE9C3E4A6E8122D60F2AF0-g2Ljlah8a+id4EXwv3iukNicc1VoeDReZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Attak, Hamza" <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Cc: "Jacquin, Ludovic" <ludo-ZPxbGqLxI0U@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Edwards, Nigel" <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Your subject line looks wrong. This cannot be cleanly applied with git
am.

Please go through https://kernelnewbies.org/FirstKernelPatch

On Wed, Jul 12, 2017 at 12:34:19PM +0000, Attak, Hamza wrote:
> msleep() delays - replace with usleep_range() in TPM 1.2/2.0 generic drivers
> 
> The patch simply replaces all msleep function calls with usleep_range calls in
> the generic drivers.
> 
> Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a
> thousand PCR extends, we see results going from 1m57s unpatched to 40s with
> the new patch. We obtain similar results when using the original and patched
> tpm_infineon driver, which is also part of the patch. Similarly with a STM TPM
> 2.0, using the CRB driver, it takes about 20ms per extend unpatched and around
> 7ms with the new patch.
> 
> Note that the PCR consistency is untouched with this patch, each TPM has been
> tested with 10 million extends and the aggregated PCR value is continuously
> verified to be correct.
> 
> As an extension of this work, this could potentially and easily be applied to
> other vendor's drivers. Still, these changes are not included in the proposed
> patch as they are untested.
> 
> Signed-off-by: Hamza Attak <hamza-ZPxbGqLxI0U@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 13 ++++++++-----
>  drivers/char/tpm/tpm2-cmd.c      |  2 +-
>  drivers/char/tpm/tpm_infineon.c  |  9 ++++++---
>  drivers/char/tpm/tpm_tis_core.c  |  9 +++++----
>  4 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bd2128e..513b801 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -395,7 +395,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  			goto out;
>  		}
>  
> -		msleep(TPM_TIMEOUT);	/* CHECK */
> +		usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);

Plese look into.

https://patchwork.kernel.org/patch/9617823/

Now you are sprinkling magic numbers everywhere.

>  		rmb();
>  	} while (time_before(jiffies, stop));
>  
> @@ -862,7 +862,8 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  			dev_info(
>  			    &chip->dev, HW_ERR
>  			    "TPM command timed out during continue self test");
> -			msleep(delay_msec);
> +			usleep_range(delay_msec * 1000,
> +				(delay_msec * 1000) + 300);

The second line dooes not look properly aligned.

There's probably similar style issues elsewhere in the patch (at least
spotted one after this).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
