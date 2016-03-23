From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] tpm: drop list from struct
	tpm_vendor_specific
Date: Wed, 23 Mar 2016 21:17:17 +0100
Message-ID: <1458764240-24185-3-git-send-email-christophe-h.ricard@st.com>
References: <1458764240-24185-1-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1458764240-24185-1-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Dropped list from struct tpm_vendor_specific as it is not used in any
place.

It is initialized in tpm_i2c_infineon but not used at all in the code.

Signed-off-by: Christophe Ricard <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
---
 drivers/char/tpm/tpm.h              | 1 -
 drivers/char/tpm/tpm_i2c_infineon.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0d1b7e6..357ac14 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -133,7 +133,6 @@ struct tpm_chip;
 struct tpm_vendor_specific {
 	int irq;
 
-	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
 	bool timeout_adjusted;
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index f2aa99e..e74f1c1 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -619,7 +619,6 @@ static int tpm_tis_i2c_init(struct device *dev)
 
 	dev_info(dev, "1.2 TPM (device-id 0x%X)\n", vendor >> 16);
 
-	INIT_LIST_HEAD(&chip->vendor.list);
 	tpm_dev.chip = chip;
 
 	tpm_get_timeouts(chip);
-- 
2.5.0


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
