From: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] tpm/tpm_i2c_infineon: ensure no ongoing
	commands on shutdown
Date: Fri, 13 Jan 2017 16:09:54 -0800
Message-ID: <20170114000954.17728-1-apronin@chromium.org>
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
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, semenzato-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Resetting TPM while processing a command may lead to issues
on the next boot. Ensure that we don't have any ongoing
commands, and that no further commands can be sent to the chip
by unregistering the device in the shutdown handler.
tpm_chip_unregister() waits for the completion of an ongoing
command, if any, and then clears out chip->ops and unregisters
sysfs entities.

Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 62ee44e57ddc..0c829fe26561 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -689,14 +689,18 @@ static int tpm_tis_i2c_probe(struct i2c_client *client,
 	return rc;
 }
 
-static int tpm_tis_i2c_remove(struct i2c_client *client)
+static void tpm_tis_i2c_shutdown(struct i2c_client *client)
 {
 	struct tpm_chip *chip = tpm_dev.chip;
 
 	tpm_chip_unregister(chip);
 	release_locality(chip, tpm_dev.locality, 1);
 	tpm_dev.client = NULL;
+}
 
+static int tpm_tis_i2c_remove(struct i2c_client *client)
+{
+	tpm_tis_i2c_shutdown(client);
 	return 0;
 }
 
@@ -704,6 +708,7 @@ static struct i2c_driver tpm_tis_i2c_driver = {
 	.id_table = tpm_tis_i2c_table,
 	.probe = tpm_tis_i2c_probe,
 	.remove = tpm_tis_i2c_remove,
+	.shutdown = tpm_tis_i2c_shutdown,
 	.driver = {
 		   .name = "tpm_i2c_infineon",
 		   .pm = &tpm_tis_i2c_ops,
-- 
2.11.0.483.g087da7b7c-goog


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
