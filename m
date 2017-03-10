From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 3/3] tpm/tpm_crb: Enable TPM CRB interface for
	ARM64
Date: Fri, 10 Mar 2017 03:58:09 -0600
Message-ID: <1489139889-14376-4-git-send-email-anjiandi@codeaurora.org>
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

This enables TPM Command Response Buffer interface driver for
ARM64 and implements an ARM specific TPM CRB start method that
invokes a Secure Monitor Call to request the Firmware to execute
or cancel a TPM 2.0 command.

Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/char/tpm/Kconfig   |  2 +-
 drivers/char/tpm/tpm_crb.c | 24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index d520ac5..9659f40 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -136,7 +136,7 @@ config TCG_XEN
 
 config TCG_CRB
 	tristate "TPM 2.0 CRB Interface"
-	depends on X86 && ACPI
+	depends on (X86 || ARM64) && ACPI
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 089fcf8..d29a84a 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -73,6 +73,7 @@ enum crb_status {
 enum crb_flags {
 	CRB_FL_ACPI_START	= BIT(0),
 	CRB_FL_CRB_START	= BIT(1),
+	CRB_FL_CRB_SMC_START	= BIT(2),
 };
 
 struct crb_priv {
@@ -82,6 +83,7 @@ struct crb_priv {
 	u8 __iomem *cmd;
 	u8 __iomem *rsp;
 	u32 cmd_size;
+	u32 smc_func_id;
 };
 
 /**
@@ -101,7 +103,8 @@ struct crb_priv {
  */
 static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
 {
-	if (priv->flags & CRB_FL_ACPI_START)
+	if ((priv->flags & CRB_FL_ACPI_START) ||
+	    (priv->flags & CRB_FL_CRB_SMC_START))
 		return 0;
 
 	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->cca->req);
@@ -129,7 +132,8 @@ static int __maybe_unused crb_cmd_ready(struct device *dev,
 {
 	ktime_t stop, start;
 
-	if (priv->flags & CRB_FL_ACPI_START)
+	if ((priv->flags & CRB_FL_ACPI_START) ||
+	    (priv->flags & CRB_FL_CRB_SMC_START))
 		return 0;
 
 	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->cca->req);
@@ -229,6 +233,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	if (priv->flags & CRB_FL_ACPI_START)
 		rc = crb_do_acpi_start(chip);
 
+	if (priv->flags & CRB_FL_CRB_SMC_START) {
+		iowrite32(CRB_START_INVOKE, &priv->cca->start);
+		rc = tpm_crb_smc_start(priv->smc_func_id);
+	}
+
 	return rc;
 }
 
@@ -445,6 +454,17 @@ static int crb_acpi_add(struct acpi_device *device)
 	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
 		priv->flags |= CRB_FL_ACPI_START;
 
+	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_SMC) {
+		if ((buf->header.length - default_len) !=
+		    sizeof(struct tpm2_crb_smc)) {
+			dev_err(dev, "TPM2 ACPI table has wrong size %u for start method type %d\n",
+				buf->header.length, ACPI_TPM2_COMMAND_BUFFER_WITH_SMC);
+			return -EINVAL;
+		}
+		priv->flags |= CRB_FL_CRB_SMC_START;
+		priv->smc_func_id = buf->platform_data.smc_params.smc_func_id;
+	}
+
 	rc = crb_map_io(device, priv, buf);
 	if (rc)
 		return rc;
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
