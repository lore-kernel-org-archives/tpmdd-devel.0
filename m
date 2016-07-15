From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH 2/2] tpm: support driver-specific sysfs attrs
	in tpm_tis_core
Date: Thu, 14 Jul 2016 18:51:36 -0700
Message-ID: <1468547496-16215-3-git-send-email-apronin@chromium.org>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468547496-16215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add attr_group to phy_ops that a driver relying on tpm_tis_core_init
can set to have its specific attributes registered in sysfs.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/tpm-sysfs.c    | 1 -
 drivers/char/tpm/tpm.h          | 8 +++++++-
 drivers/char/tpm/tpm_tis_core.c | 3 +++
 drivers/char/tpm/tpm_tis_core.h | 1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 95ce90d..22c9874 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -304,7 +304,6 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
 	 * is called before ops is null'd and the sysfs core synchronizes this
 	 * removal so that no callbacks are running or can run again
 	 */
-	WARN_ON(chip->groups_cnt != 0);
 	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		chip->groups[chip->groups_cnt++] = &tpm2_dev_group;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8890df2..8c69649 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -173,7 +173,13 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
-	const struct attribute_group *groups[3];
+	/* up to 4 attribute groups:
+	 * - driver-specific
+	 * - common TPM1.2 and TPM2.0
+	 * - TPM1.2/2.0-specific
+	 * - ppi
+	 */
+	const struct attribute_group *groups[5];
 	unsigned int groups_cnt;
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 8110b52..6d5d8f4 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -796,6 +796,9 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		}
 	}
 
+	if (priv->phy_ops->attr_group)
+		chip->groups[chip->groups_cnt++] = priv->phy_ops->attr_group;
+
 	return tpm_chip_register(chip);
 out_err:
 	tpm_tis_remove(chip);
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9191aab..4417ed9 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -95,6 +95,7 @@ struct tpm_tis_data {
 };
 
 struct tpm_tis_phy_ops {
+	const struct attribute_group *attr_group;
 	int (*read_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
 			  u8 *result);
 	int (*write_bytes)(struct tpm_tis_data *data, u32 addr, u16 len,
-- 
2.6.6


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
