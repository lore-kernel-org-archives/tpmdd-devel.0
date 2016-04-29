From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: select ANON_INODES for proxy driver
Date: Fri, 29 Apr 2016 21:42:06 +0300
Message-ID: <20160429184206.GA21071@intel.com>
References: <1461840382-2996256-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461840382-2996256-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 28, 2016 at 12:46:13PM +0200, Arnd Bergmann wrote:
> The newly added vtpmx driver fails to build if CONFIG_ANON_INODES
> is disabled:
> 
> drivers/char/built-in.o: In function `vtpmx_fops_ioctl':
> (.text+0x97f8): undefined reference to `anon_inode_getfile'
> 
> This adds a Kconfig 'select' statement to ensure it's always there
> when we need it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 794c38e01358 ("tpm: Proxy driver for supporting multiple emulated TPMs")

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 0eac596e33d1..bfdc5c0486aa 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -125,6 +125,7 @@ config TCG_CRB
>  config TCG_VTPM_PROXY
>  	tristate "VTPM Proxy Interface"
>  	depends on TCG_TPM
> +	select ANON_INODES
>  	---help---
>  	  This driver proxies for an emulated TPM (vTPM) running in userspace.
>  	  A device /dev/vtpmx is provided that creates a device pair
> -- 
> 2.7.0
> 
