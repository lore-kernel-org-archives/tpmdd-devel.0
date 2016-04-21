From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 7/8] tpm: Use read/write_bytes for drivers
	without more specialized methods
Date: Fri, 22 Apr 2016 00:04:42 +0200
Message-ID: <1461276283-2453-8-git-send-email-christophe-h.ricard@st.com>
References: <1461276283-2453-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1461276283-2453-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm_tis_core.c | 30 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_tis_core.h |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index f4e05ac..fd9c6a5 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -854,6 +854,36 @@ int tpm_tis_resume(struct device *dev)
 EXPORT_SYMBOL_GPL(tpm_tis_resume);
 #endif
 
+int tpm_tis_common_read16(struct tpm_tis_data *data, u32 addr, u16 *result)
+{
+	int rc;
+
+	rc = data->phy_ops->read_bytes(data, addr, sizeof(u16), (u8 *)result);
+	if (!rc)
+		*result = le16_to_cpu(*result);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_read16);
+
+int tpm_tis_common_read32(struct tpm_tis_data *data, u32 addr, u32 *result)
+{
+	int rc;
+
+	rc = data->phy_ops->read_bytes(data, addr, sizeof(u32), (u8 *)result);
+	if (!rc)
+		*result = le32_to_cpu(*result);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_read32);
+
+int tpm_tis_common_write32(struct tpm_tis_data *data, u32 addr, u32 value)
+{
+	value = cpu_to_le32(value);
+	return data->phy_ops->write_bytes(data, addr, sizeof(u32),
+					   (u8 *)&value);
+}
+EXPORT_SYMBOL_GPL(tpm_tis_common_write32);
+
 MODULE_AUTHOR("Leendert van Doorn (leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org)");
 MODULE_DESCRIPTION("TPM Driver");
 MODULE_VERSION("2.0");
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 76899d8..b426934 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -142,6 +142,10 @@ static inline int tpm_write32(struct tpm_tis_data *data, u32 addr, u32 value)
 	return data->phy_ops->write32(data, addr, value);
 }
 
+int tpm_tis_common_read16(struct tpm_tis_data *data, u32 addr, u16 *result);
+int tpm_tis_common_read32(struct tpm_tis_data *data, u32 addr, u32 *result);
+int tpm_tis_common_write32(struct tpm_tis_data *data, u32 addr, u32 value);
+
 void tpm_tis_remove(struct tpm_chip *chip);
 int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		      const struct tpm_tis_phy_ops *phy_ops,
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
