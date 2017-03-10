From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 1/3] ACPICA: Update TPM2 ACPI table
Date: Fri, 10 Mar 2017 03:58:07 -0600
Message-ID: <1489139889-14376-2-git-send-email-anjiandi@codeaurora.org>
References: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1489139889-14376-1-git-send-email-anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

TCG ACPI Specification Family "1.2" and "2.0" Version 1.2
Revision 8 introduces new start method for ARM SMC.

- Add new start method (type 11) for ARM SMC
- Add start method specific parameters for ARM SMC start method

Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c |  6 +++++-
 drivers/char/tpm/tpm_tis.c |  6 +++++-
 include/acpi/actbl2.h      | 12 ++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index cb6fb13..089fcf8 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -410,12 +410,16 @@ static int crb_acpi_add(struct acpi_device *device)
 	struct tpm_chip *chip;
 	struct device *dev = &device->dev;
 	acpi_status status;
+	u32 default_len;
 	u32 sm;
 	int rc;
 
+	default_len = sizeof(struct acpi_table_tpm2) -
+		      sizeof(union platform_params);
+
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
-	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
+	if (ACPI_FAILURE(status) || buf->header.length < default_len) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
 	}
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7e1384..0e2e5f6 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -253,11 +253,15 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
 	acpi_status st;
 	struct list_head resources;
 	struct tpm_info tpm_info = {};
+	u32 default_len;
 	int ret;
 
+	default_len = sizeof(struct acpi_table_tpm2) -
+		      sizeof(union platform_params);
+
 	st = acpi_get_table(ACPI_SIG_TPM2, 1,
 			    (struct acpi_table_header **) &tbl);
-	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
+	if (ACPI_FAILURE(st) || tbl->header.length < default_len) {
 		dev_err(&acpi_dev->dev,
 			FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 7aee9fb..9612049 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1277,6 +1277,14 @@ struct acpi_table_tcpa_server {
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
@@ -1285,6 +1293,9 @@ struct acpi_table_tpm2 {
 	u32 start_method;
 
 	/* Platform-specific data follows */
+	union platform_params {
+		struct tpm2_crb_smc smc_params;
+	} platform_data;
 };
 
 /* Values for start_method above */
@@ -1294,6 +1305,7 @@ struct acpi_table_tpm2 {
 #define ACPI_TPM2_MEMORY_MAPPED                     6
 #define ACPI_TPM2_COMMAND_BUFFER                    7
 #define ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD  8
+#define ACPI_TPM2_COMMAND_BUFFER_WITH_SMC          11
 
 /*******************************************************************************
  *
-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.


------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
