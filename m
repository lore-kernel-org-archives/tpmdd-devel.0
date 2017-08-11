From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH v2] Do not disable driver and bus shutdown hook when class shutdown hook is set.
Date: Fri, 11 Aug 2017 15:44:43 +0200
Message-ID: <20170811134443.770-1-msuchanek@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Phil Sutter <phil@nwl.cc>, Josh Zimmerman <joshz@google.com>, Michal Suchanek <msuchanek@suse.de>, Madalin Bucur <madalin.bucur@nxp.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ludovic Desroches <ludovic.desroches@o2linux.fr>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

As seen from the implementation of the single class shutdown hook this
is not very sound design.

Rename the class shutdown hook to shutdown_pre to make it clear it runs
before the driver shutdown hook.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
v2: rename class shutdown member to shutdown_pre
---
 drivers/base/core.c         |  9 +++++----
 drivers/char/tpm/tpm-chip.c | 11 ++---------
 include/linux/device.h      |  4 ++--
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 755451f684bc..13e7c41fd417 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2664,11 +2664,12 @@ void device_shutdown(void)
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
 
-		if (dev->class && dev->class->shutdown) {
+		if (dev->class && dev->class->shutdown_pre) {
 			if (initcall_debug)
-				dev_info(dev, "shutdown\n");
-			dev->class->shutdown(dev);
-		} else if (dev->bus && dev->bus->shutdown) {
+				dev_info(dev, "shutdown_pre\n");
+			dev->class->shutdown_pre(dev);
+		}
+		if (dev->bus && dev->bus->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 67ec9d3d04f5..0eca20c5a80c 100644
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
 
@@ -214,7 +207,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	device_initialize(&chip->devs);
 
 	chip->dev.class = tpm_class;
-	chip->dev.class->shutdown = tpm_class_shutdown;
+	chip->dev.class->shutdown_pre = tpm_class_shutdown;
 	chip->dev.release = tpm_dev_release;
 	chip->dev.parent = pdev;
 	chip->dev.groups = chip->groups;
diff --git a/include/linux/device.h b/include/linux/device.h
index beabdbc08420..649b1b72c76a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -375,7 +375,7 @@ int subsys_virtual_register(struct bus_type *subsys,
  * @suspend:	Used to put the device to sleep mode, usually to a low power
  *		state.
  * @resume:	Used to bring the device from the sleep mode.
- * @shutdown:	Called at shut-down time to quiesce the device.
+ * @shutdown_pre: Called at shut-down time before driver shutdown.
  * @ns_type:	Callbacks so sysfs can detemine namespaces.
  * @namespace:	Namespace of the device belongs to this class.
  * @pm:		The default device power management operations of this class.
@@ -404,7 +404,7 @@ struct class {
 
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
-	int (*shutdown)(struct device *dev);
+	int (*shutdown_pre)(struct device *dev);
 
 	const struct kobj_ns_type_operations *ns_type;
 	const void *(*namespace)(struct device *dev);
-- 
2.10.2
