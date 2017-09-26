From: Ruben Roy <rubenroy2005@gmail.com>
Subject: [PATCH] tpm: fix duplicate inline declaration specifier
Date: Tue, 26 Sep 2017 13:58:57 +0000
Message-ID: <1506434337-15284-1-git-send-email-rubenroy2005@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>, trivial@kernel.org, Ruben Roy <rubenroy2005@gmail.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This commit fixes the duplicate inline declaration specifier in
tpm2_rc_value which caused a warning

Signed-off-by: Ruben Roy <rubenroy2005@gmail.com>
---
 drivers/char/tpm/tpm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 04fbff2..f4d0272 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -550,7 +550,7 @@ static inline void tpm_add_ppi(struct tpm_chip *chip)
 }
 #endif
 
-static inline inline u32 tpm2_rc_value(u32 rc)
+static inline u32 tpm2_rc_value(u32 rc)
 {
 	return (rc & BIT(7)) ? rc & 0xff : rc;
 }
-- 
1.8.3.1
