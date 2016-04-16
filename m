From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 06/12] tpm: Use read/write_bytes for
	drivers without more specialized methods
Date: Sat, 16 Apr 2016 08:35:36 +0200
Message-ID: <1460788542-2455-7-git-send-email-christophe-h.ricard@st.com>
References: <1460788542-2455-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460788542-2455-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm_tis_core.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 9dd6b41..4074c98 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -60,6 +60,18 @@ static inline int tpm_read8(struct tpm_chip *chip, u32 addr, u8 *result)
 	return priv->phy_ops->read_bytes(chip, addr, 1, result);
 }
 
+static inline int tpm_tis_common_read16(struct tpm_chip *chip, u32 addr,
+					u16 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+
+	rc = priv->phy_ops->read_bytes(chip, addr, sizeof(u16), (u8 *)result);
+	if (!rc)
+		*result = le16_to_cpu(*result);
+	return rc;
+}
+
 static inline int tpm_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
@@ -67,6 +79,18 @@ static inline int tpm_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 	return priv->phy_ops->read16(chip, addr, result);
 }
 
+static inline int tpm_tis_common_read32(struct tpm_chip *chip, u32 addr,
+					u32 *result)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+
+	rc = priv->phy_ops->read_bytes(chip, addr, sizeof(u32), (u8 *)result);
+	if (!rc)
+		*result = le32_to_cpu(*result);
+	return rc;
+}
+
 static inline int tpm_read32(struct tpm_chip *chip, u32 addr, u32 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
@@ -89,6 +113,16 @@ static inline int tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
 	return priv->phy_ops->write_bytes(chip, addr, 1, &value);
 }
 
+static inline int tpm_tis_common_write32(struct tpm_chip *chip, u32 addr,
+					 u32 value)
+{
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+
+	value = cpu_to_le32(value);
+	return priv->phy_ops->write_bytes(chip, addr, sizeof(u32),
+					   (u8 *)&value);
+}
+
 static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
