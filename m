From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: remove tpm_read_index and
	tpm_write_index from tpm.h
Date: Wed, 25 Jan 2017 16:48:58 +0200
Message-ID: <20170125144858.24889-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

These are non-generic functions and do not belong to tpm.h.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h       | 11 -----------
 drivers/char/tpm/tpm_atmel.h |  6 ++++++
 drivers/char/tpm/tpm_nsc.c   | 12 ++++++++++++
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 7216bd7..244fcff 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -195,17 +195,6 @@ struct tpm_chip {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-static inline int tpm_read_index(int base, int index)
-{
-	outb(index, base);
-	return inb(base+1) & 0xFF;
-}
-
-static inline void tpm_write_index(int base, int index, int value)
-{
-	outb(index, base);
-	outb(value & 0xFF, base+1);
-}
 struct tpm_input_header {
 	__be16	tag;
 	__be32	length;
diff --git a/drivers/char/tpm/tpm_atmel.h b/drivers/char/tpm/tpm_atmel.h
index 4f96d80..5c82eb4 100644
--- a/drivers/char/tpm/tpm_atmel.h
+++ b/drivers/char/tpm/tpm_atmel.h
@@ -96,6 +96,12 @@ enum tpm_atmel_addr {
 	TPM_ATMEL_BASE_ADDR_HI = 0x09
 };
 
+static inline int tpm_read_index(int base, int index)
+{
+	outb(index, base);
+	return inb(base+1) & 0xFF;
+}
+
 /* Verify this is a 1.1 Atmel TPM */
 static int atmel_verify_tpm11(void)
 {
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 9ff0e07..5d6cce7 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -278,6 +278,18 @@ static struct platform_driver nsc_drv = {
 	},
 };
 
+static inline int tpm_read_index(int base, int index)
+{
+	outb(index, base);
+	return inb(base+1) & 0xFF;
+}
+
+static inline void tpm_write_index(int base, int index, int value)
+{
+	outb(index, base);
+	outb(value & 0xFF, base+1);
+}
+
 static int __init init_nsc(void)
 {
 	int rc = 0;
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
