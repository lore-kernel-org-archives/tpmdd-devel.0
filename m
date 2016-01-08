From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 0/7] tpm_tis: Clean up force module parameter
Date: Fri, 8 Jan 2016 17:12:21 +0200
Message-ID: <20160108151221.GB2218@intel.com>
References: <1452213386-21460-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452213386-21460-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 07, 2016 at 05:36:19PM -0700, Jason Gunthorpe wrote:
> Drive the force=1 flow through the driver core. There are two main reasons to do this:
>  1) To enable tpm_tis for OF environments requires a platform_device anyhow, so
>     the force_device needs to be re-used for them.
>  2) Recent changes in the core code break the assumption that a driver will be
>     'attached' to things created through platform_device_register_simple,
>     which causes the tpm core to blow up.
> 
> To make force probing reliable this also fixes both tpm_tis and tpm_crb to
> properly use request_region to lock the TPM iomemory against multiple access.

Applied. Thank you.

/Jarkko

> 
> v4:
> - Alter the commit message for using the common ACPI definitions (Jarkko)
> - Move the misplaced error check hunk from patch #4 to #3 (Jarkko)
> 
> v3:
> - Fix some bugs in getting the struct resource for tpm_tis (Martin Wilck)
> - Include tpm_crb in the request_resource cleanup as well, tpm_tis and tpm_crb
>   tend to use the same address ranges so both should have locking for safety
> - ACPI and endianness cleanups in both drivers
> 
> v2:
>  - Make sure we request the mem resource in tpm_tis to avoid double-loading
>    the driver
>  - Re-order the init sequence so that a forced platform device gets first crack at
>    loading, and excludes the other mechanisms via the above
>  - Checkpatch clean
>  - Gotos renamed
> 
> Jason Gunthorpe (7):
>   tpm_crb: Use the common ACPI definition of struct acpi_tpm2
>   tpm_tis: Disable interrupt auto probing on a per-device basis
>   tpm_tis: Do not fall back to a hardcoded address for TPM2
>   tpm_tis: Use devm_ioremap_resource
>   tpm_tis: Clean up the force=1 module parameter
>   tpm_crb: Drop le32_to_cpu(ioread32(..))
>   tpm_crb: Use devm_ioremap_resource
> 
>  drivers/char/tpm/tpm.h     |   7 --
>  drivers/char/tpm/tpm_crb.c | 196 +++++++++++++++++++++-------------
>  drivers/char/tpm/tpm_tis.c | 254 +++++++++++++++++++++++++--------------------
>  3 files changed, 264 insertions(+), 193 deletions(-)
> 
> -- 
> 2.1.4
> 
