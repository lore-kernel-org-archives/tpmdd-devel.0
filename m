From: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] tpm: select CONFIG_CRYPTO
Date: Tue, 28 Feb 2017 22:24:45 +0100
Message-ID: <A83F6A3E-1BE9-48C9-8FB8-B3C061402061@gmx.de>
References: <20170228211326.3667625-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170228211326.3667625-1-arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



Am 28. Februar 2017 22:12:55 MEZ schrieb Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
>We get a newly introduced harmless warning when CONFIG_CRYPTO is
>disabled:
>
>warning: (TCG_TPM && TRUSTED_KEYS && IMA) selects CRYPTO_HASH_INFO
>which has unmet direct dependencies (CRYPTO)
>
>This adds another select to avoid the warning, consistent with other
>users
>of the crypto code.
>
>Fixes: c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support
>multiple banks")
>Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Lgtm

Reviewed-by: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>
>---
> drivers/char/tpm/Kconfig | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
>index af985cca413c..d520ac51c11c 100644
>--- a/drivers/char/tpm/Kconfig
>+++ b/drivers/char/tpm/Kconfig
>@@ -6,6 +6,7 @@ menuconfig TCG_TPM
> 	tristate "TPM Hardware Support"
> 	depends on HAS_IOMEM
> 	select SECURITYFS
>+	select CRYPTO
> 	select CRYPTO_HASH_INFO
> 	---help---
> 	  If you have a TPM security chip in your system, which

-- 
Sent from my mobile

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
