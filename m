From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Mon,  2 Jan 2017 15:22:08 +0200
Message-ID: <20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170102132213.22880-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Check for every TPM 2.0 command that the command code is supported and
the command buffer has at least the length that can contain the header
and the handle area.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 32 +++++++++++++++++++++++++++++-
 drivers/char/tpm/tpm.h           | 15 +++++++++++++-
 drivers/char/tpm/tpm2-cmd.c      | 43 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 769d8b0..0794a5d3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,6 +328,36 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
+static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
+				 size_t len)
+{
+	const struct tpm_input_header *header = (const void *)cmd;
+	u32 cc;
+	size_t len_min = TPM_HEADER_SIZE;
+	u32 attrs;
+
+	if ((len >= len_min) && (chip->flags & TPM_CHIP_FLAG_TPM2) &&
+	    chip->nr_commands) {
+		cc = be32_to_cpu(header->ordinal);
+		if (!tpm2_find_cc_attrs(chip, cc, &attrs)) {
+			dev_dbg(&chip->dev, "0x%04x is an invalid command\n",
+				cc);
+			return false;
+		}
+		len_min +=
+			4 * ((attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0));
+	}
+
+	if (len < len_min) {
+		dev_dbg(&chip->dev,
+			"%s: insufficient command length %zu < %zu\n",
+			__func__, len, len_min);
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * tmp_transmit - Internal kernel interface to transmit TPM commands.
  *
@@ -347,7 +377,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz < TPM_HEADER_SIZE)
+	if (!tpm_validate_command(chip, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c74a663..ed21c2c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -127,7 +127,12 @@ enum tpm2_permanent_handles {
 };
 
 enum tpm2_capabilities {
-	TPM2_CAP_TPM_PROPERTIES = 6,
+	TPM2_CAP_COMMANDS	= 2,
+	TPM2_CAP_TPM_PROPERTIES	= 6,
+};
+
+enum tpm2_properties {
+	TPM_PT_TOTAL_COMMANDS	= 0x0129,
 };
 
 enum tpm2_startup_types {
@@ -135,6 +140,11 @@ enum tpm2_startup_types {
 	TPM2_SU_STATE	= 0x0001,
 };
 
+enum tpm2_cc_attrs {
+	TPM2_CC_ATTR_CHANDLES	= 25,
+	TPM2_CC_ATTR_RHANDLE	= 28,
+};
+
 #define TPM_VID_INTEL    0x8086
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
@@ -207,6 +217,8 @@ struct tpm_chip {
 #endif /* CONFIG_ACPI */
 
 	struct tpm_buf tr_buf;
+	u32 nr_commands;
+	u32 *cc_attrs_tbl;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -534,4 +546,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
 void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
+bool tpm2_find_cc_attrs(struct tpm_chip *chip, u32 cc, u32 *attrs);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index f0e0807..fa928c7 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -943,7 +943,9 @@ EXPORT_SYMBOL_GPL(tpm2_probe);
  */
 int tpm2_auto_startup(struct tpm_chip *chip)
 {
+	u32 nr_commands;
 	int rc;
+	int i;
 
 	rc = tpm_get_timeouts(chip);
 	if (rc)
@@ -967,8 +969,49 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 		}
 	}
 
+	rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands, NULL);
+	if (rc)
+		return rc;
+
+	chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
+					  GFP_KERNEL);
+
+	tpm_buf_init(&chip->tr_buf, TPM2_ST_NO_SESSIONS,
+		     TPM2_CC_GET_CAPABILITY);
+	tpm_buf_append_u32(&chip->tr_buf, TPM2_CAP_COMMANDS);
+	tpm_buf_append_u32(&chip->tr_buf, TPM2_CC_FIRST);
+	tpm_buf_append_u32(&chip->tr_buf, nr_commands);
+
+	rc = tpm_transmit_cmd(chip, chip->tr_buf.data, TPM_BUFSIZE, 0, NULL);
+	if (rc < 0)
+		goto out;
+
+	if (nr_commands !=
+	    be32_to_cpup((__be32 *)&chip->tr_buf.data[TPM_HEADER_SIZE + 5]))
+		return -EINVAL;
+
+	for (i = 0; i < nr_commands; i++)
+		chip->cc_attrs_tbl[i] = be32_to_cpup(
+			(u32 *)&chip->tr_buf.data[TPM_HEADER_SIZE + 9 + 4 * i]);
+
+	chip->nr_commands = nr_commands;
+
 out:
 	if (rc > 0)
 		rc = -ENODEV;
 	return rc;
 }
+
+bool tpm2_find_cc_attrs(struct tpm_chip *chip, u32 cc, u32 *attrs)
+{
+	int i;
+
+	for (i = 0; i < chip->nr_commands; i++) {
+		if (cc == (chip->cc_attrs_tbl[i] & GENMASK(15, 0))) {
+			*attrs = chip->cc_attrs_tbl[i];
+			return true;
+		}
+	}
+
+	return false;
+}
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
