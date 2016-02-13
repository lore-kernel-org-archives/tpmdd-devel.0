From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 4/4] tpm_eventlog.c: fix binary_bios_measurements
Date: Sat, 13 Feb 2016 15:47:07 +0200
Message-ID: <1455371228-20431-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, Harald Hoyer <harald@redhat.com>, stable@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

From: Harald Hoyer <harald@redhat.com>

The commit 0cc698af36ff ("vTPM: support little endian guests") copied
the event, but without the event data, did an endian conversion on the
size and tried to output the event data from the copied version, which
has only have one byte of the data, resulting in garbage event data.

[jarkko.sakkinen@linux.intel.com: minor coding style fixes]

Signed-off-by: Harald Hoyer <harald@redhat.com>
Fixes: 0cc698af36ff ("vTPM: support little endian guests")
cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm_eventlog.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index bd72fb0..6011751 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -242,9 +242,15 @@ static int tpm_binary_bios_measurements_show(struct seq_file *m, void *v)
 	temp_event.event_type = do_endian_conversion(event->event_type);
 	temp_event.event_size = do_endian_conversion(event->event_size);
 
-	tempPtr = (char *)&temp_event;
+	tempPtr = (char *) &temp_event;
 
-	for (i = 0; i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
+	for (i = 0; i < sizeof(struct tcpa_event)-1 ; i++)
+		seq_putc(m, tempPtr[i]);
+
+	tempPtr = (char *) v;
+
+	for (i = sizeof(struct tcpa_event) - 1;
+	     i < sizeof(struct tcpa_event) + temp_event.event_size; i++)
 		seq_putc(m, tempPtr[i]);
 
 	return 0;
-- 
2.7.0
