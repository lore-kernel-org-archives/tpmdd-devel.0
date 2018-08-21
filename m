From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/23] TPM: Expose struct tpm_chip and related
 find_get and put functions
Date: Tue, 21 Aug 2018 16:57:16 +0100
Message-ID: <153486703636.13066.16209594327379341518.stgit@warthog.procyon.org.uk>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <153486700916.13066.12870860668352070081.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Expose struct tpm_chip and related find_get and put functions so that
TPM-using code can make sure it uses the same TPM for any related set of
operations.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-interface.c |   19 ++++++++++++++++---
 drivers/char/tpm/tpm.h           |    5 -----
 include/linux/tpm.h              |   10 ++++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index cfb9089887bd..b8f1df5b64fe 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -636,10 +636,11 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	return rc;
 }
 
-/*
- * tpm_chip_find_get - return tpm_chip for given chip number
+/**
+ * tpm_chip_find_get - Look up a TPM chip by device index
+ * @chip_num: The index number of the chip to use or TPM_ANY_NUM
  */
-static struct tpm_chip *tpm_chip_find_get(int chip_num)
+struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
 	struct tpm_chip *pos, *chip = NULL;
 
@@ -656,6 +657,18 @@ static struct tpm_chip *tpm_chip_find_get(int chip_num)
 	rcu_read_unlock();
 	return chip;
 }
+EXPORT_SYMBOL_GPL(tpm_chip_find_get);
+
+/**
+ * tpm_chip_put - Release a previously looked up TPM chip
+ * @chip: The chip to release
+ */
+void tpm_chip_put(struct tpm_chip *chip)
+{
+	if (chip)
+		module_put(chip->dev->driver->owner);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_put);
 
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
 #define READ_PCR_RESULT_SIZE 30
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e4d0888d2eab..df6ffceb3429 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -115,11 +115,6 @@ struct tpm_chip {
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
 
-static inline void tpm_chip_put(struct tpm_chip *chip)
-{
-	module_put(chip->dev->driver->owner);
-}
-
 static inline int tpm_read_index(int base, int index)
 {
 	outb(index, base);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 8350c538b486..44c8cad7132d 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -46,11 +46,21 @@ struct tpm_class_ops {
 
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
+extern struct tpm_chip *tpm_chip_find_get(int chip_num);
+extern void tpm_chip_put(struct tpm_chip *chip);
+
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
 extern int tpm_send(u32 chip_num, void *cmd, size_t buflen);
 extern int tpm_get_random(u32 chip_num, u8 *data, size_t max);
 #else
+static inline struct tpm_chip *tpm_chip_find_get(int chip_num)
+{
+	return NULL;
+}
+static inline void tpm_chip_put(struct tpm_chip *chip)
+{
+}
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
 }


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
