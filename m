From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] tpm: remove struct tpm_pcrextend_in
Date: Thu, 25 May 2017 07:32:28 +0200
Message-ID: <trinity-4c867f71-295b-4ef6-b141-ca66fa805d6c-1495690348388@3capp-gmx-bs66>
References: <20170524222731.19741-1-jarkko.sakkinen@linux.intel.com>
	<20170524222822.bk2popwamuo7ee3o@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170524222822.bk2popwamuo7ee3o-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> Removed struct tpm_pcrextend_in as it is not used for anything anymore.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
LGTM.
Reviewed-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>

> ---
> drivers/char/tpm/tpm.h | 6 ------
> 1 file changed, 6 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index dd1173427fb2..af05c1403c6e 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -363,11 +363,6 @@ struct tpm_pcrread_in {
> __be32 pcr_idx;
> } __packed;
>
> -struct tpm_pcrextend_in {
> - __be32 pcr_idx;
> - u8 hash[TPM_DIGEST_SIZE];
> -} __packed;
> -
> /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
> * bytes, but 128 is still a relatively large number of random bytes and
> * anything much bigger causes users of struct tpm_cmd_t to start getting
> @@ -392,7 +387,6 @@ typedef union {
> u8 readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
> struct tpm_pcrread_in pcrread_in;
> struct tpm_pcrread_out pcrread_out;
> - struct tpm_pcrextend_in pcrextend_in;
> struct tpm_getrandom_in getrandom_in;
> struct tpm_getrandom_out getrandom_out;
> struct tpm_startup_in startup_in;
> --
> 2.11.0
>

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
