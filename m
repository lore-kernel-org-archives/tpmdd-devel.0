From: Thiebaud Weksteen via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v3 2/5] tpm: rename event log provider files
Date: Wed, 20 Sep 2017 10:13:37 +0200
Message-ID: <20170920081340.7413-3-tweek@google.com>
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

Rename the current TPM Event Log provider files (ACPI and OF)
for clarity.

Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/Makefile                            | 4 ++--
 drivers/char/tpm/{tpm_acpi.c => tpm_eventlog_acpi.c} | 0
 drivers/char/tpm/{tpm_of.c => tpm_eventlog_of.c}     | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/char/tpm/{tpm_acpi.c => tpm_eventlog_acpi.c} (100%)
 rename drivers/char/tpm/{tpm_of.c => tpm_eventlog_of.c} (100%)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 23681f01f95a..c8509cd723a1 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -5,8 +5,8 @@ obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
 	 tpm-dev-common.o tpmrm-dev.o tpm1_eventlog.o tpm2_eventlog.o \
          tpm2-space.o
-tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
-tpm-$(CONFIG_OF) += tpm_of.o
+tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_eventlog_acpi.o
+tpm-$(CONFIG_OF) += tpm_eventlog_of.o
 obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_TIS_SPI) += tpm_tis_spi.o
diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_eventlog_acpi.c
similarity index 100%
rename from drivers/char/tpm/tpm_acpi.c
rename to drivers/char/tpm/tpm_eventlog_acpi.c
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_eventlog_of.c
similarity index 100%
rename from drivers/char/tpm/tpm_of.c
rename to drivers/char/tpm/tpm_eventlog_of.c
-- 
2.14.1.821.g8fa685d3b7-goog


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
