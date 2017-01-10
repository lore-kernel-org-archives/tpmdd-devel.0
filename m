From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v2] tpm: Check size of response before
 accessing data
Date: Tue, 10 Jan 2017 17:04:37 -0500
Message-ID: <1894ae73-4816-473f-9eff-76c1d67c5a3d@linux.vnet.ibm.com>
References: <1484079341-22088-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170110211029.GA26700@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170110211029.GA26700@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/10/2017 04:10 PM, Jason Gunthorpe wrote:
> On Tue, Jan 10, 2017 at 03:15:41PM -0500, Stefan Berger wrote:
>>   ssize_t tpm_transmit_cmd(struct tpm_chip *chip, const void *cmd,
>> -			 int len, unsigned int flags, const char *desc)
>> +			 int len, size_t min_rx_len,
> May as well make len size_t while you are here..
>
> The const void * is also wrong and should get fixed someday..
>
>>   ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
>> -		   const char *desc)
>> +		   const char *desc, size_t min_rx_length)
> Nicer to make min_rx_length into min_cap_length:
>
>> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, 0,
>> -			      desc);
>> +	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>> +			      min_rx_length, 0, desc);
> Then use 'TPM_HEADER_SIZE + min_cap_length'
>
>> -	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
>> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
>> +	                TPM_HEADER_SIZE + sizeof(cap.timeout));
> And this is just 'sizeof(cap.timeout)'

Done in v3.

    Stefan

