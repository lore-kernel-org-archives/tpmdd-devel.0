From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: remove redundant code from self-test functions
Date: Wed, 30 Mar 2016 16:25:41 +0300
Message-ID: <20160330132541.GA22512@intel.com>
References: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459344045-21602-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 30, 2016 at 04:20:45PM +0300, Jarkko Sakkinen wrote:
> Self-test functions construct PCR read calls by ad hoc, which is only a
> waste space. Use instead tpm_pcr_read_dev (renamed as tpm1_pcr_read() by
> this commit) in tpm_do_selftest and tpm2_pcr_read() in
> tpm2_do_selftest() functions in order to remove the duplicate code.
> 
> Patch can be tested easily tested by running the a kernel with this
> patch compiled in since self-test is done when the a device driver
> initializes.

This is now fixed version (I forgot to squash one fixup to the previous
version). This could use peer test preferably with a FIFO device. It is
easy as one only needs to load the driver and see that there are no
errors in dmesg from self-additions. As an additional measure on a TPM
1.x device outputting 'pcrs' file could be a good idea.

/Jarkko

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/tpm-interface.c | 14 +++++---------
>  drivers/char/tpm/tpm-sysfs.c     |  2 +-
>  drivers/char/tpm/tpm.h           |  2 +-
>  drivers/char/tpm/tpm2-cmd.c      | 14 ++------------
>  4 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 5397b64..0c8140f 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -1,6 +1,6 @@
>  /*
>   * Copyright (C) 2004 IBM Corporation
> - * Copyright (C) 2014 Intel Corporation
> + * Copyright (C) 2014, 2016 Intel Corporation
>   *
>   * Authors:
>   * Leendert van Doorn <leendert@watson.ibm.com>
> @@ -666,7 +666,7 @@ static struct tpm_input_header pcrread_header = {
>  	.ordinal = TPM_ORDINAL_PCRREAD
>  };
>  
> -int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> +int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  {
>  	int rc;
>  	struct tpm_cmd_t cmd;
> @@ -676,7 +676,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
>  			      "attempting to read a pcr value");
>  
> -	if (rc == 0)
> +	if (rc == 0 && res_buf)
>  		memcpy(res_buf, cmd.params.pcrread_out.pcr_result,
>  		       TPM_DIGEST_SIZE);
>  	return rc;
> @@ -728,7 +728,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
>  	else
> -		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
> +		rc = tpm1_pcr_read(chip, pcr_idx, res_buf);
>  	tpm_put_ops(chip);
>  	return rc;
>  }
> @@ -793,7 +793,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  	unsigned int loops;
>  	unsigned int delay_msec = 100;
>  	unsigned long duration;
> -	struct tpm_cmd_t cmd;
>  
>  	duration = tpm_calc_ordinal_duration(chip, TPM_ORD_CONTINUE_SELFTEST);
>  
> @@ -808,9 +807,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  
>  	do {
>  		/* Attempt to read a PCR value */
> -		cmd.header.in = pcrread_header;
> -		cmd.params.pcrread_in.pcr_idx = cpu_to_be32(0);
> -		rc = tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE);
> +		rc = tpm1_pcr_read(chip, 0, NULL);
>  		/* Some buggy TPMs will not respond to tpm_tis_ready() for
>  		 * around 300ms while the self test is ongoing, keep trying
>  		 * until the self test duration expires. */
> @@ -825,7 +822,6 @@ int tpm_do_selftest(struct tpm_chip *chip)
>  		if (rc < TPM_HEADER_SIZE)
>  			return -EFAULT;
>  
> -		rc = be32_to_cpu(cmd.header.out.return_code);
>  		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
>  			dev_info(&chip->dev,
>  				 "TPM is disabled/deactivated (0x%X)\n", rc);
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
> index cd780c7..89740db 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -511,7 +511,7 @@ extern void tpm_chip_unregister(struct tpm_chip *chip);
>  int tpm_sysfs_add_device(struct tpm_chip *chip);
>  void tpm_sysfs_del_device(struct tpm_chip *chip);
>  
> -int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
> +int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
>  
>  #ifdef CONFIG_ACPI
>  extern void tpm_add_ppi(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 5fc0e7c..afe8d47 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -284,7 +284,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
>  			      "attempting to read a pcr value");
> -	if (rc == 0) {
> +	if (rc == 0 && res_buf) {
>  		buf = cmd.params.pcrread_out.digest;
>  		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
>  	}
> @@ -861,7 +861,6 @@ int tpm2_do_selftest(struct tpm_chip *chip)
>  	unsigned int loops;
>  	unsigned int delay_msec = 100;
>  	unsigned long duration;
> -	struct tpm2_cmd cmd;
>  	int i;
>  
>  	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
> @@ -874,19 +873,10 @@ int tpm2_do_selftest(struct tpm_chip *chip)
>  
>  	for (i = 0; i < loops; i++) {
>  		/* Attempt to read a PCR value */
> -		cmd.header.in = tpm2_pcrread_header;
> -		cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
> -		cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
> -		cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
> -		cmd.params.pcrread_in.pcr_select[0] = 0x01;
> -		cmd.params.pcrread_in.pcr_select[1] = 0x00;
> -		cmd.params.pcrread_in.pcr_select[2] = 0x00;
> -
> -		rc = tpm_transmit_cmd(chip, (u8 *) &cmd, sizeof(cmd), NULL);
> +		rc = tpm2_pcr_read(chip, 0, NULL);
>  		if (rc < 0)
>  			break;
>  
> -		rc = be32_to_cpu(cmd.header.out.return_code);
>  		if (rc != TPM2_RC_TESTING)
>  			break;
>  
> -- 
> 1.9.1
> 
