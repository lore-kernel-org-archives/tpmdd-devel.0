From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix node pointer lookup
Date: Tue, 15 Nov 2016 09:36:09 -0800
Message-ID: <20161115173609.6d625ksyv7rppeci@intel.com>
References: <20161115155736.599954-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161115155736.599954-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Nov 15, 2016 at 04:57:11PM +0100, Arnd Bergmann wrote:
> A rework left the node pointer uninitialized when the device tree
> is not in use:
> 
> drivers/char/tpm/tpm_of.c: In function 'read_log_of':
> drivers/char/tpm/tpm_of.c:37:8: error: 'np' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> This reverts the behavior to what it should be.
> 
> Fixes: 4a45d9669ac1 ("tpm: replace of_find_node_by_name() with dev of_node property")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Arnd, I got patch from Colin a moment earlier so I applied that.
Thank you in any case!

/Jarkko

> ---
>  drivers/char/tpm/tpm_of.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 3af829f3ad59..24fa6afc2e55 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -29,8 +29,7 @@ int read_log_of(struct tpm_chip *chip)
>  	struct tpm_bios_log *log;
>  
>  	log = &chip->log;
> -	if (chip->dev.parent->of_node)
> -		np = chip->dev.parent->of_node;
> +	np = chip->dev.parent->of_node;
>  	if (!np)
>  		return -ENODEV;
>  
> -- 
> 2.9.0
> 
