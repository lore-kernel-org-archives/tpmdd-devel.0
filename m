From: Andrey Pronin <apronin@chromium.org>
Subject: [PATCH 0/2] tpm: driver- and tpm2-specific sysfs attributes
Date: Thu, 14 Jul 2016 18:51:34 -0700
Message-ID: <1468547496-16215-1-git-send-email-apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Andrey Pronin <apronin@chromium.org>, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset adds sysfs attributes for the cases not covered by the
existing TPM1.2 support:
 - device-specific attributes provided by drivers like tpm_tis_spi
 - TPM2.0

Andrey Pronin (2):
  tpm: add sysfs attributes for tpm2
  tpm: support driver-specific sysfs attrs in tpm_tis_core

 drivers/char/tpm/tpm-chip.c     | 48 ++++++++++++++++++++++++++---------------
 drivers/char/tpm/tpm-sysfs.c    | 25 ++++++++++++++++++---
 drivers/char/tpm/tpm.h          |  8 ++++++-
 drivers/char/tpm/tpm_tis_core.c |  3 +++
 drivers/char/tpm/tpm_tis_core.h |  1 +
 5 files changed, 64 insertions(+), 21 deletions(-)

-- 
2.6.6
