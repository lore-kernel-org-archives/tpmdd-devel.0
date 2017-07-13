From: Josh Zimmerman <joshz@google.com>
Subject: [PATCH v1 1/2] Add "shutdown" to "struct class".'
Date: Wed, 12 Jul 2017 17:41:20 -0700
Message-ID: <20170713004121.21750-2-joshz@google.com>
References: <20170713004121.21750-1-joshz@google.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170713004121.21750-1-joshz@google.com>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: Josh Zimmerman <joshz@google.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Backport of commit f77af15165847406b15d8f70c382c4cb15846b2a upstream.

The TPM class has some common shutdown code that must be executed for
all drivers. This adds some needed functionality for that.

Signed-off-by: Josh Zimmerman <joshz@google.com>
---
 drivers/base/core.c    | 6 +++++-
 include/linux/device.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ce057a568673..03a82d017cf1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2095,7 +2095,11 @@ void device_shutdown(void)
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
 
-		if (dev->bus && dev->bus->shutdown) {
+		if (dev->class && dev->class->shutdown) {
+			if (initcall_debug)
+				dev_info(dev, "shutdown\n");
+			dev->class->shutdown(dev);
+		} else if (dev->bus && dev->bus->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index bc41e87a969b..df850f723264 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -373,6 +373,7 @@ int subsys_virtual_register(struct bus_type *subsys,
  * @suspend:	Used to put the device to sleep mode, usually to a low power
  *		state.
  * @resume:	Used to bring the device from the sleep mode.
+ * @shutdown:  Called at shut-down time to quiesce the device.
  * @ns_type:	Callbacks so sysfs can detemine namespaces.
  * @namespace:	Namespace of the device belongs to this class.
  * @pm:		The default device power management operations of this class.
@@ -401,6 +402,7 @@ struct class {
 
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+	int (*shutdown)(struct device *dev);
 
 	const struct kobj_ns_type_operations *ns_type;
 	const void *(*namespace)(struct device *dev);
-- 
2.13.2.932.g7449e964c-goog
