From: Ed Swierk <eswierk@skyportsystems.com>
Subject: [PATCH v9 5/5] tpm_tis: Increase ST19NP18 TPM command duration to avoid chip lockup
Date: Wed, 13 Jul 2016 09:19:36 -0700
Message-ID: <1468426776-42762-6-git-send-email-eswierk@skyportsystems.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com, eswierk@skyportsystems.com
List-Id: tpmdd-devel@lists.sourceforge.net

The STMicro ST19NP18-TPM sometimes takes much longer to execute
commands than it reports in its capabilities. For example, command 186
(TPM_FlushSpecific) has been observed to take 14560 msec to complete,
far longer than the 3000 msec limit for "short" commands reported by
the chip. The behavior has also been seen with command 101
(TPM_GetCapability).

Worse, when the tpm_tis driver attempts to cancel the current command
(by writing commandReady = 1 to TPM_STS_x), the chip locks up
completely, returning all-1s from all memory-mapped register
reads. The lockup can be cleared only by resetting the system.

The occurrence of this excessive command duration depends on the
sequence of commands preceding it. One sequence is creating at least 2
new keys via TPM_CreateWrapKey, then letting the TPM idle for at least
30 seconds, then loading a key via TPM_LoadKey2. The next
TPM_FlushSpecific occasionally takes tens of seconds to
complete. Another sequence is creating many keys in a row without
pause. The TPM_CreateWrapKey operation gets much slower after the
first few iterations, as one would expect when the pool of precomputed
keys is exhausted. Then after a 35-second pause, the same TPM_LoadKey2
followed by TPM_FlushSpecific sequence triggers the behavior.

Our working theory is that this older TPM sometimes pauses to
precompute keys, which modern chips implement as a background
process. Without access to the chip's implementation details it's
impossible to know whether any commands are immune to being blocked by
this process. So it seems safest to ignore the chip's reported command
durations, and use a value much higher than any observed duration,
like 180 sec (which is the duration this chip reports for "long"
commands).

Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>
---
 drivers/char/tpm/tpm_tis_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index f013664..84d6008 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -416,6 +416,12 @@ static void tpm_tis_update_timeouts(struct tpm_chip *chip)
 		chip->timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 		chip->timeout_adjusted = true;
 		break;
+	case 0x0000104a: /* STMicro ST19NP18-TPM */
+		chip->duration[TPM_SHORT] = 180 * HZ;
+		chip->duration[TPM_MEDIUM] = 180 * HZ;
+		chip->duration[TPM_LONG] = 180 * HZ;
+		chip->duration_adjusted = true;
+		break;
 	}
 }
 
-- 
1.9.1
