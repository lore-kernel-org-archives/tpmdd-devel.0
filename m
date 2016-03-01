From: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix unallocated memory access in TPM eventlog
	code
Date: Tue,  1 Mar 2016 15:03:34 -0800
Message-ID: <1456873414-6127-1-git-send-email-mjg59@coreos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

COmmit 0cc698 added support for handling endian fixups in the event log code
but broke the binary log file in the process. Keep the endian code, but read
the event data from the actual event rather than from unallocated RAM.

Signed-off-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
Should be applied to 4.4
 drivers/char/tpm/tpm_eventlog.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index bd72fb0..e47092c 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -244,7 +244,12 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 
 	tempPtr = (char *)&temp_event;
 
-	for (i = 0; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
+	for (i = 0; i < sizeof(struct tcpa_event); i++)
+		seq_putc(m, tempPtr[i]);
+
+	tempPtr = (char *)&event->event_data;
+
+	for (i = 0; i < temp_event.event_size; i++)
 		seq_putc(m, tempPtr[i]);
 
 	return 0;
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785231&iu=/4140
