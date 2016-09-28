From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 2/2] Documentation: tpm: add the Physical TPM device tree binding documentation
Date: Wed, 28 Sep 2016 04:30:41 -0400
Message-ID: <1475051441-23008-2-git-send-email-nayna@linux.vnet.ibm.com>
References: <1475051441-23008-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475051441-23008-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, hellerda-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, cclaudio-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Newly added support of TPM 2.0 eventlog securityfs pseudo files in tpm
device driver consumes device tree bindings representing I2C based
Physical TPM. This patch adds the documentation for corresponding device
tree bindings of I2C based Physical TPM. These bindings are similar to
vtpm device tree bindings being used on IBM Power7+ and Power8 Systems
running PowerVM.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
Changelog v2:

- Include review feedbacks.
  - Move the doc within bindings/security/tpm.
  - Add example for compatible property in description.
  - Delete implicit properties like status, label from description.
  - Redefine linux,sml-base description.

 .../devicetree/bindings/security/tpm/tpm-i2c.txt     | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt

diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
new file mode 100644
index 0000000..16df8bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
@@ -0,0 +1,20 @@
+* Device Tree Bindings for I2C based Trusted Platform Module(TPM)
+
+Required properties:
+
+- compatible     : 'manufacturer,model', eg. nuvoton,npct650
+- linux,sml-base : 64-bit base address of the reserved memory allocated for
+                   the firmware event log
+- linux,sml-size : size of the memory allocated for the firmware event log
+
+Example (for OpenPower Systems with Nuvoton TPM 2.0 on I2C)
+----------------------------------------------------------
+
+tpm@57 {
+	reg = <0x57>;
+	label = "tpm";
+	compatible = "nuvoton,npct650", "nuvoton,npct601";
+	linux,sml-base = <0x7f 0xfd450000>;
+	linux,sml-size = <0x10000>;
+	status = "okay";
+};
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
