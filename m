From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC v4 1/5] tpm: validate TPM 2.0 commands
Date: Mon, 23 Jan 2017 01:44:29 +0200
Message-ID: <20170122234438.12102-2-jarkko.sakkinen@linux.intel.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Check for every TPM 2.0 command that the command code is supported and
the command buffer has at least the length that can contain the header
and the handle area.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 37 +++++++++++++++++++++++++-
 drivers/char/tpm/tpm.h           | 27 ++++++++++++++++---
 drivers/char/tpm/tpm2-cmd.c      | 56 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 2ea16ab..21021cb 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,6 +328,41 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
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
+		nr_handles = 4 * ((attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0));
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
@@ -347,7 +382,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz < TPM_HEADER_SIZE)
+	if (!tpm_validate_command(chip, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 7216bd7..037def5 100644
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
@@ -191,6 +201,9 @@ struct tpm_chip {
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
+
+	u32 nr_commands;
+	u32 *cc_attrs_tbl;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -393,7 +406,8 @@ struct tpm_cmd_t {
  */
 
 enum tpm_buf_flags {
-	TPM_BUF_OVERFLOW	= BIT(0),
+	TPM_BUF_INITIALIZED	= BIT(0),
+	TPM_BUF_OVERFLOW	= BIT(1),
 };
 
 struct tpm_buf {
@@ -419,13 +433,17 @@ static inline int tpm_buf_init(struct tpm_buf *buf, u16 tag, u32 ordinal)
 	head->length = cpu_to_be32(sizeof(*head));
 	head->ordinal = cpu_to_be32(ordinal);
 
+	buf->flags = TPM_BUF_INITIALIZED;
+
 	return 0;
 }
 
 static inline void tpm_buf_destroy(struct tpm_buf *buf)
 {
-	kunmap(buf->data_page);
-	__free_page(buf->data_page);
+	if (buf->flags & TPM_BUF_INITIALIZED) {
+		kunmap(buf->data_page);
+		__free_page(buf->data_page);
+	}
 }
 
 static inline u32 tpm_buf_length(struct tpm_buf *buf)
@@ -546,4 +564,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
 void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
+int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index a0199f1..4cc0853 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -1001,7 +1001,11 @@ EXPORT_SYMBOL_GPL(tpm2_probe);
  */
 int tpm2_auto_startup(struct tpm_chip *chip)
 {
+	struct tpm_buf buf;
+	u32 nr_commands;
+	u32 *attrs;
 	int rc;
+	int i;
 
 	rc = tpm_get_timeouts(chip);
 	if (rc)
@@ -1025,8 +1029,60 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 		}
 	}
 
+	rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands, NULL);
+	if (rc)
+		goto out;
+
+	/* sanity check */
+	if (nr_commands > INT_MAX) {
+		rc = -E2BIG;
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
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0, NULL);
+	if (rc < 0) {
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
+	for (i = 0; i < nr_commands; i++, attrs++)
+		chip->cc_attrs_tbl[i] = be32_to_cpup(attrs);
+
+	tpm_buf_destroy(&buf);
+
 out:
 	if (rc > 0)
 		rc = -ENODEV;
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
