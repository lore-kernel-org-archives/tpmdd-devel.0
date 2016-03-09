From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 11/11] A test program for vTPM device
	creation
Date: Wed,  9 Mar 2016 12:39:30 -0500
Message-ID: <1457545170-30120-12-git-send-email-stefanb@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1457545170-30120-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patch provides a program that is for testing purposes only.

Build it using the following commands:

make headers_install ARCH=x86_64  INSTALL_HDR_PATH=/usr

gcc vtpmctrl.c -o vtpmctrl

To use it:

To create a device pair and have vtpmctrl listen for commands, display
them and respond with TPM success messages do:

Created TPM device /dev/tpm0; vTPM device has fd 4, major/minor = 10/224.

In another shell do

00000000 00 c4 00 00 00 0a 00 00 00 00
00000012

Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 vtpmctrl.c | 163 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)
 create mode 100644 vtpmctrl.c

diff --git a/vtpmctrl.c b/vtpmctrl.c
new file mode 100644
index 0000000..071be45
--- /dev/null
+++ b/vtpmctrl.c
@@ -0,0 +1,163 @@
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
+#include <endian.h>
+#include <stdint.h>
+
+int vtpmctrl_create(void)
+{
+	int fd, n, option, li, serverfd, nn;
+	struct vtpm_new_dev vtpm_new_dev = {
+		.flags = 0,
+	};
+	char tpmdev[16];
+	unsigned char buffer[4096];
+	const unsigned char tpm_startup_resp[] = {
+		0x00, 0xc4, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x00
+	};
+	const unsigned char timeout_req[] = {
+		0x00, 0xc1, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x65,
+		0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00,
+		0x01, 0x15
+	};
+	const unsigned char timeout_res[] = {
+		0x00, 0xc4, 0x00, 0x00, 0x00, 0x1e, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00,
+		0x00, 0x01, 0x00, 0x00,
+		0x00, 0x02, 0x00, 0x00,
+		0x00, 0x03, 0x00, 0x00,
+		0x00, 0x04, 0x00, 0x00,
+	};
+	const unsigned char duration_req[] = {
+		0x00, 0xc1, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x65,
+		0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00,
+		0x01, 0x20
+	};
+	const unsigned char duration_res[] = {
+		0x00, 0xc4, 0x00, 0x00, 0x00, 0x1a, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00,
+		0x00, 0x01, 0x00, 0x00,
+		0x00, 0x02, 0x00, 0x00,
+		0x00, 0x03, 0x00, 0x00,
+	};
+	uint32_t ordinal;
+
+	fd = open("/dev/vtpmx", O_RDWR);
+	if (fd < 0) {
+		perror("Could not open /dev/vtpmx");
+		return 1;
+	}
+
+	n = ioctl(fd, VTPM_NEW_DEV, &vtpm_new_dev);
+	if (n != 0) {
+		perror("ioctl to create new device failed");
+		close(fd);
+		return 1;
+	}
+
+	snprintf(tpmdev, sizeof(tpmdev), "/dev/tpm%u",
+		 vtpm_new_dev.dev_num);
+
+	serverfd = vtpm_new_dev.fd;
+
+	printf("Created TPM device %s; vTPM device has fd %d, "
+	       "major/minor = %u/%u.\n",
+	       tpmdev, serverfd, vtpm_new_dev.major, vtpm_new_dev.minor);
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
+			ordinal = be32toh(*(uint32_t *)&(buffer[6]));
+			switch (ordinal) {
+			case 0x99:
+				n = write(serverfd, tpm_startup_resp, sizeof(tpm_startup_resp));
+				break;
+			case 0x65:
+				if (!memcmp(timeout_req, buffer, sizeof(timeout_req))) {
+					n = write(serverfd, timeout_res, sizeof(timeout_res));
+
+				} else if (!memcmp(duration_req, buffer, sizeof(duration_req))) {
+					n = write(serverfd, duration_res, sizeof(duration_res));
+				} else {
+					n = write(serverfd, tpm_startup_resp, sizeof(tpm_startup_resp));
+				}
+				break;
+			default:
+				n = write(serverfd, tpm_startup_resp, sizeof(tpm_startup_resp));
+				break;
+			}
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
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
