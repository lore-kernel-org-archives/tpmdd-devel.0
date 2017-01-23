From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC v4 3/5] tpm: infrastructure for TPM spaces
Date: Mon, 23 Jan 2017 02:00:25 +0200
Message-ID: <20170123000025.wtgnibdwhr5fkdkm@intel.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
 <20170122234438.12102-4-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170122234438.12102-4-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 23, 2017 at 01:44:31AM +0200, Jarkko Sakkinen wrote:
> Added ability to tpm_transmit() to supply a TPM space that contains
> mapping from virtual handles to physical handles and backing storage for
> swapping transient objects. TPM space is isolated from other users of
> the TPM.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/tpm/Makefile        |   2 +-
>  drivers/char/tpm/tpm-chip.c      |   7 +
>  drivers/char/tpm/tpm-dev.c       |   2 +-
>  drivers/char/tpm/tpm-interface.c |  63 +++++---
>  drivers/char/tpm/tpm-sysfs.c     |   2 +-
>  drivers/char/tpm/tpm.h           |  24 ++-
>  drivers/char/tpm/tpm2-cmd.c      |  38 +++--
>  drivers/char/tpm/tpm2-space.c    | 336 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 427 insertions(+), 47 deletions(-)
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
> index 21021cb..ef72c28 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -375,10 +375,11 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
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
> @@ -404,10 +405,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>  	if (chip->dev.parent)
>  		pm_runtime_get_sync(chip->dev.parent);
>  
> +	rc = tpm2_prepare_space(chip, space, ordinal, buf);
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
> @@ -440,17 +445,23 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
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
> +	rc = tpm2_commit_space(chip, space, ordinal, buf, len);
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
> @@ -469,15 +480,16 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
>   *     A negative number for system errors (errno).
>   *     A positive number for a TPM error.
>   */
> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf,
> -			 size_t bufsiz, size_t min_rsp_body_length,
> -			 unsigned int flags, const char *desc)
> +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> +			 const void *buf, size_t bufsiz,
> +			 size_t min_rsp_body_length, unsigned int flags,
> +			 const char *desc)
>  {
>  	const struct tpm_output_header *header;
>  	int err;
>  	ssize_t len;
>  
> -	len = tpm_transmit(chip, (const u8 *)buf, bufsiz, flags);
> +	len = tpm_transmit(chip, space, (u8 *)buf, bufsiz, flags);
>  	if (len <  0)
>  		return len;
>  	else if (len < TPM_HEADER_SIZE)
> @@ -536,7 +548,7 @@ ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
>  	}
> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> +	rc = tpm_transmit_cmd(chip, NULL, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>  			      min_cap_length, 0, desc);
>  	if (!rc)
>  		*cap = tpm_cmd.params.getcap_out.cap;
> @@ -560,7 +572,8 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  	start_cmd.header.in = tpm_startup_header;
>  
>  	start_cmd.params.startup_in.startup_type = startup_type;
> -	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
> +	return tpm_transmit_cmd(chip, NULL, &start_cmd,
> +				TPM_INTERNAL_RESULT_SIZE, 0,
>  				0, "attempting to start the TPM");
>  }
>  
> @@ -717,8 +730,8 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
>  	struct tpm_cmd_t cmd;
>  
>  	cmd.header.in = continue_selftest_header;
> -	rc = tpm_transmit_cmd(chip, &cmd, CONTINUE_SELFTEST_RESULT_SIZE, 0, 0,
> -			      "continue selftest");
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, CONTINUE_SELFTEST_RESULT_SIZE,
> +			      0, 0, "continue selftest");
>  	return rc;
>  }
>  
> @@ -738,7 +751,7 @@ int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  
>  	cmd.header.in = pcrread_header;
>  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> -	rc = tpm_transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, READ_PCR_RESULT_SIZE,
>  			      READ_PCR_RESULT_BODY_SIZE, 0,
>  			      "attempting to read a pcr value");
>  
> @@ -838,7 +851,7 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
>  	cmd.header.in = pcrextend_header;
>  	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
>  	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
> -	rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
>  			      EXTEND_PCR_RESULT_BODY_SIZE, 0,
>  			      "attempting extend a PCR value");
>  
> @@ -943,8 +956,8 @@ int tpm_send(u32 chip_num, void *cmd, size_t buflen)
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> -	rc = tpm_transmit_cmd(chip, cmd, buflen, 0, 0, "attempting tpm_cmd");
> -
> +	rc = tpm_transmit_cmd(chip, NULL, cmd, buflen, 0, 0,
> +			      "attempting tpm_cmd");
>  	tpm_put_ops(chip);
>  	return rc;
>  }
> @@ -1045,16 +1058,16 @@ int tpm_pm_suspend(struct device *dev)
>  		cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(tpm_suspend_pcr);
>  		memcpy(cmd.params.pcrextend_in.hash, dummy_hash,
>  		       TPM_DIGEST_SIZE);
> -		rc = tpm_transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
> -				     EXTEND_PCR_RESULT_BODY_SIZE, 0,
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, EXTEND_PCR_RESULT_SIZE,
> +				      EXTEND_PCR_RESULT_BODY_SIZE, 0,
>  				      "extending dummy pcr before suspend");
>  	}
>  
>  	/* now do the actual savestate */
>  	for (try = 0; try < TPM_RETRY; try++) {
>  		cmd.header.in = savestate_header;
> -		rc = tpm_transmit_cmd(chip, &cmd, SAVESTATE_RESULT_SIZE, 0,
> -				      0, NULL);
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, SAVESTATE_RESULT_SIZE,
> +				      0, 0, NULL);
>  
>  		/*
>  		 * If the TPM indicates that it is too busy to respond to
> @@ -1137,7 +1150,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  		tpm_cmd.header.in = tpm_getrandom_header;
>  		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
>  
> -		err = tpm_transmit_cmd(chip, &tpm_cmd,
> +		err = tpm_transmit_cmd(chip, NULL, &tpm_cmd,
>  				       TPM_GETRANDOM_RESULT_SIZE + num_bytes,
>  				       offsetof(struct tpm_getrandom_out,
>  						rng_data),
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 2f596d7..55405db 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -40,7 +40,7 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
>  	struct tpm_chip *chip = to_tpm_chip(dev);
>  
>  	tpm_cmd.header.in = tpm_readpubek_header;
> -	err = tpm_transmit_cmd(chip, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
> +	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
>  			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
>  			       "attempting to read the PUBEK");
>  	if (err)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index d7f748f..37c9760 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -90,7 +90,9 @@ enum tpm2_structures {
>  };
>  
>  enum tpm2_return_codes {
> +	TPM2_RC_SUCCESS		= 0x0000,
>  	TPM2_RC_HASH		= 0x0083, /* RC_FMT1 */
> +	TPM2_RC_HANDLE		= 0x008B,
>  	TPM2_RC_INITIALIZE	= 0x0100, /* RC_VER1 */
>  	TPM2_RC_DISABLED	= 0x0120,
>  	TPM2_RC_TESTING		= 0x090A, /* RC_WARN */
> @@ -114,6 +116,8 @@ enum tpm2_command_codes {
>  	TPM2_CC_CREATE		= 0x0153,
>  	TPM2_CC_LOAD		= 0x0157,
>  	TPM2_CC_UNSEAL		= 0x015E,
> +	TPM2_CC_CONTEXT_LOAD	= 0x0161,
> +	TPM2_CC_CONTEXT_SAVE	= 0x0162,
>  	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
>  	TPM2_CC_GET_CAPABILITY	= 0x017A,
>  	TPM2_CC_GET_RANDOM	= 0x017B,
> @@ -151,6 +155,11 @@ enum tpm2_cc_attrs {
>  
>  #define TPM_PPI_VERSION_LEN		3
>  
> +struct tpm_space {
> +	u32 context_tbl[3];
> +	u8 *context_buf;
> +};
> +
>  enum tpm_chip_flags {
>  	TPM_CHIP_FLAG_TPM2		= BIT(1),
>  	TPM_CHIP_FLAG_IRQ		= BIT(2),
> @@ -202,6 +211,7 @@ struct tpm_chip {
>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
>  #endif /* CONFIG_ACPI */
>  
> +	struct tpm_space work_space;
>  	u32 nr_commands;
>  	u32 *cc_attrs_tbl;
>  };
> @@ -509,10 +519,11 @@ enum tpm_transmit_flags {
>  	TPM_TRANSMIT_UNLOCKED	= BIT(0),
>  };
>  
> -ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
> -		     unsigned int flags);
> -ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *buf, size_t bufsiz,
> -			 size_t min_rsp_body_len, unsigned int flags,
> +ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
> +		     u8 *buf, size_t bufsiz, unsigned int flags);
> +ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
> +			 const void *buf, size_t bufsiz,
> +			 size_t min_rsp_body_length, unsigned int flags,
>  			 const char *desc);
>  ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>  		   const char *desc, size_t min_cap_length);
> @@ -567,4 +578,9 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
>  unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>  int tpm2_probe(struct tpm_chip *chip);
>  int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
> +int tpm2_init_space(struct tpm_chip *chip, struct tpm_space *space);
> +int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
> +		       u8 *cmd);
> +int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
> +		      u32 cc, u8 *buf, size_t bufsiz);
>  #endif
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 6eb9517..22c1da8 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -283,7 +283,7 @@ int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
>  	       sizeof(cmd.params.pcrread_in.pcr_select));
>  	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
>  			      TPM2_PCR_READ_RESP_BODY_SIZE,
>  			      0, "attempting to read a pcr value");
>  	if (rc == 0) {
> @@ -331,7 +331,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
>  	cmd.params.pcrextend_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
>  	memcpy(cmd.params.pcrextend_in.digest, hash, TPM_DIGEST_SIZE);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
>  			      "attempting extend a PCR value");
>  
>  	return rc;
> @@ -377,7 +377,7 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
>  		cmd.header.in = tpm2_getrandom_header;
>  		cmd.params.getrandom_in.size = cpu_to_be16(num_bytes);
>  
> -		err = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +		err = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
>  				       offsetof(struct tpm2_get_random_out,
>  						buffer),
>  				       0, "attempting get random");
> @@ -436,7 +436,7 @@ void tpm2_flush_context_cmd(struct tpm_chip *chip, u32 handle,
>  
>  	tpm_buf_append_u32(&buf, handle);
>  
> -	(void) tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, flags,
> +	(void) tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, flags,
>  				"flushing context");
>  
>  	tpm_buf_destroy(&buf);
> @@ -552,7 +552,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, 0,
>  			      "sealing data");
>  	if (rc)
>  		goto out;
> @@ -636,7 +636,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 4, flags,
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, flags,
>  			      "loading blob");
>  	if (!rc)
>  		*blob_handle = be32_to_cpup(
> @@ -688,7 +688,7 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  			     options->blobauth /* hmac */,
>  			     TPM_DIGEST_SIZE);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 6, flags,
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 6, flags,
>  			      "unsealing");
>  	if (rc > 0)
>  		rc = -EPERM;
> @@ -765,7 +765,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
>  	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(property_id);
>  	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd),
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
>  			      TPM2_GET_TPM_PT_OUT_BODY_SIZE, 0, desc);
>  	if (!rc)
>  		*value = be32_to_cpu(cmd.params.get_tpm_pt_out.value);
> @@ -800,7 +800,7 @@ static int tpm2_startup(struct tpm_chip *chip, u16 startup_type)
>  	cmd.header.in = tpm2_startup_header;
>  
>  	cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
> -	return tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
> +	return tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
>  				"attempting to start the TPM");
>  }
>  
> @@ -829,7 +829,7 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type)
>  	cmd.header.in = tpm2_shutdown_header;
>  	cmd.params.startup_in.startup_type = cpu_to_be16(shutdown_type);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
>  			      "stopping the TPM");
>  
>  	/* In places where shutdown command is sent there's no much we can do
> @@ -893,7 +893,7 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
>  	cmd.header.in = tpm2_selftest_header;
>  	cmd.params.selftest_in.full_test = full;
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
>  			      "continue selftest");
>  
>  	/* At least some prototype chips seem to give RC_TESTING error
> @@ -944,7 +944,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>  		cmd.params.pcrread_in.pcr_select[1] = 0x00;
>  		cmd.params.pcrread_in.pcr_select[2] = 0x00;
>  
> -		rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
> +		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0, NULL);
>  		if (rc < 0)
>  			break;
>  
> @@ -977,7 +977,7 @@ int tpm2_probe(struct tpm_chip *chip)
>  	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
>  	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
>  
> -	rc = tpm_transmit_cmd(chip, &cmd, sizeof(cmd), 0, 0, NULL);
> +	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0, NULL);
>  	if (rc <  0)
>  		return rc;
>  
> @@ -1046,7 +1046,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
>  	tpm_buf_append_u32(&buf, nr_commands);
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0, NULL);
> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0, NULL);
>  	if (rc < 0) {
>  		tpm_buf_destroy(&buf);
>  		goto out;
> @@ -1061,9 +1061,17 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>  	chip->nr_commands = nr_commands;
>  
>  	attrs = (u32 *)&buf.data[TPM_HEADER_SIZE + 9];
> -	for (i = 0; i < nr_commands; i++, attrs++)
> +	for (i = 0; i < nr_commands; i++, attrs++) {
>  		chip->cc_attrs_tbl[i] = be32_to_cpup(attrs);
>  
> +		/* handle is in the body  */
> +		if ((chip->cc_attrs_tbl[i] & 0xFFFF) == TPM2_CC_FLUSH_CONTEXT) {
> +			chip->cc_attrs_tbl[i] &=
> +				~(GENMASK(2, 0) << TPM2_CC_ATTR_CHANDLES);
> +			chip->cc_attrs_tbl[i] |= 1 << TPM2_CC_ATTR_CHANDLES;
> +		}
> +	}

Oops. Should be in the earlier commit.

/Jarkko
