From: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND v2 2/3] tpm2-cmd: Use dynamic delay to
 wait for self test result
Date: Thu, 31 Aug 2017 19:18:57 +0200
Message-ID: <20170831171858.13252-3-Alexander.Steffen@infineon.com>
References: <20170831171858.13252-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170831171858.13252-1-Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

In order to avoid delaying the code longer than necessary while still
giving the TPM enough time to execute the self tests asynchronously, start
with a small delay between two polls and increase it each round.

Signed-off-by: Alexander Steffen <Alexander.Steffen-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 8e940a5..2178437 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -877,20 +877,17 @@ static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
 static int tpm2_do_selftest(struct tpm_chip *chip)
 {
 	int rc;
-	unsigned int loops;
-	unsigned int delay_msec = 100;
-	unsigned long duration;
-	int i;
-
-	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
+	unsigned int delay_msec = 20;
+	long duration;
 
-	loops = jiffies_to_msecs(duration) / delay_msec;
+	duration = jiffies_to_msecs(
+		tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST));
 
 	rc = tpm2_start_selftest(chip, false);
 	if (rc)
 		return rc;
 
-	for (i = 0; i < loops; i++) {
+	while (duration > 0) {
 		/* Attempt to read a PCR value */
 		rc = tpm2_pcr_read(chip, 0, NULL);
 		if (rc < 0)
@@ -900,6 +897,10 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
 			break;
 
 		tpm_msleep(delay_msec);
+		duration -= delay_msec;
+
+		/* wait longer the next round */
+		delay_msec *= 2;
 	}
 
 	return rc;
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
