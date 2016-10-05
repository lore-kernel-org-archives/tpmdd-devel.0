From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] tpm/tpm_crb: revamp starting method setting.
Date: Wed,  5 Oct 2016 16:12:08 +0300
Message-ID: <1475673128-32262-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Encapsulate the start method parsing in a single function
and add needed debug printouts.
It eliminates small issue with useless double checking for
ACPI_TPM2_MEMORY_MAPPED.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/tpm/tpm_crb.c | 65 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index aa0ef742ac03..aeec313384d7 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -381,6 +381,52 @@ out:
 	return ret;
 }
 
+/**
+ * crb_start_method - parse starting method
+ *
+ * @device: acpi device
+ * @sm: starting method
+ *
+ * Return 0 if supported starting method was not found
+ *    CRB_FL_CRB_START or CRB_FL_ACPI_START otherwise
+ */
+static unsigned int crb_start_method(struct acpi_device *device, u32 sm)
+{
+	struct device *dev = &device->dev;
+	u32 flags;
+
+	switch (sm) {
+	/* Should the FIFO driver handle this? */
+	case ACPI_TPM2_MEMORY_MAPPED:
+		dev_dbg(dev, "starting method[%d]: MM\n", sm);
+		return 0;
+	case ACPI_TPM2_COMMAND_BUFFER:
+		flags = CRB_FL_CRB_START;
+		dev_dbg(dev, "starting method[%d]: CB\n", sm);
+		break;
+	case ACPI_TPM2_START_METHOD:
+		flags = CRB_FL_ACPI_START;
+		dev_dbg(dev, "starting method[%d]: SM\n", sm);
+		break;
+	case ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD:
+		flags = CRB_FL_ACPI_START;
+		dev_dbg(dev, "starting method[%d]: CB w/ SM\n",
+			sm);
+		break;
+	default:
+		return 0;
+	}
+
+	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
+	 * report only ACPI start but in practice seems to require both
+	 * ACPI start and CRB start.
+	 */
+	if (!strcmp(acpi_device_hid(device), "MSFT0101"))
+		flags |= CRB_FL_CRB_START;
+
+	return flags;
+}
+
 static int crb_acpi_add(struct acpi_device *device)
 {
 	struct acpi_table_tpm2 *buf;
@@ -388,7 +434,7 @@ static int crb_acpi_add(struct acpi_device *device)
 	struct tpm_chip *chip;
 	struct device *dev = &device->dev;
 	acpi_status status;
-	u32 sm;
+	unsigned int sm;
 	int rc;
 
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
@@ -398,26 +444,15 @@ static int crb_acpi_add(struct acpi_device *device)
 		return -EINVAL;
 	}
 
-	/* Should the FIFO driver handle this? */
-	sm = buf->start_method;
-	if (sm == ACPI_TPM2_MEMORY_MAPPED)
+	sm = crb_start_method(device, buf->start_method);
+	if (!sm)
 		return -ENODEV;
 
 	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
-	 * report only ACPI start but in practice seems to require both
-	 * ACPI start and CRB start.
-	 */
-	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
-	    !strcmp(acpi_device_hid(device), "MSFT0101"))
-		priv->flags |= CRB_FL_CRB_START;
-
-	if (sm == ACPI_TPM2_START_METHOD ||
-	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
-		priv->flags |= CRB_FL_ACPI_START;
+	priv->flags = sm;
 
 	rc = crb_map_io(device, priv, buf);
 	if (rc)
-- 
2.7.4
