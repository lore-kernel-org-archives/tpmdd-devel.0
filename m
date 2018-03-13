From: Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH 1/1] efi/libstub: tpm: zero initialize pointer variables
 for mixed mode
Date: Tue, 13 Mar 2018 16:10:32 +0100
Message-ID: <1a72c53b-76fe-a119-3283-0950b8f758e7@redhat.com>
References: <20180313140922.17266-1-ard.biesheuvel@linaro.org>
 <20180313140922.17266-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313140922.17266-2-ard.biesheuvel@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: hdegoede@redhat.com, tweek@google.com, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

[adding linux-integrity and tpmdd-devel since this was discussed in these ML too]

On 03/13/2018 03:09 PM, Ard Biesheuvel wrote:
> As reported by Jeremy, running the new TPM libstub code in mixed mode
> (i.e., 64-bit kernel on 32-bit UEFI) results in hangs when invoking
> the TCG2 protocol, or when accessing the log_tbl pool allocation.
> 
> The reason turns out to be that in both cases, the 64-bit pointer
> variables are not fully initialized by the 32-bit EFI code, and so
> we should take care to zero initialize these variables beforehand,
> or we'll end up dereferencing bogus pointers.
> 
> Reported-by: Jeremy Cline <jeremy@jcline.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/tpm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
> index da661bf8cb96..13c1edd37e96 100644
> --- a/drivers/firmware/efi/libstub/tpm.c
> +++ b/drivers/firmware/efi/libstub/tpm.c
> @@ -68,11 +68,11 @@ void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
>  	efi_guid_t linux_eventlog_guid = LINUX_EFI_TPM_EVENT_LOG_GUID;
>  	efi_status_t status;
>  	efi_physical_addr_t log_location, log_last_entry;
> -	struct linux_efi_tpm_eventlog *log_tbl;
> +	struct linux_efi_tpm_eventlog *log_tbl = NULL;
>  	unsigned long first_entry_addr, last_entry_addr;
>  	size_t log_size, last_entry_size;
>  	efi_bool_t truncated;
> -	void *tcg2_protocol;
> +	void *tcg2_protocol = NULL;
>  
>  	status = efi_call_early(locate_protocol, &tcg2_guid, NULL,
>  				&tcg2_protocol);
> 

Looks good to me.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
