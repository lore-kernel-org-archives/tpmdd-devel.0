From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 2/5] tpm: unify tpm_gen_interrupt()
Date: Tue, 19 Jul 2016 16:32:46 +0300
Message-ID: <1468935171-7815-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468935171-7815-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Migrated into single tpm_gen_interrupt() function and cleaned up the
whole construction in general because it was starting to turn into a
train wreck.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 23 ++++++++++++++---------
 drivers/char/tpm/tpm.h           |  1 -
 drivers/char/tpm/tpm2-cmd.c      | 17 -----------------
 drivers/char/tpm/tpm_tis_core.c  |  5 +----
 4 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1abe2d7..88dafcd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -459,18 +459,23 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
 	return rc;
 }
 
+/**
+ * tpm_gen_interrupt -- generate an interrupt by issuing an idempotent command
+ * @chip: TPM chip to use
+ *
+ * Returns 0 on success, < 0 in case of fatal error or a value > 0 representing
+ * a TPM error code.
+ */
 void tpm_gen_interrupt(struct tpm_chip *chip)
 {
-	struct	tpm_cmd_t tpm_cmd;
-	ssize_t rc;
+	const char *desc = "attempting to generate an interrupt";
+	u32 cap2;
+	cap_t cap;
 
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      "attempting to determine the timeouts");
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+	else
+		tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc);
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8b864dd..ec1f877 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -530,6 +530,5 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
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
index d66f51b..b67d225 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -575,10 +575,7 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	/* Generate an interrupt by having the core call through to
 	 * tpm_tis_send
 	 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		tpm2_gen_interrupt(chip);
-	else
-		tpm_gen_interrupt(chip);
+	tpm_gen_interrupt(chip);
 
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
