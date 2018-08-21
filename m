From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/23] TPM: Move ordinal values from interface
 file to header with other ordinals
Date: Tue, 21 Aug 2018 16:57:29 +0100
Message-ID: <153486704975.13066.1880897540173112691.stgit@warthog.procyon.org.uk>
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

Move the ordinal values (command IDs) from the tpm-interface.c file to the
tpm_command.h header where the other ordinal values are declared.  Use
cpu_to_be32() when the ordinal values are used, and not in their declarations.

The TPM_TAG_RQU_COMMAND definition in the internal tpm.h has to be removed
because it is a differently-defined duplicate label to avoid a clash.
cpu_to_be16() is then used in the places where it was used.

This allows the infineon TPM driver to use the constants directly in
tpm_inf_pnp_suspend().  The savestate buffer there can also be made static and
const.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm-interface.c |   48 +++++++++++++++++---------------------
 drivers/char/tpm/tpm-sysfs.c     |    8 +++---
 drivers/char/tpm/tpm.h           |    2 --
 drivers/char/tpm/tpm_infineon.c  |    6 ++---
 include/linux/tpm_command.h      |   19 +++++++++++----
 5 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 29c2ce5cfc69..9add6034c252 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/tpm_command.h>
 
 #include "tpm.h"
 #include "tpm_eventlog.h"
@@ -417,13 +418,11 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 }
 
 #define TPM_INTERNAL_RESULT_SIZE 200
-#define TPM_ORD_GET_CAP cpu_to_be32(101)
-#define TPM_ORD_GET_RANDOM cpu_to_be32(70)
 
 static const struct tpm_input_header tpm_getcap_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(22),
-	.ordinal = TPM_ORD_GET_CAP
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(22),
+	.ordinal = cpu_to_be32(TPM_ORD_GET_CAP),
 };
 
 ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
@@ -469,14 +468,13 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
-#define TPM_ORD_STARTUP cpu_to_be32(153)
 #define TPM_ST_CLEAR cpu_to_be16(1)
 #define TPM_ST_STATE cpu_to_be16(2)
 #define TPM_ST_DEACTIVATED cpu_to_be16(3)
 static const struct tpm_input_header tpm_startup_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(12),
-	.ordinal = TPM_ORD_STARTUP
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(12),
+	.ordinal = cpu_to_be32(TPM_ORD_STARTUP),
 };
 
 static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
@@ -609,12 +607,11 @@ duration:
 }
 EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 
-#define TPM_ORD_CONTINUE_SELFTEST 83
 #define CONTINUE_SELFTEST_RESULT_SIZE 10
 
 static struct tpm_input_header continue_selftest_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(10),
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(10),
 	.ordinal = cpu_to_be32(TPM_ORD_CONTINUE_SELFTEST),
 };
 
@@ -670,12 +667,11 @@ void tpm_chip_put(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm_chip_put);
 
-#define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
 #define READ_PCR_RESULT_SIZE 30
 static struct tpm_input_header pcrread_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(14),
-	.ordinal = TPM_ORDINAL_PCRREAD
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(14),
+	.ordinal = cpu_to_be32(TPM_ORD_PCR_READ),
 };
 
 /**
@@ -716,12 +712,11 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  * isn't, protect against the chip disappearing, by incrementing
  * the module usage count.
  */
-#define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
 #define EXTEND_PCR_RESULT_SIZE 34
 static struct tpm_input_header pcrextend_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(34),
-	.ordinal = TPM_ORD_PCR_EXTEND
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(34),
+	.ordinal = cpu_to_be32(TPM_ORD_PCR_EXTEND)
 };
 
 int tpm_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash)
@@ -889,13 +884,12 @@ void tpm_remove_hardware(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
-#define TPM_ORD_SAVESTATE cpu_to_be32(152)
 #define SAVESTATE_RESULT_SIZE 10
 
 static struct tpm_input_header savestate_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(10),
-	.ordinal = TPM_ORD_SAVESTATE
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(10),
+	.ordinal = cpu_to_be32(TPM_ORD_SAVESTATE),
 };
 
 /*
@@ -971,9 +965,9 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
 
 #define TPM_GETRANDOM_RESULT_SIZE	18
 static struct tpm_input_header tpm_getrandom_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(14),
-	.ordinal = TPM_ORD_GET_RANDOM
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(14),
+	.ordinal = cpu_to_be32(TPM_ORD_GET_RANDOM),
 };
 
 /**
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 507d8ab37ef1..d8da83a1d11c 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -18,6 +18,7 @@
  *
  */
 #include <linux/device.h>
+#include <linux/tpm_command.h>
 #include "tpm.h"
 
 /* XXX for now this helper is duplicated in tpm-interface.c */
@@ -40,11 +41,10 @@ static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 }
 
 #define READ_PUBEK_RESULT_SIZE 314
-#define TPM_ORD_READPUBEK cpu_to_be32(124)
 static struct tpm_input_header tpm_readpubek_header = {
-	.tag = TPM_TAG_RQU_COMMAND,
-	.length = cpu_to_be32(30),
-	.ordinal = TPM_ORD_READPUBEK
+	.tag	 = cpu_to_be16(TPM_TAG_RQU_COMMAND),
+	.length	 = cpu_to_be32(30),
+	.ordinal = cpu_to_be32(TPM_ORD_READPUBEK),
 };
 static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index df6ffceb3429..2a1be0ec2fbd 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -138,8 +138,6 @@ struct tpm_output_header {
 	__be32	return_code;
 } __packed;
 
-#define TPM_TAG_RQU_COMMAND cpu_to_be16(193)
-
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index dc0a2554034e..7daa3317e18d 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -591,10 +591,10 @@ static int tpm_inf_pnp_suspend(struct pnp_dev *dev, pm_message_t pm_state)
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 	int rc;
 	if (chip) {
-		u8 savestate[] = {
-			0, 193,	/* TPM_TAG_RQU_COMMAND */
+		static const u8 savestate[] = {
+			0, TPM_TAG_RQU_COMMAND,
 			0, 0, 0, 10,	/* blob length (in bytes) */
-			0, 0, 0, 152	/* TPM_ORD_SaveState */
+			0, 0, 0, TPM_ORD_SAVESTATE,
 		};
 		dev_info(&dev->dev, "saving TPM state\n");
 		rc = tpm_inf_send(chip, savestate, sizeof(savestate));
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 727512e249b5..a3e0bb670e62 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -15,11 +15,20 @@
 #define TPM_TAG_RSP_AUTH2_COMMAND       198
 
 /* Command Ordinals */
-#define TPM_ORD_GETRANDOM               70
-#define TPM_ORD_OSAP                    11
-#define TPM_ORD_OIAP                    10
-#define TPM_ORD_SEAL                    23
-#define TPM_ORD_UNSEAL                  24
+enum tpm_ordinal {
+	TPM_ORD_OSAP			= 11,
+	TPM_ORD_OIAP			= 10,
+	TPM_ORD_PCR_EXTEND		= 20,
+	TPM_ORD_PCR_READ		= 21,
+	TPM_ORD_SEAL			= 23,
+	TPM_ORD_UNSEAL			= 24,
+	TPM_ORD_GET_RANDOM		= 70,
+	TPM_ORD_CONTINUE_SELFTEST	= 83,
+	TPM_ORD_GET_CAP			= 101,
+	TPM_ORD_READPUBEK		= 124,
+	TPM_ORD_SAVESTATE		= 152,
+	TPM_ORD_STARTUP			= 153,
+};
 
 /* Other constants */
 #define SRKHANDLE                       0x40000000


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
