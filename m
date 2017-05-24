From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm, tpm_infineon: remove useless snprintf() calls
Date: Wed, 24 May 2017 14:29:16 -0700
Message-ID: <20170524212916.9106-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The memory copy from rodata to stack is useless.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_infineon.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index e3cf9f3545c5..3b1b9f9322d5 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -397,7 +397,7 @@ static int tpm_inf_pnp_probe(struct pnp_dev *dev,
 	int vendorid[2];
 	int version[2];
 	int productid[2];
-	char chipname[20];
+	const char *chipname;
 	struct tpm_chip *chip;
 
 	/* read IO-ports through PnP */
@@ -488,13 +488,13 @@ static int tpm_inf_pnp_probe(struct pnp_dev *dev,
 
 	switch ((productid[0] << 8) | productid[1]) {
 	case 6:
-		snprintf(chipname, sizeof(chipname), " (SLD 9630 TT 1.1)");
+		chipname = " (SLD 9630 TT 1.1)";
 		break;
 	case 11:
-		snprintf(chipname, sizeof(chipname), " (SLB 9635 TT 1.2)");
+		chipname = " (SLB 9635 TT 1.2)";
 		break;
 	default:
-		snprintf(chipname, sizeof(chipname), " (unknown chip)");
+		chipname = " (unknown chip)";
 		break;
 	}
 
-- 
2.11.0

