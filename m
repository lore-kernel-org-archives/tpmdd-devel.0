From: "Andrew Zamansky (NTIL)" <azamansk-1UdtCKOZWuXOzY7siszIiwMMGMOHi2eC@public.gmane.org>
Subject: [PATCH 1/1] added tpm 2.0 support to nuvoton i2c
	driver
Date: Sun, 10 Apr 2016 13:53:32 +0300
Message-ID: <20160410105332.4CD954138@taln70.nuvoton.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, shmulik.hager-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Eyal.Cohen-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

>From 2fbdc8ad7b675270873a58d0934a675eb927f704 Mon Sep 17 00:00:00 2001
From: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Date: Thu, 7 Apr 2016 09:19:57 +0300
Subject: [PATCH 1/1] added tpm 2.0 support to nuvoton i2c driver

add tpm 2.0 support to nuvoton i2c tpm driver

Signed-off-by: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
 drivers/char/tpm/tpm_i2c_nuvoton.c                 | 39 ++++++++++++++++++=
+---
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Do=
cumentation/devicetree/bindings/i2c/trivial-devices.txt
index 53987449..0a07cbc 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -62,6 +62,7 @@ national,lm80         Serial Interface ACPI-Compatible Mi=
croprocessor System Hardware M
 national,lm85          Temperature sensor with integrated fan control
 national,lm92          =B10.33=B0C Accurate, 12-Bit + Sign Temperature Sen=
sor and Thermal Window Comparator with Two-Wire Interface
 nuvoton,npct501                i2c trusted platform module (TPM)
+nuvoton,npct6xx                i2c trusted platform module (TPM) 6xx series
 nxp,pca9556            Octal SMBus and I2C registered interface
 nxp,pca9557            8-bit I2C-bus and SMBus I/O port with reset
 nxp,pcf8563            Real-time clock/calendar
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_=
nuvoton.c
index 847f159..d87433b 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -1,5 +1,5 @@
 /*************************************************************************=
*****
- * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
+ * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501/NPCT6XX,
  * based on the TCG TPM Interface Spec version 1.2.
  * Specifications at www.trustedcomputinggroup.org
  *
@@ -163,7 +163,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_client=
 *client,
 }

 /*
- * WPCT301/NPCT501 SINT# supports only dataAvail
+ * WPCT301/NPCT501/NPCT6XX SINT# supports only dataAvail
  * any call to this function which is not waiting for dataAvail will
  * set queue to NULL to avoid waiting for interrupt
  */
@@ -601,10 +601,38 @@ static int i2c_nuvoton_probe(struct i2c_client *clien=
t,
                }
        }

-       if (tpm_get_timeouts(chip))
-               return -ENODEV;
+       rc =3D tpm2_probe(chip);
+       if (rc)
+               return rc;

-       if (tpm_do_selftest(chip))
+       if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+               chip->vendor.timeout_a =3D msecs_to_jiffies(TPM2_TIMEOUT_A);
+               chip->vendor.timeout_b =3D msecs_to_jiffies(TPM2_TIMEOUT_B);
+               chip->vendor.timeout_c =3D msecs_to_jiffies(TPM2_TIMEOUT_C);
+               chip->vendor.timeout_d =3D msecs_to_jiffies(TPM2_TIMEOUT_D);
+               chip->vendor.duration[TPM_SHORT] =3D
+                       msecs_to_jiffies(TPM2_DURATION_SHORT);
+               chip->vendor.duration[TPM_MEDIUM] =3D
+                       msecs_to_jiffies(TPM2_DURATION_MEDIUM);
+               chip->vendor.duration[TPM_LONG] =3D
+                       msecs_to_jiffies(TPM2_DURATION_LONG);
+
+               rc =3D tpm2_do_selftest(chip);
+               if (rc =3D=3D TPM2_RC_INITIALIZE) {
+                       if (tpm2_startup(chip, TPM2_SU_CLEAR))
+                               return -ENODEV;
+
+                       rc =3D tpm2_do_selftest(chip);
+               }
+
+       } else {
+               if (tpm_get_timeouts(chip))
+                       return -ENODEV;
+
+               rc =3D tpm_do_selftest(chip);
+       }
+
+       if (rc)
                return -ENODEV;

        return tpm_chip_register(chip);
@@ -628,6 +656,7 @@ MODULE_DEVICE_TABLE(i2c, i2c_nuvoton_id);
 static const struct of_device_id i2c_nuvoton_of_match[] =3D {
        {.compatible =3D "nuvoton,npct501"},
        {.compatible =3D "winbond,wpct301"},
+       {.compatible =3D "nuvoton,npct6xx"},
        {},
 };
 MODULE_DEVICE_TABLE(of, i2c_nuvoton_of_match);
--
1.9.1



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The privileged confidential information contained in this email is intended=
 for use only by the addressees as indicated by the original sender of this=
 email. If you are not the addressee indicated in this email or are not res=
ponsible for delivery of the email to such a person, please kindly reply to=
 the sender indicating this fact and delete all copies of it from your comp=
uter and network server immediately. Your cooperation is highly appreciated=
. It is advised that any unauthorized use of confidential information of Nu=
voton is strictly prohibited; and any information in this email irrelevant =
to the official business of Nuvoton shall be deemed as neither given nor en=
dorsed by Nuvoton.

---------------------------------------------------------------------------=
---
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers=
 of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
