From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/4] tpm: define __wait_for_tpm_stat to specify
 variable polling sleep time
Date: Fri, 15 Sep 2017 18:07:26 +0530
Message-ID: <20e706f4-d7c2-1d20-4268-129275ab3fc9@linux.vnet.ibm.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-3-nayna@linux.vnet.ibm.com>
 <20170913005823.n7oqknkedlo22xe6@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170913005823.n7oqknkedlo22xe6@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net



On 09/13/2017 06:28 AM, Jarkko Sakkinen wrote:
> On Wed, Sep 06, 2017 at 08:56:37AM -0400, Nayna Jain wrote:
>> The existing wait_for_tpm_stat() checks the chip status before
>> sleeping for 5 msec in a polling loop.  For some functions although
>> the status isn't ready immediately, the status returns extremely
>> quickly. Waiting for 5 msec causes an unnecessary delay. An
>> example is the send() call in the tpms_tis driver.
>>
>> This patch defines __wait_for_tpm_stat(), allowing the caller
>> to specify the polling sleep timeout value within the loop.
>> The existing wait_for_tpm_stat() becomes a wrapper for this
>> function.
>>
>> After this change, performance on a TPM 1.2 with an 8 byte
>> burstcount for 1000 extends improved from ~14sec to ~10sec.
>>
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Please get rid of wait_for_tpm_stat() rather than further making it more
> complex. It's hardware specific stuff. This function should not exist in
> tpm-interface.c.

I think I didn't understand the meaning of "get rid of wait_for_tpm_stat()".
Do you mean to take care of it in driver specific file ?
Can you please elaborate it ?

Thanks & Regards,
     - Nayna

>
> /Jarkko
>
>> ---
>>   drivers/char/tpm/tpm-interface.c | 15 ++++++++++++---
>>   drivers/char/tpm/tpm.h           |  3 +++
>>   drivers/char/tpm/tpm_tis_core.c  | 11 ++++++-----
>>   3 files changed, 21 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index 1d6729be4cd6..b23d006243b7 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -1050,8 +1050,9 @@ static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
>>   	return false;
>>   }
>>   
>> -int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>> -		      wait_queue_head_t *queue, bool check_cancel)
>> +int __wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>> +		      unsigned int poll_sleep, wait_queue_head_t *queue,
>> +		      bool check_cancel)
>>   {
>>   	unsigned long stop;
>>   	long rc;
>> @@ -1085,7 +1086,7 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>>   		}
>>   	} else {
>>   		do {
>> -			tpm_msleep(TPM_TIMEOUT);
>> +			tpm_msleep(poll_sleep);
>>   			status = chip->ops->status(chip);
>>   			if ((status & mask) == mask)
>>   				return 0;
>> @@ -1093,6 +1094,14 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>>   	}
>>   	return -ETIME;
>>   }
>> +EXPORT_SYMBOL_GPL(__wait_for_tpm_stat);
>> +
>> +int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>> +		      wait_queue_head_t *queue, bool check_cancel)
>> +{
>> +	return __wait_for_tpm_stat(chip, mask, timeout, TPM_TIMEOUT,
>> +			queue, check_cancel);
>> +}
>>   EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
>>   
>>   #define TPM_ORD_SAVESTATE 152
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 2d5466a72e40..eb2f8818eded 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -525,6 +525,9 @@ int tpm_do_selftest(struct tpm_chip *chip);
>>   unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
>>   int tpm_pm_suspend(struct device *dev);
>>   int tpm_pm_resume(struct device *dev);
>> +int __wait_for_tpm_stat(struct tpm_chip *chip, u8 mask,
>> +		unsigned long timeout, unsigned int poll_sleep,
>> +		wait_queue_head_t *queue, bool check_cancel);
>>   int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>>   		      wait_queue_head_t *queue, bool check_cancel);
>>   
>> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
>> index 6b9bf4c4d434..d1eab29cb447 100644
>> --- a/drivers/char/tpm/tpm_tis_core.c
>> +++ b/drivers/char/tpm/tpm_tis_core.c
>> @@ -268,8 +268,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>>   	status = tpm_tis_status(chip);
>>   	if ((status & TPM_STS_COMMAND_READY) == 0) {
>>   		tpm_tis_ready(chip);
>> -		if (wait_for_tpm_stat
>> -		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b,
>> +		if (__wait_for_tpm_stat
>> +		    (chip, TPM_STS_COMMAND_READY, chip->timeout_b, 1,
>>   		     &priv->int_queue, false) < 0) {
>>   			rc = -ETIME;
>>   			goto out_err;
>> @@ -303,7 +303,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>>   		if (ignore_burst_count)
>>   			continue;
>>   
>> -		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>> +		if (__wait_for_tpm_stat(chip, TPM_STS_VALID,
>> +					chip->timeout_c, 1,
>>   					&priv->int_queue, false) < 0) {
>>   			rc = -ETIME;
>>   			goto out_err;
>> @@ -320,8 +321,8 @@ static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
>>   	if (rc < 0)
>>   		goto out_err;
>>   
>> -	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>> -				&priv->int_queue, false) < 0) {
>> +	if (__wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>> +				1, &priv->int_queue, false) < 0) {
>>   		rc = -ETIME;
>>   		goto out_err;
>>   	}
>> -- 
>> 2.13.3
>>

