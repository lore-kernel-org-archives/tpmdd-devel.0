From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 4/6] tpm: replace TPM algorithms IDs with tpm_pcr_bank_info structs in tpm_chip
Date: Wed, 21 Jun 2017 16:29:39 +0200
Message-ID: <20170621142941.32674-5-roberto.sassu@huawei.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621142941.32674-1-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch replaces the array of TPM algorithms ID, stored in the tpm_chip
structure, with an array of the new structure tpm_pcr_bank_info.

The array is initialized during the execution of tpm2_get_pcr_allocation(),
by tpm2_init_pcr_bank_info().

tpm2_pcr_extend() and tpm_pcr_extend() have been modified to use the
digest size retrieved from the TPM instead of that from the crypto
subsystem.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/char/tpm/tpm-interface.c |  4 ++--
 drivers/char/tpm/tpm.h           |  2 +-
 drivers/char/tpm/tpm2-cmd.c      | 22 +++++++++++-----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d2b4df6..a11598a 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -897,8 +897,8 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 		memset(digest_list, 0, sizeof(digest_list));
 
 		for (i = 0; i < ARRAY_SIZE(chip->active_banks) &&
-			    chip->active_banks[i] != TPM2_ALG_ERROR; i++) {
-			digest_list[i].alg_id = chip->active_banks[i];
+		     chip->active_banks[i].alg_id != TPM2_ALG_ERROR; i++) {
+			digest_list[i].alg_id = chip->active_banks[i].alg_id;
 			memcpy(digest_list[i].digest, hash, TPM_DIGEST_SIZE);
 			count++;
 		}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 62c600d..d285bc6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -208,7 +208,7 @@ struct tpm_chip {
 	const struct attribute_group *groups[3];
 	unsigned int groups_cnt;
 
-	u16 active_banks[7];
+	struct tpm_pcr_bank_info active_banks[7];
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 74a68ea..7bd2cf7 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -301,7 +301,6 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	struct tpm2_null_auth_area auth_area;
 	int rc;
 	int i;
-	int j;
 
 	if (count > ARRAY_SIZE(chip->active_banks))
 		return -EINVAL;
@@ -323,14 +322,10 @@ int tpm2_pcr_extend(struct tpm_chip *chip, int pcr_idx, u32 count,
 	tpm_buf_append_u32(&buf, count);
 
 	for (i = 0; i < count; i++) {
-		for (j = 0; j < ARRAY_SIZE(tpm2_hash_map); j++) {
-			if (digests[i].alg_id != tpm2_hash_map[j].tpm_id)
-				continue;
-			tpm_buf_append_u16(&buf, digests[i].alg_id);
-			tpm_buf_append(&buf, (const unsigned char
-					      *)&digests[i].digest,
-			       hash_digest_size[tpm2_hash_map[j].crypto_id]);
-		}
+		/* digests[i].alg_id == chip->active_banks[i].alg_id */
+		tpm_buf_append_u16(&buf, digests[i].alg_id);
+		tpm_buf_append(&buf, (const unsigned char *)&digests[i].digest,
+			       chip->active_banks[i].digest_size);
 	}
 
 	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 0, 0,
@@ -1076,7 +1071,12 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 		}
 
 		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
-		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
+		rc =  tpm2_init_pcr_bank_info(chip,
+					be16_to_cpu(pcr_selection.hash_alg),
+					&chip->active_banks[i]);
+		if (rc)
+			break;
+
 		sizeof_pcr_selection = sizeof(pcr_selection.hash_alg) +
 			sizeof(pcr_selection.size_of_select) +
 			pcr_selection.size_of_select;
@@ -1085,7 +1085,7 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
 
 out:
 	if (i < ARRAY_SIZE(chip->active_banks))
-		chip->active_banks[i] = TPM2_ALG_ERROR;
+		chip->active_banks[i].alg_id = TPM2_ALG_ERROR;
 
 	tpm_buf_destroy(&buf);
 
-- 
2.9.3
