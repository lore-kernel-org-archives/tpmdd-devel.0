From: Thiebaud Weksteen <tweek@google.com>
Subject: [PATCH v3 5/5] tpm: parse TPM event logs based on EFI table
Date: Wed, 20 Sep 2017 10:13:40 +0200
Message-ID: <20170920081340.7413-6-tweek@google.com>
References: <20170920081340.7413-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170920081340.7413-1-tweek@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, linux-kernel@vger.kernel.org, mjg59@google.com, peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd@selhorst.net, Thiebaud Weksteen <tweek@google.com>
List-Id: tpmdd-devel@lists.sourceforge.net

If we are not able to retrieve the TPM event logs from the ACPI table,
check the EFI configuration table (Linux-specific GUID).

The format version of the log is now returned by the provider function.

Signed-off-by: Thiebaud Weksteen <tweek@google.com>
---
 drivers/char/tpm/Makefile            |  1 +
 drivers/char/tpm/tpm.h               |  8 +++++
 drivers/char/tpm/tpm1_eventlog.c     | 11 ++++--
 drivers/char/tpm/tpm_eventlog_acpi.c |  2 +-
 drivers/char/tpm/tpm_eventlog_efi.c  | 66 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_eventlog_of.c   |  4 ++-
 6 files changed, 88 insertions(+), 4 deletions(-)
 create mode 100644 drivers/char/tpm/tpm_eventlog_efi.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index c8509cd723a1..e94ccecff4a5 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -6,6 +6,7 @@ tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
 	 tpm-dev-common.o tpmrm-dev.o tpm1_eventlog.o tpm2_eventlog.o \
          tpm2-space.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_eventlog_acpi.o
+tpm-$(CONFIG_EFI) += tpm_eventlog_efi.o
 tpm-$(CONFIG_OF) += tpm_eventlog_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 46caccf6fd1a..1bd97e01df50 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -597,6 +597,14 @@ static inline int tpm_read_log_of(struct tpm_chip *chip)
 	return -ENODEV;
 }
 #endif
+#if defined(CONFIG_EFI)
+int tpm_read_log_efi(struct tpm_chip *chip);
+#else
+static inline int tpm_read_log_efi(struct tpm_chip *chip)
+{
+	return -ENODEV;
+}
+#endif
 
 int tpm_bios_log_setup(struct tpm_chip *chip);
 void tpm_bios_log_teardown(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm1_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
index d6f70f365443..add798bd69d0 100644
--- a/drivers/char/tpm/tpm1_eventlog.c
+++ b/drivers/char/tpm/tpm1_eventlog.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/seq_file.h>
+#include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/security.h>
 #include <linux/module.h>
@@ -371,6 +372,10 @@ static int tpm_read_log(struct tpm_chip *chip)
 	if (rc != -ENODEV)
 		return rc;
 
+	rc = tpm_read_log_efi(chip);
+	if (rc != -ENODEV)
+		return rc;
+
 	return tpm_read_log_of(chip);
 }
 
@@ -388,11 +393,13 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
 	unsigned int cnt;
+	int log_version;
 	int rc = 0;
 
 	rc = tpm_read_log(chip);
-	if (rc)
+	if (rc < 0)
 		return rc;
+	log_version = rc;
 
 	cnt = 0;
 	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
@@ -404,7 +411,7 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	cnt++;
 
 	chip->bin_log_seqops.chip = chip;
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2)
 		chip->bin_log_seqops.seqops =
 			&tpm2_binary_b_measurements_seqops;
 	else
diff --git a/drivers/char/tpm/tpm_eventlog_acpi.c b/drivers/char/tpm/tpm_eventlog_acpi.c
index acc990ba376a..66f19e93c216 100644
--- a/drivers/char/tpm/tpm_eventlog_acpi.c
+++ b/drivers/char/tpm/tpm_eventlog_acpi.c
@@ -102,7 +102,7 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	memcpy_fromio(log->bios_event_log, virt, len);
 
 	acpi_os_unmap_iomem(virt, len);
-	return 0;
+	return EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 
 err:
 	kfree(log->bios_event_log);
diff --git a/drivers/char/tpm/tpm_eventlog_efi.c b/drivers/char/tpm/tpm_eventlog_efi.c
new file mode 100644
index 000000000000..e3f9ffd341d2
--- /dev/null
+++ b/drivers/char/tpm/tpm_eventlog_efi.c
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2017 Google
+ *
+ * Authors:
+ *      Thiebaud Weksteen <tweek@google.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/efi.h>
+#include <linux/tpm_eventlog.h>
+
+#include "tpm.h"
+
+/* read binary bios log from EFI configuration table */
+int tpm_read_log_efi(struct tpm_chip *chip)
+{
+
+	struct linux_efi_tpm_eventlog *log_tbl;
+	struct tpm_bios_log *log;
+	u32 log_size;
+	u8 tpm_log_version;
+
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+		return -ENODEV;
+
+	if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
+		return -ENODEV;
+
+	log = &chip->log;
+
+	log_tbl = memremap(efi.tpm_log, sizeof(*log_tbl), MEMREMAP_WB);
+	if (!log_tbl) {
+		pr_err("Could not map UEFI TPM log table !\n");
+		return -ENOMEM;
+	}
+
+	log_size = log_tbl->size;
+	memunmap(log_tbl);
+
+	log_tbl = memremap(efi.tpm_log, sizeof(*log_tbl) + log_size,
+			   MEMREMAP_WB);
+	if (!log_tbl) {
+		pr_err("Could not map UEFI TPM log table payload!\n");
+		return -ENOMEM;
+	}
+
+	/* malloc EventLog space */
+	log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
+	if (!log->bios_event_log)
+		goto err_memunmap;
+	memcpy(log->bios_event_log, log_tbl->log, log_size);
+	log->bios_event_log_end = log->bios_event_log + log_size;
+
+	tpm_log_version = log_tbl->version;
+	memunmap(log_tbl);
+	return tpm_log_version;
+
+err_memunmap:
+	memunmap(log_tbl);
+	return -ENOMEM;
+}
diff --git a/drivers/char/tpm/tpm_eventlog_of.c b/drivers/char/tpm/tpm_eventlog_of.c
index 4a2f8c79231e..96fd5646f866 100644
--- a/drivers/char/tpm/tpm_eventlog_of.c
+++ b/drivers/char/tpm/tpm_eventlog_of.c
@@ -76,5 +76,7 @@ int tpm_read_log_of(struct tpm_chip *chip)
 
 	memcpy(log->bios_event_log, __va(base), size);
 
-	return 0;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return EFI_TCG2_EVENT_LOG_FORMAT_TCG_2;
+	return EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 }
-- 
2.14.1.821.g8fa685d3b7-goog
