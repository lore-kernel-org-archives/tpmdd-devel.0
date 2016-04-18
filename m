From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 11/12] tpm: Use read/write_bytes for
	drivers without more specialized methods
Date: Tue, 19 Apr 2016 00:17:43 +0200
Message-ID: <1461017864-3903-12-git-send-email-christophe-h.ricard@st.com>
References: <1461017864-3903-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461017864-3903-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Some drivers might need to implement only functions for transferring an
arbitrary number of bytes. Provides a generic functions for handling  of
word or dword transfers to be dump into driver functions pointers.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h |  4 ++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 09f7822..5933781 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -803,6 +803,40 @@ int tpm_tis_resume(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_tis_resume);
 #endif
 
+int tpm_tis_common_read16(struct tpm_chip *chip, u32 addr, u16 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+
+	rc = priv->phy_ops->read_bytes(chip, addr, sizeof(u16), (u8 *)result);
+	if (!rc)
+		*result = le16_to_cpu(*result);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_read16);
+
+int tpm_tis_common_read32(struct tpm_chip *chip, u32 addr, u32 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+
+	rc = priv->phy_ops->read_bytes(chip, addr, sizeof(u32), (u8 *)result);
+	if (!rc)
+		*result = le32_to_cpu(*result);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_read32);
+
+int tpm_tis_common_write32(struct tpm_chip *chip, u32 addr, u32 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	value = cpu_to_le32(value);
+	return priv->phy_ops->write_bytes(chip, addr, sizeof(u32),
+					   (u8 *)&value);
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_write32);
+
 MODULE_AUTHOR("Leendert van Doorn (leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org)");
 MODULE_DESCRIPTION("TPM Driver");
 MODULE_VERSION("2.0");
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 157c5c3..6b82944 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -153,6 +153,10 @@ static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 	return priv->phy_ops->write32(chip, addr, value);
 }
 
+int tpm_tis_common_read16(struct tpm_chip *chip, u32 addr, u16 *result);
+int tpm_tis_common_read32(struct tpm_chip *chip, u32 addr, u32 *result);
+int tpm_tis_common_write32(struct tpm_chip *chip, u32 addr, u32 value);
+
 void tpm_tis_ready(struct tpm_chip *chip);
 void release_locality(struct tpm_chip *chip, int l, int force);
 int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len);
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
