From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: select CONFIG_CRYPTO
Date: Wed, 15 Mar 2017 10:30:24 +0200
Message-ID: <20170315083024.loltipc7h3uxwfaa@intel.com>
References: <20170314214043.3895041-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170314214043.3895041-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, Christophe Ricard <christophe.ricard@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Arnd,

On Tue, Mar 14, 2017 at 10:40:24PM +0100, Arnd Bergmann wrote:
> As we need the CRYPTO_HASH_INFO implementation, we should also
> select CRYPTO itself to avoid this build warning:
> 
> warning: (TCG_TPM && TRUSTED_KEYS && IMA) selects CRYPTO_HASH_INFO which has unmet direct dependencies (CRYPTO)
> 
> Fixes: c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I've already merged this and put to my next branch.

/Jarkko

> ---
>  drivers/char/tpm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index af985cca413c..d520ac51c11c 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -6,6 +6,7 @@ menuconfig TCG_TPM
>  	tristate "TPM Hardware Support"
>  	depends on HAS_IOMEM
>  	select SECURITYFS
> +	select CRYPTO
>  	select CRYPTO_HASH_INFO
>  	---help---
>  	  If you have a TPM security chip in your system, which
> -- 
> 2.9.0
> 
