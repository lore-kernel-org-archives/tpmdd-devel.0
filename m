From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 09/10] tpm/tpm_tis: Split tpm_tis driver
 into a core and TCG TIS compliant phy
Date: Sun, 10 Apr 2016 17:54:16 -0600
Message-ID: <20160410235416.GD11226@obsidianresearch.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
	<1460323386-16892-10-git-send-email-christophe-h.ricard@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460323386-16892-10-git-send-email-christophe-h.ricard-qxv4g6HH51o@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Apr 10, 2016 at 11:23:05PM +0200, Christophe Ricard wrote:

> +config TCG_TIS_CORE
> +	tristate
> +	---help---
> +	TCG TIS TPM core driver. It implements the TPM TCG TIS logic and hooks
> +	into the TPM kernel APIs. Physical layers will register against it.
> +
>  config TCG_TIS
>  	tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
>  	depends on X86
> +	select TCG_TIS_CORE
>  	  If you have a TPM security chip that is compliant with the
>  	  TCG TIS 1.2 TPM specification (TPM1.2) or the TCG PTP FIFO
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 56e8f1f..c6a4cea 100644
> +++ b/drivers/char/tpm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for the kernel tpm device drivers.
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
> -tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
> +tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o tpm_tis_core.o

Not sure we should merge tpm_tis_core into the main module like that,
make a new module?

> +++ b/drivers/char/tpm/tpm_tis_core.c
> +EXPORT_SYMBOL(release_locality);
> +MODULE_LICENSE("GPL");

These look like then need to be EXPORT_SYMBOL_GPL to me?

Why are so many things being exported? It seems really strange to
export the ops callbacks.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
