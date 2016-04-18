From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v11 2/4] tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
Date: Mon, 18 Apr 2016 13:26:14 -0400
Message-ID: <1461000376-2888-3-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461000376-2888-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Introduce TPM_CHIP_FLAG_VIRTUAL to be used when the chip device has no
parent device.

Prevent sysfs entries requiring a parent device from being created.

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c | 7 +++++--
 drivers/char/tpm/tpm.h      | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 7e2c9cf..a12db8e 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -181,6 +181,9 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
 	if (rc)
 		goto out;
 
+	if (!dev)
+		chip->flags |= TPM_CHIP_FLAG_VIRTUAL;
+
 	cdev_init(&chip->cdev, &tpm_fops);
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdev.kobj.parent = &chip->dev.kobj;
@@ -297,7 +300,7 @@ static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
 {
 	struct attribute **i;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
 		return;
 
 	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
@@ -315,7 +318,7 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
 	struct attribute **i;
 	int rc;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
 		return 0;
 
 	rc = __compat_only_sysfs_link_entry_to_kobj(
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 508e8e0..ff4e53c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -138,6 +138,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
+	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
 };
 
 struct tpm_chip {
-- 
2.4.3


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
