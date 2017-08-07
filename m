From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm: improve tpm_tis send() performance by ignoring
 burstcount
Date: Mon, 7 Aug 2017 19:55:49 +0530
Message-ID: <5988786D.3080301@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net
Cc: tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/07/2017 05:22 PM, Peter Huewe wrote:
>
>
> Am 7. August 2017 13:46:32 MESZ schrieb Nayna Jain <nayna@linux.vnet.ibm.com>:
>> The TPM burstcount status indicates the number of bytes that can
>> be sent to the TPM without causing bus wait states.  Effectively,
>> it is the number of empty bytes in the command FIFO. Further,
>> some TPMs have a static burstcount, when the value remains zero
>> until the entire FIFO is empty.
>>
>> This patch ignores burstcount, permitting wait states, and thus
>> writes the command as fast as the TPM can accept the bytes.
>> The performance of a 34 byte extend on a TPM 1.2 improved from
>> 52 msec to 11 msec.
>>
>> Suggested-by: Ken Goldman <kgold@linux.vnet.ibm.com> in
>> conjunction with the TPM Device Driver work group.
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> Are you sure this is a good idea?
> On lpc systems this more or less stalls the bus, including keyboard/mouse (if connected via superio lpc).

Thanks Peter for quick response.

I actually meant to post this patch as RFC. Sorry, missed that.
It was meant to be a starting place for the discussion related to 
burst_count.

>
> On which systems have you tested this?
> Spi/Lpc? Architecture?

Tested it with LPC on x86.

>
> This might not be noticable for small transfers, but think about much larger transfers....

I did the following testing:

* Ran a script with 1000 extends. This was to test continuous extends
which are generally in large numbers when IMA is enabled.

* Ran a command to ask TPM to hash big size file like 1MB. This was to
test the long command.

In both of the above cases, I didn't face any tpm specific errors.

Is there any test-script or test-cases which I can try to test the
scenario(stalling the bus, including keyboard/mouse) with the patch ?

Thanks & Regards,
    - Nayna


>
> Imho: NACK from my side.
>
> Thanks,
> Peter
>
>> ---
>> drivers/char/tpm/tpm_tis_core.c | 45
>> ++---------------------------------------
>> 1 file changed, 2 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis_core.c
>> b/drivers/char/tpm/tpm_tis_core.c
>> index b617b2eeb080..478cbc0f61c3 100644
>> --- a/drivers/char/tpm/tpm_tis_core.c
>> +++ b/drivers/char/tpm/tpm_tis_core.c
>> @@ -255,9 +255,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8
>> *buf, size_t count)
>> static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t
>> len)
>> {
>> 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
>> -	int rc, status, burstcnt;
>> -	size_t count = 0;
>> -	bool itpm = priv->flags & TPM_TIS_ITPM_WORKAROUND;
>> +	int rc, status;
>>
>> 	status = tpm_tis_status(chip);
>> 	if ((status & TPM_STS_COMMAND_READY) == 0) {
>> @@ -270,49 +268,10 @@ static int tpm_tis_send_data(struct tpm_chip
>> *chip, u8 *buf, size_t len)
>> 		}
>> 	}
>>
>> -	while (count < len - 1) {
>> -		burstcnt = get_burstcount(chip);
>> -		if (burstcnt < 0) {
>> -			dev_err(&chip->dev, "Unable to read burstcount\n");
>> -			rc = burstcnt;
>> -			goto out_err;
>> -		}
>> -		burstcnt = min_t(int, burstcnt, len - count - 1);
>> -		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
>> -					 burstcnt, buf + count);
>> -		if (rc < 0)
>> -			goto out_err;
>> -
>> -		count += burstcnt;
>> -
>> -		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>> -					&priv->int_queue, false) < 0) {
>> -			rc = -ETIME;
>> -			goto out_err;
>> -		}
>> -		status = tpm_tis_status(chip);
>> -		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
>> -			rc = -EIO;
>> -			goto out_err;
>> -		}
>> -	}
>> -
>> -	/* write last byte */
>> -	rc = tpm_tis_write8(priv, TPM_DATA_FIFO(priv->locality), buf[count]);
>> +	rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality), len,
>> buf);
>> 	if (rc < 0)
>> 		goto out_err;
>>
>> -	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
>> -				&priv->int_queue, false) < 0) {
>> -		rc = -ETIME;
>> -		goto out_err;
>> -	}
>> -	status = tpm_tis_status(chip);
>> -	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
>> -		rc = -EIO;
>> -		goto out_err;
>> -	}
>> -
>> 	return 0;
>>
>> out_err:
>
