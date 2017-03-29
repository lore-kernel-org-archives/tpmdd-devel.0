From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/4] Read TCG log from TPM2 table
Date: Wed, 29 Mar 2017 00:43:26 -0700
Message-ID: <20170329074326.jxeoxtn4tbjjwcl2@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Latest draft of TPM 2 ACPI specification added TCG log start/length
to the TPM2 ACPI table.  So Linux kernel can now read it without
having to get involved with boot loader, same way TPM1/TCPA tables
work.

Signed-off-by: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm_acpi.c | 70 ++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index 169edf3ce86d..e48b1503220c 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -48,46 +48,62 @@ struct acpi_tcpa {
 /* read binary bios log */
 int tpm_read_log_acpi(struct tpm_chip *chip)
 {
-	struct acpi_tcpa *buff;
 	acpi_status status;
 	void __iomem *virt;
 	u64 len, start;
 	struct tpm_bios_log *log;
 
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return -ENODEV;
-
-	log = &chip->log;
-
 	/* Unfortuntely ACPI does not associate the event log with a specific
 	 * TPM, like PPI. Thus all ACPI TPMs will read the same log.
 	 */
 	if (!chip->acpi_dev_handle)
 		return -ENODEV;
 
-	/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
-	status = acpi_get_table(ACPI_SIG_TCPA, 1,
-				(struct acpi_table_header **)&buff);
-
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	switch(buff->platform_class) {
-	case BIOS_SERVER:
-		len = buff->server.log_max_len;
-		start = buff->server.log_start_addr;
-		break;
-	case BIOS_CLIENT:
-	default:
-		len = buff->client.log_max_len;
-		start = buff->client.log_start_addr;
-		break;
-	}
-	if (!len) {
-		dev_warn(&chip->dev, "%s: TCPA log area empty\n", __func__);
-		return -EIO;
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		struct acpi_table_tpm2 *buff;
+
+		/* Find TPM2 entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
+		status = acpi_get_table(ACPI_SIG_TPM2, 1,
+					(struct acpi_table_header **)&buff);
+
+		if (ACPI_FAILURE(status) || buff->header.length < ACPI_TPM2_SIZE_WITH_LOG)
+			return -ENODEV;
+
+		len = buff->minimum_log_length;
+		start = buff->log_address;
+		if (!len) {
+			dev_warn(&chip->dev, "%s: TPM2 log area empty\n", __func__);
+			return -EIO;
+		}
+	} else {
+		struct acpi_tcpa *buff;
+
+		/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
+		status = acpi_get_table(ACPI_SIG_TCPA, 1,
+					(struct acpi_table_header **)&buff);
+
+		if (ACPI_FAILURE(status))
+			return -ENODEV;
+
+		switch(buff->platform_class) {
+		case BIOS_SERVER:
+			len = buff->server.log_max_len;
+			start = buff->server.log_start_addr;
+			break;
+		case BIOS_CLIENT:
+		default:
+			len = buff->client.log_max_len;
+			start = buff->client.log_start_addr;
+			break;
+		}
+		if (!len) {
+			dev_warn(&chip->dev, "%s: TCPA log area empty\n", __func__);
+			return -EIO;
+		}
 	}
 
+	log = &chip->log;
+
 	/* malloc EventLog space */
 	log->bios_event_log = kmalloc(len, GFP_KERNEL);
 	if (!log->bios_event_log)
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
