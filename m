From: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 1/5] tpm: move tpm_eventlog.h outside of drivers folder
Date: Wed, 20 Sep 2017 10:13:36 +0200
Message-ID: <20170920081340.7413-2-tweek@google.com>
References: <20170920081340.7413-1-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170920081340.7413-1-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The generic definitions of data structures in tpm_eventlog.h are
required by other part of the kernel (namely, the EFI stub).

Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c                        |  3 +-
 drivers/char/tpm/tpm-interface.c                   |  2 +-
 drivers/char/tpm/tpm.h                             | 27 +++++++++++++++---
 drivers/char/tpm/tpm1_eventlog.c                   |  2 +-
 drivers/char/tpm/tpm2_eventlog.c                   |  2 +-
 drivers/char/tpm/tpm_acpi.c                        |  2 +-
 drivers/char/tpm/tpm_of.c                          |  2 +-
 {drivers/char/tpm => include/linux}/tpm_eventlog.h | 32 +++++-----------------
 8 files changed, 37 insertions(+), 35 deletions(-)
 rename {drivers/char/tpm => include/linux}/tpm_eventlog.h (77%)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 67ec9d3d04f5..de2680118181 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -26,8 +26,9 @@
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
 #include <linux/major.h>
+#include <linux/tpm_eventlog.h>
+
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 DEFINE_IDR(dev_nums_idr);
 static DEFINE_MUTEX(idr_lock);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fe597e6c55c4..bd7091d510bd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -30,9 +30,9 @@
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
 #include <linux/pm_runtime.h>
+#include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 #define TPM_MAX_ORDINAL 243
 #define TSC_MAX_ORDINAL 12
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 04fbff2edbf3..46caccf6fd1a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -34,6 +34,7 @@
 #include <linux/acpi.h>
 #include <linux/cdev.h>
 #include <linux/highmem.h>
+#include <linux/tpm_eventlog.h>
 #include <crypto/hash_info.h>
 
 #ifdef CONFIG_X86
@@ -397,10 +398,6 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
-struct tpm2_digest {
-	u16 alg_id;
-	u8 digest[SHA512_DIGEST_SIZE];
-} __packed;
 
 /* A string buffer type for constructing TPM commands. This is based on the
  * ideas of string buffer code in security/keys/trusted.h but is heap based
@@ -581,4 +578,26 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u32 cc,
 		       u8 *cmd);
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t *bufsiz);
+
+extern const struct seq_operations tpm2_binary_b_measurements_seqops;
+
+#if defined(CONFIG_ACPI)
+int tpm_read_log_acpi(struct tpm_chip *chip);
+#else
+static inline int tpm_read_log_acpi(struct tpm_chip *chip)
+{
+	return -ENODEV;
+}
+#endif
+#if defined(CONFIG_OF)
+int tpm_read_log_of(struct tpm_chip *chip);
+#else
+static inline int tpm_read_log_of(struct tpm_chip *chip)
+{
+	return -ENODEV;
+}
+#endif
+
+int tpm_bios_log_setup(struct tpm_chip *chip);
+void tpm_bios_log_teardown(struct tpm_chip *chip);
 #endif
diff --git a/drivers/char/tpm/tpm1_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
index 9a8605e500b5..d6f70f365443 100644
--- a/drivers/char/tpm/tpm1_eventlog.c
+++ b/drivers/char/tpm/tpm1_eventlog.c
@@ -25,9 +25,9 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 
 static const char* tcpa_event_type_strings[] = {
diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
index 34a8afa69138..1ce4411292ba 100644
--- a/drivers/char/tpm/tpm2_eventlog.c
+++ b/drivers/char/tpm/tpm2_eventlog.c
@@ -21,9 +21,9 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 /*
  * calc_tpm2_event_size() - calculate the event size, where event
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 169edf3ce86d..acc990ba376a 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -25,9 +25,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 struct acpi_tcpa {
 	struct acpi_table_header hdr;
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index aadb7f464076..4a2f8c79231e 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -17,9 +17,9 @@
 
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/tpm_eventlog.h>
 
 #include "tpm.h"
-#include "tpm_eventlog.h"
 
 int tpm_read_log_of(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm_eventlog.h b/include/linux/tpm_eventlog.h
similarity index 77%
rename from drivers/char/tpm/tpm_eventlog.h
rename to include/linux/tpm_eventlog.h
index b4b549559203..446656d1f317 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -1,6 +1,5 @@
-
-#ifndef __TPM_EVENTLOG_H__
-#define __TPM_EVENTLOG_H__
+#ifndef __LINUX_TPM_EVENTLOG_H__
+#define __LINUX_TPM_EVENTLOG_H__
 
 #include <crypto/hash_info.h>
 
@@ -104,6 +103,11 @@ struct tcg_event_field {
 	u8 event[0];
 } __packed;
 
+struct tpm2_digest {
+	u16 alg_id;
+	u8 digest[SHA512_DIGEST_SIZE];
+} __packed;
+
 struct tcg_pcr_event2 {
 	u32 pcr_idx;
 	u32 event_type;
@@ -112,26 +116,4 @@ struct tcg_pcr_event2 {
 	struct tcg_event_field event;
 } __packed;
 
-extern const struct seq_operations tpm2_binary_b_measurements_seqops;
-
-#if defined(CONFIG_ACPI)
-int tpm_read_log_acpi(struct tpm_chip *chip);
-#else
-static inline int tpm_read_log_acpi(struct tpm_chip *chip)
-{
-	return -ENODEV;
-}
-#endif
-#if defined(CONFIG_OF)
-int tpm_read_log_of(struct tpm_chip *chip);
-#else
-static inline int tpm_read_log_of(struct tpm_chip *chip)
-{
-	return -ENODEV;
-}
-#endif
-
-int tpm_bios_log_setup(struct tpm_chip *chip);
-void tpm_bios_log_teardown(struct tpm_chip *chip);
-
 #endif
-- 
2.14.1.821.g8fa685d3b7-goog
