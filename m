From: Alexander Steffen <Alexander.Steffen@infineon.com>
Subject: [PATCH RESEND v2 3/3] tpm2-cmd: React correctly to RC_TESTING from self tests
Date: Thu, 31 Aug 2017 19:18:58 +0200
Message-ID: <20170831171858.13252-4-Alexander.Steffen@infineon.com>
References: <20170831171858.13252-1-Alexander.Steffen@infineon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170831171858.13252-1-Alexander.Steffen@infineon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Alexander Steffen <Alexander.Steffen@infineon.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The TPM can choose one of two ways to react to the TPM2_SelfTest command.
It can either run all self tests synchronously and then return RC_SUCCESS
once all tests were successful. Or it can choose to run the tests
asynchronously and return RC_TESTING immediately while the self tests still
execute in the background.

The previous implementation apparently was not aware of those possibilities
and attributed RC_TESTING to some prototype chips instead. With this change
the return code of TPM2_SelfTest is interpreted correctly, i.e. the self
test result is polled if and only if RC_TESTING is received.

Unfortunately, the polling cannot be done in the most straightforward way.
If RC_TESTING is received, ideally the code should now poll the
selfTestDone bit in the STS register, as this avoids sending more commands,
that might interrupt self tests executing in the background and thus
prevent them from ever completing. But it cannot be guaranteed that this
bit is correctly implemented for all devices, so the next best thing would
be to use TPM2_GetTestResult to query the test result. But the response to
that command can be very long, and the code currently lacks the
capabilities for efficient unmarshalling, so it is difficult to execute
this command.

Therefore, we simply run the TPM2_SelfTest command in a loop, which should
complete eventually, since we only request the execution of self tests that
have not yet been done.

Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm2-cmd.c | 52 ++++++++++-----------------------------------
 1 file changed, 11 insertions(+), 41 deletions(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 2178437..70ee328 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -834,64 +834,34 @@ static const struct tpm_input_header tpm2_selftest_header = {
 };
 
 /**
- * tpm2_continue_selftest() - start a self test
- *
- * @chip: TPM chip to use
- * @full: test all commands instead of testing only those that were not
- *        previously tested.
- *
- * Return: Same as with tpm_transmit_cmd with exception of RC_TESTING.
- */
-static int tpm2_start_selftest(struct tpm_chip *chip, bool full)
-{
-	int rc;
-	struct tpm2_cmd cmd;
-
-	cmd.header.in = tpm2_selftest_header;
-	cmd.params.selftest_in.full_test = full;
-
-	rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE, 0, 0,
-			      "continue selftest");
-
-	/* At least some prototype chips seem to give RC_TESTING error
-	 * immediately. This is a workaround for that.
-	 */
-	if (rc == TPM2_RC_TESTING) {
-		dev_warn(&chip->dev, "Got RC_TESTING, ignoring\n");
-		rc = 0;
-	}
-
-	return rc;
-}
-
-/**
  * tpm2_do_selftest() - ensure that all self tests have passed
  *
  * @chip: TPM chip to use
  *
  * Return: Same as with tpm_transmit_cmd.
  *
- * During the self test TPM2 commands return with the error code RC_TESTING.
- * Waiting is done by issuing PCR read until it executes successfully.
+ * The TPM can either run all self tests synchronously and then return
+ * RC_SUCCESS once all tests were successful. Or it can choose to run the tests
+ * asynchronously and return RC_TESTING immediately while the self tests still
+ * execute in the background. This function handles both cases and waits until
+ * all tests have completed.
  */
 static int tpm2_do_selftest(struct tpm_chip *chip)
 {
 	int rc;
 	unsigned int delay_msec = 20;
 	long duration;
+	struct tpm2_cmd cmd;
 
 	duration = jiffies_to_msecs(
 		tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST));
 
-	rc = tpm2_start_selftest(chip, false);
-	if (rc)
-		return rc;
-
 	while (duration > 0) {
-		/* Attempt to read a PCR value */
-		rc = tpm2_pcr_read(chip, 0, NULL);
-		if (rc < 0)
-			break;
+		cmd.header.in = tpm2_selftest_header;
+		cmd.params.selftest_in.full_test = 0;
+
+		rc = tpm_transmit_cmd(chip, NULL, &cmd, TPM2_SELF_TEST_IN_SIZE,
+				      0, 0, "continue selftest");
 
 		if (rc != TPM2_RC_TESTING)
 			break;
-- 
2.7.4
