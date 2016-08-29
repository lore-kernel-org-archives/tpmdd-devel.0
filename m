From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org: TPM2 erroring-out after tpm: Factor
 out common startup code]
Date: Mon, 29 Aug 2016 14:08:28 -0600
Message-ID: <20160829200828.GB3201@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Looks legit to me.

----- Forwarded message from Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org> -----

Date: Sat, 27 Aug 2016 23:44:46 -0700
From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Subject: TPM2 erroring-out after tpm: Factor out common startup code

Hi Jason,
  your change cae8b441fc20812d7260dc3b45e05ee98fcfff1b to factor out common
startup code introduced regression in tpm2-cmd :-(  Now if firmware does
initialize tpm2 (and so tpm2_do_selftest succeeds), 'TPM self test failed'
error message is still printed, despite 'rc' being zero :-(

Can you apply something like patch below, and send it to Linus?

You also probably want to keep warning that TPM was not initialized by
firmware if tpm2-cmd has to perform initialization, as in such case TPM cannot
be used for attestation.
					Thanks,
						Petr


Do not print error message on successful TPM2 selftest

If TPM2 selftest succeeds, everything is fine, and no error message
should be printed.

Signed-off-by: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>


diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 08c7e23..f141357 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -957,7 +957,7 @@ int tpm2_auto_startup(struct tpm_chip *chip)
                goto out;

        rc = tpm2_do_selftest(chip);
-       if (rc != TPM2_RC_INITIALIZE) {
+       if (rc && rc != TPM2_RC_INITIALIZE) {
                dev_err(&chip->dev, "TPM self test failed\n");
                goto out;
        }

----- End forwarded message -----

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada

------------------------------------------------------------------------------
