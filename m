From: Christophe Ricard <christophe.ricard@gmail.com>
Subject: [PATCH v8 4/7] devicetree: Add infineon to vendor-prefix.txt
Date: Thu, 19 May 2016 00:35:50 +0200
Message-ID: <1463610953-2766-5-git-send-email-christophe-h.ricard@st.com>
References: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1463610953-2766-1-git-send-email-christophe-h.ricard@st.com>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net, christophe-h.ricard@st.com, jean-luc.blanc@st.com, benoit.houyere@st.com, Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, devicetree@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

From: Christophe Ricard <christophe.ricard@gmail.com>

Add missing vendor to vendor-prefix.txt

Cc: devicetree@vger.kernel.org
Signed-off-by: Christophe Ricard <christophe-h.ricard@st.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 72e2c5a..6c3d970 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -113,6 +113,7 @@ ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
 iom	Iomega Corporation
 img	Imagination Technologies Ltd.
+infineon Infineon Technologies
 ingenic	Ingenic Semiconductor
 innolux	Innolux Corporation
 intel	Intel Corporation
-- 
2.1.4

