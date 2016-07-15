From: Andrey Pronin <apronin@chromium.org>
Subject: [PATCH 0/2] tpm: add driver for cr50 on SPI
Date: Thu, 14 Jul 2016 19:20:16 -0700
Message-ID: <1468549218-19215-1-git-send-email-apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Andrey Pronin <apronin@chromium.org>, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset adds a TCG TPM2.0 PTP FIFO compliant interface for
Cr50 chip on SPI.

Depends on the following patches by Andrey Pronin <apronin@chromium.org>
that add new members to phy_ops in tpm_tis_core:
 - tpm: support driver-specific sysfs attrs in tpm_tis_core
 - tpm_tis_core: add optional max xfer size check

Andrey Pronin (2):
  tpm: devicetree: document properties for cr50
  tpm: add driver for cr50 on SPI

 .../devicetree/bindings/security/tpm/cr50_spi.txt  |  30 ++
 drivers/char/tpm/Kconfig                           |   9 +
 drivers/char/tpm/Makefile                          |   1 +
 drivers/char/tpm/cr50_spi.c                        | 409 +++++++++++++++++++++
 4 files changed, 449 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/cr50_spi.txt
 create mode 100644 drivers/char/tpm/cr50_spi.c

-- 
2.6.6
