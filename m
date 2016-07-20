From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v2] tpm: add sysfs attributes for tpm2
Date: Tue, 19 Jul 2016 19:51:52 -0700
Message-ID: <e084dfe4f1865aed1a38376f5ce4731fe52030d4.1468982816.git.apronin@chromium.org>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468547496-16215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1468547496-16215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468547496-16215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add sysfs attributes in TPM2.0 case for:
 - TPM_PT_PERMANENT flags
 - TPM_PT_STARTUP_CLEAR flags
 - lockout-related properties

v2: Dropped adding driver-specific attributes.
    No legacy links for TPM2 attributes.
    All attributes created in groups[0].
    Added actual attributes for flags and lockout properties.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/tpm-chip.c  |   4 +-
 drivers/char/tpm/tpm-sysfs.c | 108 +++++++++++++++++++++++++++++++++++++++++--
 drivers/char/tpm/tpm.h       |  30 ++++++++++++
 3 files changed, 136 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e595013..ede2ca0 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -281,8 +281,6 @@ static int tpm1_chip_register(struct tpm_chip *chip)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return 0;
 
-	tpm_sysfs_add_device(chip);
-
 	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
 
 	return 0;
@@ -363,6 +361,8 @@ int tpm_chip_register(struct tpm_chip *chip)
 			return rc;
 	}
 
+	tpm_sysfs_add_device(chip);
+
 	rc = tpm1_chip_register(chip);
 	if (rc)
 		return rc;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index b46cf70..fcfc7e0 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -264,7 +264,7 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(timeouts);
 
-static struct attribute *tpm_dev_attrs[] = {
+static struct attribute *tpm1_dev_attrs[] = {
 	&dev_attr_pubek.attr,
 	&dev_attr_pcrs.attr,
 	&dev_attr_enabled.attr,
@@ -278,8 +278,106 @@ static struct attribute *tpm_dev_attrs[] = {
 	NULL,
 };
 
-static const struct attribute_group tpm_dev_group = {
-	.attrs = tpm_dev_attrs,
+static const struct attribute_group tpm1_dev_group = {
+	.attrs = tpm1_dev_attrs,
+};
+
+static ssize_t tpm2_prop_flag_show(struct device *dev, u32 property_id,
+				   u32 flag_mask, char *buf)
+{
+	u32 flags;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(to_tpm_chip(dev), property_id, &flags,
+			     "reading property");
+	if (rc)
+		return 0;
+
+	return sprintf(buf, "%d\n", !!(flags & flag_mask));
+}
+
+static ssize_t tpm2_prop_u32_show(struct device *dev, u32 property_id,
+				  char *buf)
+{
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(to_tpm_chip(dev), property_id, &value,
+			     "reading property");
+	if (rc)
+		return 0;
+
+	return sprintf(buf, "%u\n", value);
+}
+
+#define DEFINE_TPM2_PROP_FLAG_ATTR(name, property_id, flag_mask)      \
+static ssize_t name##_show(struct device *dev,                        \
+			   struct device_attribute *attr, char *buf)  \
+{                                                                     \
+	return tpm2_prop_flag_show(dev, property_id, flag_mask, buf); \
+}                                                                     \
+static DEVICE_ATTR_RO(name)
+
+#define DEFINE_TPM2_PROP_U32_ATTR(name, property_id)                  \
+static ssize_t name##_show(struct device *dev,                        \
+			   struct device_attribute *attr, char *buf)  \
+{                                                                     \
+	return tpm2_prop_u32_show(dev, property_id, buf);             \
+}                                                                     \
+static DEVICE_ATTR_RO(name)
+
+DEFINE_TPM2_PROP_FLAG_ATTR(owner_auth_set,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_OWNER_AUTH_SET);
+DEFINE_TPM2_PROP_FLAG_ATTR(endorsement_auth_set,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_ENDORSEMENT_AUTH_SET);
+DEFINE_TPM2_PROP_FLAG_ATTR(lockout_auth_set,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_LOCKOUT_AUTH_SET);
+DEFINE_TPM2_PROP_FLAG_ATTR(disable_clear,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_DISABLE_CLEAR);
+DEFINE_TPM2_PROP_FLAG_ATTR(in_lockout,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_IN_LOCKOUT);
+DEFINE_TPM2_PROP_FLAG_ATTR(tpm_generated_eps,
+			   TPM2_PT_PERMANENT, TPM2_ATTR_TPM_GENERATED_EPS);
+
+DEFINE_TPM2_PROP_FLAG_ATTR(ph_enable,
+			   TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_PH_ENABLE);
+DEFINE_TPM2_PROP_FLAG_ATTR(sh_enable,
+			   TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_SH_ENABLE);
+DEFINE_TPM2_PROP_FLAG_ATTR(eh_enable,
+			   TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_EH_ENABLE);
+DEFINE_TPM2_PROP_FLAG_ATTR(ph_enable_nv,
+			   TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_PH_ENABLE_NV);
+DEFINE_TPM2_PROP_FLAG_ATTR(orderly,
+			   TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_ORDERLY);
+
+DEFINE_TPM2_PROP_U32_ATTR(lockout_counter, TPM2_PT_LOCKOUT_COUNTER);
+DEFINE_TPM2_PROP_U32_ATTR(max_auth_fail, TPM2_PT_MAX_AUTH_FAIL);
+DEFINE_TPM2_PROP_U32_ATTR(lockout_interval, TPM2_PT_LOCKOUT_INTERVAL);
+DEFINE_TPM2_PROP_U32_ATTR(lockout_recovery, TPM2_PT_LOCKOUT_RECOVERY);
+
+static struct attribute *tpm2_dev_attrs[] = {
+	&dev_attr_owner_auth_set.attr,
+	&dev_attr_endorsement_auth_set.attr,
+	&dev_attr_lockout_auth_set.attr,
+	&dev_attr_disable_clear.attr,
+	&dev_attr_in_lockout.attr,
+	&dev_attr_tpm_generated_eps.attr,
+	&dev_attr_ph_enable.attr,
+	&dev_attr_sh_enable.attr,
+	&dev_attr_eh_enable.attr,
+	&dev_attr_ph_enable_nv.attr,
+	&dev_attr_orderly.attr,
+	&dev_attr_lockout_counter.attr,
+	&dev_attr_max_auth_fail.attr,
+	&dev_attr_lockout_interval.attr,
+	&dev_attr_lockout_recovery.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	NULL,
+};
+
+static const struct attribute_group tpm2_dev_group = {
+	.attrs = tpm2_dev_attrs,
 };
 
 void tpm_sysfs_add_device(struct tpm_chip *chip)
@@ -289,5 +387,7 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
 	 * removal so that no callbacks are running or can run again
 	 */
 	WARN_ON(chip->groups_cnt != 0);
-	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
+	chip->groups[chip->groups_cnt++] =
+		(chip->flags & TPM_CHIP_FLAG_TPM2) ?
+		&tpm2_dev_group : &tpm1_dev_group;
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3e32d5b..cf4359a 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -127,6 +127,36 @@ enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_properties {
+	TPM2_PT_NONE			= 0,
+	TPM2_PT_GROUP			= 0x100,
+	TPM2_PT_FIXED			= TPM2_PT_GROUP,
+	TPM2_PT_VAR			= TPM2_PT_GROUP * 2,
+	TPM2_PT_PERMANENT		= TPM2_PT_VAR + 0,
+	TPM2_PT_STARTUP_CLEAR		= TPM2_PT_VAR + 1,
+	TPM2_PT_LOCKOUT_COUNTER		= TPM2_PT_VAR + 14,
+	TPM2_PT_MAX_AUTH_FAIL		= TPM2_PT_VAR + 15,
+	TPM2_PT_LOCKOUT_INTERVAL	= TPM2_PT_VAR + 16,
+	TPM2_PT_LOCKOUT_RECOVERY	= TPM2_PT_VAR + 17,
+};
+
+enum tpm2_attr_permanent {
+	TPM2_ATTR_OWNER_AUTH_SET	= BIT(0),
+	TPM2_ATTR_ENDORSEMENT_AUTH_SET	= BIT(1),
+	TPM2_ATTR_LOCKOUT_AUTH_SET	= BIT(2),
+	TPM2_ATTR_DISABLE_CLEAR		= BIT(8),
+	TPM2_ATTR_IN_LOCKOUT		= BIT(9),
+	TPM2_ATTR_TPM_GENERATED_EPS	= BIT(10),
+};
+
+enum tpm2_attr_startup_clear {
+	TPM2_ATTR_PH_ENABLE		= BIT(0),
+	TPM2_ATTR_SH_ENABLE		= BIT(1),
+	TPM2_ATTR_EH_ENABLE		= BIT(2),
+	TPM2_ATTR_PH_ENABLE_NV		= BIT(3),
+	TPM2_ATTR_ORDERLY		= BIT(31),
+};
+
 enum tpm2_startup_types {
 	TPM2_SU_CLEAR	= 0x0000,
 	TPM2_SU_STATE	= 0x0001,
-- 
2.6.6


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
