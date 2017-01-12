From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC v2 5/5] tpm2: expose resource manager via a device
 link /dev/tpms<n>
Date: Thu, 12 Jan 2017 22:56:28 +0200
Message-ID: <20170112205628.qh3yf2jcargtw6qv@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 07:46:08PM +0200, Jarkko Sakkinen wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Currently the Resource Manager (RM) is not exposed to userspace.  Make
> this exposure via a separate device, which can now be opened multiple
> times because each read/write transaction goes separately via the RM.
> 
> Concurrency is protected by the chip->tpm_mutex for each read/write
> transaction separately.  The TPM is cleared of all transient objects
> by the time the mutex is dropped, so there should be no interference
> between the kernel and userspace.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

I think you should talk about TPM spaces here.

> ---
>  drivers/char/tpm/Makefile        |  2 +-
>  drivers/char/tpm/tpm-chip.c      | 54 ++++++++++++++++++++++++++++++++++---
>  drivers/char/tpm/tpm-interface.c | 13 +++++++--
>  drivers/char/tpm/tpm.h           |  6 +++--
>  drivers/char/tpm/tpms-dev.c      | 57 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 124 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/char/tpm/tpms-dev.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 13ff5da..e50d768 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  obj-$(CONFIG_TCG_TPM) += tpm.o
>  tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
> -	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o
> +	 tpm_eventlog.o tpm2-space.o tpm-dev-common.o tpms-dev.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>  tpm-$(CONFIG_OF) += tpm_of.o
>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 993b9ae..0d2be04 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -33,6 +33,7 @@ DEFINE_IDR(dev_nums_idr);
>  static DEFINE_MUTEX(idr_lock);
>  
>  struct class *tpm_class;
> +struct class *tpm_rm_class;

They belong to the same device class.

>  dev_t tpm_devt;

But they should have different major device numbers.

/Jarkko
