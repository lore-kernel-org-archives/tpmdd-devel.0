From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/2] tpm: add driver for cr50 on SPI
Date: Tue, 19 Jul 2016 15:56:24 +0300
Message-ID: <20160719125624.GC5047@intel.com>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 07:20:16PM -0700, Andrey Pronin wrote:
> This patchset adds a TCG TPM2.0 PTP FIFO compliant interface for
> Cr50 chip on SPI.
> 
> Depends on the following patches by Andrey Pronin <apronin@chromium.org>
> that add new members to phy_ops in tpm_tis_core:
>  - tpm: support driver-specific sysfs attrs in tpm_tis_core
>  - tpm_tis_core: add optional max xfer size check
> 
> Andrey Pronin (2):
>   tpm: devicetree: document properties for cr50
>   tpm: add driver for cr50 on SPI

I wonder who coul peer test this? I do not possess this hardware.

/Jarkko
