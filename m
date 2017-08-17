From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: vtpm: constify vio_device_id
Date: Thu, 17 Aug 2017 13:16:42 -0600
Message-ID: <20170817191642.GF24735@obsidianresearch.com>
References: <a9ebcd668f5a7293c3805d0b6b21245f15c80212.1502989694.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a9ebcd668f5a7293c3805d0b6b21245f15c80212.1502989694.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: ashleydlai@gmail.com, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Aug 17, 2017 at 11:04:21PM +0530, Arvind Yadav wrote:
> vio_device_id are not supposed to change at runtime. All functions
> working with vio_device_id provided by <asm/vio.h> work with
> const vio_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

>  drivers/char/tpm/tpm_ibmvtpm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
> index f01d083..d2ce46b 100644
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -32,7 +32,7 @@
>  
>  static const char tpm_ibmvtpm_driver_name[] = "tpm_ibmvtpm";
>  
> -static struct vio_device_id tpm_ibmvtpm_device_table[] = {
> +static const struct vio_device_id tpm_ibmvtpm_device_table[] = {
>  	{ "IBM,vtpm", "IBM,vtpm"},
>  	{ "", "" }
>  };
