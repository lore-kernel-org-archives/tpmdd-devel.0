From: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Mon, 18 Sep 2017 14:33:19 +0200
Message-ID: <CA+zpnLffr6MRHmA_c4-siyE8Mo-mdxTaqg-tjkyHt__rZEXH2Q@mail.gmail.com>
References: <20170911100022.7251-1-tweek@google.com> <20170911100022.7251-4-tweek@google.com>
 <20170914184732.uiypaz4yft777oc7@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170914184732.uiypaz4yft777oc7-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 14, 2017 at 8:47 PM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> On Mon, Sep 11, 2017 at 12:00:22PM +0200, Thiebaud Weksteen wrote:
>> If we are not able to retrieve the TPM event logs from the ACPI table,
>> check the EFI configuration table (Linux-specific GUID).
>>
>> The format version of the log may be returned by the function. If not
>> specified (by previous implementation: tpm_acpi and tpm_of), we default
>> to the version of the chip (previous behaviour).
>>
>> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> You saw my comment about file naming. I.e. tpm_eventlog_efi.c would be
> a more senseful name.

Done.

>
>> ---
>>  drivers/char/tpm/Makefile        |  2 +-
>>  drivers/char/tpm/tpm.h           |  8 +++++
>>  drivers/char/tpm/tpm1_eventlog.c | 15 +++++++--
>>  drivers/char/tpm/tpm_efi.c       | 66 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/firmware/efi/efi.c       |  2 ++
>>  include/linux/efi.h              |  1 +
>>  6 files changed, 90 insertions(+), 4 deletions(-)
>>  create mode 100644 drivers/char/tpm/tpm_efi.c
>>
>> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>> index 23681f01f95a..74182a63eef2 100644
>> --- a/drivers/char/tpm/Makefile
>> +++ b/drivers/char/tpm/Makefile
>> @@ -4,7 +4,7 @@
>>  obj-$(CONFIG_TCG_TPM) += tpm.o
>>  tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
>>        tpm-dev-common.o tpmrm-dev.o tpm1_eventlog.o tpm2_eventlog.o \
>> -         tpm2-space.o
>> +         tpm2-space.o tpm_efi.o
>>  tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>>  tpm-$(CONFIG_OF) += tpm_of.o
>>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 46caccf6fd1a..1bd97e01df50 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -597,6 +597,14 @@ static inline int tpm_read_log_of(struct tpm_chip *chip)
>>       return -ENODEV;
>>  }
>>  #endif
>> +#if defined(CONFIG_EFI)
>> +int tpm_read_log_efi(struct tpm_chip *chip);
>> +#else
>> +static inline int tpm_read_log_efi(struct tpm_chip *chip)
>> +{
>> +     return -ENODEV;
>> +}
>> +#endif
>>
>>  int tpm_bios_log_setup(struct tpm_chip *chip);
>>  void tpm_bios_log_teardown(struct tpm_chip *chip);
>> diff --git a/drivers/char/tpm/tpm1_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
>> index d6f70f365443..7e25e6bff6ce 100644
>> --- a/drivers/char/tpm/tpm1_eventlog.c
>> +++ b/drivers/char/tpm/tpm1_eventlog.c
>> @@ -21,6 +21,7 @@
>>   */
>>
>>  #include <linux/seq_file.h>
>> +#include <linux/efi.h>
>>  #include <linux/fs.h>
>>  #include <linux/security.h>
>>  #include <linux/module.h>
>> @@ -371,6 +372,10 @@ static int tpm_read_log(struct tpm_chip *chip)
>>       if (rc != -ENODEV)
>>               return rc;
>>
>> +     rc = tpm_read_log_efi(chip);
>> +     if (rc != -ENODEV)
>> +             return rc;
>> +
>>       return tpm_read_log_of(chip);
>>  }
>>
>> @@ -388,11 +393,13 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>  {
>>       const char *name = dev_name(&chip->dev);
>>       unsigned int cnt;
>> -     int rc = 0;
>> +     int rc = 0, log_version;
>
> A tid bit, one declaration per line.

Done.

>
>> +
>>
>>       rc = tpm_read_log(chip);
>> -     if (rc)
>> +     if (rc < 0)
>>               return rc;
>> +     log_version = rc;
>>
>>       cnt = 0;
>>       chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
>> @@ -404,7 +411,9 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>       cnt++;
>>
>>       chip->bin_log_seqops.chip = chip;
>> -     if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +
>> +     if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
>> +         (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))
>>               chip->bin_log_seqops.seqops =
>>                       &tpm2_binary_b_measurements_seqops;
>>       else
>> diff --git a/drivers/char/tpm/tpm_efi.c b/drivers/char/tpm/tpm_efi.c
>> new file mode 100644
>> index 000000000000..c8247fc45bb0
>> --- /dev/null
>> +++ b/drivers/char/tpm/tpm_efi.c
>> @@ -0,0 +1,66 @@
>> +/*
>> + * Copyright (C) 2017 Google
>> + *
>> + * Authors:
>> + *      Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version
>> + * 2 of the License, or (at your option) any later version.
>> + *
>> + */
>> +
>> +#include <linux/efi.h>
>> +#include <linux/tpm_eventlog.h>
>> +
>> +#include "tpm.h"
>> +
>> +/* read binary bios log from EFI configuration table */
>> +int tpm_read_log_efi(struct tpm_chip *chip)
>> +{
>> +
>> +     struct linux_efi_tpm_eventlog *log_tbl;
>> +     struct tpm_bios_log *log;
>> +     u32 log_size;
>> +     u8 tpm_log_version;
>> +
>> +     if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>> +             return -ENODEV;
>> +
>> +     if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
>> +             return -ENODEV;
>> +
>> +     log = &chip->log;
>> +
>> +     log_tbl = memremap(efi.tpm_log, sizeof(*log_tbl), MEMREMAP_WB);
>> +     if (!log_tbl) {
>> +             pr_err("Could not map UEFI TPM log table !\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     log_size = log_tbl->size;
>> +     iounmap(log_tbl);
>> +
>> +     log_tbl = memremap(efi.tpm_log, sizeof(*log_tbl) + log_size,
>> +                        MEMREMAP_WB);
>> +     if (!log_tbl) {
>> +             pr_err("Could not map UEFI TPM log table payload!\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     /* malloc EventLog space */
>> +     log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
>> +     if (!log->bios_event_log)
>> +             goto err_iounmap;
>> +     memcpy(log->bios_event_log, log_tbl->log, log_size);
>> +     log->bios_event_log_end = log->bios_event_log + log_size;
>> +
>> +     tpm_log_version = log_tbl->version;
>> +     iounmap(log_tbl);
>> +     return tpm_log_version;
>> +
>> +err_iounmap:
>> +     iounmap(log_tbl);
>> +     return -ENOMEM;
>> +}
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index 03fbaf8eb248..0308acfaaf76 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -52,6 +52,7 @@ struct efi __read_mostly efi = {
>>       .properties_table       = EFI_INVALID_TABLE_ADDR,
>>       .mem_attr_table         = EFI_INVALID_TABLE_ADDR,
>>       .rng_seed               = EFI_INVALID_TABLE_ADDR,
>> +     .tpm_log                = EFI_INVALID_TABLE_ADDR
>>  };
>>  EXPORT_SYMBOL(efi);
>>
>> @@ -444,6 +445,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>>       {EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
>>       {EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
>>       {LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
>> +     {LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
>>       {NULL_GUID, NULL, NULL},
>>  };
>>
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index e671ea9a462e..ab78950e6911 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -943,6 +943,7 @@ extern struct efi {
>>       unsigned long properties_table; /* properties table */
>>       unsigned long mem_attr_table;   /* memory attributes table */
>>       unsigned long rng_seed;         /* UEFI firmware random seed */
>> +     unsigned long tpm_log;          /* TPM2 Event Log table */
>>       efi_get_time_t *get_time;
>>       efi_set_time_t *set_time;
>>       efi_get_wakeup_time_t *get_wakeup_time;
>> --
>> 2.14.1.581.gf28d330327-goog
>>
>
> I would not put efi changes to the same commit.

Done.

>
> I did not have too detailed look but code changes look nice and
> clean overally. I'll give this more detailed review once it is
> sent to linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and CC'd to
> linux-security-module-u79uwXL29TaiAVqoAR/hOA@public.gmane.org

Will do.

>
> /Jarkko
