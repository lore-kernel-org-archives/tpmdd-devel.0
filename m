From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 0/2] Nuvoton TPM2 support
Date: Mon, 18 Jul 2016 21:03:53 +0300
Message-ID: <20160718180353.GA31463@intel.com>
References: <1468345311-8014-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468345311-8014-1-git-send-email-jgunthorpe@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: andrew.zamansky@nuvoton.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 12, 2016 at 11:41:48AM -0600, Jason Gunthorpe wrote:
> This should be ready to go now.

I've applied this series.

/Jarkko

> 
> v4:
>  - Fix build error noticed by Fengguang Wu when DT is enabled.
>  - IRQ patch split out
> 
> Jason Gunthorpe (2):
>   tpm: Factor out common startup code
>   tpm: Add TPM 2.0 support to the Nuvoton i2c driver (NPCT6xx family)
> 
>  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 +
>  drivers/char/tpm/st33zp24/st33zp24.c               |  4 +-
>  drivers/char/tpm/tpm-chip.c                        |  9 +++++
>  drivers/char/tpm/tpm-interface.c                   | 27 +++++++++++++
>  drivers/char/tpm/tpm.h                             |  4 +-
>  drivers/char/tpm/tpm2-cmd.c                        | 46 ++++++++++++++++++++--
>  drivers/char/tpm/tpm_crb.c                         | 10 +----
>  drivers/char/tpm/tpm_i2c_atmel.c                   |  6 +--
>  drivers/char/tpm/tpm_i2c_infineon.c                |  4 +-
>  drivers/char/tpm/tpm_i2c_nuvoton.c                 | 33 ++++++++++------
>  drivers/char/tpm/tpm_tis_core.c                    | 24 +----------
>  drivers/char/tpm/tpm_vtpm_proxy.c                  |  9 +----
>  include/linux/tpm.h                                |  5 +++
>  13 files changed, 113 insertions(+), 69 deletions(-)
> 
> -- 
> 2.1.4
> 
