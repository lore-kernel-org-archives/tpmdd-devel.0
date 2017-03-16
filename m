From: Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH v3] tpm_crb: request and relinquish locality 0
Date: Wed, 15 Mar 2017 20:27:54 -0700
Message-ID: <87fuidx5mt.fsf@redhat.com>
References: <20170315055738.11088-1-jarkko.sakkinen@iki.fi> <87h92uvtce.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <87h92uvtce.fsf@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, gang.wei@intel.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net


Jerry Snitselaar @ 2017-03-16 02:38 GMT:

> Jarkko Sakkinen @ 2017-03-15 05:57 GMT:
>
>> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>
>> This commit adds support for requesting and relinquishing locality 0 in
>> tpm_crb for the course of command transmission.
>>
>> In order to achieve this, two new callbacks are added to struct
>> tpm_class_ops:
>>
>> - request_locality
>> - relinquish_locality
>>
>> These are called before sending and receiving data from the TPM.  We
>> update also tpm_tis_core to use these callbacks. A small modification to
>> request_locality() is done so that it returns -EBUSY instead of locality
>> number when check_locality() fails in order to return something
>> meaningful to the user space.
>>
>> With CRB interface you first set either requestAccess or relinquish bit
>> from TPM_LOC_CTRL_x register and then wait for locAssigned and
>> tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.
>>
>> The reason why were are doing this is to make sure that the driver
>> will work properly with Intel TXT that uses locality 2. There's no
>> explicit guarantee that it would relinquish this locality. In more
>> general sense this commit enables tpm_crb to be a well behaving
>> citizen in a multi locality environment.
>>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> ---
>> v2:
>> - TPM driver level calllbacks
>> v3:
>> - Call ops->relinquish_locality only if ops->request_locality has been
>>   successful.
>> - Do not reserve locality in nested tpm_transmit calls.
>> - Check for tpmRegValidSts to make sure that the value in TPM_LOC_STATE_x is
>>   stable.
>>  drivers/char/tpm/tpm-interface.c | 10 ++++++++++
>>  drivers/char/tpm/tpm.h           |  3 ++-
>>  drivers/char/tpm/tpm2-space.c    | 15 +++++++++------
>>  drivers/char/tpm/tpm_crb.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/char/tpm/tpm_tis_core.c  | 12 ++++--------
>>  include/linux/tpm.h              |  3 ++-
>>  6 files changed, 68 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index 95c6f98..4cd216f 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -384,6 +384,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>>  	ssize_t len = 0;
>>  	u32 count, ordinal;
>>  	unsigned long stop;
>> +	bool no_locality = !(flags & TPM_TRANSMIT_HAS_LOCALITY);
>>
>>  	if (!tpm_validate_command(chip, buf, bufsiz))
>>  		return -EINVAL;
>> @@ -407,6 +408,12 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>>  	if (chip->dev.parent)
>>  		pm_runtime_get_sync(chip->dev.parent);
>>
>> +	if (no_locality && chip->ops->request_locality)  {
>> +		rc = chip->ops->request_locality(chip, 0);
>> +		if (rc)
>> +			goto out_no_locality;
>> +	}
>> +
>>  	rc = tpm2_prepare_space(chip, space, ordinal, buf);
>>  	if (rc)
>>  		goto out;
>> @@ -466,6 +473,9 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>>  	rc = tpm2_commit_space(chip, space, ordinal, buf, &len);
>>
>>  out:
>> +	if (no_locality && chip->ops->relinquish_locality)
>> +		chip->ops->relinquish_locality(chip, 0, false);
>> +out_no_locality:
>>  	if (chip->dev.parent)
>>  		pm_runtime_put_sync(chip->dev.parent);
>>
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 5eacb3f..ba2c00d 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -521,7 +521,8 @@ extern const struct file_operations tpmrm_fops;
>>  extern struct idr dev_nums_idr;
>>
>>  enum tpm_transmit_flags {
>> -	TPM_TRANSMIT_UNLOCKED	= BIT(0),
>> +	TPM_TRANSMIT_UNLOCKED		= BIT(0),
>> +	TPM_TRANSMIT_HAS_LOCALITY	= BIT(1),
>>  };
>>
>>  ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
>> index d36d81e..43d05ab 100644
>> --- a/drivers/char/tpm/tpm2-space.c
>> +++ b/drivers/char/tpm/tpm2-space.c
>> @@ -19,6 +19,9 @@
>>  #include <asm/unaligned.h>
>>  #include "tpm.h"
>>
>> +#define TPM_TRANSMIT_NESTED \
>> +	(TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_HAS_LOCALITY)
>> +
>>  enum tpm2_handle_types {
>>  	TPM2_HT_HMAC_SESSION	= 0x02000000,
>>  	TPM2_HT_POLICY_SESSION	= 0x03000000,
>> @@ -39,7 +42,7 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
>>  	for (i = 0; i < ARRAY_SIZE(space->session_tbl); i++) {
>>  		if (space->session_tbl[i])
>>  			tpm2_flush_context_cmd(chip, space->session_tbl[i],
>> -					       TPM_TRANSMIT_UNLOCKED);
>> +					       TPM_TRANSMIT_NESTED);
>>  	}
>>  }
>>
>> @@ -84,7 +87,7 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
>>  	tpm_buf_append(&tbuf, &buf[*offset], body_size);
>>
>>  	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 4,
>> -			      TPM_TRANSMIT_UNLOCKED, NULL);
>> +			      TPM_TRANSMIT_NESTED, NULL);
>>  	if (rc < 0) {
>>  		dev_warn(&chip->dev, "%s: failed with a system error %d\n",
>>  			 __func__, rc);
>> @@ -132,7 +135,7 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
>>  	tpm_buf_append_u32(&tbuf, handle);
>>
>>  	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 0,
>> -			      TPM_TRANSMIT_UNLOCKED, NULL);
>> +			      TPM_TRANSMIT_NESTED, NULL);
>>  	if (rc < 0) {
>>  		dev_warn(&chip->dev, "%s: failed with a system error %d\n",
>>  			 __func__, rc);
>> @@ -169,7 +172,7 @@ static void tpm2_flush_space(struct tpm_chip *chip)
>>  	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
>>  		if (space->context_tbl[i] && ~space->context_tbl[i])
>>  			tpm2_flush_context_cmd(chip, space->context_tbl[i],
>> -					       TPM_TRANSMIT_UNLOCKED);
>> +					       TPM_TRANSMIT_NESTED);
>>
>>  	tpm2_flush_sessions(chip, space);
>>  }
>> @@ -376,7 +379,7 @@ static int tpm2_map_response_header(struct tpm_chip *chip, u32 cc, u8 *rsp,
>>
>>  	return 0;
>>  out_no_slots:
>> -	tpm2_flush_context_cmd(chip, phandle, TPM_TRANSMIT_UNLOCKED);
>> +	tpm2_flush_context_cmd(chip, phandle, TPM_TRANSMIT_NESTED);
>>  	dev_warn(&chip->dev, "%s: out of slots for 0x%08X\n", __func__,
>>  		 phandle);
>>  	return -ENOMEM;
>> @@ -468,7 +471,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
>>  			return rc;
>>
>>  		tpm2_flush_context_cmd(chip, space->context_tbl[i],
>> -				       TPM_TRANSMIT_UNLOCKED);
>> +				       TPM_TRANSMIT_NESTED);
>>  		space->context_tbl[i] = ~0;
>>  	}
>>
>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>> index 1dfc37e..eb2fcf1 100644
>> --- a/drivers/char/tpm/tpm_crb.c
>> +++ b/drivers/char/tpm/tpm_crb.c
>> @@ -34,6 +34,16 @@ enum crb_defaults {
>>  	CRB_ACPI_START_INDEX = 1,
>>  };
>>
>> +enum crb_loc_ctrl {
>> +	CRB_LOC_CTRL_REQUEST_ACCESS	= BIT(0),
>> +	CRB_LOC_CTRL_RELINQUISH		= BIT(1),
>> +};
>> +
>> +enum crb_loc_state {
>> +	CRB_LOC_STATE_LOC_ASSIGNED	= BIT(1),
>> +	CRB_LOC_STATE_TPM_REG_VALID_STS	= BIT(7),
>> +};
>> +
>>  enum crb_ctrl_req {
>>  	CRB_CTRL_REQ_CMD_READY	= BIT(0),
>>  	CRB_CTRL_REQ_GO_IDLE	= BIT(1),
>> @@ -172,6 +182,35 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
>>  	return 0;
>>  }
>>
>> +static int crb_request_locality(struct tpm_chip *chip, int loc)
>> +{
>> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>> +	u32 value = CRB_LOC_STATE_LOC_ASSIGNED |
>> +		CRB_LOC_STATE_TPM_REG_VALID_STS;
>> +
>> +	if (!priv->regs_h)
>> +		return 0;
>> +
>> +	iowrite32(CRB_LOC_CTRL_REQUEST_ACCESS, &priv->regs_h->loc_ctrl);
>> +	if (!crb_wait_for_reg_32(&priv->regs_h->loc_state, value, value,
>> +				 TPM2_TIMEOUT_C)) {
>> +		dev_warn(&chip->dev, "TPM_LOC_STATE_x.requestAccess timed out\n");
>> +		return -ETIME;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void crb_relinquish_locality(struct tpm_chip *chip, int loc, bool force)
>> +{
>> +	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>> +
>> +	if (!priv->regs_h)
>> +		return;
>> +
>> +	iowrite32(CRB_LOC_CTRL_RELINQUISH, &priv->regs_h->loc_ctrl);
>> +}
>> +
>>  static u8 crb_status(struct tpm_chip *chip)
>>  {
>>  	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
>> @@ -278,6 +317,8 @@ static const struct tpm_class_ops tpm_crb = {
>>  	.send = crb_send,
>>  	.cancel = crb_cancel,
>>  	.req_canceled = crb_req_canceled,
>> +	.request_locality = crb_request_locality,
>> +	.relinquish_locality = crb_relinquish_locality,
>>  	.req_complete_mask = CRB_DRV_STS_COMPLETE,
>>  	.req_complete_val = CRB_DRV_STS_COMPLETE,
>>  };
>> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
>> index fc0e9a2..c3cbe24 100644
>> --- a/drivers/char/tpm/tpm_tis_core.c
>> +++ b/drivers/char/tpm/tpm_tis_core.c
>> @@ -73,7 +73,7 @@ static int check_locality(struct tpm_chip *chip, int l)
>>  	return -1;
>>  }
>>
>> -static void release_locality(struct tpm_chip *chip, int l, int force)
>> +static void release_locality(struct tpm_chip *chip, int l, bool force)
>>  {
>>  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>>  	int rc;
>> @@ -97,7 +97,7 @@ static int request_locality(struct tpm_chip *chip, int l)
>>  	long rc;
>>
>>  	if (check_locality(chip, l) >= 0)
>> -		return l;
>> +		return -EBUSY;
>>
>>  	rc = tpm_tis_write8(priv, TPM_ACCESS(l), TPM_ACCESS_REQUEST_USE);
>>  	if (rc < 0)
>> @@ -252,7 +252,6 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
>>
>>  out:
>>  	tpm_tis_ready(chip);
>> -	release_locality(chip, priv->locality, 0);
>>  	return size;
>>  }
>>
>> @@ -268,9 +267,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>>  	size_t count = 0;
>>  	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
>>
>> -	if (request_locality(chip, 0) < 0)
>> -		return -EBUSY;
>> -
>>  	status = tpm_tis_status(chip);
>>  	if ((status & TPM_STS_COMMAND_READY) == 0) {
>>  		tpm_tis_ready(chip);
>> @@ -329,7 +325,6 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>>
>>  out_err:
>>  	tpm_tis_ready(chip);
>> -	release_locality(chip, priv->locality, 0);
>>  	return rc;
>>  }
>>
>> @@ -390,7 +385,6 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
>>  	return len;
>>  out_err:
>>  	tpm_tis_ready(chip);
>> -	release_locality(chip, priv->locality, 0);
>>  	return rc;
>>  }
>>
>> @@ -681,6 +675,8 @@ static const struct tpm_class_ops tpm_tis = {
>>  	.send = tpm_tis_send,
>>  	.cancel = tpm_tis_ready,
>>  	.update_timeouts = tpm_tis_update_timeouts,
>> +	.request_locality = request_locality,
>> +	.relinquish_locality = release_locality,
>>  	.req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>>  	.req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
>>  	.req_canceled = tpm_tis_req_canceled,
>> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
>> index da158f0..65e05f9 100644
>> --- a/include/linux/tpm.h
>> +++ b/include/linux/tpm.h
>> @@ -48,7 +48,8 @@ struct tpm_class_ops {
>>  	u8 (*status) (struct tpm_chip *chip);
>>  	bool (*update_timeouts)(struct tpm_chip *chip,
>>  				unsigned long *timeout_cap);
>> -
>> +	int (*request_locality)(struct tpm_chip *chip, int loc);
>> +	void (*relinquish_locality)(struct tpm_chip *chip, int loc, bool force);
>>  };
>>
>>  #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
>
> This is broken for me on tpm_tis at the moment. release_locality only
> actually follows through with releasing if you've set force or there is
> a pending request for the TPM from another locality. So first time
> through it requests and gets the locality, does its work, goes
> to release it and doesn't because there is no pending request. Then
> next time through, request_locality calls check_locality and returns
> -EBUSY causing it to bail out of tpm_transmit.

Actually I should amend that, I'd been debugging a bit. With the
patch itself, tpm_tis_core_init() calls tpm2_probe() which fails
because tpm_transmit_cmd -> tpm_transmit -> request_locality returns
-EBUSY. There is a request_locality() call right before the
tpm2_probe(). I'd dropped that as part of my debugging which allowed
it to get further along, but then run into the problem mentioned above.

