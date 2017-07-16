From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: tpm_crb: constify acpi_device_id.
Date: Sun, 16 Jul 2017 14:24:40 +0300
Message-ID: <1500204280.8397.4.camel@linux.intel.com>
References: <8a670ac215126b76d72861319a0d45e17759ad66.1499363107.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <8a670ac215126b76d72861319a0d45e17759ad66.1499363107.git.arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-07-06 at 23:18 +0530, Arvind Yadav wrote:
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
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

Applied.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
