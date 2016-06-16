From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm_vtpm_proxy: fix sparse warning
Date: Thu, 16 Jun 2016 12:37:54 +0200
Message-ID: <1466073474-4381-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

When running make C=2 M=drivers/char/tpm/

  CC [M]  drivers/char/tpm//tpm_crb.o
  CHECK   drivers/char/tpm//tpm_vtpm_proxy.c
drivers/char/tpm//tpm_vtpm_proxy.c:552:32: warning: incorrect type in assignment (different address spaces)
drivers/char/tpm//tpm_vtpm_proxy.c:552:32:    expected struct vtpm_proxy_new_dev *vtpm_new_dev_p
drivers/char/tpm//tpm_vtpm_proxy.c:552:32:    got void [noderef] <asn:1>*argp
drivers/char/tpm//tpm_vtpm_proxy.c:553:51: warning: incorrect type in argument 2 (different address spaces)
drivers/char/tpm//tpm_vtpm_proxy.c:553:51:    expected void const [noderef] <asn:1>*from
drivers/char/tpm//tpm_vtpm_proxy.c:553:51:    got struct vtpm_proxy_new_dev *vtpm_new_dev_p
drivers/char/tpm//tpm_vtpm_proxy.c:559:34: warning: incorrect type in argument 1 (different address spaces)
drivers/char/tpm//tpm_vtpm_proxy.c:559:34:    expected void [noderef] <asn:1>*to
drivers/char/tpm//tpm_vtpm_proxy.c:559:34:    got struct vtpm_proxy_new_dev *vtpm_new_dev_p

The __user annotation was missing from the corresponding variable.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 4384042..86e27e8 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -541,7 +541,7 @@ static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
 				   unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	struct vtpm_proxy_new_dev *vtpm_new_dev_p;
+	struct vtpm_proxy_new_dev __user *vtpm_new_dev_p;
 	struct vtpm_proxy_new_dev vtpm_new_dev;
 	struct file *file;
 
-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://pubads.g.doubleclick.net/gampad/clk?id=1444514421&iu=/41014381
