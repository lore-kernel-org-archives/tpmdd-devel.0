From: Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [tpmdd-devel] [PATCH v2 2/3] efi: call get_event_log before
 ExitBootServices
Date: Mon, 18 Sep 2017 14:49:00 +0200
Message-ID: <e29971dc-c266-95a6-86fa-0459490ef754@redhat.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-3-tweek@google.com>
 <1f25ebdc-ab90-517f-b580-991a7cb5e25a@redhat.com>
 <CA+zpnLfewoD7H1hZzCnVKi09a6+DvfGY8ZhFTYuKKFTBgSgoOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+zpnLfewoD7H1hZzCnVKi09a6+DvfGY8ZhFTYuKKFTBgSgoOA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, jarkko.sakkinen@linux.intel.com, Peter Jones <pjones@redhat.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On 09/18/2017 02:11 PM, Thiebaud Weksteen wrote:
> On Thu, Sep 14, 2017 at 12:24 PM, Javier Martinez Canillas
> <javierm@redhat.com> wrote:
>> On 09/11/2017 12:00 PM, Thiebaud Weksteen via tpmdd-devel wrote:

[snip]

>>> +
>>> +     if (status != EFI_SUCCESS) {
>>> +             efi_printk(sys_table_arg,
>>> +                        "Unable to allocate memory for event log\n");
>>> +             return;
>>> +     }
>>
>> If this fails or any previous error that will prevent the event log table + logs
>> to be allocated, shouldn't tpm_read_log_efi() be notified somehow? Since AFAICT
>> it will still try to access them even if the EFI allocate_pool did not succeed.
>>
> 
> The implicit part that covers this case is in
> drivers/firmware/efi/efi.c. The match_config_table function will go
> through all the installed configuration tables and only fill up the
> associated member of the efi structure if it exists. In this case,
> .tpm_log will remains at EFI_INVALID_TABLE_ADDR unless
> efi_call_early(install_configuration_table, ...) is called. So no
> further processing is to be expected should the allocation failed.
>

I see, missed that. Thanks a lot for the explanation.

>>> + */
>>> +int __init efi_tpm_eventlog_init(void)
>>> +{
>>> +     struct linux_efi_tpm_eventlog *tbl;
>>> +     unsigned int tbl_size;
>>> +
>>
>> The functions efi_retrieve_tpm2_eventlog_1_2() and tpm_read_log_efi() are using
>> log_tbl as variable name, so I would use it here too for consistency.
>>
> 
> Done.
> 
>>> +     if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
>>> +             return 0;
>>> +
>>> +     tbl = early_memremap(efi.tpm_log, sizeof(*tbl));
>>> +     if (!tbl) {
>>> +             pr_err("Failed to map TPM Event Log table @ 0x%lx\n",
>>> +                     efi.tpm_log);
>>> +             return -ENOMEM;
>>> +     }
>>> +
>>
>> Same question than before, if this fails then the table + logs memory won't be
>> reserved but tpm_read_log_efi() will still try to access it. I'm not sure what
>> is the correct way to notify though, maybe setting efi.tpm_log to 0 and then in
>> tpm_read_log_efi() check efi.tpm_log for 0 or EFI_INVALID_TABLE_ADDR instead?
>>
> 
> That's right. To keep it simple, it might be easier to just set
> tpm_log to EFI_INVALID_TABLE_ADDR if that happens. Added in the next
> version of the patch set.
>

Right. I wasn't sure if you wanted to distinguish between the two cases, but that
is simpler indeed.

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
