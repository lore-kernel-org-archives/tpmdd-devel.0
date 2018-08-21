From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/23] TPM: Provide a platform driver for the
 user emulator driver
Date: Tue, 21 Aug 2018 16:57:09 +0100
Message-ID: <153486702979.13066.16900998092976336647.stgit@warthog.procyon.org.uk>
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

Provide a platform driver for the user emulator driver.  This seems to be
necessary to stop tpm_chip_find_get() from blowing up because it assumes
unconditionally that any device will have a driver attached:

		if (try_module_get(pos->dev->driver->owner)) {

However, this doesn't then work right because if I remove the TPM device and
re-add it, the tpm ID isn't recycled (ie, /dev/tpm0 becomes unavailable and
the new TPM is /dev/tpm1).

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/char/tpm/tpm_user_emul.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_user_emul.c b/drivers/char/tpm/tpm_user_emul.c
index b96350592bca..e5b13358c71e 100644
--- a/drivers/char/tpm/tpm_user_emul.c
+++ b/drivers/char/tpm/tpm_user_emul.c
@@ -656,17 +656,39 @@ static struct miscdevice tpm_user_dev = {
 	.fops	= &tpm_user_fops,
 };
 
+static struct platform_driver tpm_user_drv = {
+	.driver = {
+		.name	= "tpm_user",
+		.owner	= THIS_MODULE,
+		/* .pm	= &tpm_user_pm, -- do we need pm since there's no h/w? */
+	},
+};
+
 /*
  * Initialise a device
  */
 static __init int tpm_user_mod_init(void)
 {
-	return misc_register(&tpm_user_dev);
+	int ret;
+
+	ret = platform_driver_register(&tpm_user_drv);
+	if (ret < 0)
+		return ret;
+
+	ret = misc_register(&tpm_user_dev);
+	if (ret < 0)
+		goto error_dev;
+	return 0;
+
+error_dev:
+	platform_driver_unregister(&tpm_user_drv);
+	return ret;
 }
 device_initcall(tpm_user_mod_init);
 
 static __exit void tpm_user_mod_exit(void)
 {
 	misc_deregister(&tpm_user_dev);
+	platform_driver_unregister(&tpm_user_drv);
 }
 module_exit(tpm_user_mod_exit);


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
