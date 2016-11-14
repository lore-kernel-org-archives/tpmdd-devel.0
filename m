From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v6 2/9] tpm: replace symbolic permission with octal for securityfs files
Date: Mon, 14 Nov 2016 05:00:49 -0500
Message-ID: <1479117656-12403-3-git-send-email-nayna@linux.vnet.ibm.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

checkpatch.pl flags warning for symbolic permissions and suggests
to replace with octal value.

This patch changes securityfs pseudo files permission
to octal values in tpm_bios_log_setup().

Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_eventlog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 42b49c4..9467e31 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -378,7 +378,7 @@ struct dentry **tpm_bios_log_setup(const char *name)
 
 	bin_file =
 	    securityfs_create_file("binary_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir,
+				   0440, tpm_dir,
 				   (void *)&tpm_binary_b_measurements_seqops,
 				   &tpm_bios_measurements_ops);
 	if (is_bad(bin_file))
@@ -386,7 +386,7 @@ struct dentry **tpm_bios_log_setup(const char *name)
 
 	ascii_file =
 	    securityfs_create_file("ascii_bios_measurements",
-				   S_IRUSR | S_IRGRP, tpm_dir,
+				   0440, tpm_dir,
 				   (void *)&tpm_ascii_b_measurements_seqops,
 				   &tpm_bios_measurements_ops);
 	if (is_bad(ascii_file))
-- 
2.5.0
