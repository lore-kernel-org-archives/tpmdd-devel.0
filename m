From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH 2/2] tpm-interface: Fix checks of buffer size
Date: Tue, 4 Jul 2017 15:54:19 +0200
Message-ID: <20170704135419.1692-2-Alexander.Steffen@infineon.com>
References: <20170704135419.1692-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170704135419.1692-1-Alexander.Steffen@infineon.com>
Sender: stable-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Alexander Steffen <Alexander.Steffen@infineon.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

bufsiz contains the length of the buffer, whereas bufvalid contains the
number of valid bytes within the buffer. Therefore, bufvalid should be used
as a limit when reading from the buffer and bufsize when writing to it.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
---
 drivers/char/tpm/tpm-interface.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index a452cd0..5ef8eb3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -393,19 +393,16 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	unsigned long stop;
 	bool need_locality;
 
-	if (!tpm_validate_command(chip, space, buf, bufsiz))
+	if (!tpm_validate_command(chip, space, buf, bufvalid))
 		return -EINVAL;
 
-	if (bufsiz > TPM_BUFSIZE)
-		bufsiz = TPM_BUFSIZE;
-
 	count = be32_to_cpu(*((__be32 *) (buf + 2)));
 	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
 	if (count == 0)
 		return -ENODATA;
-	if (count > bufsiz || count > bufvalid) {
+	if (count > bufvalid) {
 		dev_err(&chip->dev,
-			"invalid count value %x %zx\n", count, bufsiz);
+			"invalid count value %x %zx\n", count, bufvalid);
 		return -E2BIG;
 	}
 
-- 
2.7.4
