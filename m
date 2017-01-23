From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v9 2/2] tpm: add securityfs support for TPM
	2.0 firmware event log
Date: Mon, 23 Jan 2017 02:26:27 -0500
Message-ID: <1485156387-7735-3-git-send-email-nayna@linux.vnet.ibm.com>
References: <1485156387-7735-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1485156387-7735-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Unlike the device driver support for TPM 1.2, the TPM 2.0 does
not support the securityfs pseudo files for displaying the
firmware event log.

This patch enables support for providing the TPM 2.0 event log in
binary form. TPM 2.0 event log supports a crypto agile format that
records multiple digests, which is different from TPM 1.2. This
patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
event log parser which understand the TPM 2.0 crypto agile format.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/Makefile                          |   2 +-
 .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
 drivers/char/tpm/tpm2_eventlog.c                   | 203 +++++++++++++++++++++
 drivers/char/tpm/tpm_acpi.c                        |   3 +
 drivers/char/tpm/tpm_eventlog.h                    |  59 ++++++
 5 files changed, 287 insertions(+), 15 deletions(-)
 rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
 create mode 100644 drivers/char/tpm/tpm2_eventlog.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a05b1eb..3d386a8 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,7 +3,7 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
-		tpm_eventlog.o
+		tpm1_eventlog.o tpm2_eventlog.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
 tpm-$(CONFIG_OF) += tpm_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
similarity index 95%
rename from drivers/char/tpm/tpm_eventlog.c
rename to drivers/char/tpm/tpm1_eventlog.c
index 11bb113..9a8605e 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm1_eventlog.c
@@ -390,9 +390,6 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	unsigned int cnt;
 	int rc = 0;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return 0;
-
 	rc = tpm_read_log(chip);
 	if (rc)
 		return rc;
@@ -407,7 +404,13 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 	cnt++;
 
 	chip->bin_log_seqops.chip = chip;
-	chip->bin_log_seqops.seqops = &tpm_binary_b_measurements_seqops;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		chip->bin_log_seqops.seqops =
+			&tpm2_binary_b_measurements_seqops;
+	else
+		chip->bin_log_seqops.seqops =
+			&tpm_binary_b_measurements_seqops;
+
 
 	chip->bios_dir[cnt] =
 	    securityfs_create_file("binary_bios_measurements",
@@ -418,17 +421,21 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
 		goto err;
 	cnt++;
 
-	chip->ascii_log_seqops.chip = chip;
-	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurements_seqops;
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
 
-	chip->bios_dir[cnt] =
-	    securityfs_create_file("ascii_bios_measurements",
-				   0440, chip->bios_dir[0],
-				   (void *)&chip->ascii_log_seqops,
-				   &tpm_bios_measurements_ops);
-	if (IS_ERR(chip->bios_dir[cnt]))
-		goto err;
-	cnt++;
+		chip->ascii_log_seqops.chip = chip;
+		chip->ascii_log_seqops.seqops =
+			&tpm_ascii_b_measurements_seqops;
+
+		chip->bios_dir[cnt] =
+			securityfs_create_file("ascii_bios_measurements",
+					       0440, chip->bios_dir[0],
+					       (void *)&chip->ascii_log_seqops,
+					       &tpm_bios_measurements_ops);
+		if (IS_ERR(chip->bios_dir[cnt]))
+			goto err;
+		cnt++;
+	}
 
 	return 0;
 
diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
new file mode 100644
index 0000000..513897c
--- /dev/null
+++ b/drivers/char/tpm/tpm2_eventlog.c
@@ -0,0 +1,203 @@
+/*
+ * Copyright (C) 2016 IBM Corporation
+ *
+ * Authors:
+ *      Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
+ *
+ * Access to TPM 2.0 event log as written by Firmware.
+ * It assumes that writer of event log has followed TCG Specification
+ * for Family "2.0" and written the event data in little endian.
+ * With that, it doesn't need any endian conversion for structure
+ * content.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+/*
+ * calc_tpm2_event_size() - calculate the event size, where event
+ * is an entry in the TPM 2.0 event log. The event is of type Crypto
+ * Agile Log Entry Format as defined in TCG EFI Protocol Specification
+ * Family "2.0".
+
+ * @event: event whose size is to be calculated.
+ * @event_header: the first event in the event log.
+ *
+ * Returns size of the event. If it is an invalid event, returns 0.
+ */
+static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
+				struct tcg_pcr_event *event_header)
+{
+	struct tcg_efi_specid_event *efispecid;
+	struct tcg_event_field *event_field;
+	void *marker;
+	void *marker_start;
+	u32 halg_size;
+	size_t size;
+	u16 halg;
+	int i;
+	int j;
+
+	marker = event;
+	marker_start = marker;
+	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
+		+ sizeof(event->count);
+
+	efispecid = (struct tcg_efi_specid_event *)event_header->event;
+
+	for (i = 0; (i < event->count) && (i < TPM2_ACTIVE_PCR_BANKS);
+	     i++) {
+		halg_size = sizeof(event->digests[i].alg_id);
+		memcpy(&halg, marker, halg_size);
+		marker = marker + halg_size;
+		for (j = 0; (j < efispecid->num_algs); j++) {
+			if (halg == efispecid->digest_sizes[j].alg_id) {
+				marker = marker +
+					efispecid->digest_sizes[j].digest_size;
+				break;
+			}
+		}
+	}
+
+	event_field = (struct tcg_event_field *)marker;
+	marker = marker + sizeof(event_field->event_size)
+		+ event_field->event_size;
+	size = marker - marker_start;
+
+	if ((event->event_type == 0) && (event_field->event_size == 0))
+		return 0;
+
+	return size;
+}
+
+static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
+{
+	struct tpm_chip *chip = m->private;
+	struct tpm_bios_log *log = &chip->log;
+	void *addr = log->bios_event_log;
+	void *limit = log->bios_event_log_end;
+	struct tcg_pcr_event *event_header;
+	struct tcg_pcr_event2 *event;
+	size_t size;
+	int i;
+
+	event_header = addr;
+	size = sizeof(struct tcg_pcr_event) - sizeof(event_header->event)
+		+ event_header->event_size;
+
+	if (*pos == 0) {
+		if (addr + size < limit) {
+			if ((event_header->event_type == 0) &&
+			    (event_header->event_size == 0))
+				return NULL;
+			return SEQ_START_TOKEN;
+		}
+	}
+
+	if (*pos > 0) {
+		addr += size;
+		event = addr;
+		size = calc_tpm2_event_size(event, event_header);
+		if ((addr + size >=  limit) || (size == 0))
+			return NULL;
+	}
+
+	for (i = 0; i < (*pos - 1); i++) {
+		event = addr;
+		size = calc_tpm2_event_size(event, event_header);
+
+		if ((addr + size >= limit) || (size == 0))
+			return NULL;
+		addr += size;
+	}
+
+	return addr;
+}
+
+static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
+					 loff_t *pos)
+{
+	struct tcg_pcr_event *event_header;
+	struct tcg_pcr_event2 *event;
+	struct tpm_chip *chip = m->private;
+	struct tpm_bios_log *log = &chip->log;
+	void *limit = log->bios_event_log_end;
+	size_t event_size;
+	void *marker;
+
+	event_header = log->bios_event_log;
+
+	if (v == SEQ_START_TOKEN) {
+		event_size = sizeof(struct tcg_pcr_event) -
+			sizeof(event_header->event) + event_header->event_size;
+		marker = event_header;
+	} else {
+		event = v;
+		event_size = calc_tpm2_event_size(event, event_header);
+		if (event_size == 0)
+			return NULL;
+		marker = event;
+	}
+
+	marker = marker + event_size;
+	if (marker >= limit)
+		return NULL;
+	v = marker;
+	event = v;
+
+	event_size = calc_tpm2_event_size(event, event_header);
+	if (((v + event_size) >= limit) || (event_size == 0))
+		return NULL;
+
+	(*pos)++;
+	return v;
+}
+
+static void tpm2_bios_measurements_stop(struct seq_file *m, void *v)
+{
+}
+
+static int tpm2_binary_bios_measurements_show(struct seq_file *m, void *v)
+{
+	struct tpm_chip *chip = m->private;
+	struct tpm_bios_log *log = &chip->log;
+	struct tcg_pcr_event *event_header = log->bios_event_log;
+	struct tcg_pcr_event2 *event = v;
+	void *temp_ptr;
+	size_t size;
+
+	if (v == SEQ_START_TOKEN) {
+		size = sizeof(struct tcg_pcr_event) -
+			sizeof(event_header->event) + event_header->event_size;
+
+		temp_ptr = event_header;
+
+		if (size > 0)
+			seq_write(m, temp_ptr, size);
+	} else {
+		size = calc_tpm2_event_size(event, event_header);
+		temp_ptr = event;
+		if (size > 0)
+			seq_write(m, temp_ptr, size);
+	}
+
+	return 0;
+}
+
+const struct seq_operations tpm2_binary_b_measurements_seqops = {
+	.start = tpm2_bios_measurements_start,
+	.next = tpm2_bios_measurements_next,
+	.stop = tpm2_bios_measurements_stop,
+	.show = tpm2_binary_bios_measurements_show,
+};
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index b7718c9..169edf3 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -54,6 +54,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	u64 len, start;
 	struct tpm_bios_log *log;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return -ENODEV;
+
 	log = &chip->log;
 
 	/* Unfortuntely ACPI does not associate the event log with a specific
diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index 1660d74..8d43328 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -2,9 +2,12 @@
 #ifndef __TPM_EVENTLOG_H__
 #define __TPM_EVENTLOG_H__
 
+#include <crypto/hash_info.h>
+
 #define TCG_EVENT_NAME_LEN_MAX	255
 #define MAX_TEXT_EVENT		1000	/* Max event string length */
 #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
+#define TPM2_ACTIVE_PCR_BANKS	3
 
 #ifdef CONFIG_PPC64
 #define do_endian_conversion(x) be32_to_cpu(x)
@@ -73,6 +76,62 @@ enum tcpa_pc_event_ids {
 	HOST_TABLE_OF_DEVICES,
 };
 
+/*
+ * All the structures related to TPM 2.0 Event Log are taken from TCG EFI
+ * Protocol Specification, Family "2.0". Document is available on link
+ * http://www.trustedcomputinggroup.org/tcg-efi-protocol-specification/ .
+ * Information is also available on TCG PC Client Platform Firmware Profile
+ * Specification, Family "2.0".
+ * Detailed digest structures for TPM 2.0 are defined in document
+ * Trusted Platform Module Library Part 2: Structures, Family "2.0".
+ */
+
+struct tcg_efi_specid_event_algs {
+	u16 alg_id;
+	u16 digest_size;
+} __packed;
+
+struct tcg_efi_specid_event {
+	u8 signature[16];
+	u32 platform_class;
+	u8 spec_version_minor;
+	u8 spec_version_major;
+	u8 spec_errata;
+	u8 uintnsize;
+	u32 num_algs;
+	struct tcg_efi_specid_event_algs digest_sizes[TPM2_ACTIVE_PCR_BANKS];
+	u8 vendor_info_size;
+	u8 vendor_info[0];
+} __packed;
+
+struct tcg_pcr_event {
+	u32 pcr_idx;
+	u32 event_type;
+	u8 digest[20];
+	u32 event_size;
+	u8 event[0];
+} __packed;
+
+struct tpm2_digest {
+	u16 alg_id;
+	u8 digest[SHA512_DIGEST_SIZE];
+} __packed;
+
+struct tcg_event_field {
+	u32 event_size;
+	u8 event[0];
+} __packed;
+
+struct tcg_pcr_event2 {
+	u32 pcr_idx;
+	u32 event_type;
+	u32 count;
+	struct tpm2_digest digests[TPM2_ACTIVE_PCR_BANKS];
+	struct tcg_event_field event;
+} __packed;
+
+extern const struct seq_operations tpm2_binary_b_measurements_seqops;
+
 #if defined(CONFIG_ACPI)
 int tpm_read_log_acpi(struct tpm_chip *chip);
 #else
-- 
2.5.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
