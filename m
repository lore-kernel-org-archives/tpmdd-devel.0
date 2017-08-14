From: Hamza Attak <hamza@hpe.com>
Subject: [PATCH v2] msleep() delays - replace with usleep_range() in TPM
 1.2/2.0 generic drivers
Date: Mon, 14 Aug 2017 19:09:16 +0100
Message-ID: <20170814180916.GA5574@dev-HP-EliteBook-Folio-1040-G1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com
Cc: tpmdd-devel@lists.sourceforge.net, nigel.edwards@hpe.com, ludo@hpe.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

The patch simply replaces all msleep function calls with usleep_range calls
in the generic drivers.

Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a
thousand PCR extends, we see results going from 1m57s unpatched to 40s
with the new patch. We obtain similar results when using the original and
patched tpm_infineon driver, which is also part of the patch.
Similarly with a STM TPM 2.0, using the CRB driver, it takes about 20ms per
extend unpatched and around 7ms with the new patch.

Note that the PCR consistency is untouched with this patch, each TPM has
been tested with 10 million extends and the aggregated PCR value is
continuously verified to be correct.

As an extension of this work, this could potentially and easily be applied
to other vendor's drivers. Still, these changes are not included in the
proposed patch as they are untested.

Signed-off-by: Hamza Attak <hamza@hpe.com>
---
 drivers/char/tpm/tpm-interface.c | 10 +++++-----
 drivers/char/tpm/tpm.h           |  9 ++++++++-
 drivers/char/tpm/tpm2-cmd.c      |  2 +-
 drivers/char/tpm/tpm_infineon.c  |  6 +++---
 drivers/char/tpm/tpm_tis_core.c  |  8 ++++----
 5 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e..123a73a 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -395,7 +395,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 			goto out;
 		}
 
-		msleep(TPM_TIMEOUT);	/* CHECK */
+		tpm_msleep(TPM_TIMEOUT);
 		rmb();
 	} while (time_before(jiffies, stop));
 
@@ -862,7 +862,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			dev_info(
 			    &chip->dev, HW_ERR
 			    "TPM command timed out during continue self test");
-			msleep(delay_msec);
+			tpm_msleep(delay_msec);
 			continue;
 		}
 
@@ -877,7 +877,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		}
 		if (rc != TPM_WARN_DOING_SELFTEST)
 			return rc;
-		msleep(delay_msec);
+		tpm_msleep(delay_msec);
 	} while (--loops > 0);
 
 	return rc;
@@ -977,7 +977,7 @@ again:
 		}
 	} else {
 		do {
-			msleep(TPM_TIMEOUT);
+			tpm_msleep(TPM_TIMEOUT);
 			status = chip->ops->status(chip);
 			if ((status & mask) == mask)
 				return 0;
@@ -1045,7 +1045,7 @@ int tpm_pm_suspend(struct device *dev)
 		 */
 		if (rc != TPM_WARN_RETRY)
 			break;
-		msleep(TPM_TIMEOUT_RETRY);
+		tpm_msleep(TPM_TIMEOUT_RETRY);
 	}
 
 	if (rc)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 4937b56..255ecdc 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -46,7 +46,8 @@ enum tpm_const {
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
-	TPM_TIMEOUT_RETRY = 100 /* msecs */
+	TPM_TIMEOUT_RETRY = 100, /* msecs */
+	TPM_TIMEOUT_RANGE_US = 300	/* usecs */
 };
 
 /* TPM addresses */
@@ -509,6 +510,12 @@ int tpm_pm_resume(struct device *dev);
 int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 		      wait_queue_head_t *queue, bool check_cancel);
 
+static inline void tpm_msleep(unsigned int delay_msec)
+{
+	usleep_range(delay_msec * 1000,
+		     (delay_msec * 1000) + TPM_TIMEOUT_RANGE_US);
+};
+
 struct tpm_chip *tpm_chip_find_get(int chip_num);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 881aea9..13c77fc 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -961,7 +961,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		if (rc != TPM2_RC_TESTING)
 			break;
 
-		msleep(delay_msec);
+		tpm_msleep(delay_msec);
 	}
 
 	return rc;
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index e3cf9f3..690d948 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -191,7 +191,7 @@ static int wait(struct tpm_chip *chip, int wait_for_bit)
 		/* check the status-register if wait_for_bit is set */
 		if (status & 1 << wait_for_bit)
 			break;
-		msleep(TPM_MSLEEP_TIME);
+		tpm_msleep(TPM_MSLEEP_TIME);
 	}
 	if (i == TPM_MAX_TRIES) {	/* timeout occurs */
 		if (wait_for_bit == STAT_XFE)
@@ -226,7 +226,7 @@ static void tpm_wtx(struct tpm_chip *chip)
 	wait_and_send(chip, TPM_CTRL_WTX);
 	wait_and_send(chip, 0x00);
 	wait_and_send(chip, 0x00);
-	msleep(TPM_WTX_MSLEEP_TIME);
+	tpm_msleep(TPM_WTX_MSLEEP_TIME);
 }
 
 static void tpm_wtx_abort(struct tpm_chip *chip)
@@ -237,7 +237,7 @@ static void tpm_wtx_abort(struct tpm_chip *chip)
 	wait_and_send(chip, 0x00);
 	wait_and_send(chip, 0x00);
 	number_of_wtx = 0;
-	msleep(TPM_WTX_MSLEEP_TIME);
+	tpm_msleep(TPM_WTX_MSLEEP_TIME);
 }
 
 static int tpm_inf_recv(struct tpm_chip *chip, u8 * buf, size_t count)
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index c0f296b..a305448 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -51,7 +51,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
 
 		if (access & TPM_ACCESS_VALID)
 			return 0;
-		msleep(TPM_TIMEOUT);
+		tpm_msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
 	return -1;
 }
@@ -125,7 +125,7 @@ again:
 		do {
 			if (check_locality(chip, l) >= 0)
 				return l;
-			msleep(TPM_TIMEOUT);
+			tpm_msleep(TPM_TIMEOUT);
 		} while (time_before(jiffies, stop));
 	}
 	return -1;
@@ -170,7 +170,7 @@ static int get_burstcount(struct tpm_chip *chip)
 		burstcnt = (value >> 8) & 0xFFFF;
 		if (burstcnt)
 			return burstcnt;
-		msleep(TPM_TIMEOUT);
+		tpm_msleep(TPM_TIMEOUT);
 	} while (time_before(jiffies, stop));
 	return -EBUSY;
 }
@@ -408,7 +408,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	priv->irq = irq;
 	chip->flags |= TPM_CHIP_FLAG_IRQ;
 	if (!priv->irq_tested)
-		msleep(1);
+		tpm_msleep(1);
 	if (!priv->irq_tested)
 		disable_interrupts(chip);
 	priv->irq_tested = true;
-- 
2.7.4
