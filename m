From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Call GetEventLog before ExitBootServices
Date: Fri, 3 Nov 2017 17:27:03 +0200
Message-ID: <20171103152703.f224mvtg3luubqa3@linux.intel.com>
References: <20170911100022.7251-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170911100022.7251-1-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 11, 2017 at 12:00:19PM +0200, Thiebaud Weksteen wrote:
> With TPM 1.2, the ACPI table ("TCPA") has two fields to recover the Event Log
> Area (LAML and LASA). These logs are useful to understand and rebuild the
> final values of PCRs.
> 
> With TPM 2.0, the ACPI table ("TPM2") does not contain these fields anymore.
> The recommended method is now to call the GetEventLog EFI protocol before
> ExitBootServices.
> 
> Implement this method within the EFI stub and create copy of the logs for the
> TPM device. This will create /sys/kernel/security/tpm0/binary_bios_measurements
> for TPM 2.0 devices (similarly to the current behaviour for TPM 1.2 devices).
> 
> -------------------------------------------------------------------------------
> 
> Patchset Changelog:
> 
> Version 2:
> - Move tpm_eventlog.h to top include directory, add commit for this.
> - Use EFI_LOADER_DATA to store the configuration table
> - Whitespace and new lines fixes
> 
> 
> Thiebaud Weksteen (3):
>   tpm: move tpm_eventlog.h outside of drivers folder
>   efi: call get_event_log before ExitBootServices
>   tpm: parse TPM event logs based on EFI table
> 
>  arch/x86/boot/compressed/eboot.c                   |  1 +
>  drivers/char/tpm/Makefile                          |  2 +-
>  drivers/char/tpm/tpm-chip.c                        |  3 +-
>  drivers/char/tpm/tpm-interface.c                   |  2 +-
>  drivers/char/tpm/tpm.h                             | 35 ++++++++--
>  drivers/char/tpm/tpm1_eventlog.c                   | 17 +++--
>  drivers/char/tpm/tpm2_eventlog.c                   |  2 +-
>  drivers/char/tpm/tpm_acpi.c                        |  2 +-
>  drivers/char/tpm/tpm_efi.c                         | 66 ++++++++++++++++++
>  drivers/char/tpm/tpm_of.c                          |  2 +-
>  drivers/firmware/efi/Makefile                      |  2 +-
>  drivers/firmware/efi/efi.c                         |  4 ++
>  drivers/firmware/efi/libstub/Makefile              |  3 +-
>  drivers/firmware/efi/libstub/tpm.c                 | 81 ++++++++++++++++++++++
>  drivers/firmware/efi/tpm.c                         | 39 +++++++++++
>  include/linux/efi.h                                | 50 +++++++++++++
>  {drivers/char/tpm => include/linux}/tpm_eventlog.h | 32 ++-------
>  17 files changed, 301 insertions(+), 42 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_efi.c
>  create mode 100644 drivers/firmware/efi/tpm.c
>  rename {drivers/char/tpm => include/linux}/tpm_eventlog.h (77%)
> 
> -- 
> 2.14.1.581.gf28d330327-goog
> 

Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1560T/Km9Ha9FPA@public.gmane.org>

/Jarkko
