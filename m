From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/4] tpm: reduce tpm_msleep() time in get_burstcount()
Date: Fri, 15 Sep 2017 18:10:49 +0530
Message-ID: <32b07575-a895-fe45-eba3-15e47adfbcac@linux.vnet.ibm.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-4-nayna@linux.vnet.ibm.com>
 <20170913010011.myvhrj2f4i3piphl@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170913010011.myvhrj2f4i3piphl@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net



On 09/13/2017 06:30 AM, Jarkko Sakkinen wrote:
> On Wed, Sep 06, 2017 at 08:56:38AM -0400, Nayna Jain wrote:
>> Currently, get_burstcount() function sleeps for 5msec in a loop
>> before retrying for next query to burstcount. However, if it takes
>> lesser time for TPM to return, this 5 msec delay is longer
>> than necessary.
>>
>> This patch replaces the tpm_msleep time from 5msec to 1msec.
>>
>> After this change, performance on a TPM 1.2 with an 8 byte
>> burstcount for 1000 extends improved from ~10sec to ~9sec.
>>
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>> ---
>>   drivers/char/tpm/tpm_tis_core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
>> index d1eab29cb447..d710bbc4608b 100644
>> --- a/drivers/char/tpm/tpm_tis_core.c
>> +++ b/drivers/char/tpm/tpm_tis_core.c
>> @@ -169,7 +169,7 @@ static int get_burstcount(struct tpm_chip *chip)
>>   		burstcnt = (value >> 8) & 0xFFFF;
>>   		if (burstcnt)
>>   			return burstcnt;
>> -		tpm_msleep(TPM_TIMEOUT);
>> +		tpm_msleep(1);
>>   	} while (time_before(jiffies, stop));
>>   	return -EBUSY;
>>   }
>> -- 
>> 2.13.3
> How did you pick 1 ms delay? Should there be a constant defining it?

As per ddwg input, the command may not take more than a few
microseconds. The minimum tpm_msleep() value is 1 msec, so we really
don't have a choice.  (We're working on a patch set to lower this
value even more.)

Thanks & Regards,
     - Nayna

>
> /Jarkko
>

