From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] tpm: fix tpm_bios_log_setup stub prototype
Date: Wed, 16 Mar 2016 09:19:48 +0100
Message-ID: <1458116410-3208536-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Hon Ching (Vicky) Lo" <honclo@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

A cleanup patch changed the prototype of the regular tpm_bios_log_setup
function, but not that of the stub that is used when the TPM is disabled,
causing a harmless build warning:

drivers/char/tpm/tpm-chip.c: In function 'tpm1_chip_register':
drivers/char/tpm/tpm-chip.c:287:38: error: passing argument 1 of 'tpm_bios_log_setup' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
  chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
In file included from ../drivers/char/tpm/tpm-chip.c:30:0:
../drivers/char/tpm/tpm_eventlog.h:83:31: note: expected 'char *' but argument is of type 'const char *'
 static inline struct dentry **tpm_bios_log_setup(char *name)

This changes the stub function to match the normal prototype,
avoiding that warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: aca8db8088c3 ("tpm: Get rid of devname")
---
 drivers/char/tpm/tpm_eventlog.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
index cc9672f64e8f..8de62b09be51 100644
--- a/drivers/char/tpm/tpm_eventlog.h
+++ b/drivers/char/tpm/tpm_eventlog.h
@@ -80,7 +80,7 @@ int read_log(struct tpm_bios_log *log);
 extern struct dentry **tpm_bios_log_setup(const char *);
 extern void tpm_bios_log_teardown(struct dentry **);
 #else
-static inline struct dentry **tpm_bios_log_setup(char *name)
+static inline struct dentry **tpm_bios_log_setup(const char *name)
 {
 	return NULL;
 }
-- 
2.7.0
