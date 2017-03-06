From: "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] vTPM: Fix missing NULL check
Date: Mon,  6 Mar 2017 17:32:15 -0500
Message-ID: <1488839535-11822-1-git-send-email-honclo@linux.vnet.ibm.com>
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
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hon Ching(Vicky) Lo" <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

The current code passes the address of tpm_chip as the argument to
dev_get_drvdata() without prior NULL check in
tpm_ibmvtpm_get_desired_dma.  This resulted an oops during kernel
boot when vTPM is enabled in Power partition configured in active
memory sharing mode.

The vio_driver's get_desired_dma() is called before the probe(), which
for vtpm is tpm_ibmvtpm_probe, and it's this latter function that
initializes the driver and set data.  Attempting to get data before
the probe() caused the problem.

This patch adds a NULL check to the tpm_ibmvtpm_get_desired_dma.

fixes: 9e0d39d8a6a0 ("tpm: Remove useless priv field in struct tpm_vendor_specific")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Hon Ching(Vicky) Lo <honclo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_ibmvtpm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 1b9d61f..a88ee25 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -313,7 +313,10 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 static unsigned long tpm_ibmvtpm_get_desired_dma(struct vio_dev *vdev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
-	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
+	struct ibmvtpm_dev *ibmvtpm = NULL;
+
+	if (chip)
+		ibmvtpm = dev_get_drvdata(&chip->dev);
 
 	/*
 	 * ibmvtpm initializes at probe time, so the data we are
-- 
1.7.1


------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
