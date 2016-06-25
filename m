From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 1/6] tpm: remove unnecessary externs from
	tpm.h
Date: Sun, 26 Jun 2016 00:44:46 +0300
Message-ID: <1466891093-27766-2-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1466891093-27766-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1466891093-27766-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Removed unnecessary externs from tpm.h.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8890df2..80b5fa4 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -482,25 +482,25 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
 ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd, int len,
 			 const char *desc);
-extern int tpm_get_timeouts(struct tpm_chip *);
-extern void tpm_gen_interrupt(struct tpm_chip *);
-extern int tpm_do_selftest(struct tpm_chip *);
-extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
-extern int tpm_pm_suspend(struct device *);
-extern int tpm_pm_resume(struct device *);
-extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
-			     wait_queue_head_t *, bool);
+int tpm_get_timeouts(struct tpm_chip *chip);
+void tpm_gen_interrupt(struct tpm_chip *chip);
+int tpm_do_selftest(struct tpm_chip *chip);
+unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
+int tpm_pm_suspend(struct device *dev);
+int tpm_pm_resume(struct device *dev);
+int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+		      wait_queue_head_t *queue, bool check_cancel);
 
 struct tpm_chip *tpm_chip_find_get(int chip_num);
 __must_check int tpm_try_get_ops(struct tpm_chip *chip);
 void tpm_put_ops(struct tpm_chip *chip);
 
-extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
-				       const struct tpm_class_ops *ops);
-extern struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
-				       const struct tpm_class_ops *ops);
-extern int tpm_chip_register(struct tpm_chip *chip);
-extern void tpm_chip_unregister(struct tpm_chip *chip);
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				const struct tpm_class_ops *ops);
+struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
+				 const struct tpm_class_ops *ops);
+int tpm_chip_register(struct tpm_chip *chip);
+void tpm_chip_unregister(struct tpm_chip *chip);
 
 void tpm_sysfs_add_device(struct tpm_chip *chip);
 
@@ -526,10 +526,10 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
 ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			u32 *value, const char *desc);
 
-extern int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
-extern void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
-extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
-extern int tpm2_do_selftest(struct tpm_chip *chip);
-extern int tpm2_gen_interrupt(struct tpm_chip *chip);
-extern int tpm2_probe(struct tpm_chip *chip);
+int tpm2_startup(struct tpm_chip *chip, u16 startup_type);
+void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
+unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
+int tpm2_do_selftest(struct tpm_chip *chip);
+int tpm2_gen_interrupt(struct tpm_chip *chip);
+int tpm2_probe(struct tpm_chip *chip);
 #endif
-- 
2.7.4


------------------------------------------------------------------------------
Attend Shape: An AT&T Tech Expo July 15-16. Meet us at AT&T Park in San
Francisco, CA to explore cutting-edge tech and listen to tech luminaries
present their vision of the future. This family event has something for
everyone, including kids. Get more information and register today.
http://sdm.link/attshape
