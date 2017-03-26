From: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
Subject: [PATCH] tpm: do handle area size validation only when TPM space used
Date: Mon, 27 Mar 2017 00:08:15 +0300
Message-ID: <20170326210815.21252-1-jarkko.sakkinen@iki.fi>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

In order to not cause backwards compatibility issues with
/dev/tpm0 disable handle area size validation if tpm_transmit
is not called with a TPM space.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
---
 drivers/char/tpm/tpm-interface.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bf0c3fa..158c1db 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,7 +328,9 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
-static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
+static bool tpm_validate_command(struct tpm_chip *chip,
+				 struct tpm_space *space,
+				 const u8 *cmd,
 				 size_t len)
 {
 	const struct tpm_input_header *header = (const void *)cmd;
@@ -340,6 +342,9 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
 	if (len < TPM_HEADER_SIZE)
 		return false;
 
+	if (!space)
+		return true;
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2 && chip->nr_commands) {
 		cc = be32_to_cpu(header->ordinal);
 
@@ -386,7 +391,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	unsigned long stop;
 	bool need_locality;
 
-	if (!tpm_validate_command(chip, buf, bufsiz))
+	if (!tpm_validate_command(chip, space, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
-- 
2.9.3

