From: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] tpm/tpm_crb: drop useless cpu_to_le32
	when writing to registers
Date: Mon, 12 Sep 2016 02:03:54 +0300
Message-ID: <1473635035-14443-4-git-send-email-tomas.winkler@intel.com>
References: <1473635035-14443-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1473635035-14443-1-git-send-email-tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Don't apply endianity conversion when writing to the registers
this is already handled by the system.

Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/char/tpm/tpm_crb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index f066810bfc03..0c9989d0106e 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -154,7 +154,7 @@ static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
 	wmb();
 
 	if (priv->flags & CRB_FL_CRB_START)
-		iowrite32(cpu_to_le32(CRB_START_INVOKE), &priv->cca->start);
+		iowrite32(CRB_START_INVOKE, &priv->cca->start);
 
 	if (priv->flags & CRB_FL_ACPI_START)
 		rc = crb_do_acpi_start(chip);
@@ -166,7 +166,7 @@ static void crb_cancel(struct tpm_chip *chip)
 {
 	struct crb_priv *priv = dev_get_drvdata(&chip->dev);
 
-	iowrite32(cpu_to_le32(CRB_CANCEL_INVOKE), &priv->cca->cancel);
+	iowrite32(CRB_CANCEL_INVOKE, &priv->cca->cancel);
 
 	/* Make sure that cmd is populated before issuing cancel. */
 	wmb();
-- 
2.7.4


------------------------------------------------------------------------------
