From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 3/5] tpm: return error code from
	tpm_gen_interrupt()
Date: Tue, 19 Jul 2016 14:40:27 -0600
Message-ID: <20160719204027.GE16042@obsidianresearch.com>
References: <1468935171-7815-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1468935171-7815-4-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20160719202741.GB16042@obsidianresearch.com>
	<20160719203147.GA26228@intel.com>
	<20160719203634.GB26228@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160719203634.GB26228-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 19, 2016 at 11:36:34PM +0300, Jarkko Sakkinen wrote:
> If Christophe could submit a fix for st33, I could include it to this
> series and make one more revision. Thank you for reviewing this!

Here is a commit:

>From 5e178858dcdc2bff9ac31f9851db52370cc282cb Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 19 Jul 2016 14:38:55 -0600
Subject: [PATCH] tpm/st33zp24: Remove useless tpm_gen_interrupt

This function should only be called as part of an IRQ probing protocol
and st33 does not have any code to detect that the IRQ it tries to
generate was not generated and disable the IRQ.

Since st33 is primarily a DT binding driver it should not be doing
IRQ probing anyhow, so let us just delete this useless call.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/char/tpm/st33zp24/st33zp24.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/tpm/st33zp24/st33zp24.c b/drivers/char/tpm/st33zp24/st33zp24.c
index c2ee30451e41..6f060c76217b 100644
--- a/drivers/char/tpm/st33zp24/st33zp24.c
+++ b/drivers/char/tpm/st33zp24/st33zp24.c
@@ -589,8 +589,6 @@ int st33zp24_probe(void *phy_id, const struct st33zp24_phy_ops *ops,
 		chip->flags |= TPM_CHIP_FLAG_IRQ;
 
 		disable_irq_nosync(tpm_dev->irq);
-
-		tpm_gen_interrupt(chip);
 	}
 
 	return tpm_chip_register(chip);
-- 
2.1.4


------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
