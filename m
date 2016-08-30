From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] Documentation: tpm: Adds the TPM device tree node documentation
Date: Tue, 30 Aug 2016 00:44:37 -0400
Message-ID: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hellerda-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, ltcgcw-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This is documenting device tree binding for
I2C based TPM, similar concept which being used
for virtual TPM on POWER7 and POWER8 systems running PowerVM.

Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/devicetree/bindings/i2c/i2c-tpm.txt | 29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-tpm.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-tpm.txt b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
new file mode 100644
index 0000000..8fdee14
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
@@ -0,0 +1,29 @@
+Device Tree Bindings for I2C based Trusted Platform Module(TPM)
+---------------------------------------------------------------
+
+This node describes a TPM device connected to Processor on i2c bus.
+
+Required properties:
+
+- compatible : 'manufacturer,model'
+- label : represents device type
+- linux,sml-base : base address of the Event Log. It is a physical address.
+		   sml stands for shared memory log.
+- linux,sml-size : size of the memory allocated for the Event Log.
+
+Optional properties:
+
+- status: indicates whether the device is enabled or disabled. "okay" for
+          enabled and "disabled" for disabled.
+
+Example
+-------
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
