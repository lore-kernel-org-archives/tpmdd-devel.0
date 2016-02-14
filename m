From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [GIT PULL] tpmdd fixes for Linux 4.5 (updated)
Date: Sun, 14 Feb 2016 07:50:13 +0200
Message-ID: <20160214055013.GA4292@intel.com>
References: <20160210034804.GA5153@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160210034804.GA5153@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 10, 2016 at 05:48:04AM +0200, Jarkko Sakkinen wrote:
> Hi James,
> 
> As we discussed I'm sending now a revised pull request with a couple
> of new fixes to the one that I sent with the tag:
> 
>   tags/tpmdd-next-20160120

Forgot to say that these are for -rc4 (rebased on top of security/next,
which was -rc3).

/Jarkko

> /Jarkko
> 
> The following changes since commit 388f7b1d6e8ca06762e2454d28d6c3c55ad0fe95:
> 
>   Linux 4.5-rc3 (2016-02-07 15:38:30 -0800)
> 
> are available in the git repository at:
> 
>   https://github.com/jsakkine/linux-tpmdd.git tags/tpmdd-next-20160210
> 
> for you to fetch changes up to 8e0ee3c9faed7ca68807ea45141775856c438ac0:
> 
>   tpm: fix the cleanup of struct tpm_chip (2016-02-10 04:12:08 +0200)
> 
> ----------------------------------------------------------------
> tpmdd fixes for Linux 4.5 (updated)
> 
> ----------------------------------------------------------------
> Jarkko Sakkinen (3):
>       tpm: fix checks for policy digest existence in tpm2_seal_trusted()
>       tpm: fix the rollback in tpm_chip_register()
>       tpm: fix the cleanup of struct tpm_chip
> 
> Jason Gunthorpe (7):
>       tpm_crb: Use the common ACPI definition of struct acpi_tpm2
>       tpm_tis: Disable interrupt auto probing on a per-device basis
>       tpm_tis: Do not fall back to a hardcoded address for TPM2
>       tpm_tis: Use devm_ioremap_resource
>       tpm_tis: Clean up the force=1 module parameter
>       tpm_crb: Drop le32_to_cpu(ioread32(..))
>       tpm_crb: Use devm_ioremap_resource
> 
> Jerry Snitselaar (1):
>       tpm: remove unneeded include of actbl2.h
> 
>  drivers/char/tpm/tpm-chip.c |  14 +--
>  drivers/char/tpm/tpm.h      |   7 --
>  drivers/char/tpm/tpm2-cmd.c |  12 +--
>  drivers/char/tpm/tpm_crb.c  | 190 ++++++++++++++++++++-------------
>  drivers/char/tpm/tpm_tis.c  | 255 +++++++++++++++++++++++++-------------------
>  include/keys/trusted-type.h |   2 +-
>  security/keys/trusted.c     |  11 +-
>  7 files changed, 276 insertions(+), 215 deletions(-)
> 
> ------------------------------------------------------------------------------
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
