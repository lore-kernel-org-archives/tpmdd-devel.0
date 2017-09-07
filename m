From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: [PATCH 1/2] efi: call get_event_log before ExitBootServices
Date: Thu, 7 Sep 2017 17:24:50 +0200
Message-ID: <20170907152450.eelrfyoipmtfr3x3@google.com>
References: <20170906142502.11783-1-tweek@google.com>
 <CAKv+Gu-HcjfcryRZsdigXG4-=9eFykHmS9Fw-ZgSeVt-d=mxxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-HcjfcryRZsdigXG4-=9eFykHmS9Fw-ZgSeVt-d=mxxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Ard,

Thanks for reviewing the patch. (Non-addressed comments are fixed in the
next patch set).

On Wed, Sep 06, 2017 at 03:53:33PM +0100, Ard Biesheuvel wrote:
> Hi Thiebaud,
> 
> On 6 September 2017 at 15:25, Thiebaud Weksteen <tweek@google.com> wrote:
> > With TPM 2.0, access to the event log is only possible by using the
> > EFI TPM2 Boot Service. Modify the EFI stub to copy the log area to a new
> > Linux-specific EFI table so it remains accessible for future use.
> >
> > Signed-off-by: Thiebaud Weksteen <tweek@google.com>
> > ---
> >  arch/x86/boot/compressed/eboot.c      |  1 +
> >  drivers/char/tpm/tpm.h                | 29 ++++++++++---
> >  drivers/char/tpm/tpm_eventlog.h       | 26 +++---------
> >  drivers/firmware/efi/libstub/Makefile |  3 +-
> >  drivers/firmware/efi/libstub/tpm.c    | 80 +++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h                   | 35 +++++++++++++++
> >  6 files changed, 146 insertions(+), 28 deletions(-)
> >
> 
> Why is this x86 only?

I haven't had a chance to test on ARM/ARM64 yet.

> 
> 
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index a1686f3dc295..97bec8df36ff 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -999,6 +999,7 @@ struct boot_params *efi_main(struct efi_config *c,
> >
> >         /* Ask the firmware to clear memory on unclean shutdown */
> >         efi_enable_reset_attack_mitigation(sys_table);
> > +       efi_retrieve_tpm2_eventlog(boot_params, sys_table);
> >
> >         setup_graphics(boot_params);
> >
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 04fbff2edbf3..efede7dc9340 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -40,6 +40,8 @@
> >  #include <asm/intel-family.h>
> >  #endif
> >
> > +#include "tpm_eventlog.h"
> > +
> >  enum tpm_const {
> >         TPM_MINOR = 224,        /* officially assigned */
> >         TPM_BUFSIZE = 4096,
> > @@ -397,11 +399,6 @@ struct tpm_cmd_t {
> >         tpm_cmd_params  params;
> >  } __packed;
> >
> > -struct tpm2_digest {
> > -       u16 alg_id;
> > -       u8 digest[SHA512_DIGEST_SIZE];
> > -} __packed;
> > -
> >  /* A string buffer type for constructing TPM commands. This is based on the
> >   * ideas of string buffer code in security/keys/trusted.h but is heap based
> >   * in order to keep the stack usage minimal.
> > @@ -581,4 +578,26 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
> >                        u8 *cmd);
> >  int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
> >                       u32 cc, u8 *buf, size_t *bufsiz);
> > +
> > +extern const struct seq_operations tpm2_binary_b_measurements_seqops;
> > +
> > +#if defined(CONFIG_ACPI)
> > +int tpm_read_log_acpi(struct tpm_chip *chip);
> > +#else
> > +static inline int tpm_read_log_acpi(struct tpm_chip *chip)
> > +{
> > +       return -ENODEV;
> > +}
> > +#endif
> > +#if defined(CONFIG_OF)
> > +int tpm_read_log_of(struct tpm_chip *chip);
> > +#else
> > +static inline int tpm_read_log_of(struct tpm_chip *chip)
> > +{
> > +       return -ENODEV;
> > +}
> > +#endif
> > +
> > +int tpm_bios_log_setup(struct tpm_chip *chip);
> > +void tpm_bios_log_teardown(struct tpm_chip *chip);
> >  #endif
> > diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> > index b4b549559203..1009a2503985 100644
> > --- a/drivers/char/tpm/tpm_eventlog.h
> > +++ b/drivers/char/tpm/tpm_eventlog.h
> > @@ -104,6 +104,11 @@ struct tcg_event_field {
> >         u8 event[0];
> >  } __packed;
> >
> > +struct tpm2_digest {
> > +       u16 alg_id;
> > +       u8 digest[SHA512_DIGEST_SIZE];
> > +} __packed;
> > +
> >  struct tcg_pcr_event2 {
> >         u32 pcr_idx;
> >         u32 event_type;
> > @@ -112,26 +117,5 @@ struct tcg_pcr_event2 {
> >         struct tcg_event_field event;
> >  } __packed;
> >
> > -extern const struct seq_operations tpm2_binary_b_measurements_seqops;
> > -
> > -#if defined(CONFIG_ACPI)
> > -int tpm_read_log_acpi(struct tpm_chip *chip);
> > -#else
> > -static inline int tpm_read_log_acpi(struct tpm_chip *chip)
> > -{
> > -       return -ENODEV;
> > -}
> > -#endif
> > -#if defined(CONFIG_OF)
> > -int tpm_read_log_of(struct tpm_chip *chip);
> > -#else
> > -static inline int tpm_read_log_of(struct tpm_chip *chip)
> > -{
> > -       return -ENODEV;
> > -}
> > -#endif
> > -
> > -int tpm_bios_log_setup(struct tpm_chip *chip);
> > -void tpm_bios_log_teardown(struct tpm_chip *chip);
> >
> >  #endif
> > diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> > index dedf9bde44db..2abe6d22dc5f 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -29,8 +29,7 @@ OBJECT_FILES_NON_STANDARD     := y
> >  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
> >  KCOV_INSTRUMENT                        := n
> >
> > -lib-y                          := efi-stub-helper.o gop.o secureboot.o
> > -lib-$(CONFIG_RESET_ATTACK_MITIGATION) += tpm.o
> > +lib-y                          := efi-stub-helper.o gop.o secureboot.o tpm.o
> >
> 
> Did you build test on ARM/arm64 as well?

I did not, but the next patch version build fine for both.

> 
> >  # include the stub's generic dependencies from lib/ when building for ARM/arm64
> >  arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
> > diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
> > index 6224cdbc9669..ba2cb68833fb 100644
> > --- a/drivers/firmware/efi/libstub/tpm.c
> > +++ b/drivers/firmware/efi/libstub/tpm.c
> > @@ -4,6 +4,7 @@
> >   * Copyright (C) 2016 CoreOS, Inc
> >   * Copyright (C) 2017 Google, Inc.
> >   *     Matthew Garrett <mjg59@google.com>
> > + *     Thiebaud Weksteen <tweek@google.com>
> >   *
> >   * This file is part of the Linux kernel, and is made available under the
> >   * terms of the GNU General Public License version 2.
> > @@ -12,7 +13,9 @@
> >  #include <asm/efi.h>
> >
> >  #include "efistub.h"
> > +#include "../../../char/tpm/tpm_eventlog.h"
> >
> > +#if IS_ENABLED(CONFIG_RESET_ATTACK_MITIGATION)
> 
> IS_ENABLED() is intended for C style if()s rather than preprocessor
> conditionals. Please replace with #ifdef
> 
> >  static const efi_char16_t efi_MemoryOverWriteRequest_name[] = {
> >         'M', 'e', 'm', 'o', 'r', 'y', 'O', 'v', 'e', 'r', 'w', 'r', 'i', 't',
> >         'e', 'R', 'e', 'q', 'u', 'e', 's', 't', 'C', 'o', 'n', 't', 'r', 'o',
> > @@ -56,3 +59,80 @@ void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
> >                     EFI_VARIABLE_BOOTSERVICE_ACCESS |
> >                     EFI_VARIABLE_RUNTIME_ACCESS, sizeof(val), &val);
> >  }
> > +
> > +#endif
> > +
> > +void efi_retrieve_tpm2_eventlog_1_2(struct boot_params *boot_params,
> 
> Does this function actually use struct boot_params?
> 
> > +                                   efi_system_table_t *sys_table_arg)
> > +{
> > +       efi_guid_t tcg2_guid = EFI_TCG2_PROTOCOL_GUID;
> > +       efi_guid_t linux_eventlog_guid = LINUX_EFI_TPM_EVENT_LOG_GUID;
> > +       efi_status_t status;
> > +       efi_physical_addr_t log_location, log_last_entry;
> > +       struct linux_efi_tpm_eventlog *log_tbl;
> > +       size_t log_size, last_entry_size;
> > +       efi_bool_t truncated;
> > +       void *tcg2_protocol;
> > +
> > +       status = efi_call_early(locate_protocol, &tcg2_guid, NULL,
> > +                       &tcg2_protocol);
> 
> Please indent appropriately.
> 
> > +       if (status != EFI_SUCCESS)
> > +               return;
> > +
> > +       status = efi_call_proto(efi_tcg2_protocol, get_event_log, tcg2_protocol,
> > +                               EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2,
> > +                               &log_location, &log_last_entry, &truncated);
> > +       if (status != EFI_SUCCESS)
> > +               return;
> > +
> > +       if (!log_location)
> > +               return;
> > +
> > +       /*
> > +        * If the logs are empty, we still populate the EFI table to surface
> 
> I am not a native English speaker, but 'to surface' sounds a bit awkward here.
> 
> > +        * this information to userland.
> > +        */
> > +       if (!log_last_entry) {
> > +               log_size = 0;
> > +       } else {
> > +               /*
> > +                * get_event_log only returns the address of the last entry.
> > +                * We need to calculate its size to deduce the full size of
> > +                * the logs.
> > +                */
> > +               last_entry_size = sizeof(struct tcpa_event) +
> > +                       ((struct tcpa_event *)log_last_entry)->event_size;
> > +               log_size = log_last_entry - log_location + last_entry_size;
> > +       }
> > +
> > +       /* Allocate space for the logs and copy them. */
> > +       status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
> 
> Why is this runtime services data? You are passing your own data
> across the UEFI / kernel handover, and so if you parse your config
> table early enough, you can just reserve this memory.
> 

I am simply following the specifications here: "In general, UEFI Configuration
Tables loaded at boot time (e.g., SMBIOS table) can be contained in memory of
type EfiRuntimeServicesData (recommended and the system firmware must not
request a virtual mapping), EfiBootServicesData, EfiACPIReclaimMemory or
EfiACPIMemoryNVS." [UEFI 2.6].

Although it is my own data, this is still an EFI configuration table
and as such must remain available once booted. If you have another
solution in mind, could you please be more explicit about how this would
look like?

> Runtime services data will be given a virtual mapping by the firmware
> so it is accessible to the firmware itself during runtime services
> invocations, and on ARM/arm64, we actually have to omit if from the
> ordinary direct mapping of memory, which may lead to page table
> fragmentation and increased TLB pressure.
> 
> In summary, don't use it as a convenience so you don'y have to think
> about when/how to reserve it from normal allocation by the kernel.
> 
> > +                               sizeof(*log_tbl) + log_size, &log_tbl);
> > +
> > +       if (status != EFI_SUCCESS) {
> > +               efi_printk(sys_table_arg,
> > +                          "Unable to allocate memory for event log\n");
> > +               return;
> > +       }
> > +
> > +       memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
> > +       log_tbl->size = log_size;
> > +       log_tbl->version = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
> > +       memcpy(log_tbl->log, (void *)log_location, log_size);
> > +
> > +       status = efi_call_early(install_configuration_table,
> > +                       &linux_eventlog_guid, log_tbl);
> 
> Indentation please.
> 
> > +       if (status != EFI_SUCCESS)
> > +               goto err_free;
> > +       return;
> > +
> > +err_free:
> > +       efi_call_early(free_pool, log_tbl);
> > +}
> > +
> > +void efi_retrieve_tpm2_eventlog(struct boot_params *boot_params,
> > +                               efi_system_table_t *sys_table_arg)
> > +{
> > +       /* Only try to retrieve the logs in 1.2 format. */
> > +       efi_retrieve_tpm2_eventlog_1_2(boot_params, sys_table_arg);
> > +}
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 8dc3d94a3e3c..5eaaa68ac58a 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -472,6 +472,26 @@ typedef struct {
> >         u64 get_all;
> >  } apple_properties_protocol_64_t;
> >
> > +typedef struct {
> > +       u32 get_capability;
> > +       u32 get_event_log;
> > +       u32 hash_log_extend_event;
> > +       u32 submit_command;
> > +       u32 get_active_pcr_banks;
> > +       u32 set_active_pcr_banks;
> > +       u32 get_result_of_set_active_pcr_banks;
> > +} efi_tcg2_protocol_32_t;
> > +
> > +typedef struct {
> > +       u64 get_capability;
> > +       u64 get_event_log;
> > +       u64 hash_log_extend_event;
> > +       u64 submit_command;
> > +       u64 get_active_pcr_banks;
> > +       u64 set_active_pcr_banks;
> > +       u64 get_result_of_set_active_pcr_banks;
> > +} efi_tcg2_protocol_64_t;
> > +
> >  /*
> >   * Types and defines for EFI ResetSystem
> >   */
> > @@ -622,6 +642,7 @@ void efi_native_runtime_setup(void);
> >  #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID       EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
> >  #define EFI_CONSOLE_OUT_DEVICE_GUID            EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> >  #define APPLE_PROPERTIES_PROTOCOL_GUID         EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
> > +#define EFI_TCG2_PROTOCOL_GUID                 EFI_GUID(0x607f766c, 0x7455, 0x42be,  0x93, 0x0b, 0xe4, 0xd7, 0x6d, 0xb2, 0x72, 0x0f)
> >
> >  #define EFI_IMAGE_SECURITY_DATABASE_GUID       EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
> >  #define EFI_SHIM_LOCK_GUID                     EFI_GUID(0x605dab50, 0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
> > @@ -634,6 +655,7 @@ void efi_native_runtime_setup(void);
> >  #define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID   EFI_GUID(0xe03fc20a, 0x85dc, 0x406e,  0xb9, 0x0e, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
> >  #define LINUX_EFI_LOADER_ENTRY_GUID            EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
> >  #define LINUX_EFI_RANDOM_SEED_TABLE_GUID       EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
> > +#define LINUX_EFI_TPM_EVENT_LOG_GUID           EFI_GUID(0xb7799cb0, 0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
> >
> >  typedef struct {
> >         efi_guid_t guid;
> > @@ -1504,6 +1526,9 @@ static inline void
> >  efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
> >  #endif
> >
> > +void efi_retrieve_tpm2_eventlog(struct boot_params *boot_params,
> > +                               efi_system_table_t *sys_table);
> > +
> >  /*
> >   * Arch code can implement the following three template macros, avoiding
> >   * reptition for the void/non-void return cases of {__,}efi_call_virt():
> > @@ -1571,4 +1596,14 @@ struct linux_efi_random_seed {
> >         u8      bits[];
> >  };
> >
> > +
> > +#define EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2 0x1
> > +#define EFI_TCG2_EVENT_LOG_FORMAT_TCG_2   0x2
> > +
> > +struct linux_efi_tpm_eventlog {
> > +       u32     size;
> > +       u8      version;
> > +       u8      log[];
> > +};
> > +
> >  #endif /* _LINUX_EFI_H */
> > --
> > 2.14.1.581.gf28d330327-goog
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
