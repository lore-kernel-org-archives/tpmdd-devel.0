From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] tpm: select ANON_INODES for proxy driver
Date: Thu, 28 Apr 2016 12:46:13 +0200
Message-ID: <1461840382-2996256-1-git-send-email-arnd@arndb.de>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The newly added vtpmx driver fails to build if CONFIG_ANON_INODES
is disabled:

drivers/char/built-in.o: In function `vtpmx_fops_ioctl':
(.text+0x97f8): undefined reference to `anon_inode_getfile'

This adds a Kconfig 'select' statement to ensure it's always there
when we need it.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: 794c38e01358 ("tpm: Proxy driver for supporting multiple emulated TPMs")
---
 drivers/char/tpm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 0eac596e33d1..bfdc5c0486aa 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -125,6 +125,7 @@ config TCG_CRB
 config TCG_VTPM_PROXY
 	tristate "VTPM Proxy Interface"
 	depends on TCG_TPM
+	select ANON_INODES
 	---help---
 	  This driver proxies for an emulated TPM (vTPM) running in userspace.
 	  A device /dev/vtpmx is provided that creates a device pair
-- 
2.7.0


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
