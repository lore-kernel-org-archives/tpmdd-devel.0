From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3 1/2] ACPICA: Update TPM2 ACPI table
Date: Fri, 17 Mar 2017 18:43:12 -0500
Message-ID: <1489794193-17233-2-git-send-email-anjiandi@codeaurora.org>
References: <1489794193-17233-1-git-send-email-anjiandi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1489794193-17233-1-git-send-email-anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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
 include/acpi/actbl2.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 7aee9fb..2b4af07 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1294,6 +1294,9 @@ struct acpi_table_tpm2 {
 #define ACPI_TPM2_MEMORY_MAPPED                     6
 #define ACPI_TPM2_COMMAND_BUFFER                    7
 #define ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD  8
+#define ACPI_TPM2_COMMAND_BUFFER_WITH_SMC          11
+
+#define ACPI_TPM2_START_METHOD_PARAMETER_OFFSET    52
 
 /*******************************************************************************
  *
-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
