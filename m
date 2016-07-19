From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 3/5] tpm: replace tpm_gen_interrupt() with
	tpm_tis_gen_interrupt()
Date: Wed, 20 Jul 2016 02:44:58 +0300
Message-ID: <1468971906-6528-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1468971906-6528-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468971906-6528-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Since tpm_gen_interrupt() is only used in tpm_tis_core.c this commit
replaces it with an internal tpm_tis_gen_interrupt(). The semantics
also changed in a way that on a system error the driver initialization
is failed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 15 ---------------
 drivers/char/tpm/tpm.h           |  2 --
 drivers/char/tpm/tpm2-cmd.c      | 17 -----------------
 drivers/char/tpm/tpm_tis_core.c  | 19 +++++++++++++++----
 4 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1abe2d7..f43cc3f 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -459,21 +459,6 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 	return rc;
 }
 
-void tpm_gen_interrupt(struct tpm_chip *chip)
-{
-	struct	tpm_cmd_t tpm_cmd;
-	ssize_t rc;
-
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      "attempting to determine the timeouts");
-}
-EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
-
 #define TPM_ORD_STARTUP cpu_to_be32(153)
 #define TPM_ST_CLEAR cpu_to_be16(1)
 #define TPM_ST_STATE cpu_to_be16(2)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8b864dd..6e002c4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -483,7 +483,6 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
 int tpm_get_timeouts(struct tpm_chip *chip);
-void tpm_gen_interrupt(struct tpm_chip *chip);
 int tpm1_auto_startup(struct tpm_chip *chip);
 int tpm_do_selftest(struct tpm_chip *chip);
 unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
@@ -530,6 +529,5 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 int tpm2_auto_startup(struct tpm_chip *chip);
 void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
 unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
-int tpm2_gen_interrupt(struct tpm_chip *chip);
 int tpm2_probe(struct tpm_chip *chip);
 #endif
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 08c7e23..1c393ba 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -895,23 +895,6 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 }
 
 /**
- * tpm2_gen_interrupt() - generate an interrupt
- * @chip: TPM chip to use
- *
- * 0 is returned when the operation is successful. If a negative number is
- * returned it remarks a POSIX error code. If a positive number is returned
- * it remarks a TPM error.
- */
-int tpm2_gen_interrupt(struct tpm_chip *chip)
-{
-	u32 dummy;
-
-	return tpm2_get_tpm_pt(chip, 0x100, &dummy,
-			       "attempting to generate an interrupt");
-}
-EXPORT_SYMBOL_GPL(tpm2_gen_interrupt);
-
-/**
  * tpm2_probe() - probe TPM 2.0
  * @chip: TPM chip to use
  *
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index d66f51b..f22caf8 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -526,6 +526,18 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
+{
+	const char *desc = "attempting to generate an interrupt";
+	u32 cap2;
+	cap_t cap;
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+	else
+		return tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
+}
+
 /* Register the IRQ and issue a command that will cause an interrupt. If an
  * irq is seen then leave the chip setup for IRQ operation, otherwise reverse
  * everything and leave in polling mode. Returns 0 on success.
@@ -575,10 +587,9 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	/* Generate an interrupt by having the core call through to
 	 * tpm_tis_send
 	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_gen_interrupt(chip);
-	else
-		tpm_gen_interrupt(chip);
+	rc = tpm_tis_gen_interrupt(chip);
+	if (rc < 0)
+		return rc;
 
 	/* tpm_tis_send will either confirm the interrupt is working or it
 	 * will call disable_irq which undoes all of the above.
-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
