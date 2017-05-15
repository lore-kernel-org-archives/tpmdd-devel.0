From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/2] tpm: Refactor tpm_transmit pulling out
 tpm_transfer function
Date: Mon, 15 May 2017 12:04:40 -0400
Message-ID: <1b9e7995-8ed0-cc62-40b7-55b8d1e71ffe@linux.vnet.ibm.com>
References: <1494460462-29022-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1494460462-29022-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170515124005.thnfzt4zz4yrba34@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170515124005.thnfzt4zz4yrba34@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 05/15/2017 08:40 AM, Jarkko Sakkinen wrote:
> On Wed, May 10, 2017 at 07:54:21PM -0400, Stefan Berger wrote:
>> Refactor tpm_transmit and pull out code sending the command
>> and receiving the response and put this into tpm_transfer.
>>
>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
>> ---
>>   drivers/char/tpm/tpm-interface.c | 121 +++++++++++++++++++++++----------------
>>   1 file changed, 73 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index 158c1db..263b6d1 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -370,67 +370,29 @@ static bool tpm_validate_command(struct tpm_chip *chip,
>>   }
>>   
>>   /**
>> - * tmp_transmit - Internal kernel interface to transmit TPM commands.
>> + * tmp_transfer - Send a TPM command to the TPM and receive response
>>    *
>>    * @chip: TPM chip to use
>>    * @buf: TPM command buffer
>> + * @count: size of the TPM command
>>    * @bufsiz: length of the TPM command buffer
>> - * @flags: tpm transmit flags - bitmap
>>    *
>>    * Return:
>> - *     0 when the operation is successful.
>> + *     >0 when the operation is successful; returns response length
>>    *     A negative number for system errors (errno).
>>    */
>> -ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
>> -		     u8 *buf, size_t bufsiz, unsigned int flags)
>> +ssize_t tpm_transfer(struct tpm_chip *chip, u8 *buf, u32 count, size_t bufsiz)
> Add instead a flag TPM_TRANSMIT_RAW (this name is just a suggestion)
> that skips "prepare" and "commit" parts. That would save us from a
> new export.
>
> Better way to make it less messy would be to add static functions
> tpm_prepare_command and tpm_commit_command that would be always
> called and would return immediately if flags contain TPM_TRANSMIT_RAW.

I'll do that then, modifying the code to skip tpm_validate_command as well.

    Stefan

>
> /Jarkko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

