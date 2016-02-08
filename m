From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 3/5] Make tpm_startup() available
Date: Mon,  8 Feb 2016 14:27:06 -0500
Message-ID: <1454959628-30582-4-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1454959628-30582-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Make tpm_startup() available for others to call.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 8 +++-----
 drivers/char/tpm/tpm.h           | 7 +++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 792731e..cda8ef6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -474,24 +474,22 @@ void tpm_gen_interrupt(struct tpm_chip *chip)
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
 #define TPM_ORD_STARTUP cpu_to_be32(153)
-#define TPM_ST_CLEAR cpu_to_be16(1)
-#define TPM_ST_STATE cpu_to_be16(2)
-#define TPM_ST_DEACTIVATED cpu_to_be16(3)
 static const struct tpm_input_header tpm_startup_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(12),
 	.ordinal = TPM_ORD_STARTUP
 };
 
-static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
+int tpm_startup(struct tpm_chip *chip, u16 startup_type)
 {
 	struct tpm_cmd_t start_cmd;
 	start_cmd.header.in = tpm_startup_header;
 
-	start_cmd.params.startup_in.startup_type = startup_type;
+	start_cmd.params.startup_in.startup_type = cpu_to_be16(startup_type);
 	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
 				"attempting to start the TPM");
 }
+EXPORT_SYMBOL_GPL(tpm_startup);
 
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 2fb59f8..68510d8 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -383,6 +383,12 @@ struct tpm_startup_in {
 	__be16	startup_type;
 } __packed;
 
+enum tpm_startup_types {
+	TPM_ST_CLEAR		= 0x0001,
+	TPM_ST_STATE		= 0x0002,
+	TPM_ST_DEACTIVATED	= 0x0003,
+};
+
 typedef union {
 	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
@@ -505,6 +511,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
+extern int tpm_startup(struct tpm_chip *, u16 startup_type);
 extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
