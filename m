From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix type issues in tpm_getcap()
Date: Wed,  1 Feb 2017 19:53:47 +0200
Message-ID: <20170201175347.2035-1-jarkko.sakkinen@linux.intel.com>
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

There are two type issues associated with tpm_getcap().

You must not do arithmetic with __be32 or __le32 types because sometimes
it results incorrect results. Calculations must be done only with data
that is in CPU byte order. This commit migrates tpm_getcap() to struct
tpm_buf in order to sort out these issues.

The second issue is with struct cap_t as the size of the type bool is
assumed to be one byte. This commit sorts out the issue by changing the
type to u8.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
v2:
- Use struct tpm_buf.
- Merge the type change of 'owned' to this patch.
 drivers/char/tpm/tpm-interface.c | 33 ++++++++++++++++++---------------
 drivers/char/tpm/tpm.h           | 15 +--------------
 2 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 423938e..7af1e8c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -480,31 +480,34 @@ static const struct tpm_input_header tpm_getcap_header = {
 ssize_t tpm_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		   const char *desc, size_t min_cap_length)
 {
-	struct tpm_cmd_t tpm_cmd;
+	struct tpm_buf buf;
 	int rc;
 
-	tpm_cmd.header.in = tpm_getcap_header;
+	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_GET_CAP);
+	if (rc)
+		return rc;
+
 	if (subcap_id == TPM_CAP_VERSION_1_1 ||
 	    subcap_id == TPM_CAP_VERSION_1_2) {
-		tpm_cmd.params.getcap_in.cap = cpu_to_be32(subcap_id);
-		/*subcap field not necessary */
-		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(0);
-		tpm_cmd.header.in.length -= cpu_to_be32(sizeof(__be32));
+		tpm_buf_append_u32(&buf, subcap_id);
+		tpm_buf_append_u32(&buf, 0);
 	} else {
 		if (subcap_id == TPM_CAP_FLAG_PERM ||
 		    subcap_id == TPM_CAP_FLAG_VOL)
-			tpm_cmd.params.getcap_in.cap =
-				cpu_to_be32(TPM_CAP_FLAG);
+			tpm_buf_append_u32(&buf, TPM_CAP_FLAG);
 		else
-			tpm_cmd.params.getcap_in.cap =
-				cpu_to_be32(TPM_CAP_PROP);
-		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = cpu_to_be32(subcap_id);
+			tpm_buf_append_u32(&buf, TPM_CAP_PROP);
+
+		tpm_buf_append_u32(&buf, 4);
+		tpm_buf_append_u32(&buf, subcap_id);
 	}
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      min_cap_length, 0, desc);
+
+	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, min_cap_length, 0,
+			      desc);
 	if (!rc)
-		*cap = tpm_cmd.params.getcap_out.cap;
+		*cap = *(cap_t *)&buf.data[TPM_HEADER_SIZE + 4];
+
+	tpm_buf_destroy(&buf);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_getcap);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index bff37be..709e7d4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -281,7 +281,7 @@ struct permanent_flags_t {
 typedef union {
 	struct	permanent_flags_t perm_flags;
 	struct	stclear_flags_t	stclear_flags;
-	bool	owned;
+	u8	owned;
 	__be32	num_pcrs;
 	struct	tpm_version_t	tpm_version;
 	struct	tpm_version_1_2_t tpm_version_1_2;
@@ -307,17 +307,6 @@ enum tpm_sub_capabilities {
 	TPM_CAP_PROP_TIS_DURATION = 0x120,
 };
 
-struct	tpm_getcap_params_in {
-	__be32	cap;
-	__be32	subcap_size;
-	__be32	subcap;
-} __packed;
-
-struct	tpm_getcap_params_out {
-	__be32	cap_size;
-	cap_t	cap;
-} __packed;
-
 struct	tpm_readpubek_params_out {
 	u8	algorithm[4];
 	u8	encscheme[2];
@@ -367,10 +356,8 @@ struct tpm_startup_in {
 } __packed;
 
 typedef union {
-	struct	tpm_getcap_params_out getcap_out;
 	struct	tpm_readpubek_params_out readpubek_out;
 	u8	readpubek_out_buffer[sizeof(struct tpm_readpubek_params_out)];
-	struct	tpm_getcap_params_in getcap_in;
 	struct	tpm_pcrread_in	pcrread_in;
 	struct	tpm_pcrread_out	pcrread_out;
 	struct	tpm_pcrextend_in pcrextend_in;
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
