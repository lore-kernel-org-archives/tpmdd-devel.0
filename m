From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 3/5] tpm: Factor out reading of timeout and
	duration capabilities
Date: Fri, 10 Jun 2016 18:55:05 -0700
Message-ID: <1465610107-87762-4-git-send-email-eswierk@skyportsystems.com>
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

Factor sending the TPM_GetCapability command and validating the result
from tpm_get_timeouts() into a new function. Return all errors to the
caller rather than swallowing them (e.g. when tpm_transmit_cmd()
returns nonzero).

Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 96 ++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index cc1e5bc..4d1f62c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -502,6 +502,52 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
 				"attempting to start the TPM");
 }
 
+static int tpm_get_cap_prop(struct tpm_chip *chip, __be32 type, int size,
+			    cap_t *cap, char *desc)
+{
+	struct tpm_cmd_t tpm_cmd;
+	ssize_t rc;
+
+	tpm_cmd.header.in = tpm_getcap_header;
+	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+	tpm_cmd.params.getcap_in.subcap = type;
+	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
+
+	if (rc == TPM_ERR_INVALID_POSTINIT) {
+		/* The TPM is not started, we are the first to talk to it.
+		   Execute a startup command. */
+		dev_info(chip->pdev, "Issuing TPM_STARTUP\n");
+		if (tpm_startup(chip, TPM_ST_CLEAR))
+			return rc;
+
+		tpm_cmd.header.in = tpm_getcap_header;
+		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
+		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
+		tpm_cmd.params.getcap_in.subcap = type;
+		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
+				  NULL);
+	}
+
+	if (rc) {
+		dev_err(chip->pdev,
+			"Error %zd reading %s\n", rc, desc);
+		return rc;
+	}
+
+	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
+	    be32_to_cpu(tpm_cmd.header.out.length)
+	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + size * sizeof(u32)) {
+		dev_err(chip->pdev,
+			"Bad return code or length reading %s\n", desc);
+		return -EINVAL;
+	}
+
+	memcpy(cap, &tpm_cmd.params.getcap_out.cap, sizeof(cap_t));
+
+	return 0;
+}
+
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	struct tpm_cmd_t tpm_cmd;
@@ -510,37 +556,10 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	struct duration_t *duration_cap;
 	ssize_t rc;
 
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
-
-	if (rc == TPM_ERR_INVALID_POSTINIT) {
-		/* The TPM is not started, we are the first to talk to it.
-		   Execute a startup command. */
-		dev_info(chip->pdev, "Issuing TPM_STARTUP");
-		if (tpm_startup(chip, TPM_ST_CLEAR))
-			return rc;
-
-		tpm_cmd.header.in = tpm_getcap_header;
-		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
-		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-				  NULL);
-	}
-	if (rc) {
-		dev_err(chip->pdev,
-			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
-			rc);
-		goto duration;
-	}
-
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
-		return -EINVAL;
+	rc = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_TIMEOUT, 4,
+			      &tpm_cmd.params.getcap_out.cap, "timeouts");
+	if (rc)
+		return rc;
 
 	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
 	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
@@ -583,22 +602,11 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
 	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
 
-duration:
-	tpm_cmd.header.in = tpm_getcap_header;
-	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
-	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
-	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
-
-	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
-			      "attempting to determine the durations");
+	rc = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_DURATION, 3,
+			      &tpm_cmd.params.getcap_out.cap, "durations");
 	if (rc)
 		return rc;
 
-	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
-	    be32_to_cpu(tpm_cmd.header.out.length)
-	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
-		return -EINVAL;
-
 	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
 	chip->vendor.duration[TPM_SHORT] =
 	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
-- 
1.9.1


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
