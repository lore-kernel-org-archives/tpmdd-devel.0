From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Add start method for ARM Secure
	Monitor Call
Date: Sat, 11 Mar 2017 10:39:25 +0200
Message-ID: <20170311083925.ogw5ugwj6qxemp2j@intel.com>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
	<1489139889-14376-3-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489139889-14376-3-git-send-email-anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 10, 2017 at 03:58:08AM -0600, Jiandi An wrote:
> Add a TPM Command Response Buffer start method that invokes
> a secure Monitor Call to request the firmware to execute or
> cancel a TPM 2.0 command for ARM64.
> 
> Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---

These are placed incorrectly. They should be in tpm_crb.c

/Jarkko

>  drivers/char/tpm/tpm.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4937b56..4341594 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -35,6 +35,9 @@
>  #include <linux/cdev.h>
>  #include <linux/highmem.h>
>  #include <crypto/hash_info.h>
> +#ifdef CONFIG_ARM64
> +#include <linux/arm-smccc.h>
> +#endif
>  
>  enum tpm_const {
>  	TPM_MINOR = 224,	/* officially assigned */
> @@ -484,6 +487,32 @@ static inline void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value)
>  	tpm_buf_append(buf, (u8 *) &value2, 4);
>  }
>  
> +#ifdef CONFIG_ARM64
> +/*
> + * This is a TPM Command Response Buffer start method that invokes a
> + * Secure Monitor Call to requrest the firmware to execute or cancel
> + * a TPM 2.0 command.
> + */
> +static inline int tpm_crb_smc_start(unsigned long func_id)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
> +	if (res.a0 != 0) {
> +		WARN(1, "tpm_crb_smc_start() returns res.a0 = 0x%lx\n", res.a0);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static inline int tpm_crb_smc_start(unsigned long func_id)
> +{
> +	WARN(1, "tpm_crb: incorrect start method\n");
> +	return -EINVAL;
> +}
> +#endif
> +
>  extern struct class *tpm_class;
>  extern dev_t tpm_devt;
>  extern const struct file_operations tpm_fops;
> -- 
> Jiandi An
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
