From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] tpm: uninitialized variable in read_log_of()
Date: Wed, 16 Nov 2016 17:12:21 +0300
Message-ID: <20161116141221.GA28875@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

"np" is supposed to be set to NULL at the start.

Fixes: 4a45d9669ac1 ("tpm: replace of_find_node_by_name() with dev of_node propert")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 3af829f..904ed4a 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -23,7 +23,7 @@
 
 int read_log_of(struct tpm_chip *chip)
 {
-	struct device_node *np;
+	struct device_node *np = NULL;
 	const u32 *sizep;
 	const u64 *basep;
 	struct tpm_bios_log *log;
