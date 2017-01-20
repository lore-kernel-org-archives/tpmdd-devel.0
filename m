From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v7] tpm: Check size of response before
	accessing data
Date: Fri, 20 Jan 2017 15:36:30 +0200
Message-ID: <20170120133630.ld5shdqhquxzd7sn@intel.com>
References: <1484828352-23202-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484828352-23202-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 19, 2017 at 07:19:12AM -0500, Stefan Berger wrote:
> Make sure that we have not received less bytes than what is indicated
> in the header of the TPM response. Also, check the number of bytes in
> the response before accessing its data.
> 
> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> 
> --
> 
> v7:
>  - Followed Jarkko's suggestions on v6
> 
> v6:
>  - Fixed comparsion of size_t with negative number in transmit_cmd
>  - Added new min_rx_length parameter to documentation
>  - Reworked error checking in tpm_transmit_cmd to check for TPM
>    error and return that before validating expected minimum size.
> 
> v5:
>  - Fixed a bug related to tpm_getcap() having to allow to return
>    only a header rather than having to receive a full response
> 
> ---
>  drivers/char/tpm/tpm-interface.c | 69 ++++++++++++++++++++++++++++------------
>  drivers/char/tpm/tpm-sysfs.c     | 28 ++++++++++------
>  drivers/char/tpm/tpm.h           |  7 ++--
>  drivers/char/tpm/tpm2-cmd.c      | 66 ++++++++++++++++++++++++++++----------
>  drivers/char/tpm/tpm_tis_core.c  |  3 +-
>  5 files changed, 123 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index a3461cb..24cc6ec 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -425,6 +425,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>   * @chip: TPM chip to use
>   * @cmd: TPM command buffer
>   * @len: length of the TPM command
> + * @min_rsp_body_length: minimum expected length of response body
>   * @flags: tpm transmit flags - bitmap
>   * @desc: command description used in the error message
>   *
> @@ -434,25 +435,35 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>   *     A positive number for a TPM error.
>   */
>  ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
> -			 int len, unsigned int flags, const char *desc)
> +			 size_t len, size_t min_rsp_body_length,
> +			 unsigned int flags, const char *desc)
>  {
>  	const struct tpm_output_header *header;
>  	int err;
> +	ssize_t length;
>  
> -	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> -	if (len <  0)
> -		return len;
> -	else if (len < TPM_HEADER_SIZE)
> +	length = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> +	if (length <  0)
> +		return length;
> +	else if (length < TPM_HEADER_SIZE)
>  		return -EFAULT;
>  
>  	header = cmd;
> +	if (length < be32_to_cpu(header->length))
> +		return -EFAULT;
>  
>  	err = be32_to_cpu(header->return_code);
>  	if (err != 0 && desc)
>  		dev_err(&chip->dev, "A TPM error (%d) occurred %s\n", err,
>  			desc);
> +	if (err)
> +		return err;
>  
> -	return err;
> +	if (be32_to_cpu(header->length) <
> +	    min_rsp_body_length + TPM_HEADER_SIZE)
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
>  #define TPM_DIGEST_SIZE 20
> @@ -468,7 +479,7 @@ static const struct tpm_input_header tpm_getcap_header = {
>  };
>  
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> -		   const char *desc)
> +		   const char *desc, size_t min_cap_length)
>  {
>  	struct tpm_cmd_t tpm_cmd;
>  	int rc;
> @@ -491,8 +502,8 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
>  	}
> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
> -			      desc);
> +	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +			      min_cap_length, 0, desc);
>  	if (!rc)
>  		*cap = tpm_cmd.params.getcap_out.cap;
>  	return rc;
> @@ -516,7 +527,7 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  
>  	start_cmd.params.startup_in.startup_type = startup_type;
>  	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
> -				"attempting to start the TPM");
> +				0, "attempting to start the TPM");
>  }
>  
>  int tpm_get_timeouts(struct tpm_chip *chip)
> @@ -545,7 +556,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		return 0;
>  	}
>  
> -	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
> +			sizeof(cap.timeout));
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
>  		   Execute a startup command. */
> @@ -554,8 +566,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  			return rc;
>  
>  		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> -				"attempting to determine the timeouts");
> +				"attempting to determine the timeouts",
> +				sizeof(cap.timeout));
>  	}
> +
>  	if (rc) {
>  		dev_err(&chip->dev,
>  			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> @@ -617,7 +631,8 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	chip->timeout_d = usecs_to_jiffies(timeout_eff[3]);
>  
>  	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
> -			"attempting to determine the durations");
> +			"attempting to determine the durations",
> +			sizeof(cap.duration));
>  	if (rc)
>  		return rc;
>  
> @@ -668,13 +683,14 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	struct tpm_cmd_t cmd;
>  
>  	cmd.header.in = continue_selftest_header;
> -	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0, 0,
>  			      "continue selftest");
>  	return rc;
>  }
>  
>  #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
>  #define READ_PCR_RESULT_SIZE 30
> +#define READ_PCR_RESULT_BODY_SIZE 20
>  static const struct tpm_input_header pcrread_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(14),
> @@ -688,7 +704,8 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
> +			      READ_PCR_RESULT_BODY_SIZE, 0,
>  			      "attempting to read a pcr value");
>  
>  	if (rc == 0)
> @@ -751,6 +768,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>  
>  #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>  #define EXTEND_PCR_RESULT_SIZE 34
> +#define EXTEND_PCR_RESULT_BODY_SIZE 24
>  static const struct tpm_input_header pcrextend_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
>  	.length = cpu_to_be32(34),
> @@ -786,7 +804,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  	cmd.header.in = pcrextend_header;
>  	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
>  	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> -	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> +			      EXTEND_PCR_RESULT_BODY_SIZE, 0,
>  			      "attempting extend a PCR value");
>  
>  	tpm_put_ops(chip);
> @@ -890,7 +909,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> -	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, "attempting tpm_cmd");
> +	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, 0, "attempting tpm_cmd");
>  
>  	tpm_put_ops(chip);
>  	return rc;
> @@ -992,7 +1011,8 @@ int tpm_pm_suspend(struct device *dev)
>  		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
>  		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
>  		       TPM_DIGEST_SIZE);
> -		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
> +		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> +				     EXTEND_PCR_RESULT_BODY_SIZE, 0,
>  				      "extending dummy pcr before suspend");
>  	}
>  
> @@ -1000,7 +1020,7 @@ int tpm_pm_suspend(struct device *dev)
>  	for (try = 0; try < TPM_RETRY; try++) {
>  		cmd.header.in = savestate_header;
>  		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
> -				      NULL);
> +				      0, NULL);
>  
>  		/*
>  		 * If the TPM indicates that it is too busy to respond to
> @@ -1062,7 +1082,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  {
>  	struct tpm_chip *chip;
>  	struct tpm_cmd_t tpm_cmd;
> -	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA);
> +	u32 recd, num_bytes = min_t(u32, max, TPM_MAX_RNG_DATA), rlength;
>  	int err, total = 0, retries = 5;
>  	u8 *dest = out;
>  
> @@ -1085,11 +1105,20 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  
>  		err = tpm_transmit_cmd(chip, &tpm_cmd,
>  				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
> +				       offsetof(struct tpm_getrandom_out,
> +						rng_data),
>  				       0, "attempting get random");
>  		if (err)
>  			break;
>  
>  		recd = be32_to_cpu(tpm_cmd.params.getrandom_out.rng_data_len);
> +
> +		rlength = be32_to_cpu(tpm_cmd.header.out.length);
> +		if (rlength < offsetof(struct tpm_getrandom_out, rng_data) +
> +			      recd) {
> +			total = -EFAULT;
> +			break;
> +		}
>  		memcpy(dest, tpm_cmd.params.getrandom_out.rng_data, recd);
>  
>  		dest += recd;
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 848ad65..2f596d7 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -21,6 +21,7 @@
>  #include "tpm.h"
>  
>  #define READ_PUBEK_RESULT_SIZE 314
> +#define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
>  #define TPM_ORD_READPUBEK cpu_to_be32(124)
>  static const struct tpm_input_header tpm_readpubek_header = {
>  	.tag = TPM_TAG_RQU_COMMAND,
> @@ -39,7 +40,8 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
>  	struct tpm_chip *chip = to_tpm_chip(dev);
>  
>  	tpm_cmd.header.in = tpm_readpubek_header;
> -	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
> +	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
> +			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
>  			       "attempting to read the PUBEK");
>  	if (err)
>  		goto out;
> @@ -95,7 +97,8 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
>  	struct tpm_chip *chip = to_tpm_chip(dev);
>  
>  	rc = tpm_getcap(chip, TPM_CAP_PROP_PCR, &cap,
> -			"attempting to determine the number of PCRS");
> +			"attempting to determine the number of PCRS",
> +			sizeof(cap.num_pcrs));
>  	if (rc)
>  		return 0;
>  
> @@ -120,7 +123,8 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
> -			"attempting to determine the permanent enabled state");
> +			"attempting to determine the permanent enabled state",
> +			sizeof(cap.perm_flags));
>  	if (rc)
>  		return 0;
>  
> @@ -136,7 +140,8 @@ static ssize_t active_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_PERM, &cap,
> -			"attempting to determine the permanent active state");
> +			"attempting to determine the permanent active state",
> +			sizeof(cap.perm_flags));
>  	if (rc)
>  		return 0;
>  
> @@ -152,7 +157,8 @@ static ssize_t owned_show(struct device *dev, struct device_attribute *attr,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_PROP_OWNER, &cap,
> -			"attempting to determine the owner state");
> +			"attempting to determine the owner state",
> +			sizeof(cap.owned));
>  	if (rc)
>  		return 0;
>  
> @@ -168,7 +174,8 @@ static ssize_t temp_deactivated_show(struct device *dev,
>  	ssize_t rc;
>  
>  	rc = tpm_getcap(to_tpm_chip(dev), TPM_CAP_FLAG_VOL, &cap,
> -			"attempting to determine the temporary state");
> +			"attempting to determine the temporary state",
> +			sizeof(cap.stclear_flags));
>  	if (rc)
>  		return 0;
>  
> @@ -186,7 +193,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  	char *str = buf;
>  
>  	rc = tpm_getcap(chip, TPM_CAP_PROP_MANUFACTURER, &cap,
> -			"attempting to determine the manufacturer");
> +			"attempting to determine the manufacturer",
> +			sizeof(cap.manufacturer_id));
>  	if (rc)
>  		return 0;
>  	str += sprintf(str, "Manufacturer: 0x%x\n",
> @@ -194,7 +202,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  
>  	/* Try to get a TPM version 1.2 TPM_CAP_VERSION_INFO */
>  	rc = tpm_getcap(chip, TPM_CAP_VERSION_1_2, &cap,
> -			"attempting to determine the 1.2 version");
> +			"attempting to determine the 1.2 version",
> +			sizeof(cap.tpm_version_1_2));
>  	if (!rc) {
>  		str += sprintf(str,
>  			       "TCG version: %d.%d\nFirmware version: %d.%d\n",
> @@ -205,7 +214,8 @@ static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
>  	} else {
>  		/* Otherwise just use TPM_STRUCT_VER */
>  		rc = tpm_getcap(chip, TPM_CAP_VERSION_1_1, &cap,
> -				"attempting to determine the 1.1 version");
> +				"attempting to determine the 1.1 version",
> +				sizeof(cap.tpm_version));
>  		if (rc)
>  			return 0;
>  		str += sprintf(str,
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 1ae9768..7d34048 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -493,10 +493,11 @@ enum tpm_transmit_flags {
>  
>  ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  		     unsigned int flags);
> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, int len,
> -			 unsigned int flags, const char *desc);
> +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd, size_t len,
> +			 size_t min_rsp_body_len, unsigned int flags,
> +			 const char *desc);
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
> -		   const char *desc);
> +		   const char *desc, size_t min_cap_length);
>  int tpm_get_timeouts(struct tpm_chip *);
>  int tpm1_auto_startup(struct tpm_chip *chip);
>  int tpm_do_selftest(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 6eda239..a0199f1 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -248,6 +248,9 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
>  	(sizeof(struct tpm_input_header) + \
>  	 sizeof(struct tpm2_pcr_read_in))
>  
> +#define TPM2_PCR_READ_RESP_BODY_SIZE \
> +	 sizeof(struct tpm2_pcr_read_out)
> +
>  static const struct tpm_input_header tpm2_pcrread_header = {
>  	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
>  	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> @@ -280,8 +283,9 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  	       sizeof(cmd.params.pcrread_in.pcr_select));
>  	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
> -			      "attempting to read a pcr value");
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +			      TPM2_PCR_READ_RESP_BODY_SIZE,
> +			      0, "attempting to read a pcr value");
>  	if (rc == 0) {
>  		buf = cmd.params.pcrread_out.digest;
>  		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
> @@ -327,7 +331,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
>  	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
>  	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
>  			      "attempting extend a PCR value");
>  
>  	return rc;
> @@ -356,7 +360,7 @@ static const struct tpm_input_header tpm2_getrandom_header = {
>  int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
>  {
>  	struct tpm2_cmd cmd;
> -	u32 recd;
> +	u32 recd, rlength;
>  	u32 num_bytes;
>  	int err;
>  	int total = 0;
> @@ -373,13 +377,19 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
>  		cmd.header.in = tpm2_getrandom_header;
>  		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
>  
> -		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
> -				       "attempting get random");
> +		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +				       offsetof(struct tpm2_get_random_out,
> +						buffer),
> +				       0, "attempting get random");
>  		if (err)
>  			break;
>  
>  		recd = min_t(u32, be16_to_cpu(cmd.params.getrandom_out.size),
>  			     num_bytes);
> +		rlength = be32_to_cpu(cmd.header.out.length);
> +		if (rlength < offsetof(struct tpm2_get_random_out, buffer) +
> +			      recd)
> +			return -EFAULT;
>  		memcpy(dest, cmd.params.getrandom_out.buffer, recd);
>  
>  		dest += recd;
> @@ -394,6 +404,9 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
>  	(sizeof(struct tpm_input_header) + \
>  	 sizeof(struct tpm2_get_tpm_pt_in))
>  
> +#define TPM2_GET_TPM_PT_OUT_BODY_SIZE \
> +	 sizeof(struct tpm2_get_tpm_pt_out)
> +
>  static const struct tpm_input_header tpm2_get_tpm_pt_header = {
>  	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
>  	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
> @@ -445,7 +458,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  {
>  	unsigned int blob_len;
>  	struct tpm_buf buf;
> -	u32 hash;
> +	u32 hash, rlength;
>  	int i;
>  	int rc;
>  
> @@ -510,7 +523,8 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, "sealing data");
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, 0,
> +			      "sealing data");
>  	if (rc)
>  		goto out;
>  
> @@ -519,6 +533,11 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  		rc = -E2BIG;
>  		goto out;
>  	}
> +	rlength = be32_to_cpu(((struct tpm2_cmd *)&buf)->header.out.length);
> +	if (rlength < TPM_HEADER_SIZE + 4 + blob_len) {
> +		rc = -EFAULT;
> +		goto out;
> +	}
>  
>  	memcpy(payload->blob, &buf.data[TPM_HEADER_SIZE + 4], blob_len);
>  	payload->blob_len = blob_len;
> @@ -588,7 +607,8 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "loading blob");
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, flags,
> +			      "loading blob");
>  	if (!rc)
>  		*blob_handle = be32_to_cpup(
>  			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
> @@ -626,7 +646,7 @@ static void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
>  
>  	tpm_buf_append_u32(&buf, handle);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags,
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, flags,
>  			      "flushing context");
>  	if (rc)
>  		dev_warn(&chip->dev, "0x%08x was not flushed, rc=%d\n", handle,
> @@ -657,6 +677,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  	u16 data_len;
>  	u8 *data;
>  	int rc;
> +	u32 rlength;
>  
>  	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
>  	if (rc)
> @@ -671,13 +692,21 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  			     options->blobauth /* hmac */,
>  			     TPM_DIGEST_SIZE);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, flags, "unsealing");
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 6, flags,
> +			      "unsealing");
>  	if (rc > 0)
>  		rc = -EPERM;
>  
>  	if (!rc) {
>  		data_len = be16_to_cpup(
>  			(__be16 *) &buf.data[TPM_HEADER_SIZE + 4]);
> +
> +		rlength = be32_to_cpu(((struct tpm2_cmd *)&buf)
> +					->header.out.length);
> +		if (rlength < TPM_HEADER_SIZE + 6 + data_len) {
> +			rc = -EFAULT;
> +			goto out;
> +		}
>  		data = &buf.data[TPM_HEADER_SIZE + 6];
>  
>  		memcpy(payload->key, data, data_len - 1);
> @@ -685,6 +714,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  		payload->migratable = data[data_len - 1];
>  	}
>  
> +out:
>  	tpm_buf_destroy(&buf);
>  	return rc;
>  }
> @@ -739,7 +769,8 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
>  	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, desc);
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +			      TPM2_GET_TPM_PT_OUT_BODY_SIZE, 0, desc);
>  	if (!rc)
>  		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
>  
> @@ -773,7 +804,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
>  	cmd.header.in = tpm2_startup_header;
>  
>  	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
> -	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0,
> +	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
>  				"attempting to start the TPM");
>  }
>  
> @@ -802,7 +833,8 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
>  	cmd.header.in = tpm2_shutdown_header;
>  	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, "stopping the TPM");
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
> +			      "stopping the TPM");
>  
>  	/* In places where shutdown command is sent there's no much we can do
>  	 * except print the error code on a system failure.
> @@ -865,7 +897,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
>  	cmd.header.in = tpm2_selftest_header;
>  	cmd.params.selftest_in.full_test = full;
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
>  			      "continue selftest");
>  
>  	/* At least some prototype chips seem to give RC_TESTING error
> @@ -916,7 +948,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  		cmd.params.pcrread_in.pcr_select[1] = 0x00;
>  		cmd.params.pcrread_in.pcr_select[2] = 0x00;
>  
> -		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, NULL);
> +		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
>  		if (rc < 0)
>  			break;
>  
> @@ -949,7 +981,7 @@ int tpm2_probe(struct tpm_chip *chip)
>  	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
>  	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),  0, NULL);
> +	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
>  	if (rc <  0)
>  		return rc;
>  
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index 0cfc0ee..45f8840 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -552,7 +552,8 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
>  	else
> -		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
> +		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
> +				  0);
>  }
>  
>  /* Register the IRQ and issue a command that will cause an interrupt. If an
> -- 
> 2.4.3
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
