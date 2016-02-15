From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/3] tpm_eventlog.c: fix
	binary_bios_measurements
Date: Mon, 15 Feb 2016 03:41:06 +0200
Message-ID: <1455500466-11266-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1455500466-11266-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455500466-11266-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The commit 0cc698af36ff ("vTPM: support little endian guests") copied
the event, but without the event data, did an endian conversion on the
size and tried to output the event data from the copied version, which
has only have one byte of the data, resulting in garbage event data.

Signed-off-by: Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Fixes: 0cc698af36ff ("vTPM: support little endian guests")
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/char/tpm/tpm_eventlog.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index bd72fb0..27fc887 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -242,9 +242,15 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 	temp_event.event_type = do_endian_conversion(event->event_type);
 	temp_event.event_size = do_endian_conversion(event->event_size);
 
-	tempPtr = (char *)&temp_event;
+	tempPtr = (char *) &temp_event;
 
-	for (i = 0; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
+	for (i = 0; i < (sizeof(struct tcpa_event) - 1) ; i++)
+		seq_putc(m, tempPtr[i]);
+
+	tempPtr = (char *) v;
+
+	for (i = (sizeof(struct tcpa_event) - 1);
+	     i < (sizeof(struct tcpa_event) + temp_event.event_size); i++)
 		seq_putc(m, tempPtr[i]);
 
 	return 0;
-- 
2.7.0


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
