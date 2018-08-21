From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 23/23] TPM: Add an asymmetric key subtype for
 handling TPM-based keys
Date: Tue, 21 Aug 2018 16:59:25 +0100
Message-ID: <153486716525.13066.18042327896429419884.stgit@warthog.procyon.org.uk>
References: <153486700916.13066.12870860668352070081.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <153486700916.13066.12870860668352070081.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add an asymmetric key subtype for handling keys that have to be loaded into
the TPM to be used.

A key can be created by something like:

	keyctl add asymmetric "a" "tpm_create parent=40000000,095c2a76085f6aa9327c62f72a3d1348f62b99db keyauth=095c2a76085f6aa9327c62f72a3d1348f62b99db" @s

where "parent=<parent_key_handle>,<parent_key_secret>" and
"keyauth=<new_key_secret>".

The above will ask the TPM to create a key and return the TPM_KEY struct as a
blob with the private key encrypted by the parent key (in the above case, the
SRK).

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 crypto/asymmetric_keys/Kconfig          |    7 +
 crypto/asymmetric_keys/Makefile         |    1 
 crypto/asymmetric_keys/tpm_key.c        |   73 +++++++++++
 crypto/asymmetric_keys/tpm_key.h        |   19 +++
 crypto/asymmetric_keys/tpm_key_parser.c |  212 +++++++++++++++++++++++++++++++
 5 files changed, 312 insertions(+)
 create mode 100644 crypto/asymmetric_keys/tpm_key.c
 create mode 100644 crypto/asymmetric_keys/tpm_key.h
 create mode 100644 crypto/asymmetric_keys/tpm_key_parser.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 4870f28403f5..97d1bb714617 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -67,4 +67,11 @@ config SIGNED_PE_FILE_VERIFICATION
 	  This option provides support for verifying the signature(s) on a
 	  signed PE binary.
 
+config ASYMMETRIC_TPM_KEY_SUBTYPE
+	tristate "Asymmetric TPM-based public-key crypto algorithm subtype"
+	depends on TCG_TPM
+	help
+	  This option provides support for TPM hardware-based asymmetric public
+	  key type handling.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index e47fcd9ac5e8..690c16a517a9 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys.o
 asymmetric_keys-y := asymmetric_type.o signature.o
 
 obj-$(CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE) += public_key.o
+obj-$(CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE) += tpm_key.o tpm_key_parser.o
 obj-$(CONFIG_PUBLIC_KEY_ALGO_RSA) += rsa.o
 
 #
diff --git a/crypto/asymmetric_keys/tpm_key.c b/crypto/asymmetric_keys/tpm_key.c
new file mode 100644
index 000000000000..bfddedc9db32
--- /dev/null
+++ b/crypto/asymmetric_keys/tpm_key.c
@@ -0,0 +1,73 @@
+/* In-TPM asymmetric public-key crypto subtype
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) "TPK: "fmt
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/tpm.h>
+#include <keys/asymmetric-subtype.h>
+#include "tpm_key.h"
+
+MODULE_LICENSE("GPL");
+
+/*
+ * Provide a part of a description of the key for /proc/keys.
+ */
+static void tpm_key_describe(const struct key *asymmetric_key,
+			     struct seq_file *m)
+{
+	struct tpm_asymmetric_key *key = asymmetric_key->payload.data;
+	struct tpm_wrapped_key *wrap;
+
+	if (key && key->wrapped_key) {
+		wrap = key->wrapped_key;
+		seq_printf(m, "TPM.RSA %*phN",
+			   wrap->pubkey_len, wrap->data + wrap->pubkey_offset);
+	}
+}
+
+/*
+ * Destroy a TPM-based key.
+ */
+static void tpm_key_destroy(void *payload)
+{
+	struct tpm_asymmetric_key *key = payload;
+
+	if (key) {
+		kfree(key->wrapped_key);
+		kfree(key);
+		tpm_library_unuse();
+	}
+}
+
+/*
+ * Verify a signature using a TPM-based key.
+ */
+static int tpm_key_verify_signature(const struct key *key,
+				    const struct public_key_signature *sig)
+{
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Public key algorithm asymmetric key subtype
+ */
+struct asymmetric_key_subtype tpm_key_subtype = {
+	.owner			= THIS_MODULE,
+	.name			= "tpm_key",
+	.describe		= tpm_key_describe,
+	.destroy		= tpm_key_destroy,
+	.verify_signature	= tpm_key_verify_signature,
+};
+EXPORT_SYMBOL_GPL(tpm_key_subtype);
diff --git a/crypto/asymmetric_keys/tpm_key.h b/crypto/asymmetric_keys/tpm_key.h
new file mode 100644
index 000000000000..712221fee874
--- /dev/null
+++ b/crypto/asymmetric_keys/tpm_key.h
@@ -0,0 +1,19 @@
+/* TPM-based public key algorithm internals
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+struct tpm_asymmetric_key {
+	struct tpm_wrapped_key *wrapped_key;
+	u32	parent_tpm_handle;
+	u8	parent_authdata[TPM_DIGEST_SIZE];
+	u8	key_authdata[TPM_DIGEST_SIZE];
+};
+
+extern struct asymmetric_key_subtype tpm_key_subtype;
diff --git a/crypto/asymmetric_keys/tpm_key_parser.c b/crypto/asymmetric_keys/tpm_key_parser.c
new file mode 100644
index 000000000000..efb53172b43d
--- /dev/null
+++ b/crypto/asymmetric_keys/tpm_key_parser.c
@@ -0,0 +1,212 @@
+/* Instantiate a TPM key.
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#define DEBUG
+#define pr_fmt(fmt) "TPKP: "fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/tpm.h>
+#include <linux/parser.h>
+#include <keys/asymmetric-subtype.h>
+#include <keys/asymmetric-parser.h>
+#include "asymmetric_keys.h"
+#include "tpm_key.h"
+
+
+enum tpm_key_create_token {
+	opt_crt_err = -1,
+	opt_crt_parent,
+	opt_crt_keyauth,
+};
+
+static const match_table_t tpm_key_create_tokens = {
+	{ opt_crt_parent,	"parent=%x,%s"},
+	{ opt_crt_keyauth,	"keyauth=%s"},
+	{ opt_crt_err,		NULL}
+};
+
+/*
+ * Attempt to parse a key creation request.
+ */
+static int tpm_key_create(struct tpm_asymmetric_key *key, char *data)
+{
+	enum tpm_key_create_token token;
+	struct tpm_chip *chip;
+	unsigned long tmp, got = 0;
+	substring_t args[MAX_OPT_ARGS];
+	uint32_t key_handle;
+	char *p;
+	int ret;
+
+	pr_devel("==>%s(,%s)\n", __func__, data);
+
+	while ((p = strsep(&data, " \t"))) {
+		if (*p == '\0' || *p == ' ' || *p == '\t')
+			continue;
+		token = match_token(p, tpm_key_create_tokens, args);
+		switch (token) {
+		case opt_crt_parent:
+			pr_devel("parent %ld %ld\n",
+				 args[0].to - args[0].from,
+				 args[1].to - args[1].from);
+			*args[0].to = 0;
+			ret = kstrtoul(args[0].from, 16, &tmp);
+			if (ret < 0) {
+				pr_devel("bad parent handle\n");
+				return -EINVAL;
+			}
+			key->parent_tpm_handle = tmp;
+			if (args[1].to - args[1].from != TPM_DIGEST_SIZE * 2) {
+				pr_devel("parent auth wrong size\n");
+				return -EINVAL;
+			}
+			if (hex2bin(key->parent_authdata, args[1].from,
+				    TPM_DIGEST_SIZE) < 0) {
+				pr_devel("parent auth bad hex\n");
+				return -EINVAL;
+			}
+			break;
+
+		case opt_crt_keyauth:
+			pr_devel("keyauth\n");
+			if (args[1].to - args[1].from != TPM_DIGEST_SIZE * 2)
+				return -EINVAL;
+			if (hex2bin(key->parent_authdata, args[1].from,
+				    TPM_DIGEST_SIZE) < 0)
+				return -EINVAL;
+			break;
+
+		case opt_crt_err:
+			pr_devel("Unknown token %s\n", p);
+			return -EINVAL;
+		}
+		got |= 1 << token;
+	}
+
+	if ((got & 3) != 3) {
+		pr_devel("Missing mandatory args\n");
+		return -EINVAL;
+	}
+
+	chip = tpm_chip_find_get(TPM_ANY_NUM);
+	if (!chip)
+		return -ENODEV;
+
+	/* Create a key and retrieve the partially encrypted blob. */
+	ret = tpm_create_wrap_key(chip, TPM_ET_SRK, key->parent_tpm_handle,
+				  key->parent_authdata,
+				  key->key_authdata,
+				  NULL,
+				  &key->wrapped_key);
+	if (ret == -EBADMSG)
+		ret = -EIO;
+
+	/* Attempt to load the key back as a check */
+	ret = tpm_load_key2(chip, TPM_ET_SRK, key->parent_tpm_handle,
+			    key->parent_authdata, key->wrapped_key,
+			    &key_handle);
+	if (ret != 0) {
+		pr_devel("Couldn't load key back\n");
+		goto out;
+	}
+
+	ret = tpm_flush_specific(chip, key_handle, TPM_RT_KEY);
+	if (ret != 0)
+		pr_devel("Couldn't flush key handle\n");
+
+out:
+	tpm_chip_put(chip);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+
+/*
+ * Attempt to parse a data blob for a key as a TPM key specification.
+ *
+ * We expect one of the following in the prep data:
+ *
+ *	tpm_create parent=<key>,<auth> keyauth=<hex> [options...]
+ *	tpm_load parent=<key>,<auth> data=<hex> [options...]
+ */
+static int tpm_key_preparse(struct key_preparsed_payload *prep)
+{
+	struct tpm_asymmetric_key *key;
+	char *data;
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	ret = tpm_library_use();
+	if (ret < 0)
+		goto out;
+
+	ret = -ENOMEM;
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	if (!key)
+		goto out_free_tpmlib;
+	data = kmalloc(prep->datalen + 1, GFP_KERNEL);
+	if (!data)
+		goto out_free_key;
+
+	memcpy(data, prep->data, prep->datalen);
+	data[prep->datalen] = 0;
+	if (memcmp(data, "tpm_create ", 11) == 0) {
+		ret = tpm_key_create(key, data + 11);
+	} else {
+		ret = -EBADMSG;
+		goto out_free_data;
+	}
+
+	/* We're pinning the module by being linked against it */
+	__module_get(tpm_key_subtype.owner);
+	prep->type_data[0] = &tpm_key_subtype;
+	//prep->type_data[1] = kids;
+	prep->payload[0] = key;
+	//prep->description = desc;
+	prep->quotalen = 100;
+	key = NULL;
+	tpm_library_use();
+
+out_free_data:
+	kfree(data);
+out_free_key:
+	kfree(key);
+out_free_tpmlib:
+	tpm_library_unuse();
+out:
+	return ret;
+}
+
+static struct asymmetric_key_parser tpm_key_parser = {
+	.owner	= THIS_MODULE,
+	.name	= "tpm",
+	.parse	= tpm_key_preparse,
+};
+
+/*
+ * Module stuff
+ */
+static int __init tpm_key_init(void)
+{
+	return register_asymmetric_key_parser(&tpm_key_parser);
+}
+
+static void __exit tpm_key_exit(void)
+{
+	unregister_asymmetric_key_parser(&tpm_key_parser);
+}
+
+module_init(tpm_key_init);
+module_exit(tpm_key_exit);
+
+MODULE_DESCRIPTION("TPM key parser");
+MODULE_LICENSE("GPL");


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
