From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: remove unneeded include of actbl2.h
Date: Tue, 5 Jan 2016 08:49:33 +0200
Message-ID: <20160105064933.GA5835@intel.com>
References: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 04, 2016 at 12:19:43PM -0700, Jerry Snitselaar wrote:
> tpm_tis.c already gets actbl2.h via linux/acpi.h -> acpi/acpi.h ->
> acpi/actbl.h -> acpi/actbl2.h, so the direct include in tpm_tis.c
> is not needed.
> 
> Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
> 
> Jarrko, this is a trivial thing I noticed while doing some work.
> Not sure if you guys care, but thought I'd send it in anyways.
> 
>  drivers/char/tpm/tpm_tis.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 65f7eec..461d486 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -28,7 +28,6 @@
>  #include <linux/wait.h>
>  #include <linux/acpi.h>
>  #include <linux/freezer.h>
> -#include <acpi/actbl2.h>
>  #include "tpm.h"
>  
>  enum tis_access {
> -- 
> 2.6.1
> 
