From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 1/3] tpm: move event log init functions to
 tpm_eventlog_init.c
Date: Thu, 24 Nov 2016 22:20:14 +0530
Message-ID: <58371A46.3090400@linux.vnet.ibm.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
 <20161123193830.GB13927@obsidianresearch.com>
 <58369E3F.40509@linux.vnet.ibm.com>
 <20161124164331.GA4930@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161124164331.GA4930@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/24/2016 10:13 PM, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2016 at 01:31:03PM +0530, Nayna wrote:
>
>>>> Since the initialization functions are common with the TPM 2.0 event
>>>> log support, this patch splits tpm_eventlog.c to have only TPM 1.2
>>>> event log parsing logic and moves the init functions into
>>>> tpm_eventlog_init.c.
>>>
>>> I think I'd rather see a tpm_eventlog1.c/tpm_eventlog2.c than this
>>> _init thing..
>>
>> Do you mean tpm_eventlog1.c for TPM 1.2 and tpm_eventlog2.c for TPM 2.0
>> event log specific parsing ?
>>
>> And if so, then which one should have the common functions for TPM 1.2 and
>> TPM 2.0?
>
> Leave them in tpm_eventlog.c ..

Sure. I am fine with that. I just feel that it bit of mixed up the scope 
of tpm_eventlog.c file, where it now also refers to TPM2, but have 
corresponding seq functions in separate file.

Thanks & Regards,
    - Nayna

>
> Jason
>

