From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v4 1/2] tpm: devicetree: document properties
	for cr50
Date: Thu, 28 Jul 2016 18:55:13 -0700
Message-ID: <1469757314-116169-2-git-send-email-apronin@chromium.org>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
	<1469757314-116169-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1469757314-116169-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
References: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, dtor-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add TPM2.0 PTP FIFO compatible SPI interface for chips with Cr50
firmware.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 .../devicetree/bindings/security/tpm/cr50_spi.txt   | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt

diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
new file mode 100644
index 0000000..2fbebd3
--- /dev/null
+++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
@@ -0,0 +1,21 @@
+* H1 Secure Microcontroller with Cr50 Firmware on SPI Bus.
+
+H1 Secure Microcontroller running Cr50 firmware provides several
+functions, including TPM-like functionality. It communicates over
+SPI using the FIFO protocol described in the PTP Spec, section 6.
+
+Required properties:
+- compatible: Should be "google,cr50".
+- spi-max-frequency: Maximum SPI frequency.
+
+Example:
+
+&spi0 {
+        status = "okay";
+
+        cr50@0 {
+                compatible = "google,cr50";
+                reg = <0>;
+                spi-max-frequency = <800000>;
+        };
+};
-- 
2.6.6


------------------------------------------------------------------------------
