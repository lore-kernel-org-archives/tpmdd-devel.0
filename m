From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/4] tpm: last minute critical fixes for Linux 4.5
Date: Sat, 13 Feb 2016 15:47:03 +0200
Message-ID: <1455371228-20431-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

These are critical to get to Linux 4.5 in order to get the chip refcount
management stabilized and API/ABI for policy based sealing correct.

Harald Hoyer (1):
  tpm_eventlog.c: fix binary_bios_measurements

Jarkko Sakkinen (2):
  tpm: fix: keep auth session intact after unseal operation
  tpm: fix: rollback when devm_add_action() fails

Jason Gunthorpe (1):
  tpm: Hold the kref during tpm_chip_find_get

 drivers/char/tpm/tpm-chip.c     |  9 ++++++++-
 drivers/char/tpm/tpm.h          |  1 +
 drivers/char/tpm/tpm2-cmd.c     | 10 +++++++---
 drivers/char/tpm/tpm_eventlog.c | 10 ++++++++--
 4 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.7.0
