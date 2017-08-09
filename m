From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] Do not disable driver and bus shutdown hook when class shutdown hook is set.
Date: Wed,  9 Aug 2017 23:34:20 +0200
Message-ID: <20170809213420.2391-1-msuchanek@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: Michal Suchanek <msuchanek@suse.de>
List-Id: tpmdd-devel@lists.sourceforge.net

Disabling the driver hook by setting class hook is totally sound design
not prone to error as evidenced by the single implementation of the
class hook.

Fixes: d1bd4a792d39 ("tpm: Issue a TPM2_Shutdown for TPM2 devices.")
Fixes: f77af1516584 ("Add "shutdown" to "struct class".")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/base/core.c         | 3 ++-
 drivers/char/tpm/tpm-chip.c | 9 +--------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 755451f684bc..2cf752dc1421 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2668,7 +2668,8 @@ void device_shutdown(void)
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->class->shutdown(dev);
-		} else if (dev->bus && dev->bus->shutdown) {
+		}
+		if (dev->bus && dev->bus->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 67ec9d3d04f5..edf8fa553f5f 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -164,14 +164,7 @@ static int tpm_class_shutdown(struct device *dev)
 		chip->ops = NULL;
 		up_write(&chip->ops_sem);
 	}
-	/* Allow bus- and device-specific code to run. Note: since chip->ops
-	 * is NULL, more-specific shutdown code will not be able to issue TPM
-	 * commands.
-	 */
-	if (dev->bus && dev->bus->shutdown)
-		dev->bus->shutdown(dev);
-	else if (dev->driver && dev->driver->shutdown)
-		dev->driver->shutdown(dev);
+
 	return 0;
 }
 
-- 
2.10.2
