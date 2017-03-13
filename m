From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 20/23] MAINTAINERS: Add file patterns for tpm device
 tree bindings
Date: Mon, 13 Mar 2017 13:55:08 +0200
Message-ID: <20170313115508.5ipzlg6uigvnxh5q@intel.com>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
 <1489324627-19126-21-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489324627-19126-21-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Mar 12, 2017 at 02:17:04PM +0100, Geert Uytterhoeven wrote:
> Submitters of device tree binding documentation may forget to CC
> the subsystem maintainer if this is missing.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Peter Huewe <peterhuewe@gmx.de>
> Cc: Marcel Selhorst <tpmdd@selhorst.net>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: tpmdd-devel@lists.sourceforge.net
> ---
> Please apply this patch directly if you want to be involved in device
> tree binding documentation for your subsystem.

Thanks

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> 
> v2:
>   - Add Acked-by.
> 
> Impact on next-20170310:
> 
> -Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS,commit_signer:3/4=75%)
> +Peter Huewe <peterhuewe@gmx.de> (maintainer:TPM DEVICE DRIVER)
> +Marcel Selhorst <tpmdd@selhorst.net> (maintainer:TPM DEVICE DRIVER)
> +Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> (maintainer:TPM DEVICE DRIVER)
> +Jason Gunthorpe <jgunthorpe@obsidianresearch.com> (reviewer:TPM DEVICE DRIVER)
> +Rob Herring <robh+dt@kernel.org> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
>  Mark Rutland <mark.rutland@arm.com> (maintainer:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
> -Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> (commit_signer:6/4=100%)
> -Nayna Jain <nayna@linux.vnet.ibm.com> (commit_signer:2/4=50%,authored:2/4=50%)
> -Christophe Ricard <christophe.ricard@gmail.com> (commit_signer:1/4=25%,authored:1/4=25%)
> -Jason Gunthorpe <jgunthorpe@obsidianresearch.com> (commit_signer:1/4=25%,authored:1/4=25%)
> +tpmdd-devel@lists.sourceforge.net (moderated list:TPM DEVICE DRIVER)
>  devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS)
>  linux-kernel@vger.kernel.org (open list)
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6cd9daf3a2f9a44a..000342ab65971a8c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12713,6 +12713,7 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
>  Q:	https://patchwork.kernel.org/project/tpmdd-devel/list/
>  T:	git git://git.infradead.org/users/jjs/linux-tpmdd.git
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/security/tpm/
>  F:	drivers/char/tpm/
>  
>  TPM IBM_VTPM DEVICE DRIVER
> -- 
> 2.7.4
> 
