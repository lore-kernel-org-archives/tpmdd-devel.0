From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: What does error code 38 mean? -> hex vs. decimal
Date: Wed, 26 Apr 2017 16:57:07 -0400
Message-ID: <odr1is$s8a$1@blaine.gmane.org>
References: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
	<odqn2s$72s$1@blaine.gmane.org>
	<20170426191808.kkvbg4iynbwysu6k@rhwork>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170426191808.kkvbg4iynbwysu6k@rhwork>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 4/26/2017 3:18 PM, Jerry Snitselaar wrote:
>
> Maybe the following?
>
>
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index bd2128e0b56c..e6e60f9f428c 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -453,9 +453,14 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
>                 return -EFAULT;
>
>         err = be32_to_cpu(header->return_code);
> -       if (err != 0 && desc)
> -               dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
> -                       desc);
> +       if (err != 0 && desc) {
> +               if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +                       dev_err(&chip->dev, "A TPM error (0x%x) occurred %s\n", err,
> +                               desc);
> +               else
> +                       dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
> +                               desc);
> +       }
>         if (err)
>                 return err;
>

I think that's a good idea.

I have a utility that parses the fields out of the TPM 2.0 error codes 
and prints the text.  It expects hex values, as does the specification.



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
