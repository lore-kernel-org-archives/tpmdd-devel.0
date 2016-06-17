From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 4/5] tpm: rename tpm_pcr_read_dev() to
	tpm1_pcr_read()
Date: Fri, 17 Jun 2016 23:10:46 +0200
Message-ID: <1466197847-4937-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1466197847-4937-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466197847-4937-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Gave more consistent name tpm1_pcr_read() as the TPM2 version is called
tpm2_pcr_read().

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 4 ++--
 drivers/char/tpm/tpm-sysfs.c     | 2 +-
 drivers/char/tpm/tpm.h           | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 4aeacf3..3995f5c 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -670,7 +670,7 @@ static struct tpm_input_header pcrread_header = {
 	.ordinal = TPM_ORDINAL_PCRREAD
 };
 
-int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
+int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 {
 	int rc;
 	struct tpm_cmd_t cmd;
@@ -732,7 +732,7 @@ int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf)
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		rc = tpm2_pcr_read(chip, pcr_idx, res_buf);
 	else
-		rc = tpm_pcr_read_dev(chip, pcr_idx, res_buf);
+		rc = tpm1_pcr_read(chip, pcr_idx, res_buf);
 	tpm_put_ops(chip);
 	return rc;
 }
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index b46cf70..a89d0e2 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -101,7 +101,7 @@ static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
 
 	num_pcrs = be32_to_cpu(cap.num_pcrs);
 	for (i = 0; i < num_pcrs; i++) {
-		rc = tpm_pcr_read_dev(chip, i, digest);
+		rc = tpm1_pcr_read(chip, i, digest);
 		if (rc)
 			break;
 		str += sprintf(str, "PCR-%02d: ", i);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index de93535..382c7e6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -504,7 +504,7 @@ extern void tpm_chip_unregister(struct tpm_chip *chip);
 
 void tpm_sysfs_add_device(struct tpm_chip *chip);
 
-int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
+int tpm1_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #ifdef CONFIG_ACPI
 extern void tpm_add_ppi(struct tpm_chip *chip);
-- 
2.7.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
