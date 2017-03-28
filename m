From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: do handle area size validation only
 when TPM space used
Date: Tue, 28 Mar 2017 13:24:53 +0300
Message-ID: <20170328102453.hvyc3a4vmrk3lyzu@intel.com>
References: <20170326210815.21252-1-jarkko.sakkinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170326210815.21252-1-jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

So do you need this or not?

/Jarkko

On Mon, Mar 27, 2017 at 12:08:15AM +0300, Jarkko Sakkinen wrote:
> In order to not cause backwards compatibility issues with
> /dev/tpm0 disable handle area size validation if tpm_transmit
> is not called with a TPM space.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-X3B1VOXEql0@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-interface.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bf0c3fa..158c1db 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -328,7 +328,9 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
>  }
>  EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
>  
> -static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
> +static bool tpm_validate_command(struct tpm_chip *chip,
> +				 struct tpm_space *space,
> +				 const u8 *cmd,
>  				 size_t len)
>  {
>  	const struct tpm_input_header *header = (const void *)cmd;
> @@ -340,6 +342,9 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
>  	if (len < TPM_HEADER_SIZE)
>  		return false;
>  
> +	if (!space)
> +		return true;
> +
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2 && chip->nr_commands) {
>  		cc = be32_to_cpu(header->ordinal);
>  
> @@ -386,7 +391,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>  	unsigned long stop;
>  	bool need_locality;
>  
> -	if (!tpm_validate_command(chip, buf, bufsiz))
> +	if (!tpm_validate_command(chip, space, buf, bufsiz))
>  		return -EINVAL;
>  
>  	if (bufsiz > TPM_BUFSIZE)
> -- 
> 2.9.3
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
