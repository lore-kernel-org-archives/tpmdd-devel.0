From: Andrey Pronin <apronin@chromium.org>
Subject: [PATCH 0/2] tpm: add optional max xfer size check
Date: Thu, 14 Jul 2016 18:39:03 -0700
Message-ID: <1468546745-14646-1-git-send-email-apronin@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Andrey Pronin <apronin@chromium.org>, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset introduces an optional maximum transfer size that can
be specified by a tpm driver. Setting the max_xfer_size helps to catch
the cases when burstcnt is incorrectly reported by the device (e.g. >64
for spi - happened in practice) and gracefully handle such situations.

Andrey Pronin (2):
  tpm_tis_core: add optional max xfer size check
  tpm_tis_spi: add max xfer size

 drivers/char/tpm/tpm_tis_core.c | 17 +++++++++++++++--
 drivers/char/tpm/tpm_tis_core.h | 13 +++++++++++++
 drivers/char/tpm/tpm_tis_spi.c  |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.6.6
