From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 20/23] MAINTAINERS: Add file patterns for tpm device tree bindings
Date: Sun, 12 Mar 2017 14:17:04 +0100
Message-ID: <1489324627-19126-21-git-send-email-geert@linux-m68k.org>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Submitters of device tree binding documentation may forget to CC
the subsystem maintainer if this is missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net
---
Please apply this patch directly if you want to be involved in device
tree binding documentation for your subsystem.

v2:
  - Add Acked-by.

Impact on next-20170310:

-Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS,commit_signer:3/4=75%)
+Peter Huewe <peterhuewe@gmx.de> (maintainer:TPM DEVICE DRIVER)
+Marcel Selhorst <tpmdd@selhorst.net> (maintainer:TPM DEVICE DRIVER)
+Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> (maintainer:TPM DEVICE DRIVER)
+Jason Gunthorpe <jgunthorpe@obsidianresearch.com> (reviewer:TPM DEVICE DRIVER)
+Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
 Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
-Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> (commit_signer:6/4=100%)
-Nayna Jain <nayna@linux.vnet.ibm.com> (commit_signer:2/4=50%,authored:2/4=50%)
-Christophe Ricard <christophe.ricard@gmail.com> (commit_signer:1/4=25%,authored:1/4=25%)
-Jason Gunthorpe <jgunthorpe@obsidianresearch.com> (commit_signer:1/4=25%,authored:1/4=25%)
+tpmdd-devel@lists.sourceforge.net (moderated list:TPM DEVICE DRIVER)
 devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
 linux-kernel@vger.kernel.org (open list)
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6cd9daf3a2f9a44a..000342ab65971a8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12713,6 +12713,7 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 Q:	https://patchwork.kernel.org/project/tpmdd-devel/list/
 T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
 S:	Maintained
+F:	Documentation/devicetree/bindings/security/tpm/
 F:	drivers/char/tpm/
 
 TPM IBM_VTPM DEVICE DRIVER
-- 
2.7.4
