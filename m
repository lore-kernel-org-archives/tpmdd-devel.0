From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add "shutdown" to "struct class".
Date: Fri, 12 May 2017 16:32:03 -0700
Message-ID: <20170512233203.23659-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The TPM class has some common shutdown code that must be executed for
all drivers. This adds some needed functionality for that.

(In addition, update a comment to reflect an out-of-date path.)
---
 drivers/base/core.c    | 5 +++++
 include/linux/device.h | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bbecaf9293be..5c1648875e94 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2667,6 +2667,11 @@ void device_shutdown(void)
 		pm_runtime_get_noresume(dev);
 		pm_runtime_barrier(dev);
 
+		if (dev->class && dev->class->shutdown) {
+			if (initcall_debug)
+				dev_info(dev, "shutdown\n");
+			dev->class->shutdown(dev);
+		}
 		if (dev->bus && dev->bus->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
diff --git a/include/linux/device.h b/include/linux/device.h
index 9ef518af5515..a150f8d3b3f1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -378,6 +378,7 @@ int subsys_virtual_register(struct bus_type *subsys,
  * @suspend:	Used to put the device to sleep mode, usually to a low power
  *		state.
  * @resume:	Used to bring the device from the sleep mode.
+ * @shutdown:	Called at shut-down time to quiesce the device.
  * @ns_type:	Callbacks so sysfs can detemine namespaces.
  * @namespace:	Namespace of the device belongs to this class.
  * @pm:		The default device power management operations of this class.
@@ -407,6 +408,7 @@ struct class {
 
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+	int (*shutdown)(struct device *dev);
 
 	const struct kobj_ns_type_operations *ns_type;
 	const void *(*namespace)(struct device *dev);
@@ -1228,7 +1230,7 @@ static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
 static inline int devtmpfs_mount(const char *mountpoint) { return 0; }
 #endif
 
-/* drivers/base/power/shutdown.c */
+/* drivers/base/core.c */
 extern void device_shutdown(void);
 
 /* debugging and troubleshooting/diagnostic helpers. */
-- 
2.13.0.rc2.291.g57267f2277-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
