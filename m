From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm/tpm_tis_spi: drop duplicate header module.h
Date: Mon, 19 Dec 2016 15:42:02 +0200
Message-ID: <20161219134202.iy57sk6nyesctqqf@intel.com>
References: <41617f27bb513c364b091d7255561138f40db6e3.1479914241.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41617f27bb513c364b091d7255561138f40db6e3.1479914241.git.geliangtang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 23, 2016 at 11:18:53PM +0800, Geliang Tang wrote:
> Drop duplicate header module.h from tpm_tis_spi.c.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Applied.

/Jarkko
    `
> ---
>  drivers/char/tpm/tpm_tis_spi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
> index dbaad9c..5292e57 100644
> --- a/drivers/char/tpm/tpm_tis_spi.c
> +++ b/drivers/char/tpm/tpm_tis_spi.c
> @@ -33,7 +33,6 @@
>  #include <linux/acpi.h>
>  #include <linux/freezer.h>
>  
> -#include <linux/module.h>
>  #include <linux/spi/spi.h>
>  #include <linux/gpio.h>
>  #include <linux/of_irq.h>
> -- 
> 2.9.3
> 
