From: "Attak, Hamza" <hamza.attak-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH] msleep() delays - replace with usleep_range()
 in TPM 1.2/2.0 generic drivers
Date: Mon, 10 Jul 2017 13:26:51 +0000
Message-ID: <DF4PR84MB0028CFD4B5EBE9F929B83476F2A90@DF4PR84MB0028.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: "Jacquin, Ludovic" <ludo-ZPxbGqLxI0U@public.gmane.org>, "Edwards, Nigel" <nigel.edwards-ZPxbGqLxI0U@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

msleep() delays - replace with usleep_range() in TPM 1.2/2.0 generic drivers

Following the recent Nuvoton patch submitted by Mimi Zohar:
https://sourceforge.net/p/tpmdd/mailman/message/35685260/

Based on this work, I decided to apply a similar modification to the generic TPM drivers in the kernel.
The patch simply replaces all msleep function calls with usleep_range calls in the generic drivers. As a former patch already exists for the Nuvoton TPM, it is therefore not included in this new patch.

Tested with an Infineon TPM 1.2, using the generic tpm-tis module, for a thousand PCR extends, we see results going from 1m57s unpatched to 40s with the new patch. We obtain similar results when using the original and patched tpm_infineon driver, which is also part of the patch.
Similarly with a STM TPM 2.0, using the CRB driver, it takes about 20ms per extend unpatched and around 7ms with the new patch.

Note that the PCR consistency is untouched with this patch, each TPM has been tested with 10 million extends and the aggregated PCR value is continuously verified to be correct.

As an extension of this work, this could potentially and easily be applied to other vendor's drivers. Still, these changes are not included in the proposed patch as they are untested.

Signed-off-by: Hamza Attak <hamza-ZPxbGqLxI0U@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 10 +++++-----
 drivers/char/tpm/tpm2-cmd.c      |  2 +-
 drivers/char/tpm/tpm_infineon.c  |  6 +++---
 drivers/char/tpm/tpm_tis_core.c  |  8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index bd2128e..f03daf5 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -395,7 +395,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const u8 *buf, size_t bufsiz,
 			goto out;
 		}
 
-		msleep(TPM_TIMEOUT);	/* CHECK */
+		usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);
 		rmb();
 	} while (time_before(jiffies, stop));
 
@@ -862,7 +862,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 			dev_info(
 			    &chip->dev, HW_ERR
 			    "TPM command timed out during continue self test");
-			msleep(delay_msec);
+			usleep_range(delay_msec * 1000, (delay_msec * 1000) + 300);
 			continue;
 		}
 
@@ -877,7 +877,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		}
 		if (rc != TPM_WARN_DOING_SELFTEST)
 			return rc;
-		msleep(delay_msec);
+		usleep_range(delay_msec * 1000, (delay_msec * 1000) + 300);
 	} while (--loops > 0);
 
 	return rc;
@@ -977,7 +977,7 @@ again:
 		}
 	} else {
 		do {
-			msleep(TPM_TIMEOUT);
+			usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);
 			status = chip->ops->status(chip);
 			if ((status & mask) == mask)
 				return 0;
@@ -1045,7 +1045,7 @@ int tpm_pm_suspend(struct device *dev)
 		 */
 		if (rc != TPM_WARN_RETRY)
 			break;
-		msleep(TPM_TIMEOUT_RETRY);
+		usleep_range(TPM_TIMEOUT_RETRY * 1000, (TPM_TIMEOUT_RETRY * 1000) + 300);
 	}
 
 	if (rc)
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 881aea9..bdae205 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -961,7 +961,7 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 		if (rc != TPM2_RC_TESTING)
 			break;
 
-		msleep(delay_msec);
+		usleep_range(delay_msec * 1000, (delay_msec * 1000) + 300);
 	}
 
 	return rc;
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index e3cf9f3..86f0f3e 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -191,7 +191,7 @@ static int wait(struct tpm_chip *chip, int wait_for_bit)
 		/* check the status-register if wait_for_bit is set */
 		if (status & 1 << wait_for_bit)
 			break;
-		msleep(TPM_MSLEEP_TIME);
+		usleep_range(TPM_MSLEEP_TIME * 1000, (TPM_MSLEEP_TIME * 1000) + 300);
 	}
 	if (i == TPM_MAX_TRIES) {	/* timeout occurs */
 		if (wait_for_bit == STAT_XFE)
@@ -226,7 +226,7 @@ static void tpm_wtx(struct tpm_chip *chip)
 	wait_and_send(chip, TPM_CTRL_WTX);
 	wait_and_send(chip, 0x00);
 	wait_and_send(chip, 0x00);
-	msleep(TPM_WTX_MSLEEP_TIME);
+	usleep_range(TPM_WTX_MSLEEP_TIME * 1000, (TPM_WTX_MSLEEP_TIME * 1000) + 300);
 }
 
 static void tpm_wtx_abort(struct tpm_chip *chip)
@@ -237,7 +237,7 @@ static void tpm_wtx_abort(struct tpm_chip *chip)
 	wait_and_send(chip, 0x00);
 	wait_and_send(chip, 0x00);
 	number_of_wtx = 0;
-	msleep(TPM_WTX_MSLEEP_TIME);
+	usleep_range(TPM_WTX_MSLEEP_TIME * 1000, (TPM_WTX_MSLEEP_TIME * 1000) + 300);
 }
 
 static int tpm_inf_recv(struct tpm_chip *chip, u8 * buf, size_t count)
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index c0f296b..e7d3046 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -51,7 +51,7 @@ static int wait_startup(struct tpm_chip *chip, int l)
 
 		if (access & TPM_ACCESS_VALID)
 			return 0;
-		msleep(TPM_TIMEOUT);
+		usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);
 	} while (time_before(jiffies, stop));
 	return -1;
 }
@@ -125,7 +125,7 @@ again:
 		do {
 			if (check_locality(chip, l) >= 0)
 				return l;
-			msleep(TPM_TIMEOUT);
+			usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);
 		} while (time_before(jiffies, stop));
 	}
 	return -1;
@@ -170,7 +170,7 @@ static int get_burstcount(struct tpm_chip *chip)
 		burstcnt = (value >> 8) & 0xFFFF;
 		if (burstcnt)
 			return burstcnt;
-		msleep(TPM_TIMEOUT);
+		usleep_range(TPM_TIMEOUT * 1000, (TPM_TIMEOUT * 1000) + 300);
 	} while (time_before(jiffies, stop));
 	return -EBUSY;
 }
@@ -408,7 +408,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	priv->irq = irq;
 	chip->flags |= TPM_CHIP_FLAG_IRQ;
 	if (!priv->irq_tested)
-		msleep(1);
+		usleep_range(1000, 1300);
 	if (!priv->irq_tested)
 		disable_interrupts(chip);
 	priv->irq_tested = true;
-- 
2.7.4



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
