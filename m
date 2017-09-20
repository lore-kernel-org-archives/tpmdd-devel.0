From: Thiebaud Weksteen via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v3 3/5] tpm: add event log format version
Date: Wed, 20 Sep 2017 10:13:38 +0200
Message-ID: <20170920081340.7413-4-tweek@google.com>
References: <20170920081340.7413-1-tweek@google.com>
Reply-To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170920081340.7413-1-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Although defined as part of the TCG EFI specification, we add these
definitions here so that any event log provider may reference them.

Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/tpm_eventlog.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index 446656d1f317..6337614b0855 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -8,6 +8,9 @@
 #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
 #define TPM2_ACTIVE_PCR_BANKS	3
 
+#define EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2 0x1
+#define EFI_TCG2_EVENT_LOG_FORMAT_TCG_2   0x2
+
 #ifdef CONFIG_PPC64
 #define do_endian_conversion(x) be32_to_cpu(x)
 #else
-- 
2.14.1.821.g8fa685d3b7-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
