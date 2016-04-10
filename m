From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/10] tpm: Use read/write_bytes for drivers
	without more specialized methods
Date: Sun, 10 Apr 2016 23:22:59 +0200
Message-ID: <1460323386-16892-4-git-send-email-christophe-h.ricard@st.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1460323386-16892-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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
 drivers/char/tpm/tpm.h | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e93e19b..68ce900 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -475,17 +475,35 @@ static inline int tpm_read_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 
 static inline int tpm_read8(struct tpm_chip *chip, u32 addr, u8 *result)
 {
-	return chip->lowlevel->read_bytes(chip, addr, 1, result);
+	return chip->lowlevel->read_bytes(chip, addr, sizeof(u8), result);
 }
 
 static inline int tpm_read16(struct tpm_chip *chip, u32 addr, u16 *result)
 {
-	return chip->lowlevel->read16(chip, addr, result);
+	int rc;
+
+	if (chip->lowlevel->read16)
+		return chip->lowlevel->read16(chip, addr, result);
+
+	rc = chip->lowlevel->read_bytes(chip, addr, sizeof(u16), (u8 *)result);
+	if (!rc)
+		*result = le16_to_cpu(*result);
+
+	return rc;
 }
 
 static inline int tpm_read32(struct tpm_chip *chip, u32 addr, u32 *result)
 {
-	return chip->lowlevel->read32(chip, addr, result);
+	int rc;
+
+	if (chip->lowlevel->read32)
+		return chip->lowlevel->read32(chip, addr, result);
+
+	rc = chip->lowlevel->read_bytes(chip, addr, sizeof(u32), (u8 *)result);
+	if (!rc)
+		*result = le32_to_cpu(*result);
+
+	return rc;
 }
 
 static inline int tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
@@ -496,12 +514,17 @@ static inline int tpm_write_bytes(struct tpm_chip *chip, u32 addr, u16 len,
 
 static inline int tpm_write8(struct tpm_chip *chip, u32 addr, u8 value)
 {
-	return chip->lowlevel->write_bytes(chip, addr, 1, &value);
+	return chip->lowlevel->write_bytes(chip, addr, sizeof(u8), &value);
 }
 
 static inline int tpm_write32(struct tpm_chip *chip, u32 addr, u32 value)
 {
-	return chip->lowlevel->write32(chip, addr, value);
+	if (chip->lowlevel->write32)
+		return chip->lowlevel->write32(chip, addr, value);
+
+	value = cpu_to_le32(value);
+	return chip->lowlevel->write_bytes(chip, addr, sizeof(u32),
+					   (u8 *)&value);
 }
 
 extern struct class *tpm_class;
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
