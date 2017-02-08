From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 1/6] tpm: validate TPM 2.0 commands
Date: Wed,  8 Feb 2017 13:07:03 +0200
Message-ID: <20170208110713.14070-2-jarkko.sakkinen@linux.intel.com>
References: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170208110713.14070-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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
 drivers/char/tpm/tpm-interface.c | 38 +++++++++++++++++++-
 drivers/char/tpm/tpm.h           | 14 ++++++++
 drivers/char/tpm/tpm2-cmd.c      | 77 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 087748b..f760c48 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,6 +328,42 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
+static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
+				 size_t len)
+{
+	const struct tpm_input_header *header = (const void *)cmd;
+	int i;
+	u32 cc;
+	u32 attrs;
+	unsigned int nr_handles;
+
+	if (len < TPM_HEADER_SIZE)
+		return false;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2 && chip->nr_commands) {
+		cc = be32_to_cpu(header->ordinal);
+
+		i = tpm2_find_cc(chip, cc);
+		if (i < 0) {
+			dev_dbg(&chip->dev, "0x%04X is an invalid command\n",
+				cc);
+			return false;
+		}
+
+		attrs = chip->cc_attrs_tbl[i];
+		nr_handles =
+			4 * ((attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0));
+		if (len < TPM_HEADER_SIZE + 4 * nr_handles)
+			goto err_len;
+	}
+
+	return true;
+err_len:
+	dev_dbg(&chip->dev,
+		"%s: insufficient command length %zu", __func__, len);
+	return false;
+}
+
 /**
  * tmp_transmit - Internal kernel interface to transmit TPM commands.
  *
@@ -347,7 +383,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz < TPM_HEADER_SIZE)
+	if (!tpm_validate_command(chip, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 6b4e7aa..4f21e42 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -127,15 +127,25 @@ enum tpm2_permanent_handles {
 };
 
 enum tpm2_capabilities {
+	TPM2_CAP_COMMANDS	= 2,
 	TPM2_CAP_PCRS		= 5,
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_properties {
+	TPM_PT_TOTAL_COMMANDS	= 0x0129,
+};
+
 enum tpm2_startup_types {
 	TPM2_SU_CLEAR	= 0x0000,
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
@@ -199,6 +209,9 @@ struct tpm_chip {
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
+
+	u32 nr_commands;
+	u32 *cc_attrs_tbl;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -555,4 +568,5 @@ void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
+int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 10f97e6..fe57fce 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -997,6 +997,68 @@ int tpm2_probe(struct tpm_chip *chip)
 }
 EXPORT_SYMBOL_GPL(tpm2_probe);
 
+static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
+{
+	struct tpm_buf buf;
+	u32 nr_commands;
+	u32 *attrs;
+	int i;
+	int rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands, NULL);
+	if (rc)
+		goto out;
+
+	if (nr_commands > 0xFFFFF) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
+					  GFP_KERNEL);
+
+	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
+	if (rc)
+		goto out;
+
+	tpm_buf_append_u32(&buf, TPM2_CAP_COMMANDS);
+	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
+	tpm_buf_append_u32(&buf, nr_commands);
+
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 9 + 4 * nr_commands,
+			      0, NULL);
+	if (rc) {
+		tpm_buf_destroy(&buf);
+		goto out;
+	}
+
+	if (nr_commands !=
+	    be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE + 5])) {
+		tpm_buf_destroy(&buf);
+		goto out;
+	}
+
+	chip->nr_commands = nr_commands;
+
+	attrs = (u32 *)&buf.data[TPM_HEADER_SIZE + 9];
+	for (i = 0; i < nr_commands; i++, attrs++) {
+		chip->cc_attrs_tbl[i] = be32_to_cpup(attrs);
+		/* handle is in the body  */
+		if ((chip->cc_attrs_tbl[i] & 0xFFFF) == TPM2_CC_FLUSH_CONTEXT) {
+			chip->cc_attrs_tbl[i] &=
+				~(GENMASK(2, 0) << TPM2_CC_ATTR_CHANDLES);
+			chip->cc_attrs_tbl[i] |= 1 << TPM2_CC_ATTR_CHANDLES;
+		}
+	}
+
+	tpm_buf_destroy(&buf);
+
+out:
+	if (rc > 0)
+		rc = -ENODEV;
+	return rc;
+}
+
 /**
  * tpm2_auto_startup - Perform the standard automatic TPM initialization
  *                     sequence
@@ -1031,6 +1093,10 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	}
 
 	rc = tpm2_get_pcr_allocation(chip);
+	if (rc)
+		goto out;
+
+	rc = tpm2_get_cc_attrs_tbl(chip);
 
 out:
 	if (rc > 0)
@@ -1114,3 +1180,14 @@ ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 
 	return rc;
 }
+
+int tpm2_find_cc(struct tpm_chip *chip, u32 cc)
+{
+	int i;
+
+	for (i = 0; i < chip->nr_commands; i++)
+		if (cc == (chip->cc_attrs_tbl[i] & GENMASK(15, 0)))
+			return i;
+
+	return -1;
+}
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
