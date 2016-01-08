From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v4 2/7] tpm_tis: Disable interrupt auto
	probing on a per-device basis
Date: Thu,  7 Jan 2016 17:36:21 -0700
Message-ID: <1452213386-21460-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1452213386-21460-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1452213386-21460-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Instead of clearing the global interrupts flag when any device
does not have an interrupt just pass -1 through tpm_info.irq.

The only thing that asks for autoprobing is the force=1 path.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Wilck, Martin <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 304323bdcaaa..fecd27b45fd1 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -69,7 +69,11 @@ enum tis_defaults {
 struct tpm_info {
 	unsigned long start;
 	unsigned long len;
-	unsigned int irq;
+	/* irq > 0 means: use irq $irq;
+	 * irq = 0 means: autoprobe for an irq;
+	 * irq = -1 means: no irq support
+	 */
+	int irq;
 };
 
 static struct tpm_info tis_default_info = {
@@ -807,7 +811,7 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
-	if (interrupts) {
+	if (interrupts && tpm_info->irq != -1) {
 		if (tpm_info->irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 tpm_info->irq);
@@ -895,9 +899,9 @@ static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
 
 #ifdef CONFIG_PNP
 static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
-				      const struct pnp_device_id *pnp_id)
+			    const struct pnp_device_id *pnp_id)
 {
-	struct tpm_info tpm_info = tis_default_info;
+	struct tpm_info tpm_info = {};
 	acpi_handle acpi_dev_handle = NULL;
 
 	tpm_info.start = pnp_mem_start(pnp_dev, 0);
@@ -906,7 +910,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	if (pnp_irq_valid(pnp_dev, 0))
 		tpm_info.irq = pnp_irq(pnp_dev, 0);
 	else
-		interrupts = false;
+		tpm_info.irq = -1;
 
 #ifdef CONFIG_ACPI
 	if (pnp_acpi_device(pnp_dev)) {
@@ -984,6 +988,7 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&resources);
+	tpm_info.irq = -1;
 	ret = acpi_dev_get_resources(acpi_dev, &resources, tpm_check_resource,
 				     &tpm_info);
 	if (ret < 0)
@@ -991,9 +996,6 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 
 	acpi_dev_free_resource_list(&resources);
 
-	if (!tpm_info.irq)
-		interrupts = false;
-
 	if (is_itpm(acpi_dev))
 		itpm = true;
 
-- 
2.1.4


------------------------------------------------------------------------------
