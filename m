From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC] tpm: migrate pubek_show to struct tpm_buf
Date: Thu, 25 May 2017 14:11:04 -0700
Message-ID: <20170525211105.843-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Migrated pubek_show to struct tpm_buf.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
RFC because I cannot test this ATM.
 drivers/char/tpm/tpm-sysfs.c | 49 ++++++++++++++++++++------------------------
 drivers/char/tpm/tpm.h       | 13 ------------
 2 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 4bd0997cfa2d..bb5b2053137d 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -20,43 +20,37 @@
 #include <linux/device.h>
 #include "tpm.h"
 
-#define READ_PUBEK_RESULT_SIZE 314
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
+	struct tpm_buf tpm_buf;
 	u8 *data;
-	struct tpm_cmd_t tpm_cmd;
-	ssize_t err;
-	int i, rc;
+	ssize_t rc;
+	int i;
 	char *str = buf;
-
 	struct tpm_chip *chip = to_tpm_chip(dev);
+	char anti_replay[20];
 
-	tpm_cmd.header.in = tpm_readpubek_header;
-	err = tpm_transmit_cmd(chip, NULL, &tpm_cmd, READ_PUBEK_RESULT_SIZE,
+	rc = tpm_buf_init(&tpm_buf, TPM_TAG_RQU_COMMAND, TPM_ORD_READPUBEK);
+	if (rc)
+		return rc;
+
+	/* The checksum is ignored so it doesn't matter what the contents are.
+	 */
+	tpm_buf_append(&tpm_buf, anti_replay, sizeof(anti_replay));
+
+	rc = tpm_transmit_cmd(chip, NULL, tpm_buf.data, PAGE_SIZE,
 			       READ_PUBEK_RESULT_MIN_BODY_SIZE, 0,
 			       "attempting to read the PUBEK");
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
+	if (rc) {
+		tpm_buf_destroy(&tpm_buf);
+		return 0;
+	}
+
+	data = &tpm_buf.data[10];
 	str +=
 	    sprintf(str,
 		    "Algorithm: %02X %02X %02X %02X\n"
@@ -80,8 +74,9 @@ static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
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
index af05c1403c6e..5b79b7e06937 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -339,17 +339,6 @@ enum tpm_sub_capabilities {
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
@@ -383,8 +372,6 @@ struct tpm_startup_in {
 } __packed;
 
 typedef union {
-	struct	tpm_readpubek_params_out readpubek_out;
-	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_getrandom_in getrandom_in;
-- 
2.11.0

