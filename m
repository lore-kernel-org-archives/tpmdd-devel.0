From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Tue, 06 Mar 2018 10:15:25 +0000
Message-ID: <CA+zpnLf6fJC1z_WTqrV1OAjRqzFv8B-w+x+x=tzDkwF0Omc6mA@mail.gmail.com>
References: <20170920081340.7413-1-tweek@google.com> <20170920081340.7413-5-tweek@google.com>
 <CAJ+F1CKL7UBdhfDTu-RKOv5oy=qdeP8pEbn6_TudUs75ybeSQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJ+F1CKL7UBdhfDTu-RKOv5oy=qdeP8pEbn6_TudUs75ybeSQQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: marcandre.lureau@gmail.com
Cc: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, peterhuewe@gmx.de, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd@selhorst.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Mar 5, 2018 at 4:40 PM Marc-Andr=C3=A9 Lureau
<marcandre.lureau@gmail.com>
wrote:

> Hi Thiebaud

> On Wed, Sep 20, 2017 at 10:13 AM, Thiebaud Weksteen <tweek@google.com>
wrote:
> > With TPM 2.0 specification, the event logs may only be accessible by
> > calling an EFI Boot Service. Modify the EFI stub to copy the log area t=
o
> > a new Linux-specific EFI configuration table so it remains accessible
> > once booted.
> >
> > When calling this service, it is possible to specify the expected forma=
t
> > of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only
the
> > first format is retrieved.
> >

> Do you have plans to add support for the crypto-agile format? I am
> working on uefi/ovmf support, and I am wondering if it is at all
> necessary to add support for the 1.2 format. What do you think? I can
> eventually try to work on 2.0 format support.

Yes, this is definitely my intent. I am running low on free time for this
piece of work to happen just now though.

Thanks


> Thanks

> > Signed-off-by: Thiebaud Weksteen <tweek@google.com>
> > ---
> >  arch/x86/boot/compressed/eboot.c      |  1 +
> >  drivers/firmware/efi/Makefile         |  2 +-
> >  drivers/firmware/efi/efi.c            |  4 ++
> >  drivers/firmware/efi/libstub/Makefile |  3 +-
> >  drivers/firmware/efi/libstub/tpm.c    | 81
+++++++++++++++++++++++++++++++++++
> >  drivers/firmware/efi/tpm.c            | 40 +++++++++++++++++
> >  include/linux/efi.h                   | 46 ++++++++++++++++++++
> >  7 files changed, 174 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/firmware/efi/tpm.c
> >
> > diff --git a/arch/x86/boot/compressed/eboot.c
b/arch/x86/boot/compressed/eboot.c
> > index a1686f3dc295..ef6abe8b3788 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -999,6 +999,7 @@ struct boot_params *efi_main(struct efi_config *c,
> >
> >         /* Ask the firmware to clear memory on unclean shutdown */
> >         efi_enable_reset_attack_mitigation(sys_table);
> > +       efi_retrieve_tpm2_eventlog(sys_table);
> >
> >         setup_graphics(boot_params);
> >
> > diff --git a/drivers/firmware/efi/Makefile
b/drivers/firmware/efi/Makefile
> > index 0329d319d89a..2f074b5cde87 100644
> > --- a/drivers/firmware/efi/Makefile
> > +++ b/drivers/firmware/efi/Makefile
> > @@ -10,7 +10,7 @@
> >  KASAN_SANITIZE_runtime-wrappers.o      :=3D n
> >
> >  obj-$(CONFIG_ACPI_BGRT)                +=3D efi-bgrt.o
> > -obj-$(CONFIG_EFI)                      +=3D efi.o vars.o reboot.o
memattr.o
> > +obj-$(CONFIG_EFI)                      +=3D efi.o vars.o reboot.o
memattr.o tpm.o
> >  obj-$(CONFIG_EFI)                      +=3D capsule.o memmap.o
> >  obj-$(CONFIG_EFI_VARS)                 +=3D efivars.o
> >  obj-$(CONFIG_EFI_ESRT)                 +=3D esrt.o
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index f97f272e16ee..0308acfaaf76 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -52,6 +52,7 @@ struct efi __read_mostly efi =3D {
> >         .properties_table       =3D EFI_INVALID_TABLE_ADDR,
> >         .mem_attr_table         =3D EFI_INVALID_TABLE_ADDR,
> >         .rng_seed               =3D EFI_INVALID_TABLE_ADDR,
> > +       .tpm_log                =3D EFI_INVALID_TABLE_ADDR
> >  };
> >  EXPORT_SYMBOL(efi);
> >
> > @@ -444,6 +445,7 @@ static __initdata efi_config_table_type_t
common_tables[] =3D {
> >         {EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
> >         {EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR",
&efi.mem_attr_table},
> >         {LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
> > +       {LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
> >         {NULL_GUID, NULL, NULL},
> >  };
> >
> > @@ -532,6 +534,8 @@ int __init efi_config_parse_tables(void
*config_tables, int count, int sz,
> >         if (efi_enabled(EFI_MEMMAP))
> >                 efi_memattr_init();
> >
> > +       efi_tpm_eventlog_init();
> > +
> >         /* Parse the EFI Properties table if it exists */
> >         if (efi.properties_table !=3D EFI_INVALID_TABLE_ADDR) {
> >                 efi_properties_table_t *tbl;
> > diff --git a/drivers/firmware/efi/libstub/Makefile
b/drivers/firmware/efi/libstub/Makefile
> > index dedf9bde44db..2abe6d22dc5f 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -29,8 +29,7 @@ OBJECT_FILES_NON_STANDARD     :=3D y
> >  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
> >  KCOV_INSTRUMENT                        :=3D n
> >
> > -lib-y                          :=3D efi-stub-helper.o gop.o secureboot=
.o
> > -lib-$(CONFIG_RESET_ATTACK_MITIGATION) +=3D tpm.o
> > +lib-y                          :=3D efi-stub-helper.o gop.o secureboot=
.o
tpm.o
> >
> >  # include the stub's generic dependencies from lib/ when building for
ARM/arm64
> >  arm-deps :=3D fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c
fdt_sw.c sort.c
> > diff --git a/drivers/firmware/efi/libstub/tpm.c
b/drivers/firmware/efi/libstub/tpm.c
> > index 6224cdbc9669..da661bf8cb96 100644
> > --- a/drivers/firmware/efi/libstub/tpm.c
> > +++ b/drivers/firmware/efi/libstub/tpm.c
> > @@ -4,15 +4,18 @@
> >   * Copyright (C) 2016 CoreOS, Inc
> >   * Copyright (C) 2017 Google, Inc.
> >   *     Matthew Garrett <mjg59@google.com>
> > + *     Thiebaud Weksteen <tweek@google.com>
> >   *
> >   * This file is part of the Linux kernel, and is made available under
the
> >   * terms of the GNU General Public License version 2.
> >   */
> >  #include <linux/efi.h>
> > +#include <linux/tpm_eventlog.h>
> >  #include <asm/efi.h>
> >
> >  #include "efistub.h"
> >
> > +#ifdef CONFIG_RESET_ATTACK_MITIGATION
> >  static const efi_char16_t efi_MemoryOverWriteRequest_name[] =3D {
> >         'M', 'e', 'm', 'o', 'r', 'y', 'O', 'v', 'e', 'r', 'w', 'r',
'i', 't',
> >         'e', 'R', 'e', 'q', 'u', 'e', 's', 't', 'C', 'o', 'n', 't',
'r', 'o',
> > @@ -56,3 +59,81 @@ void
efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
> >                     EFI_VARIABLE_BOOTSERVICE_ACCESS |
> >                     EFI_VARIABLE_RUNTIME_ACCESS, sizeof(val), &val);
> >  }
> > +
> > +#endif
> > +
> > +void efi_retrieve_tpm2_eventlog_1_2(efi_system_table_t *sys_table_arg)
> > +{
> > +       efi_guid_t tcg2_guid =3D EFI_TCG2_PROTOCOL_GUID;
> > +       efi_guid_t linux_eventlog_guid =3D LINUX_EFI_TPM_EVENT_LOG_GUID=
;
> > +       efi_status_t status;
> > +       efi_physical_addr_t log_location, log_last_entry;
> > +       struct linux_efi_tpm_eventlog *log_tbl;
> > +       unsigned long first_entry_addr, last_entry_addr;
> > +       size_t log_size, last_entry_size;
> > +       efi_bool_t truncated;
> > +       void *tcg2_protocol;
> > +
> > +       status =3D efi_call_early(locate_protocol, &tcg2_guid, NULL,
> > +                               &tcg2_protocol);
> > +       if (status !=3D EFI_SUCCESS)
> > +               return;
> > +
> > +       status =3D efi_call_proto(efi_tcg2_protocol, get_event_log,
tcg2_protocol,
> > +                               EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2,
> > +                               &log_location, &log_last_entry,
&truncated);
> > +       if (status !=3D EFI_SUCCESS)
> > +               return;
> > +
> > +       if (!log_location)
> > +               return;
> > +       first_entry_addr =3D (unsigned long) log_location;
> > +
> > +       /*
> > +        * We populate the EFI table even if the logs are empty.
> > +        */
> > +       if (!log_last_entry) {
> > +               log_size =3D 0;
> > +       } else {
> > +               last_entry_addr =3D (unsigned long) log_last_entry;
> > +               /*
> > +                * get_event_log only returns the address of the last
entry.
> > +                * We need to calculate its size to deduce the full
size of
> > +                * the logs.
> > +                */
> > +               last_entry_size =3D sizeof(struct tcpa_event) +
> > +                       ((struct tcpa_event *)
last_entry_addr)->event_size;
> > +               log_size =3D log_last_entry - log_location +
last_entry_size;
> > +       }
> > +
> > +       /* Allocate space for the logs and copy them. */
> > +       status =3D efi_call_early(allocate_pool, EFI_LOADER_DATA,
> > +                               sizeof(*log_tbl) + log_size,
> > +                               (void **) &log_tbl);
> > +
> > +       if (status !=3D EFI_SUCCESS) {
> > +               efi_printk(sys_table_arg,
> > +                          "Unable to allocate memory for event log\n")=
;
> > +               return;
> > +       }
> > +
> > +       memset(log_tbl, 0, sizeof(*log_tbl) + log_size);
> > +       log_tbl->size =3D log_size;
> > +       log_tbl->version =3D EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
> > +       memcpy(log_tbl->log, (void *) first_entry_addr, log_size);
> > +
> > +       status =3D efi_call_early(install_configuration_table,
> > +                               &linux_eventlog_guid, log_tbl);
> > +       if (status !=3D EFI_SUCCESS)
> > +               goto err_free;
> > +       return;
> > +
> > +err_free:
> > +       efi_call_early(free_pool, log_tbl);
> > +}
> > +
> > +void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table_arg)
> > +{
> > +       /* Only try to retrieve the logs in 1.2 format. */
> > +       efi_retrieve_tpm2_eventlog_1_2(sys_table_arg);
> > +}
> > diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
> > new file mode 100644
> > index 000000000000..0cbeb3d46b18
> > --- /dev/null
> > +++ b/drivers/firmware/efi/tpm.c
> > @@ -0,0 +1,40 @@
> > +/*
> > + * Copyright (C) 2017 Google, Inc.
> > + *     Thiebaud Weksteen <tweek@google.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modif=
y
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/efi.h>
> > +#include <linux/init.h>
> > +#include <linux/memblock.h>
> > +
> > +#include <asm/early_ioremap.h>
> > +
> > +/*
> > + * Reserve the memory associated with the TPM Event Log configuration
table.
> > + */
> > +int __init efi_tpm_eventlog_init(void)
> > +{
> > +       struct linux_efi_tpm_eventlog *log_tbl;
> > +       unsigned int tbl_size;
> > +
> > +       if (efi.tpm_log =3D=3D EFI_INVALID_TABLE_ADDR)
> > +               return 0;
> > +
> > +       log_tbl =3D early_memremap(efi.tpm_log, sizeof(*log_tbl));
> > +       if (!log_tbl) {
> > +               pr_err("Failed to map TPM Event Log table @ 0x%lx\n",
> > +                       efi.tpm_log);
> > +               efi.tpm_log =3D EFI_INVALID_TABLE_ADDR;
> > +               return -ENOMEM;
> > +       }
> > +
> > +       tbl_size =3D sizeof(*log_tbl) + log_tbl->size;
> > +       memblock_reserve(efi.tpm_log, tbl_size);
> > +       early_memunmap(log_tbl, sizeof(*log_tbl));
> > +       return 0;
> > +}
> > +
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 8dc3d94a3e3c..c5805eb601b1 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -472,6 +472,39 @@ typedef struct {
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
> > +typedef u32 efi_tcg2_event_log_format;
> > +
> > +typedef struct {
> > +       void *get_capability;
> > +       efi_status_t (*get_event_log)(efi_handle_t,
efi_tcg2_event_log_format,
> > +               efi_physical_addr_t *, efi_physical_addr_t *,
efi_bool_t *);
> > +       void *hash_log_extend_event;
> > +       void *submit_command;
> > +       void *get_active_pcr_banks;
> > +       void *set_active_pcr_banks;
> > +       void *get_result_of_set_active_pcr_banks;
> > +} efi_tcg2_protocol_t;
> > +
> >  /*
> >   * Types and defines for EFI ResetSystem
> >   */
> > @@ -622,6 +655,7 @@ void efi_native_runtime_setup(void);
> >  #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID       EFI_GUID(0xdcfa911d,
0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
> >  #define EFI_CONSOLE_OUT_DEVICE_GUID            EFI_GUID(0xd3b36f2c,
0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> >  #define APPLE_PROPERTIES_PROTOCOL_GUID         EFI_GUID(0x91bd12fe,
0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
> > +#define EFI_TCG2_PROTOCOL_GUID                 EFI_GUID(0x607f766c,
0x7455, 0x42be,  0x93, 0x0b, 0xe4, 0xd7, 0x6d, 0xb2, 0x72, 0x0f)
> >
> >  #define EFI_IMAGE_SECURITY_DATABASE_GUID       EFI_GUID(0xd719b2cb,
0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
> >  #define EFI_SHIM_LOCK_GUID                     EFI_GUID(0x605dab50,
0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
> > @@ -634,6 +668,7 @@ void efi_native_runtime_setup(void);
> >  #define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID   EFI_GUID(0xe03fc20a,
0x85dc, 0x406e,  0xb9, 0x0e, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
> >  #define LINUX_EFI_LOADER_ENTRY_GUID            EFI_GUID(0x4a67b082,
0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
> >  #define LINUX_EFI_RANDOM_SEED_TABLE_GUID       EFI_GUID(0x1ce1e5bc,
0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
> > +#define LINUX_EFI_TPM_EVENT_LOG_GUID           EFI_GUID(0xb7799cb0,
0xeca2, 0x4943,  0x96, 0x67, 0x1f, 0xae, 0x07, 0xb7, 0x47, 0xfa)
> >
> >  typedef struct {
> >         efi_guid_t guid;
> > @@ -908,6 +943,7 @@ extern struct efi {
> >         unsigned long properties_table; /* properties table */
> >         unsigned long mem_attr_table;   /* memory attributes table */
> >         unsigned long rng_seed;         /* UEFI firmware random seed */
> > +       unsigned long tpm_log;          /* TPM2 Event Log table */
> >         efi_get_time_t *get_time;
> >         efi_set_time_t *set_time;
> >         efi_get_wakeup_time_t *get_wakeup_time;
> > @@ -1504,6 +1540,8 @@ static inline void
> >  efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
{ }
> >  #endif
> >
> > +void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table);
> > +
> >  /*
> >   * Arch code can implement the following three template macros,
avoiding
> >   * reptition for the void/non-void return cases of
{__,}efi_call_virt():
> > @@ -1571,4 +1609,12 @@ struct linux_efi_random_seed {
> >         u8      bits[];
> >  };
> >
> > +struct linux_efi_tpm_eventlog {
> > +       u32     size;
> > +       u8      version;
> > +       u8      log[];
> > +};
> > +
> > +extern int efi_tpm_eventlog_init(void);
> > +
> >  #endif /* _LINUX_EFI_H */
> > --
> > 2.14.1.821.g8fa685d3b7-goog
> >



> --
> Marc-Andr=C3=A9 Lureau
