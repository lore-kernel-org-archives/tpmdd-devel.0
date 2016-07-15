From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH 0/2] tpm: add driver for cr50 on SPI
Date: Thu, 14 Jul 2016 19:50:26 -0700
Message-ID: <20160715025026.GA21375@apronin>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
 <9A3CFCAE-F2FD-438D-A32B-AD59E0362E71@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9A3CFCAE-F2FD-438D-A32B-AD59E0362E71@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 07:28:55PM -0700, Peter Huewe wrote:
> Am 14. Juli 2016 19:20:16 GMT-07:00, schrieb Andrey Pronin <apronin@chromium.org>:
> >This patchset adds a TCG TPM2.0 PTP FIFO compliant interface for
> >Cr50 chip on SPI.
> >
> >Depends on the following patches by Andrey Pronin
> ><apronin@chromium.org>
> >that add new members to phy_ops in tpm_tis_core:
> > - tpm: support driver-specific sysfs attrs in tpm_tis_core
> > - tpm_tis_core: add optional max xfer size check
> >
> >Andrey Pronin (2):
> >  tpm: devicetree: document properties for cr50
> >  tpm: add driver for cr50 on SPI
> >
> > .../devicetree/bindings/security/tpm/cr50_spi.txt  |  30 ++
> > drivers/char/tpm/Kconfig                           |   9 +
> > drivers/char/tpm/Makefile                          |   1 +
> >drivers/char/tpm/cr50_spi.c                        | 409
> >+++++++++++++++++++++
> > 4 files changed, 449 insertions(+)
> >create mode 100644
> >Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
> > create mode 100644 drivers/char/tpm/cr50_spi.c
> 
> 
> Hi, 
> can you explain a bit more about this device? And why it needs a special driver and cannot be handled by tpm_tis_spi if its tcg compliant?
> 
> Peter
> -- 
> Sent from my mobile

Hi Peter,

Yes, it has a TCG-compliant interface, however, there are several things
specific to this device:
 - need to ensure a certain delay between spi transactions, or else
   the chip can miss several first bytes.
 - if there is no spi activity for this chip, it may go to sleep, and
   needs to be waken up before sending further commands.
 - it has some vendor-specific registers accessible from spi bus.

All that combined to me seemed to be enough justification to add a
device-specific driver rather than adding vendor-specific code to
tpm_tis_spi in multiple places.

Plus, where it seemed appropriate, I added additional hooks to
tpm_tis_core (device-specific sysfs attributes, capping burstcnt
in case of chip error) to support this chip specifics.

Best regards,
Andrey
