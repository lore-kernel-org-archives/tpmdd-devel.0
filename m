From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 1/2] Documentation: tpm: add the IBM
	Virtual TPM device tree binding documentation
Date: Wed, 26 Oct 2016 05:21:44 -0400
Message-ID: <1477473705-12746-1-git-send-email-nayna@linux.vnet.ibm.com>
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
To: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org, honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cclaudio-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Virtual TPM, which is being used on IBM POWER7+ and POWER8 systems running
POWERVM, is currently supported by tpm device driver but lacks the
documentation. This patch adds the missing documentation for the existing
support.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
Changelog v3:

- No changes done.

Changelog v2:

- New Patch.

 .../devicetree/bindings/security/tpm/ibmvtpm.txt   | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt

diff --git a/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
new file mode 100644
index 0000000..d89f999
--- /dev/null
+++ b/Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
@@ -0,0 +1,41 @@
+* Device Tree Bindings for IBM Virtual Trusted Platform Module(vtpm)
+
+Required properties:
+
+- compatible            : property name that conveys the platform architecture
+                          identifiers, as 'IBM,vtpm'
+- device_type           : specifies type of virtual device
+- interrupts            : property specifying the interrupt source number and
+                          sense code associated with this virtual I/O Adapters
+- ibm,my-drc-index      : integer index for the connector between the device
+                          and its parent - present only if Dynamic
+                          Reconfiguration(DR) Connector is enabled
+- ibm,#dma-address-cells: specifies the number of cells that are used to
+                          encode the physical address field of dma-window
+                          properties
+- ibm,#dma-size-cells   : specifies the number of cells that are used to
+                          encode the size field of dma-window properties
+- ibm,my-dma-window     : specifies DMA window associated with this virtual
+                          IOA
+- ibm,loc-code          : specifies the unique and persistent location code
+                          associated with this virtual I/O Adapters
+- linux,sml-base        : 64-bit base address of the reserved memory allocated
+                          for the firmware event log
+- linux,sml-size        : size of the memory allocated for the firmware event log
+
+Example (IBM Virtual Trusted Platform Module)
+---------------------------------------------
+
+                vtpm@30000003 {
+                        ibm,#dma-size-cells = <0x2>;
+                        compatible = "IBM,vtpm";
+                        device_type = "IBM,vtpm";
+                        ibm,my-drc-index = <0x30000003>;
+                        ibm,#dma-address-cells = <0x2>;
+                        linux,sml-base = <0xc60e 0x0>;
+                        interrupts = <0xa0003 0x0>;
+                        ibm,my-dma-window = <0x10000003 0x0 0x0 0x0 0x10000000>;
+                        ibm,loc-code = "U8286.41A.10082DV-V3-C3";
+                        reg = <0x30000003>;
+                        linux,sml-size = <0xbce10200>;
+                };
-- 
2.5.0


------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
