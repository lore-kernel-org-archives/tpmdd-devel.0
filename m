From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 1/2] tpm: do not suspend/resume if power stays on
Date: Wed,  2 May 2018 17:38:28 +0300
Message-ID: <20180502143830.3534-2-jarkko.sakkinen@linux.intel.com>
References: <20180502143830.3534-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502143830.3534-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>, Sonny Rao <sonnyrao@chromium.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <james.l.morris@oracle.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

commit b5d0ebc99bf5d0801a5ecbe958caa3d68b8eaee8 upstream

The suspend/resume behavior of the TPM can be controlled by setting
"powered-while-suspended" in the DTS. This is useful for the cases
when hardware does not power-off the TPM.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
---
 drivers/char/tpm/tpm-interface.c | 3 +++
 drivers/char/tpm/tpm.h           | 2 ++
 drivers/char/tpm/tpm_of.c        | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 830d7e30e508..5463b649bdf1 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -969,6 +969,9 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
+		return 0;
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		tpm2_shutdown(chip, TPM2_SU_STATE);
 		return 0;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index aa4299cf7e5a..41756a9e9ad8 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -143,6 +143,8 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_TPM2		= BIT(1),
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
+	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
+	TPM_CHIP_FLAG_ALWAYS_POWERED	= BIT(5),
 };
 
 struct tpm_chip {
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 570f30c5c5f4..669f4a046398 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -37,6 +37,9 @@ int read_log(struct tpm_bios_log *log)
 		return -ENODEV;
 	}
 
+	if (of_property_read_bool(np, "powered-while-suspended"))
+		chip->flags |= TPM_CHIP_FLAG_ALWAYS_POWERED;
+
 	sizep = of_get_property(np, "linux,sml-size", NULL);
 	if (sizep == NULL) {
 		pr_err("%s: ERROR - SML size not found\n", __func__);
-- 
2.17.0
