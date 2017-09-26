From: Javier Martinez Canillas <javierm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v3 0/5] Call GetEventLog before
 ExitBootServices
Date: Tue, 26 Sep 2017 13:17:27 +0200
Message-ID: <ef8f75aa-4e63-edef-f0d3-4793b0bc6b27@redhat.com>
References: <20170920081340.7413-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170920081340.7413-1-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 09/20/2017 10:13 AM, Thiebaud Weksteen via tpmdd-devel wrote:
> With TPM 1.2, the ACPI table ("TCPA") has two fields to recover the Event
> Log Area (LAML and LASA). These logs are useful to understand and rebuild
> the final values of PCRs.
> 
> With TPM 2.0, the ACPI table ("TPM2") does not contain these fields
> anymore. The recommended method is now to call the GetEventLog EFI
> protocol before ExitBootServices.
> 
> Implement this method within the EFI stub and create a copy of the logs
> for the TPM device using a Linux-specific EFI configuration table
> (LINUX_EFI_TPM_EVENT_LOG). This will create
> /sys/kernel/security/tpm0/binary_bios_measurements for TPM 2.0 devices
> (similarly to the current behaviour for TPM 1.2 devices).
> 
> Two formats for the log entries exist: TPM 1.2 (SHA1) and TPM 2.0 (Crypto
> Agile). This patch set only retrieves the first type of logs. The second
> type will be implemented in a subsequent patch set.
> 
> According to the specifications[1], once GetEventLog has been called,
> future events shall be stored in a separate EFI configuration table
> (EFI_TCG2_FINAL_EVENTS_TABLE). Events stored in this table are not
> processed in this patch set as they are stored in the Crypto Agile format.
> These could eventually be merged with the new table for a unified view
> of the logs from userspace.
> 
> [1] TCG EFI Protocol Specification, Revision 00.13, March 30, 2016
>     https://trustedcomputinggroup.org/wp-content/uploads/EFI-Protocol-Specification-rev13-160330final.pdf
> 
> -------------------------------------------------------------------------------
> 
> Patchset Changelog:
> 
> Version 3:
> - Move event log providers (acpi and of) to tpm_eventlog_*.c
> - Move efi changes from PATCH 3 to PATCH 2
> - Change return value of tpm_read_log_acpi and tpm_read_log_of
> - Change iounmap to memunmap calls
> - Use log_tbl as variable name for consistency
> - Fix kbuild failures
> 

Thanks for addressing the things I pointed out. For the whole patch-set:

Reviewed-by: Javier Martinez Canillas <javierm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Javier Martinez Canillas <javierm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
