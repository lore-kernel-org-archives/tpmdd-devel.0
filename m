From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: surface TPM event log based on EFI table
Date: Wed, 6 Sep 2017 16:03:58 +0100
Message-ID: <CAKv+Gu9P+mP3GAp7StY85c8fjd4cEqUGwaL3ALgd7UhSC0tV0w@mail.gmail.com>
References: <20170906142502.11783-1-tweek@google.com> <20170906142502.11783-2-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170906142502.11783-2-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 6 September 2017 at 15:25, Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

No empty commit logs please. If you expect people to review your code,
you really need to explain what it does and why. On top of that, a
cover letter that summarizes it and keeps track of the changes between
submissions is highly appreciated as well.


> ---
>  drivers/char/tpm/Makefile        |  2 +-
>  drivers/char/tpm/tpm.h           |  8 +++++
>  drivers/char/tpm/tpm1_eventlog.c | 16 +++++++---
>  drivers/char/tpm/tpm_efi.c       | 66 ++++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_eventlog.h  |  1 -
>  drivers/firmware/efi/efi.c       |  2 ++
>  include/linux/efi.h              |  1 +
>  7 files changed, 90 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_efi.c
>
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 23681f01f95a..74182a63eef2 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -4,7 +4,7 @@
>  obj-$(CONFIG_TCG_TPM) += tpm.o
>  tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
>          tpm-dev-common.o tpmrm-dev.o tpm1_eventlog.o tpm2_eventlog.o \
> -         tpm2-space.o
> +         tpm2-space.o tpm_efi.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>  tpm-$(CONFIG_OF) += tpm_of.o
>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index efede7dc9340..8858b6467c0d 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -597,6 +597,14 @@ static inline int tpm_read_log_of(struct tpm_chip *chip)
>         return -ENODEV;
>  }
>  #endif
> +#if defined(CONFIG_EFI)
> +int tpm_read_log_efi(struct tpm_chip *chip);
> +#else
> +static inline int tpm_read_log_efi(struct tpm_chip *chip)
> +{
> +       return -ENODEV;
> +}
> +#endif
>
>  int tpm_bios_log_setup(struct tpm_chip *chip);
>  void tpm_bios_log_teardown(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm1_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
> index 9a8605e500b5..c7d9b10de97f 100644
> --- a/drivers/char/tpm/tpm1_eventlog.c
> +++ b/drivers/char/tpm/tpm1_eventlog.c
> @@ -21,6 +21,7 @@
>   */
>
>  #include <linux/seq_file.h>
> +#include <linux/efi.h>
>  #include <linux/fs.h>
>  #include <linux/security.h>
>  #include <linux/module.h>
> @@ -368,6 +369,10 @@ static int tpm_read_log(struct tpm_chip *chip)
>         }
>
>         rc = tpm_read_log_acpi(chip);
> +       if (rc != -ENODEV && rc != -EIO)

What is the logic here? Why is -EIO treated differently all of a sudden?

> +               return rc;
> +
> +       rc = tpm_read_log_efi(chip);
>         if (rc != -ENODEV)
>                 return rc;
>
> @@ -388,11 +393,13 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>  {
>         const char *name = dev_name(&chip->dev);
>         unsigned int cnt;
> -       int rc = 0;
> +       int rc = 0, log_version;
> +
>
>         rc = tpm_read_log(chip);
> -       if (rc)
> +       if (rc < 0)
>                 return rc;
> +       log_version = rc;
>
>         cnt = 0;
>         chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
> @@ -404,14 +411,15 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>         cnt++;
>
>         chip->bin_log_seqops.chip = chip;
> -       if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +
> +       if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
> +                       (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))

Indentation please

>                 chip->bin_log_seqops.seqops =
>                         &tpm2_binary_b_measurements_seqops;
>         else
>                 chip->bin_log_seqops.seqops =
>                         &tpm_binary_b_measurements_seqops;
>
> -

Spurious whitespace change.

>         chip->bios_dir[cnt] =
>             securityfs_create_file("binary_bios_measurements",
>                                    0440, chip->bios_dir[0],
> diff --git a/drivers/char/tpm/tpm_efi.c b/drivers/char/tpm/tpm_efi.c
> new file mode 100644
> index 000000000000..0ff070e5b4df
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_efi.c
> @@ -0,0 +1,66 @@
> +/*
> + * Copyright (C) 2017 Google
> + *
> + * Authors:
> + *      Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + */
> +
> +#include <linux/efi.h>
> +
> +#include "tpm.h"
> +#include "tpm_eventlog.h"
> +

In your previous patch, you include the latter into the former, so
this is redundant.

> +
> +/* read binary bios log from EFI configuration table */
> +int tpm_read_log_efi(struct tpm_chip *chip)
> +{
> +
> +       struct linux_efi_tpm_eventlog *log_tbl;
> +       struct tpm_bios_log *log;
> +       u32 log_size;
> +       u8 tpm_log_version;
> +
> +       if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> +               return -ENODEV;
> +
> +       if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
> +               return -ENODEV;
> +
> +       log = &chip->log;
> +
> +       log_tbl = ioremap(efi.tpm_log, sizeof(*log_tbl));

Use memremap for memory, not ioremap

> +       if (!log_tbl) {
> +               pr_err("Could not map UEFI TPM log table !\n");
> +               return -ENOMEM;
> +       }
> +
> +       log_size = log_tbl->size;
> +       iounmap(log_tbl);
> +
> +       log_tbl = ioremap(efi.tpm_log, sizeof(*log_tbl) + log_size);

Same here

> +       if (!log_tbl) {
> +               pr_err("Could not map UEFI TPM log table payload!\n");
> +               return -ENOMEM;
> +       }
> +
> +       /* malloc EventLog space */
> +       log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
> +       if (!log->bios_event_log)
> +               goto err_iounmap;
> +       memcpy(log->bios_event_log, log_tbl->log, log_size);
> +       log->bios_event_log_end = log->bios_event_log + log_size;
> +
> +       tpm_log_version = log_tbl->version;
> +       iounmap(log_tbl);
> +       return tpm_log_version;
> +
> +err_iounmap:
> +       iounmap(log_tbl);
> +       return -ENOMEM;
> +}
> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> index 1009a2503985..9144a8707d70 100644
> --- a/drivers/char/tpm/tpm_eventlog.h
> +++ b/drivers/char/tpm/tpm_eventlog.h
> @@ -117,5 +117,4 @@ struct tcg_pcr_event2 {
>         struct tcg_event_field event;
>  } __packed;
>
> -

Spurious whitespace change

>  #endif
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index f97f272e16ee..886f67f7519e 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -52,6 +52,7 @@ struct efi __read_mostly efi = {
>         .properties_table       = EFI_INVALID_TABLE_ADDR,
>         .mem_attr_table         = EFI_INVALID_TABLE_ADDR,
>         .rng_seed               = EFI_INVALID_TABLE_ADDR,
> +       .tpm_log                = EFI_INVALID_TABLE_ADDR
>  };
>  EXPORT_SYMBOL(efi);
>
> @@ -444,6 +445,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>         {EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
>         {EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
>         {LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
> +       {LINUX_EFI_TPM_EVENT_LOG_GUID, "TPMEventLog", &efi.tpm_log},
>         {NULL_GUID, NULL, NULL},
>  };
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 5eaaa68ac58a..277a2347fa34 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -930,6 +930,7 @@ extern struct efi {
>         unsigned long properties_table; /* properties table */
>         unsigned long mem_attr_table;   /* memory attributes table */
>         unsigned long rng_seed;         /* UEFI firmware random seed */
> +       unsigned long tpm_log;          /* TPM2 Event Log table */
>         efi_get_time_t *get_time;
>         efi_set_time_t *set_time;
>         efi_get_wakeup_time_t *get_wakeup_time;
> --
> 2.14.1.581.gf28d330327-goog
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
