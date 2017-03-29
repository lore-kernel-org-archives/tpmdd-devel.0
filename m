From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] Improve handling of TPM2 event logs
Date: Wed, 29 Mar 2017 00:43:30 -0700
Message-ID: <20170329074330.b2rbsbt2zc7o22q7@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

When TPM2 log has entries with more than 3 digests, or with digests
not listed in the log header, log gets misparsed, eventually
leading to kernel complaint that code tried to vmalloc 512MB of
memory (I have no idea what would happen on bigger system).

So code should not parse only first 3 digests: both event header
and event itself are already in memory, so we can parse any number
of digests, as long as we do not try to parse whole memory when
given count of 0xFFFFFFFF.

So this change:

* Rejects event entry with more digests than log header describes.
  Digest types should be unique, and all should be described in
  log header, so there cannot be more digests in the event than in
  the header.

* Reject event entry with digest that is not described in the
  log header.  In theory code could hardcode information about
  digest IDs already assigned by TCG, but if firmware authors
  cannot get event log format right, why should anyone believe
  that they got event log content right.

Signed-off-by: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/char/tpm/tpm2_eventlog.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
index 513897cf9c4b..6fe59b75152b 100644
--- a/drivers/char/tpm/tpm2_eventlog.c
+++ b/drivers/char/tpm/tpm2_eventlog.c
@@ -56,18 +56,23 @@ static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
 
 	efispecid = (struct tcg_efi_specid_event *)event_header->event;
 
-	for (i = 0; (i < event->count) && (i < TPM2_ACTIVE_PCR_BANKS);
-	     i++) {
+	/* Check if event is malformed. */
+	if (event->count > efispecid->num_algs)
+		return 0;
+
+	for (i = 0; i < event->count; i++) {
 		halg_size = sizeof(event->digests[i].alg_id);
 		memcpy(&halg, marker, halg_size);
 		marker = marker + halg_size;
-		for (j = 0; (j < efispecid->num_algs); j++) {
+		for (j = 0; j < efispecid->num_algs; j++) {
 			if (halg == efispecid->digest_sizes[j].alg_id) {
-				marker = marker +
-					efispecid->digest_sizes[j].digest_size;
+				marker += efispecid->digest_sizes[j].digest_size;
 				break;
 			}
 		}
+		/* Algorithm without known length. Such event is unparseable. */
+		if (j == efispecid->num_algs)
+			return 0;
 	}
 
 	event_field = (struct tcg_event_field *)marker;
-- 
2.11.0


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
