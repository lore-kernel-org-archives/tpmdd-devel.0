From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 1/3] tpm: fix type of a local variable in tpm2_get_cc_attrs_tbl()
Date: Wed, 13 Sep 2017 10:26:20 -0700
Message-ID: <20170913172620.24829-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The local variable 'attrs' should have the type __be32 instead of u32.

Fixes: 58472f5cd4f6 ("tpm: validate TPM 2.0 commands")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm2-cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 70ee32816c48..f40d20671a78 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -980,7 +980,7 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
 {
 	struct tpm_buf buf;
 	u32 nr_commands;
-	u32 *attrs;
+	__be32 *attrs;
 	u32 cc;
 	int i;
 	int rc;
@@ -1020,7 +1020,7 @@ static int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip)
 
 	chip->nr_commands = nr_commands;
 
-	attrs = (u32 *)&buf.data[TPM_HEADER_SIZE + 9];
+	attrs = (__be32 *)&buf.data[TPM_HEADER_SIZE + 9];
 	for (i = 0; i < nr_commands; i++, attrs++) {
 		chip->cc_attrs_tbl[i] = be32_to_cpup(attrs);
 		cc = chip->cc_attrs_tbl[i] & 0xFFFF;
-- 
2.14.1
