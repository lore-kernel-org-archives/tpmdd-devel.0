From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: remove struct tpm_pcrextend_in
Date: Wed, 24 May 2017 15:28:22 -0700
Message-ID: <20170524222822.bk2popwamuo7ee3o@intel.com>
References: <20170524222731.19741-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170524222731.19741-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 24, 2017 at 03:27:31PM -0700, Jarkko Sakkinen wrote:
> Removed struct tpm_pcrextend_in as it is not used for anything anymore.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Another bit of code that I just push.

/Jarkko

> ---
>  drivers/char/tpm/tpm.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index dd1173427fb2..af05c1403c6e 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -363,11 +363,6 @@ struct tpm_pcrread_in {
>  	__be32	pcr_idx;
>  } __packed;
>  
> -struct tpm_pcrextend_in {
> -	__be32	pcr_idx;
> -	u8	hash[TPM_DIGEST_SIZE];
> -} __packed;
> -
>  /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>   * bytes, but 128 is still a relatively large number of random bytes and
>   * anything much bigger causes users of struct tpm_cmd_t to start getting
> @@ -392,7 +387,6 @@ typedef union {
>  	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
>  	struct	tpm_pcrread_in	pcrread_in;
>  	struct	tpm_pcrread_out	pcrread_out;
> -	struct	tpm_pcrextend_in pcrextend_in;
>  	struct	tpm_getrandom_in getrandom_in;
>  	struct	tpm_getrandom_out getrandom_out;
>  	struct tpm_startup_in startup_in;
> -- 
> 2.11.0
> 
