From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] hwrng: meson: Fix module autoload for OF registration
Date: Mon, 17 Oct 2016 17:45:33 -0200
Message-ID: <CAOMZO5B+iDyNJ-heFU2Th-HQHocLS3Lz5zV7hFhiLs7ESJt2gw@mail.gmail.com>
References: <1476733214-19044-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476733214-19044-1-git-send-email-javier@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, Neil Armstrong <narmstrong@baylibre.com>, Kevin Hilman <khilman@baylibre.com>, Matt Mackall <mpm@selenic.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>, Carlo Caione <carlo@caione.org>, linux-amlogic@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 17, 2016 at 5:40 PM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:

> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -32,7 +32,7 @@ config TCG_TIS_CORE
>
>  config TCG_TIS
>         tristate "TPM Interface Specification 1.2 Interface / TPM 2.0 FIFO Interface"
> -       depends on X86
> +       depends on X86 || COMPILE_TEST

This is a separate change.
