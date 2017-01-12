From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v2 3/5] tpm: infrastructure for TPM
	spaces
Date: Thu, 12 Jan 2017 22:50:51 +0200
Message-ID: <20170112205051.yjrjmpiqjhn5hiw6@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170112174612.9314-4-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 07:46:06PM +0200, Jarkko Sakkinen wrote:
> Added ability to tpm_transmit() to supply a TPM space that contains
> mapping from virtual handles to physical handles and backing storage for
> swapping transient objects. TPM space is isolated from other users of
> the TPM.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/Makefile        |   2 +-
>  drivers/char/tpm/tpm-chip.c      |   7 +
>  drivers/char/tpm/tpm-dev.c       |   2 +-
>  drivers/char/tpm/tpm-interface.c |  61 ++++----
>  drivers/char/tpm/tpm-sysfs.c     |   2 +-
>  drivers/char/tpm/tpm.h           |  22 ++-
>  drivers/char/tpm/tpm2-cmd.c      |  34 +++--
>  drivers/char/tpm/tpm2-space.c    | 298 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 382 insertions(+), 46 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2-space.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index a05b1eb..251d0ed 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
>  tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
> -		tpm_eventlog.o
> +	 tpm_eventlog.o tpm2-space.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>  tpm-$(CONFIG_OF) += tpm_of.o
>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index c406343..993b9ae 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -128,6 +128,7 @@ static void tpm_dev_release(struct device *dev)
>  	mutex_unlock(&idr_lock);
>  
>  	kfree(chip->log.bios_event_log);
> +	kfree(chip->work_space.context_buf);
>  	kfree(chip);
>  }
>  
> @@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->cdev.owner = THIS_MODULE;
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
>  
> +	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!chip->work_space.context_buf) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
>  	return chip;
>  
>  out:
> diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
> index 912ad30..249eeb0 100644
> --- a/drivers/char/tpm/tpm-dev.c
> +++ b/drivers/char/tpm/tpm-dev.c
> @@ -144,7 +144,7 @@ static ssize_t tpm_write(struct file *file, const char __user *buf,
>  		mutex_unlock(&priv->buffer_mutex);
>  		return -EPIPE;
>  	}
> -	out_size = tpm_transmit(priv->chip, priv->data_buffer,
> +	out_size = tpm_transmit(priv->chip, NULL, priv->data_buffer,
>  				sizeof(priv->data_buffer), 0);
>  
>  	tpm_put_ops(priv->chip);
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 0c5aba1..65fcd04c 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -370,10 +370,11 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
>   *     0 when the operation is successful.
>   *     A negative number for system errors (errno).
>   */
> -ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
> -		     unsigned int flags)
> +ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> +		     u8 *buf, size_t bufsiz, unsigned int flags)
>  {
> -	ssize_t rc;
> +	int rc;
> +	ssize_t len = 0;
>  	u32 count, ordinal;
>  	unsigned long stop;
>  
> @@ -399,10 +400,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  	if (chip->dev.parent)
>  		pm_runtime_get_sync(chip->dev.parent);
>  
> +	rc = tpm2_prepare_space(chip, space, ordinal, buf, bufsiz);
> +	if (rc)
> +		goto out;
> +
>  	rc = chip->ops->send(chip, (u8 *) buf, count);
>  	if (rc < 0) {
>  		dev_err(&chip->dev,
> -			"tpm_transmit: tpm_send: error %zd\n", rc);
> +			"tpm_transmit: tpm_send: error %d\n", rc);
>  		goto out;
>  	}
>  
> @@ -435,17 +440,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  	goto out;
>  
>  out_recv:
> -	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
> -	if (rc < 0)
> +	len = chip->ops->recv(chip, (u8 *) buf, bufsiz);
> +	if (len < 0) {
>  		dev_err(&chip->dev,
> -			"tpm_transmit: tpm_recv: error %zd\n", rc);
> +			"tpm_transmit: tpm_recv: error %d\n", rc);
> +		rc = len;
> +		goto out;
> +	}
> +
> +	rc = tpm2_commit_space(chip, space, ordinal, buf, bufsiz);
> +
>  out:
>  	if (chip->dev.parent)
>  		pm_runtime_put_sync(chip->dev.parent);
>  
>  	if (!(flags & TPM_TRANSMIT_UNLOCKED))
>  		mutex_unlock(&chip->tpm_mutex);
> -	return rc;
> +	return rc ? rc : len;
>  }
>  
>  /**
> @@ -463,13 +474,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>   *     A negative number for system errors (errno).
>   *     A positive number for a TPM error.
>   */
> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
> -			 int len, unsigned int flags, const char *desc)
> +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> +			 void *cmd, int len, unsigned int flags,
> +			 const char *desc)
>  {
>  	const struct tpm_output_header *header;
>  	int err;
>  
> -	len = tpm_transmit(chip, (const u8 *)cmd, len, flags);
> +	len = tpm_transmit(chip, space, cmd, len, flags);
>  	if (len <  0)
>  		return len;
>  	else if (len < TPM_HEADER_SIZE)
> @@ -521,7 +533,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
>  	}
> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
>  			      desc);
>  	if (!rc)
>  		*cap = tpm_cmd.params.getcap_out.cap;
> @@ -545,8 +557,9 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  	start_cmd.header.in = tpm_startup_header;
>  
>  	start_cmd.params.startup_in.startup_type = startup_type;
> -	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
> -				"attempting to start the TPM");
> +	return tpm_transmit_cmd(chip, NULL, &start_cmd,
> +				TPM_INTERNAL_RESULT_SIZE,
> +				0, "attempting to start the TPM");
>  }
>  
>  int tpm_get_timeouts(struct tpm_chip *chip)
> @@ -687,8 +700,8 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	struct tpm_cmd_t cmd;
>  
>  	cmd.header.in = continue_selftest_header;
> -	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0,
> -			      "continue selftest");
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
> +			      0, "continue selftest");
>  	return rc;
>  }
>  
> @@ -707,7 +720,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, READ_PCR_RESULT_SIZE, 0,
>  			      "attempting to read a pcr value");
>  
>  	if (rc == 0)
> @@ -805,7 +818,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  	cmd.header.in = pcrextend_header;
>  	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
>  	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> -	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
>  			      "attempting extend a PCR value");
>  
>  	tpm_put_ops(chip);
> @@ -909,7 +922,7 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> -	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, "attempting tpm_cmd");
> +	rc = tpm_transmit_cmd(chip, NULL, cmd, buflen, 0, "attempting tpm_cmd");
>  
>  	tpm_put_ops(chip);
>  	return rc;
> @@ -1011,15 +1024,15 @@ int tpm_pm_suspend(struct device *dev)
>  		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
>  		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
>  		       TPM_DIGEST_SIZE);
> -		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE, 0,
> -				      "extending dummy pcr before suspend");
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
> +				      0, "extending dummy pcr before suspend");
>  	}
>  
>  	/* now do the actual savestate */
>  	for (try = 0; try < TPM_RETRY; try++) {
>  		cmd.header.in = savestate_header;
> -		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
> -				      NULL);
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, SAVESTATE_RESULT_SIZE,
> +				      0, NULL);
>  
>  		/*
>  		 * If the TPM indicates that it is too busy to respond to
> @@ -1102,7 +1115,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  		tpm_cmd.header.in = tpm_getrandom_header;
>  		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
>  
> -		err = tpm_transmit_cmd(chip, &tpm_cmd,
> +		err = tpm_transmit_cmd(chip, NULL, &tpm_cmd,
>  				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
>  				       0, "attempting get random");
>  		if (err)
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 848ad65..dd31a00 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -39,7 +39,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
>  	struct tpm_chip *chip = to_tpm_chip(dev);
>  
>  	tpm_cmd.header.in = tpm_readpubek_header;
> -	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
> +	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE, 0,
>  			       "attempting to read the PUBEK");
>  	if (err)
>  		goto out;
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index c87c221..0e93b93 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -91,6 +91,7 @@ enum tpm2_structures {
>  
>  enum tpm2_return_codes {
>  	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
> +	TPM2_RC_HANDLE		= 0x008B,
>  	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
>  	TPM2_RC_DISABLED	= 0x0120,
>  	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
> @@ -114,6 +115,8 @@ enum tpm2_command_codes {
>  	TPM2_CC_CREATE		= 0x0153,
>  	TPM2_CC_LOAD		= 0x0157,
>  	TPM2_CC_UNSEAL		= 0x015E,
> +	TPM2_CC_CONTEXT_LOAD	= 0x0161,
> +	TPM2_CC_CONTEXT_SAVE	= 0x0162,
>  	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
>  	TPM2_CC_GET_CAPABILITY	= 0x017A,
>  	TPM2_CC_GET_RANDOM	= 0x017B,
> @@ -151,6 +154,11 @@ enum tpm2_cc_attrs {
>  
>  #define TPM_PPI_VERSION_LEN		3
>  
> +struct tpm_space {
> +	u32 context_tbl[14];
> +	u8 *context_buf;
> +};

I'll add a cc whitelist here in the next version. I also
decrease the size of the context_tbl to three.

It could be something like

DECLARE_BITMAP(cc_map, TPM2_CC_LAST - TPM2_CC_FIRST + 1);

Or

u32 *cc_tbl;
unsigned int cc_tbl_cnt;

The first alternative takes less space and is quicker to look up.
The second alternative is more dynamic (in terms of range).

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
