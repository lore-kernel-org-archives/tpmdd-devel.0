From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 1/2] tpm: implement TPM 2.0 capability to get
	active PCR banks
Date: Sat,  8 Oct 2016 22:15:56 -0400
Message-ID: <1475979357-1167-2-git-send-email-nayna@linux.vnet.ibm.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1475979357-1167-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

As per the TCG 2.0 spec, the extend operation should be done to
all active PCR banks. However, current TPM 2.0 support doesn't
have the capability implemented to get active PCR banks.

This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
retrieve active PCR banks from the TPM.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c |  4 +++
 drivers/char/tpm/tpm.h      |  8 ++++-
 drivers/char/tpm/tpm2-cmd.c | 80 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2.h     | 35 ++++++++++++++++++++
 4 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 72715fa..667240b 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -27,6 +27,7 @@
 #include <linux/freezer.h>
 #include <linux/major.h>
 #include "tpm.h"
+#include "tpm2.h"
 #include "tpm_eventlog.h"
 
 DEFINE_IDR(dev_nums_idr);
@@ -364,6 +365,9 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
 
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_get_active_pcr_banks(chip);
+
 	rc = tpm_add_legacy_sysfs(chip);
 	if (rc) {
 		tpm_chip_unregister(chip);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 989227a..70f5ac4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -36,6 +36,9 @@
 #include <linux/highmem.h>
 
 #include "tpm_eventlog.h"
+#include "tpm2.h"
+
+#define TPM2_ACTIVE_BANKS_COUNT		HASH_COUNT
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -126,6 +129,7 @@ enum tpm2_permanent_handles {
 };
 
 enum tpm2_capabilities {
+	TPM2_CAP_PCRS		= 5,
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
@@ -167,6 +171,9 @@ struct tpm_chip {
 	int dev_num;		/* /dev/tpm# */
 	unsigned long is_open;	/* only one allowed */
 
+	int no_of_active_banks; /* Applicable on TPM2.0 */
+	enum tpm2_algorithms active_banks[TPM2_ACTIVE_BANKS_COUNT];
+
 	struct mutex tpm_mutex;	/* tpm is processing */
 
 	unsigned long timeout_a; /* jiffies */
@@ -526,7 +533,6 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
 #endif
 
 int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
-int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, const u8 *hash);
 int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max);
 int tpm2_seal_trusted(struct tpm_chip *chip,
 		      struct trusted_key_payload *payload,
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 7df55d5..c597cf3c 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -100,6 +100,8 @@ union tpm2_cmd_params {
 	struct	tpm2_pcr_extend_in	pcrextend_in;
 	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
 	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
+	struct  tpm2_get_cap_in         get_cap_in;
+	struct  tpm2_get_cap_out        get_cap_out;
 	struct	tpm2_get_random_in	getrandom_in;
 	struct	tpm2_get_random_out	getrandom_out;
 };
@@ -990,3 +992,81 @@ out:
 		rc = -ENODEV;
 	return rc;
 }
+
+#define TPM2_GET_CAPABILITY_IN_SIZE \
+	(sizeof(struct tpm_input_header) + \
+	 sizeof(struct tpm2_get_cap_in))
+
+static const struct tpm_input_header tpm2_get_capability_header = {
+	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
+	.length = cpu_to_be32(TPM2_GET_CAPABILITY_IN_SIZE),
+	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
+};
+
+int tpm2_get_capability(struct tpm_chip *chip, struct tpm2_get_cap_in *cap_in,
+			struct tpm2_get_cap_out *cap_out)
+{
+
+	struct tpm2_cmd cmd;
+	int rc;
+	u32 cap_id;
+
+	cmd.header.in = tpm2_get_capability_header;
+	cmd.params.get_cap_in.cap_id = cpu_to_be32(cap_in->cap_id);
+	cmd.params.get_cap_in.property_id = cpu_to_be32(cap_in->property_id);
+	cmd.params.get_cap_in.property_cnt = cpu_to_be32(cap_in->property_cnt);
+
+	rc = tpm_transmit_cmd(chip, (const char *) &cmd, sizeof(cmd), 0,
+			      "attempting get capability operation");
+	if (rc < 0)
+		return rc;
+	cap_id = be32_to_cpu(cmd.params.get_cap_out.cap_data.cap_id);
+
+	switch (cap_id) {
+	case TPM2_CAP_PCRS:
+		memcpy(&cap_out->cap_data, &cmd.params.get_cap_out.cap_data,
+		       sizeof(cmd.params.get_cap_out.cap_data));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return rc;
+}
+
+int tpm2_get_active_pcr_banks(struct tpm_chip *chip)
+{
+	struct tpm2_get_cap_in cap_in;
+	struct tpm2_get_cap_out cap_out;
+	struct tpm2_tpms_pcr_selection *pcr_selection;
+	void *marker;
+	u32 cap_id;
+	int rc, count, i;
+
+	cap_in.cap_id = TPM2_CAP_PCRS;
+	cap_in.property_id = 0;
+	cap_in.property_cnt = 1;
+
+	rc = tpm2_get_capability(chip, &cap_in, &cap_out);
+
+	if (rc < 0)
+		return rc;
+
+	cap_id = be32_to_cpu(cap_out.cap_data.cap_id);
+	count = be32_to_cpu(cap_out.cap_data.data.assigned_pcr.count);
+	pcr_selection =
+		&cap_out.cap_data.data.assigned_pcr.pcr_selections[0];
+	marker = pcr_selection;
+	chip->no_of_active_banks = 0;
+
+	for (i = 0; (i < count) && (i < TPM2_ACTIVE_BANKS_COUNT); i++) {
+		memcpy(pcr_selection, marker, sizeof(*pcr_selection));
+		chip->active_banks[chip->no_of_active_banks] =
+			be16_to_cpu(pcr_selection->hash_alg);
+		chip->no_of_active_banks++;
+		marker = marker + sizeof(pcr_selection->hash_alg) + sizeof(u8)
+			+ sizeof(u8) * pcr_selection->size_of_select;
+	}
+
+	return rc;
+}
diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
index 399c15c..919fb05 100644
--- a/drivers/char/tpm/tpm2.h
+++ b/drivers/char/tpm/tpm2.h
@@ -74,6 +74,41 @@ struct tcg_pcr_event2 {
 	struct tcg_event_field		event;
 } __packed;
 
+struct tpm2_get_cap_in {
+	__be32 cap_id;
+	__be32 property_id;
+	__be32 property_cnt;
+} __packed;
+
+struct tpm2_tpms_pcr_selection {
+	__be16  hash_alg;
+	u8      size_of_select;
+	u8      pcr_select[3];
+} __packed;
+
+struct tpm2_tpml_pcr_selection {
+	__be32 count;
+	struct tpm2_tpms_pcr_selection pcr_selections[HASH_COUNT];
+} __packed;
+
+union tpm2_tpmu_capabilities {
+	struct tpm2_tpml_pcr_selection assigned_pcr;
+} __packed;
+
+struct tpm2_tpms_capability_data {
+	__be32  cap_id;
+	union tpm2_tpmu_capabilities data;
+} __packed;
+
+struct tpm2_get_cap_out {
+	u8      more_data;
+	struct tpm2_tpms_capability_data cap_data;
+} __packed;
+
 extern const struct seq_operations tpm2_binary_b_measurments_seqops;
 
+extern int tpm2_get_active_pcr_banks(struct tpm_chip *chip);
+extern int tpm2_get_capability(struct tpm_chip *chip, struct tpm2_get_cap_in
+	*cap_in, struct tpm2_get_cap_out *cap_out);
+
 #endif
-- 
2.5.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
