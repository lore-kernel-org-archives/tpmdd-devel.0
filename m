From: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 2/2] Add "shutdown" to "struct class".
Date: Thu, 1 Jun 2017 09:33:43 -0700
Message-ID: <CAHSjozA+xfUM-NmbP7Kb5B=T+u6qaEFzMWeF6OxX2N7-xHLAVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The TPM class has some common shutdown code that must be executed for
all drivers. This adds some needed functionality for that.

Signed-off-by: Josh Zimmerman <joshz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

-----
v2: Add Signed-off-by.
v3: Remove logically separate change.
v4: Add "acked-by" and "cc".
v5: Execute only one of the class/bus/driver's shutdown functions.
---
 drivers/base/core.c    | 6 +++++-
 include/linux/device.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bb60fb6a30b..9f426954681e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2667,7 +2667,11 @@ void device_shutdown(void)
                pm_runtime_get_noresume(dev);
                pm_runtime_barrier(dev);

-               if (dev->bus && dev->bus->shutdown) {
+               if (dev->class && dev->class->shutdown) {
+                       if (initcall_debug)
+                               dev_info(dev, "shutdown\n");
+                       dev->class->shutdown(dev);
+               } else if (dev->bus && dev->bus->shutdown) {
                        if (initcall_debug)
                                dev_info(dev, "shutdown\n");
                        dev->bus->shutdown(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index 9ef518af5515..f240baac2001 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -378,6 +378,7 @@ int subsys_virtual_register(struct bus_type *subsys,
  * @suspend:   Used to put the device to sleep mode, usually to a low power
  *             state.
  * @resume:    Used to bring the device from the sleep mode.
+ * @shutdown:  Called at shut-down time to quiesce the device.
  * @ns_type:   Callbacks so sysfs can detemine namespaces.
  * @namespace: Namespace of the device belongs to this class.
  * @pm:                The default device power management operations
of this class.
@@ -407,6 +408,7 @@ struct class {

        int (*suspend)(struct device *dev, pm_message_t state);
        int (*resume)(struct device *dev);
+       int (*shutdown)(struct device *dev);

        const struct kobj_ns_type_operations *ns_type;
        const void *(*namespace)(struct device *dev);
-- 
2.13.0.219.gdb65acc882-goog

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
