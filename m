From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 2/7] tpm: validate TPM 2.0 commands
Date: Fri,  3 Mar 2017 17:19:03 +0200
Message-ID: <20170303151912.14752-3-jarkko.sakkinen@linux.intel.com>
References: <20170303151912.14752-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170303151912.14752-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Check for every TPM 2.0 command that the command code is supported and
the command buffer has at least the length that can contain the header
and the handle area.

For ContextSave and FlushContext we mark the body to be part of the
handle area. This gives validation for these commands at zero
cost, including the body of the command.

The more important reason for this is that we can virtualize these
commands in the same way as you would virtualize the handle area of a
command.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Tested-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Reviewed-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 38 +++++++++++++++++-
 drivers/char/tpm/tpm.h           | 15 +++++++
 drivers/char/tpm/tpm2-cmd.c      | 84 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 132 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 708d356..20b1fe3 100644
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
@@ -348,7 +384,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (bufsiz < TPM_HEADER_SIZE)
+	if (!tpm_validate_command(chip, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4937b56..8568dda 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -114,6 +114,7 @@ enum tpm2_command_codes {
 	TPM2_CC_CREATE		= 0x0153,
 	TPM2_CC_LOAD		= 0x0157,
 	TPM2_CC_UNSEAL		= 0x015E,
+	TPM2_CC_CONTEXT_SAVE	= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT	= 0x0165,
 	TPM2_CC_GET_CAPABILITY	= 0x017A,
 	TPM2_CC_GET_RANDOM	= 0x017B,
@@ -127,15 +128,25 @@ enum tpm2_permanent_handles {
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
@@ -199,6 +210,9 @@ struct tpm_chip {
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
 #endif /* CONFIG_ACPI */
+
+	u32 nr_commands;
+	u32 *cc_attrs_tbl;
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
@@ -554,4 +568,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
 void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
+int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 881aea9..5efe9c4 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -1067,15 +1067,76 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 	return rc;
 }
 
+static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
+{
+	struct tpm_buf buf;
+	u32 nr_commands;
+	u32 *attrs;
+	u32 cc;
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
+		cc = chip->cc_attrs_tbl[i] & 0xFFFF;
+
+		if (cc == TPM2_CC_CONTEXT_SAVE || cc == TPM2_CC_FLUSH_CONTEXT) {
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
  * @chip: TPM chip to use
  *
- * Initializes timeout values for operation and command durations, conducts
- * a self-test and reads the list of active PCR banks.
- *
- * Return: 0 on success. Otherwise, a system error code is returned.
+ * Returns 0 on success, < 0 in case of fatal error.
  */
 int tpm2_auto_startup(struct tpm_chip *chip)
 {
@@ -1104,9 +1165,24 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 	}
 
 	rc = tpm2_get_pcr_allocation(chip);
+	if (rc)
+		goto out;
+
+	rc = tpm2_get_cc_attrs_tbl(chip);
 
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


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
