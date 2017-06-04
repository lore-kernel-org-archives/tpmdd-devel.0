From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 2/3] tpm: vtpm_proxy: Implement request_locality
 function.
Date: Sun, 4 Jun 2017 16:09:38 -0400
Message-ID: <8f269ff4-a707-c3de-4c75-9ed986836176@linux.vnet.ibm.com>
References: <1495661981-27249-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1495661981-27249-3-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170524222130.cqnt433dbrr3t43i@intel.com>
 <a8636210-c4eb-38b2-feca-8a09cee48bbb@linux.vnet.ibm.com>
 <20170525000936.djj37wyqieorjfva@intel.com>
 <22d2ce2e-6636-82ad-3099-5f947bc70e05@linux.vnet.ibm.com>
 <20170604154332.blhrcj43xgcswxvu@intel.com>
 <20170604162705.6pv6wbgfyogzsmg5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170604162705.6pv6wbgfyogzsmg5@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: tpmdd-devel@lists.sourceforge.net

On 06/04/2017 12:27 PM, Jarkko Sakkinen wrote:
> On Sun, Jun 04, 2017 at 06:43:32PM +0300, Jarkko Sakkinen wrote:
>> On Thu, Jun 01, 2017 at 08:34:31PM -0400, Stefan Berger wrote:
>>> On 05/24/2017 08:09 PM, Jarkko Sakkinen wrote:
>>>> On Wed, May 24, 2017 at 07:03:27PM -0400, Stefan Berger wrote:
>>>>> On 05/24/2017 06:21 PM, Jarkko Sakkinen wrote:
>>>>>> On Wed, May 24, 2017 at 05:39:40PM -0400, Stefan Berger wrote:
>>>>>>> Implement the request_locality function. To set the locality on the
>>>>>>> backend we define vendor-specific TPM 1.2 and TPM 2 ordinals and send
>>>>>>> a command to the backend to set the locality for the next commands.
>>>>>>>
>>>>>>> To avoid recursing into requesting the locality, we set the
>>>>>>> TPM_TRANSMIT_RAW flag when calling tpm_transmit_cmd. To avoid recursing
>>>>>>> into TPM 2 space related commands, we set the space parameter to NULL.
>>>>>>>
>>>>>>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>>>>>>> ---
>>>>>>>     drivers/char/tpm/tpm-interface.c  |  1 +
>>>>>>>     drivers/char/tpm/tpm_vtpm_proxy.c | 36 ++++++++++++++++++++++++++++++++++++
>>>>>>>     include/uapi/linux/vtpm_proxy.h   |  4 ++++
>>>>>>>     3 files changed, 41 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>>>>>>> index 2eacda2..876d45f 100644
>>>>>>> --- a/drivers/char/tpm/tpm-interface.c
>>>>>>> +++ b/drivers/char/tpm/tpm-interface.c
>>>>>>> @@ -537,6 +537,7 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
>>>>>>>     	return 0;
>>>>>>>     }
>>>>>>> +EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
>>>>>>>     #define TPM_DIGEST_SIZE 20
>>>>>>>     #define TPM_RET_CODE_IDX 6
>>>>>>> diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
>>>>>>> index 751059d..66024bf 100644
>>>>>>> --- a/drivers/char/tpm/tpm_vtpm_proxy.c
>>>>>>> +++ b/drivers/char/tpm/tpm_vtpm_proxy.c
>>>>>>> @@ -371,6 +371,41 @@ static bool vtpm_proxy_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
>>>>>>>     	return ret;
>>>>>>>     }
>>>>>>> +static int vtpm_proxy_request_locality(struct tpm_chip *chip, int locality)
>>>>>>> +{
>>>>>>> +	struct tpm_buf buf;
>>>>>>> +	int rc;
>>>>>>> +	const struct tpm_output_header *header;
>>>>>>> +
>>>>>>> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>>>>>>> +		rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS,
>>>>>>> +				  TPM2_CC_SET_LOCALITY);
>>>>>> I would always go with this branch.
>>>>>>
>>>>>>> +	else
>>>>>>> +		rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND,
>>>>>>> +				  TPM_ORD_SET_LOCALITY);
>>>>>>> +	if (rc)
>>>>>>> +		return rc;
>>>>>>> +	tpm_buf_append_u8(&buf, locality);
>>>>>>> +
>>>>>>> +	rc = tpm_transmit_cmd(chip, NULL, buf.data, tpm_buf_length(&buf), 0,
>>>>>>> +			      TPM_TRANSMIT_UNLOCKED | TPM_TRANSMIT_RAW,
>>>>>>> +			      "attempting to set locality");
>>>>>>> +	if (rc < 0) {
>>>>>>> +		locality = rc;
>>>>>>> +		goto out;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	header = (const struct tpm_output_header *)buf.data;
>>>>>>> +	rc = be32_to_cpu(header->return_code);
>>>>>>> +	if (rc)
>>>>>>> +		locality = -1;
>>>>>>> +
>>>>>>> +out:
>>>>>>> +	tpm_buf_destroy(&buf);
>>>>>>> +
>>>>>>> +	return locality;
>>>>>>> +}
>>>>>>> +
>>>>>>>     static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
>>>>>>>     	.flags = TPM_OPS_AUTO_STARTUP,
>>>>>>>     	.recv = vtpm_proxy_tpm_op_recv,
>>>>>>> @@ -380,6 +415,7 @@ static const struct tpm_class_ops vtpm_proxy_tpm_ops = {
>>>>>>>     	.req_complete_mask = VTPM_PROXY_REQ_COMPLETE_FLAG,
>>>>>>>     	.req_complete_val = VTPM_PROXY_REQ_COMPLETE_FLAG,
>>>>>>>     	.req_canceled = vtpm_proxy_tpm_req_canceled,
>>>>>>> +	.request_locality = vtpm_proxy_request_locality,
>>>>>>>     };
>>>>>>>     /*
>>>>>>> diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
>>>>>>> index a69e991..58ac73c 100644
>>>>>>> --- a/include/uapi/linux/vtpm_proxy.h
>>>>>>> +++ b/include/uapi/linux/vtpm_proxy.h
>>>>>>> @@ -46,4 +46,8 @@ struct vtpm_proxy_new_dev {
>>>>>>>     #define VTPM_PROXY_IOC_NEW_DEV	_IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
>>>>>>> +/* vendor specific commands to set locality */
>>>>>>> +#define TPM2_CC_SET_LOCALITY	0x20001000
>>>>>>> +#define TPM_ORD_SET_LOCALITY	0x20001000
>>>>>>> +
>>>>>>>     #endif /* _UAPI_LINUX_VTPM_PROXY_H */
>>>>>>> -- 
>>>>>>> 2.4.3
>>>>>> What practical benefit you get from these two constants? I understand
>>>>>> the value range but not so much the redundant code.
>>>>> If you want to change this, please go ahead and give it a sinle name.
>>>>> For the code branches above I think that we should at least send a TPM 1.2
>>>>> formatted command in case of TPM 1.2 and a TPM 2 formatted one in case of
>>>>> TPM 2. It seems just 'proper.'
>>>>>
>>>>>      Stefan
>>>> Agreed. I will make these changes no need to send new series.
>>> I pushed an update to the test suite, which may help the cause to accept
>>> this series.
>>>
>>> https://github.com/stefanberger/linux-vtpm-tests
>>>
>>> Patch 3/3 should probably not return -EFAULT in case of the user trying to
>>> send the SetLocality command via /dev/tpm%d but rather -EPIPE to get the
>>> logging of the error suppressed, even though that doesn't seem to be the
>>> right error code.
>>>
>>>
>>>    Stefan
>>>
>>>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>>
>>>> /Jarkko
>>>>
>> On hold as there are more high priority bug fixes in the queue.
>>
>> /Jarkko
> Patches are now applied to master (bleeding edge) brach. After they are
> tested they can be put also to the next branch.

Thanks. Pulled and tested.

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

