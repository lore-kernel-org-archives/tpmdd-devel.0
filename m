From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: define constants for tpm2
	properties
Date: Mon, 18 Jul 2016 21:58:53 +0300
Message-ID: <20160718185853.GK31463@intel.com>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
	<1468544838-9990-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468544838-9990-2-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 06:07:17PM -0700, Andrey Pronin wrote:
> Change-Id: I47cb1793736781fbea93e5bf80b783e0ac9e8628
> Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

I'm not going to apply this. The patch has no value. We only want to
have a subset of constants that are *used* by the kernel.

/Jarkko

> ---
>  drivers/char/tpm/tpm.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8890df2..ad3b9d1 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -127,6 +127,32 @@ enum tpm2_capabilities {
>  	TPM2_CAP_TPM_PROPERTIES = 6,
>  };
>  
> +enum tpm2_properties {
> +	TPM2_PT_NONE			= 0,
> +	TPM2_PT_GROUP			= 0x100,
> +	TPM2_PT_FIXED			= TPM2_PT_GROUP,
> +	TPM2_PT_VAR			= TPM2_PT_GROUP * 2,
> +	TPM2_PT_PERMANENT		= TPM2_PT_VAR + 0,
> +	TPM2_PT_STARTUP_CLEAR		= TPM2_PT_VAR + 1,
> +};
> +
> +enum tpm2_attr_permanent {
> +	TPM2_ATTR_OWNER_AUTH_SET	= BIT(0),
> +	TPM2_ATTR_ENDORSEMENT_AUTH_SET	= BIT(1),
> +	TPM2_ATTR_LOCKOUT_AUTH_SET	= BIT(2),
> +	TPM2_ATTR_DISABLE_CLEAR		= BIT(8),
> +	TPM2_ATTR_IN_LOCKOUT		= BIT(9),
> +	TPM2_ATTR_TPM_GENERATED_EPS	= BIT(10),
> +};
> +
> +enum tpm2_attr_startup_clear {
> +	TPM2_ATTR_PH_ENABLE		= BIT(0),
> +	TPM2_ATTR_SH_ENABLE		= BIT(1),
> +	TPM2_ATTR_EH_ENABLE		= BIT(2),
> +	TPM2_ATTR_PH_ENABLE_NV		= BIT(3),
> +	TPM2_ATTR_ORDERLY = BIT(31),
> +};
> +
>  enum tpm2_startup_types {
>  	TPM2_SU_CLEAR	= 0x0000,
>  	TPM2_SU_STATE	= 0x0001,
> -- 
> 2.6.6
> 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
