From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] tpm: vtpm_proxy: Introduce flag to prevent
	sysfs entries
Date: Fri, 24 Jun 2016 10:36:55 -0400
Message-ID: <1466779015-26965-1-git-send-email-stefanb@linux.vnet.ibm.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Introduce TPM_VTPM_PROXY_NO_SYSFS flag that prevents a vtpm_proxy driver
instance from having the typical sysfs entries that shows the state of the
TPM. The flag is to be set in the ioctl creating the vtpm_proxy device
pair and maps on a new chip flags TPM_CHIP_FLAG_NO_SYSFS.

This flag would be set by a container management stack to prevent
TPM related information leakage between containers who share entries
in sysfs.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c       | 2 +-
 drivers/char/tpm/tpm.h            | 1 +
 drivers/char/tpm/tpm_vtpm_proxy.c | 5 ++++-
 include/uapi/linux/vtpm_proxy.h   | 3 ++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 1965dc7..c8e7cab 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -278,7 +278,7 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 
 static int tpm1_chip_register(struct tpm_chip *chip)
 {
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_NO_SYSFS))
 		return 0;
 
 	tpm_sysfs_add_device(chip);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8890df2..9d8cf81 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -143,6 +143,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
+	TPM_CHIP_FLAG_NO_SYSFS		= BIT(4),
 };
 
 struct tpm_chip {
diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 86e27e8..81079e0 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -50,7 +50,7 @@ struct proxy_dev {
 };
 
 /* all supported flags */
-#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2)
+#define VTPM_PROXY_FLAGS_ALL  (VTPM_PROXY_FLAG_TPM2 | VTPM_PROXY_FLAG_NO_SYSFS)
 
 static struct workqueue_struct *workqueue;
 
@@ -490,6 +490,9 @@ static struct file *vtpm_proxy_create_device(
 	if (proxy_dev->flags & VTPM_PROXY_FLAG_TPM2)
 		proxy_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
 
+	if (proxy_dev->flags & VTPM_PROXY_FLAG_NO_SYSFS)
+		proxy_dev->chip->flags |= TPM_CHIP_FLAG_NO_SYSFS;
+
 	vtpm_proxy_work_start(proxy_dev);
 
 	vtpm_new_dev->fd = fd;
diff --git a/include/uapi/linux/vtpm_proxy.h b/include/uapi/linux/vtpm_proxy.h
index 41e8e22..151ea48 100644
--- a/include/uapi/linux/vtpm_proxy.h
+++ b/include/uapi/linux/vtpm_proxy.h
@@ -29,7 +29,8 @@ struct vtpm_proxy_new_dev {
 };
 
 /* above flags */
-#define VTPM_PROXY_FLAG_TPM2  1  /* emulator is TPM 2 */
+#define VTPM_PROXY_FLAG_TPM2      1  /* emulator is TPM 2 */
+#define VTPM_PROXY_FLAG_NO_SYSFS  2  /* no sysfs for vTPM proxy instance */
 
 #define VTPM_PROXY_IOC_NEW_DEV   _IOWR(0xa1, 0x00, struct vtpm_proxy_new_dev)
 
-- 
2.4.3


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
