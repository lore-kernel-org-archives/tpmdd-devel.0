From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/12] tpm/tpm_tis: Rework interrupt
	management for phy compatibility
Date: Sun, 20 Mar 2016 20:34:40 +0100
Message-ID: <1458502483-16887-10-git-send-email-christophe-h.ricard@st.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458502483-16887-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
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

Rework interrupt handling in order to be compatible with every phy.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 11 ++++++++---
 drivers/char/tpm/tpm.h           |  1 +
 drivers/char/tpm/tpm_tis_core.c  | 24 +++++++++++++++++++-----
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 5397b64..c06378b 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -881,7 +881,9 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 	unsigned long stop;
 	long rc;
 	u8 status;
+	u32 cur_intrs;
 	bool canceled = false;
+	bool condition;
 
 	/* check current status */
 	status = chip->ops->status(chip);
@@ -892,14 +894,17 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	if (chip->vendor.irq) {
 again:
+		cur_intrs = chip->vendor.intrs;
 		timeout = stop - jiffies;
 		if ((long)timeout <= 0)
 			return -ETIME;
 		rc = wait_event_interruptible_timeout(*queue,
-			wait_for_tpm_stat_cond(chip, mask, check_cancel,
-					       &canceled),
+			cur_intrs != chip->vendor.intrs,
 			timeout);
-		if (rc > 0) {
+		condition = wait_for_tpm_stat_cond(chip, mask,
+						   check_cancel,
+						   &canceled);
+		if (rc > 0 && condition) {
 			if (canceled)
 				return -ECANCELED;
 			return 0;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 3ec04f4..32c17f4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -139,6 +139,7 @@ struct tpm_vendor_specific {
 	unsigned long base;		/* TPM base address */
 
 	int irq;
+	u32 intrs;
 
 	int region_size;
 	int have_region;
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index b9cc61f..baa9ab1 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -41,6 +41,18 @@ struct tpm_info {
 	int irq;
 };
 
+static void tpm_tis_clear_int(struct tpm_chip *chip)
+{
+	u32 interrupt;
+
+	if (chip->vendor.irq) {
+		interrupt = tpm_read_dword(chip,
+					TPM_INT_STATUS(chip->vendor.locality));
+		tpm_write_dword(chip, TPM_INT_STATUS(chip->vendor.locality),
+				interrupt);
+	}
+}
+
 /* Before we attempt to access the TPM we must see that the valid bit is set.
  * The specification says that this bit is 0 at reset and remains 0 until the
  * 'TPM has gone through its self test and initialization and has established
@@ -192,6 +204,8 @@ int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		goto out;
 	}
 
+	tpm_tis_clear_int(chip);
+
 	/* read first 10 bytes, including tag, paramsize, and result */
 	size = recv_data(chip, buf, TPM_HEADER_SIZE);
 	if (size < TPM_HEADER_SIZE) {
@@ -313,6 +327,8 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 	u32 ordinal;
 	unsigned long dur;
 
+	tpm_tis_clear_int(chip);
+
 	rc = tpm_tis_send_data(chip, buf, len);
 	if (rc < 0)
 		return rc;
@@ -455,6 +471,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 		return IRQ_NONE;
 
 	chip->vendor.irq_tested = true;
+	chip->vendor.intrs++;
 	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
 		wake_up_interruptible(&chip->vendor.read_queue);
 	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
@@ -466,9 +483,6 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	     TPM_INTF_CMD_READY_INT))
 		wake_up_interruptible(&chip->vendor.int_queue);
 
-	/* Clear interrupts handled with TPM_EOI */
-	tpm_write_dword(chip, TPM_INT_STATUS(chip->vendor.locality), interrupt);
-	tpm_read_dword(chip, TPM_INT_STATUS(chip->vendor.locality));
 	return IRQ_HANDLED;
 }
 
@@ -481,8 +495,8 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 {
 	u8 original_int_vec;
 
-	if (devm_request_irq(&chip->dev, irq, tis_int_handler, flags,
-			     dev_name(&chip->dev), chip) != 0) {
+	if (devm_request_threaded_irq(&chip->dev, irq, NULL, tis_int_handler, flags,
+				      dev_name(&chip->dev), chip) != 0) {
 		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
