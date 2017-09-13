From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 2/3] tpm: fix type of a local variable in tpm2_map_command()
Date: Wed, 13 Sep 2017 10:26:36 -0700
Message-ID: <20170913172637.24934-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The local variable 'handle' should have the type __be32 instead of u32.

Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm2-space.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index e2e059d8ffec..4e4014eabdb9 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -242,7 +242,7 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd)
 	struct tpm_space *space = &chip->work_space;
 	unsigned int nr_handles;
 	u32 attrs;
-	u32 *handle;
+	__be32 *handle;
 	int i;
 
 	i = tpm2_find_cc(chip, cc);
@@ -252,7 +252,7 @@ static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd)
 	attrs = chip->cc_attrs_tbl[i];
 	nr_handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
 
-	handle = (u32 *)&cmd[TPM_HEADER_SIZE];
+	handle = (__be32 *)&cmd[TPM_HEADER_SIZE];
 	for (i = 0; i < nr_handles; i++, handle++) {
 		if ((be32_to_cpu(*handle) & 0xFF000000) == TPM2_HT_TRANSIENT) {
 			if (!tpm2_map_to_phandle(space, handle))
-- 
2.14.1

