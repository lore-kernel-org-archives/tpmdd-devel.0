From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/5] Call GetEventLog before ExitBootServices
Date: Thu, 21 Sep 2017 18:13:26 +0300
Message-ID: <20170921151325.gczzoebgcwdmndzn@linux.intel.com>
References: <20170920081340.7413-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170920081340.7413-1-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 20, 2017 at 10:13:35AM +0200, Thiebaud Weksteen wrote:
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
> Version 2:
> - Move tpm_eventlog.h to top include directory, add commit for this.
> - Use EFI_LOADER_DATA to store the configuration table
> - Whitespace and new lines fixes
> 
> Thiebaud Weksteen (5):
>   tpm: move tpm_eventlog.h outside of drivers folder
>   tpm: rename event log provider files
>   tpm: add event log format version
>   efi: call get_event_log before ExitBootServices
>   tpm: parse TPM event logs based on EFI table
> 
>  arch/x86/boot/compressed/eboot.c                   |  1 +
>  drivers/char/tpm/Makefile                          |  5 +-
>  drivers/char/tpm/tpm-chip.c                        |  3 +-
>  drivers/char/tpm/tpm-interface.c                   |  2 +-
>  drivers/char/tpm/tpm.h                             | 35 ++++++++--
>  drivers/char/tpm/tpm1_eventlog.c                   | 13 +++-
>  drivers/char/tpm/tpm2_eventlog.c                   |  2 +-
>  .../char/tpm/{tpm_acpi.c => tpm_eventlog_acpi.c}   |  4 +-
>  drivers/char/tpm/tpm_eventlog_efi.c                | 66 ++++++++++++++++++
>  drivers/char/tpm/{tpm_of.c => tpm_eventlog_of.c}   |  6 +-
>  drivers/firmware/efi/Makefile                      |  2 +-
>  drivers/firmware/efi/efi.c                         |  4 ++
>  drivers/firmware/efi/libstub/Makefile              |  3 +-
>  drivers/firmware/efi/libstub/tpm.c                 | 81 ++++++++++++++++++++++
>  drivers/firmware/efi/tpm.c                         | 40 +++++++++++
>  include/linux/efi.h                                | 46 ++++++++++++
>  {drivers/char/tpm => include/linux}/tpm_eventlog.h | 35 +++-------
>  17 files changed, 304 insertions(+), 44 deletions(-)
>  rename drivers/char/tpm/{tpm_acpi.c => tpm_eventlog_acpi.c} (97%)
>  create mode 100644 drivers/char/tpm/tpm_eventlog_efi.c
>  rename drivers/char/tpm/{tpm_of.c => tpm_eventlog_of.c} (93%)
>  create mode 100644 drivers/firmware/efi/tpm.c
>  rename {drivers/char/tpm => include/linux}/tpm_eventlog.h (77%)
> 
> -- 
> 2.14.1.821.g8fa685d3b7-goog
> 

Thank you. I'll have to postpone testing this at some point next week.

/Jarkko
