From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: tpm_crb: constify acpi_device_id.
Date: Sun, 9 Jul 2017 10:05:15 +0300
Message-ID: <20170709070515.7dxpf42gqbx3r43q@linux.intel.com>
References: <8a670ac215126b76d72861319a0d45e17759ad66.1499363107.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8a670ac215126b76d72861319a0d45e17759ad66.1499363107.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 06, 2017 at 11:18:39PM +0530, Arvind Yadav wrote:
> acpi_device_id are not supposed to change at runtime. All functions
> working with acpi_device_id provided by <acpi/acpi_bus.h> work with
> const acpi_device_id. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>    4198	    608	      0	   4806	   12c6	drivers/char/tpm/tpm_crb.o
> 
> File size After adding 'const':
>    text	   data	    bss	    dec	    hex	filename
>    4262	    520	      0	   4782	   12ae	drivers/char/tpm/tpm_crb.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thanks!

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index b917b9d..bf7189e 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -665,7 +665,7 @@ static const struct dev_pm_ops crb_pm = {
>  	SET_RUNTIME_PM_OPS(crb_pm_runtime_suspend, crb_pm_runtime_resume, NULL)
>  };
>  
> -static struct acpi_device_id crb_device_ids[] = {
> +static const struct acpi_device_id crb_device_ids[] = {
>  	{"MSFT0101", 0},
>  	{"", 0},
>  };
> -- 
> 2.7.4
> 
