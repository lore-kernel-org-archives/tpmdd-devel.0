From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix duplicate inline declaration specifier
Date: Fri, 29 Sep 2017 20:17:04 +0300
Message-ID: <20170929171704.azziyvlikbv5qnbd@linux.intel.com>
References: <1506434337-15284-1-git-send-email-rubenroy2005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506434337-15284-1-git-send-email-rubenroy2005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ruben Roy <rubenroy2005@gmail.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Nick Desaulniers <nick.desaulniers@gmail.com>, trivial@kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Sep 26, 2017 at 01:58:57PM +0000, Ruben Roy wrote:
> This commit fixes the duplicate inline declaration specifier in
> tpm2_rc_value which caused a warning
> 
> Signed-off-by: Ruben Roy <rubenroy2005@gmail.com>
> ---
>  drivers/char/tpm/tpm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 04fbff2..f4d0272 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -550,7 +550,7 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
>  }
>  #endif
>  
> -static inline inline u32 tpm2_rc_value(u32 rc)
> +static inline u32 tpm2_rc_value(u32 rc)
>  {
>  	return (rc & BIT(7)) ? rc & 0xff : rc;
>  }
> -- 
> 1.8.3.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
