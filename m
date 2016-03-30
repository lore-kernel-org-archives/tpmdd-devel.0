From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: move tpm_pcr_read_dev() to tpm1-cmd.c
Date: Wed, 30 Mar 2016 16:22:17 +0300
Message-ID: <20160330132217.GA21682@intel.com>
References: <1459287050-3809-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459287050-3809-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 30, 2016 at 12:30:49AM +0300, Jarkko Sakkinen wrote:
> Created tpm1-cmd.c for TPM1 commands like we have one for TPM2 commands
> and moved tpm_pcr_read_dev() there and renamed it as tpm1_pcr_read().
> 
> Created a common enum tpm1_ordinals that is accesible both from
> tpm1-cmd.c and tpm-interface.c because TPM1_ORD_PCRREAD is used by two
> functions and it is nice to have a list of ordinals available that the
> TPM driver is using at the moment.

You can risdegard this now. I think it is better to clean up ugly bits
first where TPM commands are constructed ad hoc and change them to use
proper functions.

I'll update this patch later on.

/Jarkko

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/Makefile        |  2 +-
>  drivers/char/tpm/tpm-interface.c | 53 ++++++++++------------------------------
>  drivers/char/tpm/tpm-sysfs.c     |  2 +-
>  drivers/char/tpm/tpm.h           | 17 ++++++++++++-
>  drivers/char/tpm/tpm1-cmd.c      | 46 ++++++++++++++++++++++++++++++++++
>  5 files changed, 77 insertions(+), 43 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm1-cmd.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 56e8f1f..2547bb3 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the kernel tpm device drivers.
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
> -tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
> +tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm1-cmd.o tpm2-cmd.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o
>  
>  ifdef CONFIG_ACPI
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 5397b64..f2b2086 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -423,13 +423,11 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
>  }
>  
>  #define TPM_INTERNAL_RESULT_SIZE 200
> -#define TPM_ORD_GET_CAP cpu_to_be32(101)
> -#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
>  
>  static const struct tpm_input_header tpm_getcap_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(22),
> -	.ordinal = TPM_ORD_GET_CAP
> +	.ordinal = TPM1_ORD_GET_CAP
>  };
>  
>  ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
> @@ -475,14 +473,13 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
>  }
>  EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
>  
> -#define TPM_ORD_STARTUP cpu_to_be32(153)
>  #define TPM_ST_CLEAR cpu_to_be16(1)
>  #define TPM_ST_STATE cpu_to_be16(2)
>  #define TPM_ST_DEACTIVATED cpu_to_be16(3)
>  static const struct tpm_input_header tpm_startup_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(12),
> -	.ordinal = TPM_ORD_STARTUP
> +	.ordinal = TPM1_ORD_STARTUP
>  };
>  
>  static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
> @@ -631,13 +628,12 @@ duration:
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_timeouts);
>  
> -#define TPM_ORD_CONTINUE_SELFTEST 83
>  #define CONTINUE_SELFTEST_RESULT_SIZE 10
>  
>  static struct tpm_input_header continue_selftest_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(10),
> -	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
> +	.ordinal = TPM1_ORD_CONTINUE_SELFTEST
>  };
>  
>  /**
> @@ -658,30 +654,6 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	return rc;
>  }
>  
> -#define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
> -#define READ_PCR_RESULT_SIZE 30
> -static struct tpm_input_header pcrread_header = {
> -	.tag = TPM_TAG_RQU_COMMAND,
> -	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORDINAL_PCRREAD
> -};
> -
> -int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> -{
> -	int rc;
> -	struct tpm_cmd_t cmd;
> -
> -	cmd.header.in = pcrread_header;
> -	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
> -			      "attempting to read a pcr value");
> -
> -	if (rc == 0)
> -		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
> -		       TPM_DIGEST_SIZE);
> -	return rc;
> -}
> -
>  /**
>   * tpm_is_tpm2 - is the chip a TPM2 chip?
>   * @chip_num:	tpm idx # or ANY
> @@ -728,7 +700,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
>  	else
> -		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
> +		rc = tpm1_pcr_read(chip, pcr_idx, res_buf);
>  	tpm_put_ops(chip);
>  	return rc;
>  }
> @@ -744,12 +716,11 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>   * isn't, protect against the chip disappearing, by incrementing
>   * the module usage count.
>   */
> -#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>  #define EXTEND_PCR_RESULT_SIZE 34
>  static struct tpm_input_header pcrextend_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(34),
> -	.ordinal = TPM_ORD_PCR_EXTEND
> +	.ordinal = TPM1_ORD_PCR_EXTEND
>  };
>  
>  int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
> @@ -795,7 +766,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  	unsigned long duration;
>  	struct tpm_cmd_t cmd;
>  
> -	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
> +	duration = tpm_calc_ordinal_duration(chip, TPM1_ORD_CONTINUE_SELFTEST);
>  
>  	loops = jiffies_to_msecs(duration) / delay_msec;
>  
> @@ -808,9 +779,12 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  
>  	do {
>  		/* Attempt to read a PCR value */
> -		cmd.header.in = pcrread_header;
> +		cmd.header.in.tag = TPM_TAG_RQU_COMMAND;
> +		cmd.header.in.length = sizeof(struct tpm_input_header) +
> +				       sizeof(struct tpm_pcrread_in);
> +		cmd.header.in.ordinal = TPM1_ORD_PCRREAD;
>  		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
> -		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
> +		rc = tpm_transmit(chip, (u8 *) &cmd, sizeof(cmd));
>  		/* Some buggy TPMs will not respond to tpm_tis_ready() for
>  		 * around 300ms while the self test is ongoing, keep trying
>  		 * until the self test duration expires. */
> @@ -920,13 +894,12 @@ again:
>  }
>  EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>  
> -#define TPM_ORD_SAVESTATE cpu_to_be32(152)
>  #define SAVESTATE_RESULT_SIZE 10
>  
>  static struct tpm_input_header savestate_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(10),
> -	.ordinal = TPM_ORD_SAVESTATE
> +	.ordinal = TPM1_ORD_SAVESTATE
>  };
>  
>  /*
> @@ -1009,7 +982,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  static struct tpm_input_header tpm_getrandom_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(14),
> -	.ordinal = TPM_ORD_GET_RANDOM
> +	.ordinal = TPM1_ORD_GET_RANDOM
>  };
>  
>  /**
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 34e7fc7..48e30bd 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -101,7 +101,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
>  
>  	num_pcrs = be32_to_cpu(cap.num_pcrs);
>  	for (i = 0; i < num_pcrs; i++) {
> -		rc = tpm_pcr_read_dev(chip, i, digest);
> +		rc = tpm1_pcr_read(chip, i, digest);
>  		if (rc)
>  			break;
>  		str += sprintf(str, "PCR-%02d: ", i);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index cd780c7..c991c91 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -65,6 +65,16 @@ enum tpm_duration {
>  
>  #define TPM_HEADER_SIZE		10
>  
> +enum tpm1_ordinals {
> +	TPM1_ORD_PCR_EXTEND		= cpu_to_be32(20),
> +	TPM1_ORD_PCRREAD		= cpu_to_be32(21),
> +	TPM1_ORD_GET_RANDOM		= cpu_to_be32(70),
> +	TPM1_ORD_CONTINUE_SELFTEST	= cpu_to_be32(83),
> +	TPM1_ORD_GET_CAP		= cpu_to_be32(101),
> +	TPM1_ORD_SAVESTATE		= cpu_to_be32(152),
> +	TPM1_ORD_STARTUP		= cpu_to_be32(153),
> +};
> +
>  enum tpm2_const {
>  	TPM2_PLATFORM_PCR	= 24,
>  	TPM2_PCR_SELECT_MIN	= ((TPM2_PLATFORM_PCR + 7) / 8),
> @@ -511,7 +521,6 @@ extern void tpm_chip_unregister(struct tpm_chip *chip);
>  int tpm_sysfs_add_device(struct tpm_chip *chip);
>  void tpm_sysfs_del_device(struct tpm_chip *chip);
>  
> -int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
>  
>  #ifdef CONFIG_ACPI
>  extern void tpm_add_ppi(struct tpm_chip *chip);
> @@ -521,6 +530,12 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
>  }
>  #endif
>  
> +/* TPM1 commands */
> +
> +int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
> +
> +/* TPM2 commands */
> +
>  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
>  int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
>  int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
> diff --git a/drivers/char/tpm/tpm1-cmd.c b/drivers/char/tpm/tpm1-cmd.c
> new file mode 100644
> index 0000000..a4ac84f
> --- /dev/null
> +++ b/drivers/char/tpm/tpm1-cmd.c
> @@ -0,0 +1,46 @@
> +/*
> + * Copyright (C) 2004 IBM Corporation
> + * Copyright (C) 2014, 2016 Intel Corporation
> + *
> + * Authors:
> + * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> + * Dave Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> + * Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> + * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> + *
> + * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> + *
> + * Device driver for TCG/TCPA TPM (trusted platform module).
> + * Specifications at www.trustedcomputinggroup.org
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * Note, the TPM chip is not interrupt driven (only polling)
> + * and can have very long timeouts (minutes!). Hence the unusual
> + * calls to msleep.
> + *
> + */
> +
> +#include "tpm.h"
> +
> +int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> +{
> +	int rc;
> +	struct tpm_cmd_t cmd;
> +
> +	cmd.header.in.tag = TPM_TAG_RQU_COMMAND;
> +	cmd.header.in.length = sizeof(struct tpm_input_header) +
> +			       sizeof(struct tpm_pcrread_in);
> +	cmd.header.in.ordinal = TPM1_ORD_PCRREAD;
> +	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +			      "attempting to read a pcr value");
> +
> +	if (rc == 0)
> +		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
> +		       TPM_DIGEST_SIZE);
> +	return rc;
> +}
> -- 
> 2.7.3
> 

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
