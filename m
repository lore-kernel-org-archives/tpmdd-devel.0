From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH 1/2] tpm: devicetree: document properties for
	cr50
Date: Thu, 14 Jul 2016 19:20:17 -0700
Message-ID: <1468549218-19215-2-git-send-email-apronin@chromium.org>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1468549218-19215-1-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: =?UTF-8?q?=C2=A0=C2=A0=C2=A0Mark=20Rutland?= <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, =?UTF-8?q?=C2=A0=C2=A0=C2=A0Pawel=20Moll?= <pawel.moll-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?=C2=A0=C2=A0=C2=A0Ian=20Campbell?= <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?=C2=A0=C2=A0=C2=A0Rob=20Herring?= <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, =?UTF-8?q?=C2=A0=C2=A0=C2=A0Kumar=20Gala?= <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Add TPM2.0-compatible interface to Cr50. Document its properties
in devicetree.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 .../devicetree/bindings/security/tpm/cr50_spi.txt  | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt

diff --git a/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
new file mode 100644
index 0000000..1b05e51
--- /dev/null
+++ b/Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
@@ -0,0 +1,30 @@
+* Cr50 Chip on SPI.
+
+TCG PTP FIFO Compliant Interface to Cr50 on SPI bus.
+
+Required properties:
+- compatible: Should be "google,cr50_spi".
+- spi-max-frequency: Maximum SPI frequency.
+
+Optional properties:
+- access-delay-msec: Required delay between subsequent transactions on SPI.
+- sleep-delay-msec: Time after the last SPI activity, after which the chip
+  may go to sleep.
+- wake-start-delay-msec: Time after initiating wake up before the chip is
+  ready to accept commands over SPI.
+
+Example:
+
+&spi0 {
+        status = "okay";
+
+        cr50@0 {
+                compatible = "google,cr50_spi";
+                reg = <0>;
+                spi-max-frequency = <800000>;
+
+                access-delay-msec = <2>;
+                sleep-delay-msec = <1000>;
+                wake-start-delay-msec = <60>;
+        };
+};
-- 
2.6.6


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
