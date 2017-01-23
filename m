From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC v4 0/5] RFC: in-kernel resource manager
Date: Mon, 23 Jan 2017 09:01:03 -0800
Message-ID: <1485190863.2534.10.camel@linux.vnet.ibm.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170122234438.12102-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-23 at 01:44 +0200, Jarkko Sakkinen wrote:
> This patch set adds support for TPM spaces that provide a context
> for isolating and swapping transient objects. The content does
> not yet include support for policy and HMAC sessions.
> 
> There's a test script for trying out TPM spaces in
> 
>   git://git.infradead.org/users/jjs/tpm2-scripts.git
> 
> A simple smoke test can be run by
> 
>   sudo python -m unittest -v tpm2_smoke.SpaceTest   
> 
> v2:
> Changed to James' proposal of API. I did not make any other changes
> except split core TPM space code its own patch because I want to find
> consensus on the API before polishing the corners. Thus, this version
> also carries the RFC tag. I have not yet locked in my standpoint
> whether
> ioctl or a device file is a better deal.
> 
> v3:
> - Check TPM return code in tpm_map_response.
> - Reference tracking for /dev/tpms0.
> - clear_bit(is_open) was removed from tpm-dev.c. Added it back.
> - Use response length as the buffer size limit in tpm2_commit_space.
> - This version now passes again my smoke tests.
> 
> v4:
> - Lots of small bug fixes and clean ups.
> - Quirk for TPM2_CC_FlushHandle

It's still failing my flush test.  This time the problem is the return
code on context save failure: it's TPM_RC_REFERENCE_H0 not
TPM_RC_HANDLE.  This is the fix.  The manual implies TPM_RC_HANDLE
could also be the return, so I kept both.

James

---

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 62e8421..cc1db77 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -106,6 +106,7 @@ enum tpm2_algorithms {
 	TPM2_ALG_SHA512		= 0x000D,
 	TPM2_ALG_NULL		= 0x0010,
 	TPM2_ALG_SM3_256	= 0x0012,
+	TPM2_RC_REFERENCE_H0	= 0x0910,
 };
 
 enum tpm2_command_codes {
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 83e9708..b36337a 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -104,7 +104,8 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
 			 __func__, rc);
 		tpm_buf_destroy(&tbuf);
 		return -EFAULT;
-	} else if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE) {
+	} else if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE ||
+		   rc == TPM2_RC_REFERENCE_H0) {
 		tpm_buf_destroy(&tbuf);
 		return -ENOENT;
 	} else if (rc) {


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
