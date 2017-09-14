From: Javier Martinez Canillas <javierm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v2 2/3] efi: call get_event_log before
 ExitBootServices
Date: Thu, 14 Sep 2017 12:24:29 +0200
Message-ID: <1f25ebdc-ab90-517f-b580-991a7cb5e25a@redhat.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-3-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911100022.7251-3-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 09/11/2017 12:00 PM, Thiebaud Weksteen via tpmdd-devel wrote:
> With TPM 2.0 specification, the event logs may only be accessible by
> calling an EFI Boot Service. Modify the EFI stub to copy the log area to
> a new Linux-specific EFI configuration table so it remains accessible
> once booted.
> 
> When calling this service, it is possible to specify the expected format
> of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only the
> first format is retrieved.
> 
> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---

[snip]

> +void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
> +{

[snip]

> +
> +	/* Allocate space for the logs and copy them. */
> +	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> +				sizeof(*log_tbl) + log_size,
> +				(void **) &log_tbl);
> +
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table_arg,
> +			   "Unable to allocate memory for event log\n");
> +		return;
> +	}

If this fails or any previous error that will prevent the event log table + logs
to be allocated, shouldn't tpm_read_log_efi() be notified somehow? Since AFAICT
it will still try to access them even if the EFI allocate_pool did not succeed.

> + */
> +int __init efi_tpm_eventlog_init(void)
> +{
> +	struct linux_efi_tpm_eventlog *tbl;
> +	unsigned int tbl_size;
> +

The functions efi_retrieve_tpm2_eventlog_1_2() and tpm_read_log_efi() are using
log_tbl as variable name, so I would use it here too for consistency.

> +	if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
> +		return 0;
> +
> +	tbl = early_memremap(efi.tpm_log, sizeof(*tbl));
> +	if (!tbl) {
> +		pr_err("Failed to map TPM Event Log table @ 0x%lx\n",
> +			efi.tpm_log);
> +		return -ENOMEM;
> +	}
> +

Same question than before, if this fails then the table + logs memory won't be
reserved but tpm_read_log_efi() will still try to access it. I'm not sure what
is the correct way to notify though, maybe setting efi.tpm_log to 0 and then in
tpm_read_log_efi() check efi.tpm_log for 0 or EFI_INVALID_TABLE_ADDR instead?

> +	tbl_size = sizeof(*tbl) + tbl->size;
> +	memblock_reserve(efi.tpm_log, tbl_size);
> +	early_memunmap(tbl, sizeof(*tbl));
> +	return 0;

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
