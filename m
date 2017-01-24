From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC] tpm: define a command filter
Date: Tue, 24 Jan 2017 02:02:52 +0200
Message-ID: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This commit adds a command filter for whitelisting a set of commands in
a TPM space. When a TPM space is created through /dev/tpms0, no
commands are allowed. The user of the TPM space must explicitly define
the list of commands allowed before sending any commands. This ioctl is
a one shot call so that a resource manager daemon can call it before
sending the file descriptor to the client.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
1. This patch applies on top of 'tabrm4' brach.
2. Only compilation is tested (just drafted the idea)
 drivers/char/tpm/tpm-interface.c | 12 +++++--
 drivers/char/tpm/tpm.h           |  1 +
 drivers/char/tpm/tpm2-space.c    |  7 ++++
 drivers/char/tpm/tpms-dev.c      | 75 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tpms.h        | 29 ++++++++++++++++
 5 files changed, 121 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/tpms.h

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 70ee347..e0d9019 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -328,8 +328,8 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
 }
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
-static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
-				 size_t len)
+static bool tpm_validate_command(struct tpm_chip *chip, struct tpm_space *space,
+				 const u8 *cmd, size_t len)
 {
 	const struct tpm_input_header *header = (const void *)cmd;
 	int i;
@@ -350,6 +350,12 @@ static bool tpm_validate_command(struct tpm_chip *chip, const u8 *cmd,
 			return false;
 		}
 
+		if (!test_bit(i, space->cmd_filter)) {
+			dev_dbg(&chip->dev, "0x%04X is not allowed command\n",
+				cc);
+			return false;
+		}
+
 		attrs = chip->cc_attrs_tbl[i];
 		nr_handles = 4 * ((attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0));
 		if (len < TPM_HEADER_SIZE + 4 * nr_handles)
@@ -383,7 +389,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, struct tpm_space *space,
 	u32 count, ordinal;
 	unsigned long stop;
 
-	if (!tpm_validate_command(chip, buf, bufsiz))
+	if (!tpm_validate_command(chip, space, buf, bufsiz))
 		return -EINVAL;
 
 	if (bufsiz > TPM_BUFSIZE)
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c48255e..775bdf5 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -159,6 +159,7 @@ enum tpm2_cc_attrs {
 struct tpm_space {
 	u32 context_tbl[3];
 	u8 *context_buf;
+	unsigned long *cmd_filter;
 };
 
 enum tpm_chip_flags {
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 5d23466..081ab03 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -38,6 +38,13 @@ int tpm2_init_space(struct tpm_chip *chip, struct tpm_space *space)
 	if (!space->context_buf)
 		return -ENOMEM;
 
+	space->cmd_filter = kzalloc(BITS_TO_LONGS(chip->nr_commands),
+				    GFP_KERNEL);
+	if (!space->cmd_filter) {
+		kfree(space->context_buf);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpms-dev.c b/drivers/char/tpm/tpms-dev.c
index 2ac2537..a610368 100644
--- a/drivers/char/tpm/tpms-dev.c
+++ b/drivers/char/tpm/tpms-dev.c
@@ -4,11 +4,13 @@
  * GPLv2
  */
 #include <linux/slab.h>
+#include <uapi/linux/tpms.h>
 #include "tpm-dev.h"
 
 struct tpms_priv {
 	struct file_priv priv;
 	struct tpm_space space;
+	unsigned long flags;
 };
 
 static int tpms_open(struct inode *inode, struct file *file)
@@ -40,6 +42,7 @@ static int tpms_release(struct inode *inode, struct file *file)
 
 	tpm_common_release(file, fpriv);
 	kfree(priv->space.context_buf);
+	kfree(priv->space.cmd_filter);
 	kfree(priv);
 
 	return 0;
@@ -54,12 +57,84 @@ ssize_t tpms_write(struct file *file, const char __user *buf,
 	return tpm_common_write(file, buf, size, off, &priv->space);
 }
 
+/**
+ * tpm_ioc_set_command_filter - handler for %SGX_IOC_SET_COMMAND_FILTER ioctl
+ *
+ * Takes a list of command codes in the form of array of 16-bit words as input.
+ * This defines the set of command allowed to be used in the associated TPM
+ * space. This is a one shot call: an RM daemon can set the filter and client
+ * cannot increase its privileges afterwards.
+ */
+static long tpms_ioc_set_command_filter(struct file *file, unsigned int ioctl,
+					unsigned long arg)
+{
+	struct tpms_priv *priv = file->private_data;
+	struct tpm_chip *chip = priv->priv.chip;
+	struct tpms_command_filter cmd_filter;
+	u16 *commands;
+	int i;
+	int j;
+
+	/* one shot */
+	if (test_and_set_bit(0, &priv->flags))
+		return -EFAULT;
+
+	if (copy_from_user(&cmd_filter, (void __user *)arg,
+			   sizeof(cmd_filter)))
+		return -EFAULT;
+
+	commands = kzalloc(2 * cmd_filter.nr_commands, GFP_KERNEL);
+	if (!commands)
+		return -ENOMEM;
+
+	if (copy_from_user(commands, (void __user *)cmd_filter.commands,
+			   2 * cmd_filter.nr_commands)) {
+		kfree(commands);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < cmd_filter.nr_commands; i++) {
+		j = tpm2_find_cc(chip, commands[i]);
+		if (j < 0) {
+			kfree(commands);
+			return -EINVAL;
+		}
+
+		set_bit(j, priv->space.cmd_filter);
+	}
+
+	kfree(commands);
+	return 0;
+}
+
+static long tpms_ioctl(struct file *file, unsigned int ioctl,
+		       unsigned long arg)
+{
+	switch (ioctl) {
+	case TPMS_IOC_SET_COMMAND_FILTER:
+		tpms_ioc_set_command_filter(file, ioctl, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long tpms_compat_ioctl(struct file *file, unsigned int ioctl,
+			     unsigned long arg)
+{
+	return tpms_ioctl(file, ioctl, arg);
+}
+#endif
 const struct file_operations tpms_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.open = tpms_open,
 	.read = tpm_common_read,
 	.write = tpms_write,
+	.unlocked_ioctl = tpms_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = tpms_compat_ioctl,
+#endif
 	.release = tpms_release,
 };
 
diff --git a/include/uapi/linux/tpms.h b/include/uapi/linux/tpms.h
new file mode 100644
index 0000000..3a86e05
--- /dev/null
+++ b/include/uapi/linux/tpms.h
@@ -0,0 +1,29 @@
+/*
+ * API and definitions for the TPM device driver
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifndef _UAPI_TPMS_H
+#define _UAPI_TPMS_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define TPMS_IOC_MAGIC 0xa2
+#define TPMS_IOC_SET_COMMAND_FILTER \
+	_IOW(TPMS_IOC_MAGIC, 0x00, struct tpms_command_filter)
+
+struct tpms_command_filter {
+	__u32	nr_commands;
+	__u64	commands;
+};
+
+#endif /* _UAPI_TPMS_H */
-- 
2.9.3

