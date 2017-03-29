From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] Add log start/length fields to TPM2 table
Date: Wed, 29 Mar 2017 00:43:23 -0700
Message-ID: <20170329074323.s6qkb7pk47jqa4q6@petr-dev3.eng.vmware.com>
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

Latest revision of TPM 2.0 ACPI spec adds log start/length
to the TPM2 table.  Add them to our definition.  As few
places were using sizeof(TPM2) to make sure required fields
are present, switch them to use length of table up to and
including start type field, as that is what they are after.

Also change SMC CRB handling to use TPM2 fields rather than
offsets + typecasts.

Signed-off-by: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 15 +++------------
 drivers/char/tpm/tpm_tis.c |  2 +-
 include/acpi/actbl2.h      | 30 +++++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 72b03c328198..43bec842e013 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -110,14 +110,6 @@ struct crb_priv {
 	u32 smc_func_id;
 };
 
-struct tpm2_crb_smc {
-	u32 interrupt;
-	u8 interrupt_flags;
-	u8 op_flags;
-	u16 reserved2;
-	u32 smc_func_id;
-};
-
 /**
  * crb_go_idle - request tpm crb device to go the idle state
  *
@@ -538,7 +530,7 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
-	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
+	if (ACPI_FAILURE(status) || buf->header.length < ACPI_TPM2_SIZE_WITH_START) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
 	}
@@ -565,15 +557,14 @@ static int crb_acpi_add(struct acpi_device *device)
 		priv->flags |= CRB_FL_ACPI_START;
 
 	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_SMC) {
-		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
+		if (buf->header.length < ACPI_TPM2_SIZE_WITH_SMC) {
 			dev_err(dev,
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_SMC);
 			return -EINVAL;
 		}
-		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf,
-				       ACPI_TPM2_START_METHOD_PARAMETER_OFFSET);
+		crb_smc = &buf->platform_specific_data.smc;
 		priv->smc_func_id = crb_smc->smc_func_id;
 		priv->flags |= CRB_FL_CRB_SMC_START;
 	}
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384f1b08..f513a116e195 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -257,7 +257,7 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 
 	st = acpi_get_table(ACPI_SIG_TPM2, 1,
 			    (struct acpi_table_header **) &tbl);
-	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
+	if (ACPI_FAILURE(st) || tbl->header.length < ACPI_TPM2_SIZE_WITH_START) {
 		dev_err(&acpi_dev->dev,
 			FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 2b4af0769a28..645961f998ef 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1273,20 +1273,42 @@ struct acpi_table_tcpa_server {
  *        Version 4
  *
  * Conforms to "TCG ACPI Specification, Family 1.2 and 2.0",
- * December 19, 2014
+ * Version 1.2, Revision 8, February 27, 2017, Committee Draft
  *
  ******************************************************************************/
 
+struct tpm2_crb_smc {
+	u32 interrupt;
+	u8 interrupt_flags;
+	u8 op_flags;
+	u16 reserved2;
+	u32 smc_func_id;
+};
+
 struct acpi_table_tpm2 {
 	struct acpi_table_header header;	/* Common ACPI table header */
 	u16 platform_class;
 	u16 reserved;
 	u64 control_address;
 	u32 start_method;
-
-	/* Platform-specific data follows */
+	/* End of Version 3 or minimal version 4 table. */
+        union {
+		u8 raw[12];
+		u32 acpi;  /* ACPI start method should have 4 zero bytes here. */
+		struct tpm2_crb_smc smc;
+	} platform_specific_data;	/* Added in Level 00 Version 00.37 */
+	u32 minimum_log_length;		/* Added in Version 1.2 */
+	u64 log_address;		/* Added in Version 1.2 */
 };
 
+/* TPM2 table sizes. */
+
+#define ACPI_TPM2_SIZE_WITH_START	offsetofend(struct acpi_table_tpm2, \
+						    start_method)
+#define ACPI_TPM2_SIZE_WITH_SMC		offsetofend(struct acpi_table_tpm2, \
+						    platform_specific_data)
+#define ACPI_TPM2_SIZE_WITH_LOG		sizeof(struct acpi_table_tpm2)
+
 /* Values for start_method above */
 
 #define ACPI_TPM2_NOT_ALLOWED                       0
@@ -1296,8 +1318,6 @@ struct acpi_table_tpm2 {
 #define ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD  8
 #define ACPI_TPM2_COMMAND_BUFFER_WITH_SMC          11
 
-#define ACPI_TPM2_START_METHOD_PARAMETER_OFFSET    52
-
 /*******************************************************************************
  *
  * UEFI - UEFI Boot optimization Table
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
