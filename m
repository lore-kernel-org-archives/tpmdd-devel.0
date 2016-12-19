From: Jiandi An <anjiandi@codeaurora.org>
Subject: [PATCH] tpm, tpm_crb: Handle 64-bit resource in crb_check_resource()
Date: Sun, 18 Dec 2016 22:20:53 -0600
Message-ID: <1482121253-924-1-git-send-email-anjiandi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Jiandi An <anjiandi@codeaurora.org>
List-Id: tpmdd-devel@lists.sourceforge.net

crb_check_resource() in TPM CRB driver calls
acpi_dev_resource_memory() which only handles 32-bit resources.
Adding a call to acpi_dev_resource_address_space() in TPM CRB
driver which handles 64-bit resources.

Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
---
 drivers/char/tpm/tpm_crb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 717b6b4..86f355b 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -264,10 +264,12 @@ static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
 static int crb_check_resource(struct acpi_resource *ares, void *data)
 {
 	struct resource *io_res = data;
-	struct resource res;
+	struct resource_win win;
+	struct resource *res = &(win.res);
 
-	if (acpi_dev_resource_memory(ares, &res)) {
-		*io_res = res;
+	if (acpi_dev_resource_memory(ares, res) ||
+	    acpi_dev_resource_address_space(ares, &win)) {
+		*io_res = *res;
 		io_res->name = NULL;
 	}
 
-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
