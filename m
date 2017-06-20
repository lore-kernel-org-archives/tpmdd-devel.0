From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/2] tpm: migrate pubek_show to struct tpm_buf
Date: Tue, 20 Jun 2017 11:38:03 +0200
Message-ID: <20170620093804.23803-3-jarkko.sakkinen@linux.intel.com>
References: <20170620093804.23803-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170620093804.23803-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Migrated pubek_show to struct tpm_buf and cleaned up its implementation.
Previously the output parameter structure was declared but left
completely unused. Now it is used to refer different fields of the
output. We can move it to tpm-sysfs.c as it does not have any use
outside of that file.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-sysfs.c | 87 ++++++++++++++++++++++++--------------------
 drivers/char/tpm/tpm.h       | 13 -------
 2 files changed, 48 insertions(+), 52 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index eedb8e47bde2..fcb69f1162ab 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -20,44 +20,48 @@
 #include <linux/device.h>
 #include "tpm.h"
 
-#define READ_PUBEK_RESULT_SIZE 314
+struct tpm_readpubek_out {
+	u8 algorithm[4];
+	u8 encscheme[2];
+	u8 sigscheme[2];
+	__be32 paramsize;
+	u8 parameters[12];
+	__be32 keysize;
+	u8 modulus[256];
+	u8 checksum[20];
+} __packed;
+
 #define READ_PUBEK_RESULT_MIN_BODY_SIZE (28 + 256)
 #define TPM_ORD_READPUBEK 124
-static const struct tpm_input_header tpm_readpubek_header = {
-	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
-	.length = cpu_to_be32(30),
-	.ordinal = cpu_to_be32(TPM_ORD_READPUBEK)
-};
+
 static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	u8 *data;
-	struct tpm_cmd_t tpm_cmd;
-	ssize_t err;
-	int i, rc;
+	struct tpm_buf tpm_buf;
+	struct tpm_readpubek_out *out;
+	ssize_t rc;
+	int i;
 	char *str = buf;
 	struct tpm_chip *chip = to_tpm_chip(dev);
+	char anti_replay[20];
 
-	memset(&tpm_cmd, 0, sizeof(tpm_cmd));
-
-	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
-			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
-			       "attempting to read the PUBEK");
-	if (err)
-		goto out;
-
-	/*
-	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
-	   encscheme 16 bits
-	   sigscheme 16 bits
-	   parameters (RSA 12->bytes: keybit, #primes, expbit)
-	   keylenbytes 32 bits
-	   256 byte modulus
-	   ignore checksum 20 bytes
-	 */
-	data = tpm_cmd.params.readpubek_out_buffer;
+	memset(&anti_replay, 0, sizeof(anti_replay));
+
+	rc = tpm_buf_init(&tpm_buf, TPM_TAG_RQU_COMMAND, TPM_ORD_READPUBEK);
+	if (rc)
+		return rc;
+
+	tpm_buf_append(&tpm_buf, anti_replay, sizeof(anti_replay));
+
+	rc = tpm_transmit_cmd(chip, NULL, tpm_buf.data, PAGE_SIZE,
+			      READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
+			      "attempting to read the PUBEK");
+	if (rc) {
+		tpm_buf_destroy(&tpm_buf);
+		return 0;
+	}
+
+	out = (struct tpm_readpubek_out *)&tpm_buf.data[10];
 	str +=
 	    sprintf(str,
 		    "Algorithm: %02X %02X %02X %02X\n"
@@ -68,21 +72,26 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
 		    "%02X %02X %02X %02X\n"
 		    "Modulus length: %d\n"
 		    "Modulus:\n",
-		    data[0], data[1], data[2], data[3],
-		    data[4], data[5],
-		    data[6], data[7],
-		    data[12], data[13], data[14], data[15],
-		    data[16], data[17], data[18], data[19],
-		    data[20], data[21], data[22], data[23],
-		    be32_to_cpu(*((__be32 *) (data + 24))));
+		    out->algorithm[0], out->algorithm[1], out->algorithm[2],
+		    out->algorithm[3],
+		    out->encscheme[0], out->encscheme[1],
+		    out->sigscheme[0], out->sigscheme[1],
+		    out->parameters[0], out->parameters[1],
+		    out->parameters[2], out->parameters[3],
+		    out->parameters[4], out->parameters[5],
+		    out->parameters[6], out->parameters[7],
+		    out->parameters[8], out->parameters[9],
+		    out->parameters[10], out->parameters[11],
+		    be32_to_cpu(out->keysize));
 
 	for (i = 0; i < 256; i++) {
-		str += sprintf(str, "%02X ", data[i + 28]);
+		str += sprintf(str, "%02X ", out->modulus[i]);
 		if ((i + 1) % 16 == 0)
 			str += sprintf(str, "\n");
 	}
-out:
+
 	rc = str - buf;
+	tpm_buf_destroy(&tpm_buf);
 	return rc;
 }
 static DEVICE_ATTR_RO(pubek);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index cdd261383dea..d9835b31f652 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -343,17 +343,6 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
-struct	tpm_readpubek_params_out {
-	u8	algorithm[4];
-	u8	encscheme[2];
-	u8	sigscheme[2];
-	__be32	paramsize;
-	u8	parameters[12]; /*assuming RSA*/
-	__be32	keysize;
-	u8	modulus[256];
-	u8	checksum[20];
-} __packed;
-
 typedef union {
 	struct	tpm_input_header in;
 	struct	tpm_output_header out;
@@ -387,8 +376,6 @@ struct tpm_startup_in {
 } __packed;
 
 typedef union {
-	struct	tpm_readpubek_params_out readpubek_out;
-	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_getrandom_in getrandom_in;
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
