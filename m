From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH] tpm-emulator: add a TPM emulator pass through
Date: Sun, 08 Jan 2017 16:58:33 -0800
Message-ID: <1483923513.2644.1.camel@HansenPartnership.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

I noticed, while playing around with the kernel based resource
manager, that it's very advantageous to have an emulated TPM device to
test now that I'm playing with startup sequences and TPM ownership.

This is an emulator pass through.  It connects an existing emulator
running on the platform (expected to be the MS Simulator available
from https://sourceforge.net/projects/ibmswtpm2/) and adds it as an
in-kernel device, meaning you can exercise the kernel TPM interface
from either inside the kernel or using the device node.

The tpm-emulator simply connects to the command socket of the MS
simulator (on localhost:2321) and proxies TPM commands.  The
destination and port are settable as module parameters meaning that
the TPM emulator doesn't have to be running locally.

Signed-off-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
---
 drivers/char/tpm/Kconfig        |   7 ++
 drivers/char/tpm/Makefile       |   1 +
 drivers/char/tpm/tpm-emulator.c | 231 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 239 insertions(+)
 create mode 100644 drivers/char/tpm/tpm-emulator.c

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 277186d..034faa2 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -151,6 +151,13 @@ config TCG_VTPM_PROXY
 	  /dev/vtpmX and a server-side file descriptor on which the vTPM
 	  can receive commands.
 
+config TCG_EMULATOR
+	tristate "TPM Emulator Interface"
+	depends on m && TCG_TPM
+	---help---
+	  This creates a kernel TPM device which expects to connect to
+	  the MS simulator socket.  You must have the simulator running
+	  (powered on and started) before inserting the device.
 
 source "drivers/char/tpm/st33zp24/Kconfig"
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 251d0ed..e2de69d 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_TCG_TIS_ST33ZP24) += st33zp24/
 obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
 obj-$(CONFIG_TCG_CRB) += tpm_crb.o
 obj-$(CONFIG_TCG_VTPM_PROXY) += tpm_vtpm_proxy.o
+obj-$(CONFIG_TCG_EMULATOR) += tpm-emulator.o
diff --git a/drivers/char/tpm/tpm-emulator.c b/drivers/char/tpm/tpm-emulator.c
new file mode 100644
index 0000000..f78008c
--- /dev/null
+++ b/drivers/char/tpm/tpm-emulator.c
@@ -0,0 +1,231 @@
+/*
+ * Copyright 2017 James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
+ *
+ * GPLv2
+ *
+ * Simple socket based connector to a userspace TPM emulator
+ */
+
+#include <linux/kernel.h>
+#include <linux/net.h>
+#include <linux/inet.h>
+#include <linux/in.h>
+#include <linux/module.h>
+
+#include <net/net_namespace.h>
+
+#include "tpm.h"
+
+/*
+ * Currently we only support the MSSIM TPM connections, so every
+ * command must be prefixed with MSSIM_CMD and we have to send
+ * MSSIM_END before we close the socket
+ */
+#define MSSIM_CMD	8
+#define MSSIM_END	20
+
+/*
+ * Initial assumptions: by default connect to the microsoft simulator
+ * command port on localhost.  Note: this emulator makes no use of the
+ * platform port, so the emulator must be properly initialised (power
+ * on and startup) before being used by this in-kernel system
+ */
+static char *server = "127.0.0.1";
+module_param_named(server, server, charp, 0400);
+MODULE_PARM_DESC(server, "TPM Emulator server address.");
+static int port = 2321;
+module_param_named(port, port, uint, 0400);
+MODULE_PARM_DESC(port, "TPM Emulator server port.");
+
+static struct device tdev;
+
+static struct socket *tsock;
+struct sockaddr_in tin;
+
+static int priv_recvmsg(void *buf, size_t len, int flags)
+{
+	struct kvec iov = {
+		.iov_base = buf,
+		.iov_len = len,
+	};
+	struct msghdr msg = {
+		.msg_flags = (flags ? flags : MSG_WAITALL | MSG_NOSIGNAL)
+	};
+	return kernel_recvmsg(tsock, &msg, &iov, 1, len, msg.msg_flags);
+}
+
+static void priv_shutdown(void)
+{
+	kernel_sock_shutdown(tsock, SHUT_RDWR);
+	sock_release(tsock);
+	tsock = NULL;
+}
+
+static int priv_send(void *buf, size_t len)
+{
+	int err;
+	int sent = 0;
+
+	struct kvec iov = {
+		.iov_base = buf,
+		.iov_len = len,
+	};
+	struct msghdr msg = {
+		.msg_name = NULL,
+		.msg_namelen = 0,
+		.msg_control = NULL,
+		.msg_controllen = 0,
+		.msg_flags = MSG_WAITALL | MSG_NOSIGNAL,
+	};
+
+	do {
+		err = kernel_sendmsg(tsock, &msg, &iov, 1, iov.iov_len);
+		if (err == -EAGAIN)
+			continue;
+		if (err < 0) {
+			priv_shutdown();
+			return err;
+		}
+		sent += err;
+		iov.iov_base += err;
+		iov.iov_len -= err;
+	} while (sent < len);
+
+	return 0;
+}
+
+static int emu_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int ret;
+	u32 cmd = htonl(MSSIM_CMD), netlen = htonl(len);
+	u8 locality = 0;
+
+	ret = sock_create_kern(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			       &tsock);
+	if (ret)
+		return ret;
+
+	ret = kernel_connect(tsock, (struct sockaddr *)&tin, sizeof(tin), 0);
+	if (ret)
+		goto out;
+
+	ret = priv_send(&cmd, sizeof(cmd));
+	if (ret)
+		goto out;
+	ret = priv_send(&locality, sizeof(locality));
+	if (ret)
+		goto out;
+	ret = priv_send(&netlen, sizeof(netlen));
+	if (ret)
+		goto out;
+
+	ret = priv_send(buf, len);
+
+ out:
+	if (ret < 0)
+		priv_shutdown();
+	return ret;
+
+}
+
+static int emu_recv(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	int ret;
+	u32 header = htonl(MSSIM_END);
+	u32 reclen;
+	u32 ack;
+
+	ret = priv_recvmsg(&reclen, sizeof(reclen), 0);
+	if (ret != sizeof(reclen)) {
+		dev_err(&tdev, "Socket receive failed: %d\n", ret);
+		goto out;
+	}
+	reclen = ntohl(reclen);
+	if (len < reclen) {
+		dev_err(&tdev, "response is too large %d\n", reclen);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = priv_recvmsg(buf, reclen, 0);
+	if (ret > 0)
+		/* receive the ack packet, should be zero */
+		priv_recvmsg(&ack, sizeof(ack), 0);
+
+ out:
+	priv_send(&header, sizeof(header));
+	priv_shutdown();
+
+	return ret;
+}
+
+static struct tpm_class_ops emulator_ops = {
+	.flags = TPM_OPS_AUTO_STARTUP,
+	.send = emu_send,
+	.recv = emu_recv,
+};
+
+static void emu_dev_release(struct device *dev)
+{
+}
+
+static int emu_init(void)
+{
+	int err;
+	struct tpm_chip *chip;
+
+	tin.sin_family = AF_INET;
+	tin.sin_addr.s_addr = in_aton(server);
+	tin.sin_port = htons(port);
+
+	device_initialize(&tdev);
+	/* stop drivers/base/core.c from complaining */
+	tdev.release = emu_dev_release;
+	err = dev_set_name(&tdev, "emulated-tpm");
+	if (err)
+		goto err_out;
+	err = device_add(&tdev);
+	if (err)
+		goto err_out;
+
+	chip = tpmm_chip_alloc(&tdev, &emulator_ops);
+	if (IS_ERR(chip)) {
+		err = PTR_ERR(chip);
+		goto err_del;
+	}
+	chip->flags |= TPM_CHIP_FLAG_IRQ;
+	err = tpm2_probe(chip);
+	if (err)
+		goto err_del;
+
+	err = tpm_chip_register(chip);
+
+	dev_info(&tdev, "%s TPM emulator\n",
+		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2");
+
+	if (!err)
+		return 0;
+
+ err_del:
+	device_del(&tdev);
+ err_out:
+
+	put_device(&tdev);
+
+	return err;
+}
+
+static void emu_exit(void)
+{
+	struct tpm_chip *chip = dev_get_drvdata(&tdev);
+
+	tpm_chip_unregister(chip);
+	device_del(&tdev);
+	put_device(&tdev);
+}
+
+module_init(emu_init);
+module_exit(emu_exit);
+
+MODULE_AUTHOR("James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>");
+MODULE_LICENSE("GPL v2");
-- 
2.6.6



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
