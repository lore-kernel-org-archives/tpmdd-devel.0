From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] tpm: add longer timeouts for creation commands.
Date: Tue, 23 Jan 2018 13:27:31 +0200
Message-ID: <20180123112731.3687-3-tomas.winkler@intel.com>
References: <20180123112731.3687-1-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180123112731.3687-1-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>, tpmdd-devel@lists.sourceforge.net, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

TPM2_CC_Create(0x153) and TPM2_CC_CreatePrimary (0x131) involve generation
of crypto keys which can be a computationally intensive task.
The timeout is set to 3min.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/char/tpm/tpm-interface.c |  4 ++++
 drivers/char/tpm/tpm.h           | 27 ++++++++++++++++-----------
 drivers/char/tpm/tpm2-cmd.c      |  8 +++++---
 3 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e4d0291e22f6..4c6334f0f9ad 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -673,6 +673,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 		    msecs_to_jiffies(TPM2_DURATION_MEDIUM);
 		chip->duration[TPM_LONG] =
 		    msecs_to_jiffies(TPM2_DURATION_LONG);
+		chip->duration[TPM_LONG_LONG] =
+		    msecs_to_jiffies(TPM2_DURATION_LONG_LONG);
+		chip->duration[TPM_UNDEFINED] =
+		    msecs_to_jiffies(TPM2_DURATION_DEFAULT);
 
 		chip->flags |= TPM_CHIP_FLAG_HAVE_TIMEOUTS;
 		return 0;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index f895fba4e20d..192ba68b39c2 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -67,7 +67,9 @@ enum tpm_duration {
 	TPM_SHORT = 0,
 	TPM_MEDIUM = 1,
 	TPM_LONG = 2,
-	TPM_UNDEFINED,
+	TPM_LONG_LONG = 3,
+	TPM_UNDEFINED = 4,
+	TPM_DURATION_MAX,
 };
 
 #define TPM_WARN_RETRY          0x800
@@ -79,15 +81,17 @@ enum tpm_duration {
 #define TPM_HEADER_SIZE		10
 
 enum tpm2_const {
-	TPM2_PLATFORM_PCR	= 24,
-	TPM2_PCR_SELECT_MIN	= ((TPM2_PLATFORM_PCR + 7) / 8),
-	TPM2_TIMEOUT_A		= 750,
-	TPM2_TIMEOUT_B		= 2000,
-	TPM2_TIMEOUT_C		= 200,
-	TPM2_TIMEOUT_D		= 30,
-	TPM2_DURATION_SHORT	= 20,
-	TPM2_DURATION_MEDIUM	= 750,
-	TPM2_DURATION_LONG	= 2000,
+	TPM2_PLATFORM_PCR       =     24,
+	TPM2_PCR_SELECT_MIN     = ((TPM2_PLATFORM_PCR + 7) / 8),
+	TPM2_TIMEOUT_A          =    750,
+	TPM2_TIMEOUT_B          =   2000,
+	TPM2_TIMEOUT_C          =    200,
+	TPM2_TIMEOUT_D          =     30,
+	TPM2_DURATION_SHORT     =     20,
+	TPM2_DURATION_MEDIUM    =    750,
+	TPM2_DURATION_LONG      =   2000,
+	TPM2_DURATION_LONG_LONG = 300000,
+	TPM2_DURATION_DEFAULT   = 120000,
 };
 
 enum tpm2_structures {
@@ -123,6 +127,7 @@ enum tpm2_algorithms {
 
 enum tpm2_command_codes {
 	TPM2_CC_FIRST		= 0x011F,
+	TPM2_CC_CREATE_PRIMARY  = 0x0131,
 	TPM2_CC_SELF_TEST	= 0x0143,
 	TPM2_CC_STARTUP		= 0x0144,
 	TPM2_CC_SHUTDOWN	= 0x0145,
@@ -227,7 +232,7 @@ struct tpm_chip {
 	unsigned long timeout_c; /* jiffies */
 	unsigned long timeout_d; /* jiffies */
 	bool timeout_adjusted;
-	unsigned long duration[3]; /* jiffies */
+	unsigned long duration[TPM_DURATION_MAX]; /* jiffies */
 	bool duration_adjusted;
 
 	struct dentry *bios_dir[TPM_NUM_EVENT_LOG_FILES];
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index c17e75348a99..aaa17e982b37 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -90,6 +90,8 @@ static struct tpm2_hash tpm2_hash_map[] = {
  * of time the chip could take to return the result. The values
  * of the SHORT, MEDIUM, and LONG durations are taken from the
  * PC Client Profile (PTP) specification.
+ * LONG_LONG is for commands that generates keys which empirically
+ * takes longer time on some systems.
  */
 static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	TPM_UNDEFINED,		/* 11F */
@@ -110,7 +112,7 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	TPM_UNDEFINED,		/* 12e */
 	TPM_UNDEFINED,		/* 12f */
 	TPM_UNDEFINED,		/* 130 */
-	TPM_UNDEFINED,		/* 131 */
+	TPM_LONG_LONG,		/* 131 */
 	TPM_UNDEFINED,		/* 132 */
 	TPM_UNDEFINED,		/* 133 */
 	TPM_UNDEFINED,		/* 134 */
@@ -144,7 +146,7 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
 	TPM_UNDEFINED,		/* 150 */
 	TPM_UNDEFINED,		/* 151 */
 	TPM_UNDEFINED,		/* 152 */
-	TPM_UNDEFINED,		/* 153 */
+	TPM_LONG_LONG,		/* 153 */
 	TPM_UNDEFINED,		/* 154 */
 	TPM_UNDEFINED,		/* 155 */
 	TPM_UNDEFINED,		/* 156 */
@@ -817,7 +819,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 		duration = chip->duration[index];
 
 	if (duration <= 0)
-		duration = 2 * 60 * HZ;
+		duration = msecs_to_jiffies(TPM2_DURATION_DEFAULT);
 
 	return duration;
 }
-- 
2.14.3
