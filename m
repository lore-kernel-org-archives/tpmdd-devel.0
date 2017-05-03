From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm_ts: Consolidate the platform and acpi
	probe flow
Date: Wed, 3 May 2017 15:26:05 -0600
Message-ID: <20170503212605.GA26863@obsidianresearch.com>
References: <20170503164857.GA20369@obsidianresearch.com>
	<20170503210159.ook77o4myjebl4xr@rhwork>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170503210159.ook77o4myjebl4xr@rhwork>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jerry Snitselaar <jsnitsel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 03, 2017 at 02:01:59PM -0700, Jerry Snitselaar wrote:

> I haven't had a chance to dig into it yet, but I'm seeing this with the patch on top of tpmdd/next:
> 
> [    1.041046] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1A, rev-id 16)
> [    1.293032] genirq: Flags mismatch irq 9. 00000000 (tpm0) vs. 00000080 (acpi)

Hum.

I think this means that

	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

Did not return the IRQ for the TPM when the platform device matched
via ACPI? Can you confirm that?

I see there is a bug here, and it should be using platform_get_irq.. I
think this incremental patch will make the driver load for you.

However, can you confirm that same IRQ setting (eg no IRQ) is selected
before/after this patch?

>From 233d05aad66cbb828892f65b4dd722f3a7042241 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Wed, 3 May 2017 15:24:32 -0600
Subject: [PATCH] tpm_tis: Use platform_get_irq

Replace the open coded IORESOURCE_IRQ with platform_get_irq, which
supports more cases.

This also fixes a typo with force mode - IRQ autoprobing was being
turned on for failure to get an IRQ in normal mode, which is backwards
to the comment and intent.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index ddad56a4a958f1..54d90e31a7b690 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -284,11 +284,9 @@ static int tpm_tis_plat_probe(struct platform_device *pdev)
 	}
 	tpm_info.res = *res;
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res) {
-		tpm_info.irq = res->start;
-	} else {
-		if (pdev == force_pdev)
+	tpm_info.irq = platform_get_irq(pdev, 0);
+	if (tpm_info.irq <= 0) {
+		if (pdev != force_pdev)
 			tpm_info.irq = -1;
 		else
 			/* When forcing auto probe the IRQ */
-- 
2.7.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
