From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 8/9] tpm: replace of_find_node_by_name()
	with dev of_node property
Date: Mon, 14 Nov 2016 05:00:55 -0500
Message-ID: <1479117656-12403-9-git-send-email-nayna@linux.vnet.ibm.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1479117656-12403-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

Using the device of_node property is a better way to refer to the
device tree node rather than of_find_node_by_name().

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_of.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index 7c30752..22b8f81 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -29,7 +29,8 @@ int read_log_of(struct tpm_chip *chip)
 	struct tpm_bios_log *log;
 
 	log = &chip->log;
-	np = of_find_node_by_name(NULL, "vtpm");
+	if (chip->dev.parent->of_node)
+		np = chip->dev.parent->of_node;
 	if (!np) {
 		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
 		return -ENODEV;
@@ -55,18 +56,15 @@ int read_log_of(struct tpm_chip *chip)
 	if (!log->bios_event_log) {
 		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
 		       __func__);
-		of_node_put(np);
 		return -ENOMEM;
 	}
 
 	log->bios_event_log_end = log->bios_event_log + *sizep;
 
 	memcpy(log->bios_event_log, __va(*basep), *sizep);
-	of_node_put(np);
 
 	return 0;
 
 cleanup_eio:
-	of_node_put(np);
 	return -EIO;
 }
-- 
2.5.0


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
