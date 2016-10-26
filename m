From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 2/2] Documentation: tpm: add the Physical
	TPM device tree binding documentation
Date: Wed, 26 Oct 2016 05:21:45 -0400
Message-ID: <1477473705-12746-2-git-send-email-nayna@linux.vnet.ibm.com>
References: <1477473705-12746-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1477473705-12746-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cclaudio-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
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
Changelog v3:
 - Added documentation for "label" property.

Changelog v2:

- Include review feedbacks.
  - Move the doc within bindings/security/tpm.
  - Add example for compatible property in description.
  - Delete implicit properties like status, label from description.
  - Redefine linux,sml-base description.

 .../devicetree/bindings/security/tpm/tpm-i2c.txt    | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt

diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
new file mode 100644
index 0000000..8cb638b
--- /dev/null
+++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
@@ -0,0 +1,21 @@
+* Device Tree Bindings for I2C based Trusted Platform Module(TPM)
+
+Required properties:
+
+- compatible     : 'manufacturer,model', eg. nuvoton,npct650
+- label          : human readable string describing the device, eg. "tpm"
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


------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
