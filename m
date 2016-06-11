From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 5/5] tpm_tis: Increase ST19NP18 TPM command
	duration to avoid chip lockup
Date: Fri, 10 Jun 2016 18:55:07 -0700
Message-ID: <1465610107-87762-6-git-send-email-eswierk@skyportsystems.com>
References: <1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
	<1465610107-87762-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465610107-87762-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index caf7278..862c502 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -485,6 +485,11 @@ static void tpm_tis_update_timeouts(struct tpm_chip *chip)
 		chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 		chip->vendor.timeout_adjusted = true;
 		break;
+	case 0x0000104a: /* STMicro ST19NP18-TPM */
+		chip->vendor.duration[TPM_SHORT] = 180 * HZ;
+		chip->vendor.duration[TPM_MEDIUM] = 180 * HZ;
+		chip->vendor.duration[TPM_LONG] = 180 * HZ;
+		chip->vendor.duration_adjusted = true;
 	}
 }
 
-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
