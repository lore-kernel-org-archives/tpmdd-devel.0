From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 5/5] A test program for vTPM device creation
Date: Mon,  8 Feb 2016 14:27:08 -0500
Message-ID: <1454959628-30582-6-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1454959628-30582-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1454959628-30582-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patch provides a program that is for testing purposes only.

Build it using the following commands:

make headers_install ARCH=x86_64  INSTALL_HDR_PATH=/usr

gcc vtpmctrl.c -o vtpmctrl


To use it:

To create a device pair and have vtpmctrl listen for commands, display
them and respond with TPM success messages do:

#> ./vtpmctrl
Created TPM device /dev/tpm0; vTPM device has fd 4, major/minor = 10/224.

In another shell do

#> exec 100<>/dev/tpm0
#> /bin/echo -en '\x00\xc1\x00\x00\x00\x0a\x00\x00\x00\x00' >&100
#> od -t x1 <&100
00000000 00 c4 00 00 00 0a 00 00 00 00
00000012
#> exec 100>&-

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 vtpmctrl.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 vtpmctrl.c

diff --git a/vtpmctrl.c b/vtpmctrl.c
new file mode 100644
index 0000000..d39cb23
--- /dev/null
+++ b/vtpmctrl.c
@@ -0,0 +1,117 @@
+/*
+ * vtpmctrl.c -- Linux vTPM driver control program
+ *
+ * (c) Copyright IBM Corporation 2015.
+ *
+ * Author: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *
+ * Redistributions of source code must retain the above copyright notice,
+ * this list of conditions and the following disclaimer.
+ *
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ *
+ * Neither the names of the IBM Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived from
+ * this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+
+#include <linux/vtpm.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+
+int vtpmctrl_create(void)
+{
+	int fd, n, option, li, serverfd, nn;
+	struct vtpm_new_pair vtpm_new_pair = {
+		.flags = 0,
+	};
+	char tpmdev[16];
+	unsigned char buffer[4096];
+	const unsigned char response[] = {
+		0x00, 0xc4, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x00
+	};
+
+	fd = open("/dev/vtpmx", O_RDWR);
+	if (fd < 0) {
+		perror("Could not open /dev/vtpmx");
+		return 1;
+	}
+
+	n = ioctl(fd, VTPM_NEW_DEV, &vtpm_new_pair);
+	if (n != 0) {
+		perror("ioctl to create dev pair failed");
+		close(fd);
+		return 1;
+	}
+
+	snprintf(tpmdev, sizeof(tpmdev), "/dev/tpm%u",
+		 vtpm_new_pair.tpm_dev_num);
+
+	serverfd = vtpm_new_pair.fd;
+
+	printf("Created TPM device %s; vTPM device has fd %d, "
+	       "major/minor = %u/%u.\n",
+	       tpmdev, serverfd, vtpm_new_pair.major, vtpm_new_pair.minor);
+
+	close(fd);
+
+	while (1) {
+		n = read(serverfd, buffer, sizeof(buffer));
+		if (n > 0) {
+			printf("Request with %d bytes:\n", n);
+			nn = 0;
+			while (nn < n) {
+				printf("0x%02x ", buffer[nn]);
+				nn++;
+				if (nn % 16 == 0)
+					printf("\n");
+			}
+			printf("\n");
+			n = write(serverfd, response, sizeof(response));
+			if (n < 0) {
+				printf("Error from writing the response: %s\n",
+				       strerror(errno));
+				break;
+			} else {
+				printf("Sent response with %d bytes.\n", n);
+			}
+		} else {
+			break;
+		}
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	return vtpmctrl_create();
+}
-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
