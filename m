From: <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] tpm: add tpm 2.0 support to nuvoton chips
	on i2c bus
Date: Sun, 20 Mar 2016 08:02:58 +0000
Message-ID: <510d6333a3fc49b297a82bd69c89a05e@NTILML02.nuvoton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Eyal.Cohen-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, shmulik.hager-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

>From 40c94ed59330638da05932d14b91ebe886c4d33c Mon Sep 17 00:00:00 2001
From: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
Date: Sun, 20 Mar 2016 09:01:46 +0200
Subject: [PATCH 1/1] tpm: add tpm 2.0 support to nuvoton chips on i2c bus

prob of tpm_i2c_nuvoton check if chip tpm support tpm 2.0
specification . if chip support tpm 2.0 then run tmp 2.0 selftest
and set timeouts according tpm 2.0 .  otherwise run tpm 1.2 selftest
and set timeouts according to tpm 1.2

Signed-off-by: andrew azmansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
---
 drivers/char/tpm/tpm_i2c_nuvoton.c | 48 ++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 847f159..4263911 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -138,7 +138,8 @@ static void i2c_nuvoton_ready(struct tpm_chip *chip)
 }

 /* read burstCount field from TPM_STS register
- * return -1 on fail to read */
+ * return -1 on fail to read
+*/
 static int i2c_nuvoton_get_burstcount(struct i2c_client *client,
       struct tpm_chip *chip)
 {
@@ -170,6 +171,7 @@ static int i2c_nuvoton_get_burstcount(struct i2c_client *client,
 static bool i2c_nuvoton_check_status(struct tpm_chip *chip, u8 mask, u8 value)
 {
 u8 status = i2c_nuvoton_read_status(chip);
+
 return (status != TPM_STS_ERR_VAL) && ((status & mask) == value);
 }

@@ -188,7 +190,8 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 if (rc > 0)
 return 0;
 /* At this point we know that the SINT pin is asserted, so we
- * do not need to do i2c_nuvoton_check_status */
+ * do not need to do i2c_nuvoton_check_status
+*/
 } else {
 unsigned long ten_msec, stop;
 bool status_valid;
@@ -469,7 +472,8 @@ static const struct tpm_class_ops tpm_i2c = {
  * the interrupt is currently being asserted. The driver does not do any
  * processing triggered by interrupts, and the chip provides no way to mask at
  * the source (plus that would be slow over I2C). Run the IRQ as a one-shot,
- * this means it cannot be shared. */
+ * this means it cannot be shared.
+*/
 static irqreturn_t i2c_nuvoton_int_handler(int dummy, void *dev_id)
 {
 struct tpm_chip *chip = dev_id;
@@ -552,7 +556,8 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
  * I2C intfcaps (interrupt capabilitieis) in the chip are hard coded to:
  *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
  * The IRQ should be set in the i2c_board_info (which is done
- * automatically in of_i2c_register_devices, for device tree users */
+ * automatically in of_i2c_register_devices, for device tree users
+*/
 chip->vendor.irq = client->irq;

 if (chip->vendor.irq) {
@@ -601,10 +606,38 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 }
 }

-if (tpm_get_timeouts(chip))
-return -ENODEV;
+rc = tpm2_probe(chip);
+if (rc)
+return rc;

-if (tpm_do_selftest(chip))
+if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+chip->vendor.timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
+chip->vendor.timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
+chip->vendor.timeout_c = msecs_to_jiffies(TPM2_TIMEOUT_C);
+chip->vendor.timeout_d = msecs_to_jiffies(TPM2_TIMEOUT_D);
+chip->vendor.duration[TPM_SHORT] =
+msecs_to_jiffies(TPM2_DURATION_SHORT);
+chip->vendor.duration[TPM_MEDIUM] =
+msecs_to_jiffies(TPM2_DURATION_MEDIUM);
+chip->vendor.duration[TPM_LONG] =
+msecs_to_jiffies(TPM2_DURATION_LONG);
+
+rc = tpm2_do_selftest(chip);
+if (rc == TPM2_RC_INITIALIZE) {
+if (tpm2_startup(chip, TPM2_SU_CLEAR))
+return -ENODEV;
+
+rc = tpm2_do_selftest(chip);
+}
+
+} else {
+if (tpm_get_timeouts(chip))
+return -ENODEV;
+
+rc = tpm_do_selftest(chip);
+}
+
+if (rc)
 return -ENODEV;

 return tpm_chip_register(chip);
@@ -614,6 +647,7 @@ static int i2c_nuvoton_remove(struct i2c_client *client)
 {
 struct device *dev = &(client->dev);
 struct tpm_chip *chip = dev_get_drvdata(dev);
+
 tpm_chip_unregister(chip);
 return 0;
 }
--
1.9.1





===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
