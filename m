From: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH v4 2/2] tpm: do not suspend/resume if power
 stays on
Date: Mon, 29 May 2017 11:09:40 +0200
Message-ID: <20170529090940.9874-2-enric.balletbo@collabora.com>
References: <20170529090940.9874-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170529090940.9874-1-enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The suspend/resume behavior of the TPM can be controlled by setting
"powered-while-suspended" in the DTS. This is useful for the cases
when hardware does not power-off the TPM.

Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
Changes since v3.
  - Rebased on top of linux-next
 Rob Herring
  - Split DT binding from code patch as is preferred.
Changes since v2:
 Jarkko Sakkinen
  - Add a new TPM_CHIP_FLAG_ALWAYS_POWERED flag instead of using a boolean variable.
  - Remove a trailing newline.
Changes since v1:
 Jason Gunthorpe :
  - Move the code to handle suspend/resume in the common chip code.

 drivers/char/tpm/tpm-interface.c | 3 +++
 drivers/char/tpm/tpm.h           | 1 +
 drivers/char/tpm/tpm_of.c        | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index be54159..34ec7ce 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1099,6 +1099,9 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
+		return 0;
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		tpm2_shutdown(chip, TPM2_SU_STATE);
 		return 0;
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index af05c14..b44d39c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -170,6 +170,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_IRQ		= BIT(2),
 	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
 	TPM_CHIP_FLAG_HAVE_TIMEOUTS	= BIT(4),
+	TPM_CHIP_FLAG_ALWAYS_POWERED	= BIT(5),
 };
 
 struct tpm_bios_log {
diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
index de57d4a..aadb7f4 100644
--- a/drivers/char/tpm/tpm_of.c
+++ b/drivers/char/tpm/tpm_of.c
@@ -36,6 +36,9 @@ int tpm_read_log_of(struct tpm_chip *chip)
 	else
 		return -ENODEV;
 
+	if (of_property_read_bool(np, "powered-while-suspended"))
+		chip->flags |= TPM_CHIP_FLAG_ALWAYS_POWERED;
+
 	sizep = of_get_property(np, "linux,sml-size", NULL);
 	basep = of_get_property(np, "linux,sml-base", NULL);
 	if (sizep == NULL && basep == NULL)
-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
