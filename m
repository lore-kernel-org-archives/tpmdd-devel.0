From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 47/54] MAINTAINERS: Add file patterns for tpm device tree bindings
Date: Sun, 22 May 2016 11:06:24 +0200
Message-ID: <1463907991-7916-48-git-send-email-geert@linux-m68k.org>
References: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463907991-7916-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 01a6ed1d8fc2d81f..54dcdef6efc4a936 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11600,6 +11600,7 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 Q:	https://patchwork.kernel.org/project/tpmdd-devel/list/
 T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
 S:	Maintained
+F:	Documentation/devicetree/bindings/security/tpm/
 F:	drivers/char/tpm/
 
 TPM IBM_VTPM DEVICE DRIVER
-- 
1.9.1
