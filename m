From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] tpm/tpm_tis_spi: drop duplicate header module.h
Date: Wed, 23 Nov 2016 23:18:53 +0800
Message-ID: <41617f27bb513c364b091d7255561138f40db6e3.1479914241.git.geliangtang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Geliang Tang <geliangtang@gmail.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Drop duplicate header module.h from tpm_tis_spi.c.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/char/tpm/tpm_tis_spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_spi.c b/drivers/char/tpm/tpm_tis_spi.c
index dbaad9c..5292e57 100644
--- a/drivers/char/tpm/tpm_tis_spi.c
+++ b/drivers/char/tpm/tpm_tis_spi.c
@@ -33,7 +33,6 @@
 #include <linux/acpi.h>
 #include <linux/freezer.h>
 
-#include <linux/module.h>
 #include <linux/spi/spi.h>
 #include <linux/gpio.h>
 #include <linux/of_irq.h>
-- 
2.9.3
