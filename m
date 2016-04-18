From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 03/12] tpm: tpm_tis: Rename priv_data
	structure tpm_tis_data
Date: Tue, 19 Apr 2016 00:17:35 +0200
Message-ID: <1461017864-3903-4-git-send-email-christophe-h.ricard@st.com>
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

For code sanity rename priv_data tpm_tis_data.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c      | 44 ++++++++++++++++++++---------------------
 drivers/char/tpm/tpm_tis_core.h |  2 +-
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 7d5d2d2..af53747 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -95,7 +95,7 @@ struct tpm_info {
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
 struct tpm_tis_lpc_phy {
-	struct priv_data priv;
+	struct tpm_tis_data priv;
 	void __iomem *iobase;
 };
 
@@ -131,7 +131,7 @@ static inline int is_itpm(struct acpi_device *dev)
  * correct values in the other bits.' */
 static int wait_startup(struct tpm_chip *chip, int l)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	unsigned long stop = jiffies + chip->timeout_a;
 	do {
@@ -145,7 +145,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
 
 static int check_locality(struct tpm_chip *chip, int l)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	if ((ioread8(phy->iobase + TPM_ACCESS(l)) &
@@ -158,7 +158,7 @@ static int check_locality(struct tpm_chip *chip, int l)
 
 static void release_locality(struct tpm_chip *chip, int l, int force)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	if (force || (ioread8(phy->iobase + TPM_ACCESS(l)) &
@@ -170,7 +170,7 @@ static void release_locality(struct tpm_chip *chip, int l, int force)
 
 static int request_locality(struct tpm_chip *chip, int l)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	unsigned long stop, timeout;
 	long rc;
@@ -212,7 +212,7 @@ again:
 
 static u8 tpm_tis_status(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	return ioread8(phy->iobase +
@@ -221,7 +221,7 @@ static u8 tpm_tis_status(struct tpm_chip *chip)
 
 static void tpm_tis_ready(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 
 	/* this causes the current command to be aborted */
@@ -231,7 +231,7 @@ static void tpm_tis_ready(struct tpm_chip *chip)
 
 static int get_burstcount(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	unsigned long stop;
 	int burstcnt;
@@ -254,7 +254,7 @@ static int get_burstcount(struct tpm_chip *chip)
 
 static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	int size = 0, burstcnt;
 	while (size < count &&
@@ -273,7 +273,7 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 
 static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int size = 0;
 	int expected, status;
 
@@ -329,7 +329,7 @@ MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
  */
 static int tpm_tis_send_data(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	int rc, status, burstcnt;
 	size_t count = 0;
@@ -386,7 +386,7 @@ out_err:
 
 static void disable_interrupts(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	u32 intmask;
 
@@ -408,7 +408,7 @@ static void disable_interrupts(struct tpm_chip *chip)
  */
 static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	int rc;
 	u32 ordinal;
@@ -446,7 +446,7 @@ out_err:
 
 static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	int rc, irq;
 
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ) || priv->irq_tested)
@@ -481,7 +481,7 @@ static const struct tis_vendor_timeout_override vendor_timeout_overrides[] = {
 static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
 				    unsigned long *timeout_cap)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	int i;
 	u32 did_vid;
@@ -506,7 +506,7 @@ static bool tpm_tis_update_timeouts(struct tpm_chip *chip,
  */
 static int probe_itpm(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	int rc = 0;
 	u8 cmd_getticks[] = {
@@ -549,7 +549,7 @@ out:
 
 static bool tpm_tis_req_canceled(struct tpm_chip *chip, u8 status)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 
 	switch (priv->manufacturer_id) {
 	case TPM_VID_WINBOND:
@@ -576,7 +576,7 @@ static const struct tpm_class_ops tpm_tis = {
 static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 {
 	struct tpm_chip *chip = dev_id;
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	u32 interrupt;
 	int i;
@@ -614,7 +614,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 				    int flags, int irq)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	u8 original_int_vec;
 
@@ -668,7 +668,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
  */
 static void tpm_tis_probe_irq(struct tpm_chip *chip, u32 intmask)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	u8 original_int_vec;
 	int i;
@@ -693,7 +693,7 @@ MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static void tpm_tis_remove(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	void __iomem *reg = phy->iobase + TPM_INT_ENABLE(priv->locality);
 
@@ -857,7 +857,7 @@ out_err:
 #ifdef CONFIG_PM_SLEEP
 static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 {
-	struct priv_data *priv = dev_get_drvdata(&chip->dev);
+	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
 	struct tpm_tis_lpc_phy *phy = to_tpm_tis_lpc_phy(priv);
 	u32 intmask;
 
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 6de7986..2260f89 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -25,7 +25,7 @@
 
 #include "tpm.h"
 
-struct priv_data {
+struct tpm_tis_data {
 	u16 manufacturer_id;
 	int locality;
 	int irq;
-- 
2.1.4


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
