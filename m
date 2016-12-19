From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: Handle 64-bit resource in crb_check_resource()
Date: Mon, 19 Dec 2016 15:56:24 +0200
Message-ID: <20161219135624.2e7okpswnbqbvic7@intel.com>
References: <1482121253-924-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482121253-924-1-git-send-email-anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Dec 18, 2016 at 10:20:53PM -0600, Jiandi An wrote:
> crb_check_resource() in TPM CRB driver calls
> acpi_dev_resource_memory() which only handles 32-bit resources.
> Adding a call to acpi_dev_resource_address_space() in TPM CRB
> driver which handles 64-bit resources.
> 
> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

1. Is there a platform in existence where this change fixes a problem?
2. What is difference between "memory" and "address space" conceptually?
   Just wondering why 32-bit stuff is "memory" and 64-bit stuff is
   "address space". Could there be a one function that would work both
   for 32-bit and 64-bit cases?
   
Yeah, I do not know this API too well. That's why I'm asking.

/Jarkko

> ---
>  drivers/char/tpm/tpm_crb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 717b6b4..86f355b 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -264,10 +264,12 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
>  static int crb_check_resource(struct acpi_resource *ares, void *data)
>  {
>  	struct resource *io_res = data;
> -	struct resource res;
> +	struct resource_win win;
> +	struct resource *res = &(win.res);
>  
> -	if (acpi_dev_resource_memory(ares, &res)) {
> -		*io_res = res;
> +	if (acpi_dev_resource_memory(ares, res) ||
> +	    acpi_dev_resource_address_space(ares, &win)) {
> +		*io_res = *res;
>  		io_res->name = NULL;
>  	}
>  
> -- 
> Jiandi An
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
