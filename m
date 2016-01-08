From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH v4 1/7] tpm_crb: Use the common ACPI
	definition of struct acpi_tpm2
Date: Thu,  7 Jan 2016 17:36:20 -0700
Message-ID: <1452213386-21460-2-git-send-email-jgunthorpe@obsidianresearch.com>
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

include/acpi/actbl2.h is the proper place for these definitions
and the needed TPM2 ones have been there since
commit 413d4a6defe0 ("ACPICA: Update TPM2 ACPI table")

This also drops a couple of le32_to_cpu's for members of this table,
the existing swapping was not done consistently, and the standard
used by other Linux callers of acpi_get_table is unswapped.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Tested-by: Wilck, Martin <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Tested-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h     |  7 -------
 drivers/char/tpm/tpm_crb.c | 31 +++++++++----------------------
 drivers/char/tpm/tpm_tis.c |  2 +-
 3 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 542a80cbfd9c..28b477e8da6a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -128,13 +128,6 @@ enum tpm2_startup_types {
 	TPM2_SU_STATE	= 0x0001,
 };
 
-enum tpm2_start_method {
-	TPM2_START_ACPI = 2,
-	TPM2_START_FIFO = 6,
-	TPM2_START_CRB = 7,
-	TPM2_START_CRB_WITH_ACPI = 8,
-};
-
 struct tpm_chip;
 
 struct tpm_vendor_specific {
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 8342cf51ffdc..8dd70696ebe8 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -34,14 +34,6 @@ enum crb_defaults {
 	CRB_ACPI_START_INDEX = 1,
 };
 
-struct acpi_tpm2 {
-	struct acpi_table_header hdr;
-	u16 platform_class;
-	u16 reserved;
-	u64 control_area_pa;
-	u32 start_method;
-} __packed;
-
 enum crb_ca_request {
 	CRB_CA_REQ_GO_IDLE	= BIT(0),
 	CRB_CA_REQ_CMD_READY	= BIT(1),
@@ -207,7 +199,7 @@ static const struct tpm_class_ops tpm_crb = {
 static int crb_acpi_add(struct acpi_device *device)
 {
 	struct tpm_chip *chip;
-	struct acpi_tpm2 *buf;
+	struct acpi_table_tpm2 *buf;
 	struct crb_priv *priv;
 	struct device *dev = &device->dev;
 	acpi_status status;
@@ -217,13 +209,14 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "failed to get TPM2 ACPI table\n");
+	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
+		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -ENODEV;
 	}
 
 	/* Should the FIFO driver handle this? */
-	if (buf->start_method == TPM2_START_FIFO)
+	sm = buf->start_method;
+	if (sm == ACPI_TPM2_MEMORY_MAPPED)
 		return -ENODEV;
 
 	chip = tpmm_chip_alloc(dev, &tpm_crb);
@@ -232,11 +225,6 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	if (buf->hdr.length < sizeof(struct acpi_tpm2)) {
-		dev_err(dev, "TPM2 ACPI table has wrong size");
-		return -EINVAL;
-	}
-
 	priv = (struct crb_priv *) devm_kzalloc(dev, sizeof(struct crb_priv),
 						GFP_KERNEL);
 	if (!priv) {
@@ -244,21 +232,20 @@ static int crb_acpi_add(struct acpi_device *device)
 		return -ENOMEM;
 	}
 
-	sm = le32_to_cpu(buf->start_method);
-
 	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
 	 * report only ACPI start but in practice seems to require both
 	 * ACPI start and CRB start.
 	 */
-	if (sm == TPM2_START_CRB || sm == TPM2_START_FIFO ||
+	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
 	    !strcmp(acpi_device_hid(device), "MSFT0101"))
 		priv->flags |= CRB_FL_CRB_START;
 
-	if (sm == TPM2_START_ACPI || sm == TPM2_START_CRB_WITH_ACPI)
+	if (sm == ACPI_TPM2_START_METHOD ||
+	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
 		priv->flags |= CRB_FL_ACPI_START;
 
 	priv->cca = (struct crb_control_area __iomem *)
-		devm_ioremap_nocache(dev, buf->control_area_pa, 0x1000);
+		devm_ioremap_nocache(dev, buf->control_address, 0x1000);
 	if (!priv->cca) {
 		dev_err(dev, "ioremap of the control area failed\n");
 		return -ENOMEM;
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 8a3509cb10da..304323bdcaaa 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -135,7 +135,7 @@ static inline int is_fifo(struct acpi_device *dev)
 		return 0;
 	}
 
-	if (le32_to_cpu(tbl->start_method) != TPM2_START_FIFO)
+	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
 		return 0;
 
 	/* TPM 2.0 FIFO */
-- 
2.1.4


------------------------------------------------------------------------------
