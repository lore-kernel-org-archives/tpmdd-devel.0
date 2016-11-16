From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [patch] tpm: uninitialized variable in read_log_of()
Date: Wed, 16 Nov 2016 07:36:31 -0800
Message-ID: <20161116153631.vgsoz4o2pwlphfmo@intel.com>
References: <20161116141221.GA28875@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161116141221.GA28875@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Nayna Jain <nayna@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 16, 2016 at 05:12:21PM +0300, Dan Carpenter wrote:
> "np" is supposed to be set to NULL at the start.
> 
> Fixes: 4a45d9669ac1 ("tpm: replace of_find_node_by_name() with dev of_node propert")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Colid King submitted a patch to fix this a couple of days ago so
applied that. Anyway, thank you for noting this.

> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 3af829f..904ed4a 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -23,7 +23,7 @@
>  
>  int read_log_of(struct tpm_chip *chip)
>  {
> -	struct device_node *np;
> +	struct device_node *np = NULL;
>  	const u32 *sizep;
>  	const u64 *basep;
>  	struct tpm_bios_log *log;

/Jarkko
