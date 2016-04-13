From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/12] tpm: Use read/write_bytes for
	drivers without more specialized methods
Date: Wed, 13 Apr 2016 21:55:44 +0200
Message-ID: <1460577351-24632-6-git-send-email-christophe-h.ricard@st.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460577351-24632-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

Some drivers might choose to implement only functions for transferring an
arbitrary number of bytes, without special handling of word or dword
transfers.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis_core.h | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index b0f1e3c..732f305 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -65,15 +65,31 @@ static inline int tpm_read8(struct tpm_chip *chip, u32 addr, u8 *result)
 static inline int tpm_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
 
-	return priv->lowlevel->read16(chip, addr, result);
+	if (priv->lowlevel->read16)
+		return priv->lowlevel->read16(chip, addr, result);
+
+	rc = priv->lowlevel->read_bytes(chip, addr, sizeof(u16), (u8 *)result);
+	if (!rc)
+		*result = le16_to_cpu(*result);
+
+	return rc;
 }
 
 static inline u32 tpm_read32(struct tpm_chip *chip, u32 addr, u32 *result)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
+	int rc;
+
+	if (priv->lowlevel->read32)
+		return priv->lowlevel->read32(chip, addr, result);
 
-	return priv->lowlevel->read32(chip, addr, result);
+	rc = priv->lowlevel->read_bytes(chip, addr, sizeof(u32), (u8 *)result);
+	if (!rc)
+		*result = le32_to_cpu(*result);
+
+	return rc;
 }
 
 static inline int tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
@@ -95,7 +111,12 @@ static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
-	return priv->lowlevel->write32(chip, addr, value);
+	if (priv->lowlevel->write32)
+		return priv->lowlevel->write32(chip, addr, value);
+
+	value = cpu_to_le32(value);
+	return priv->lowlevel->write_bytes(chip, addr, sizeof(u32),
+					   (u8 *)&value);
 }
 
 #endif
-- 
2.5.0


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
