From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/5] Use tpm_transmit_cmd() consistently
Date: Fri, 17 Jun 2016 23:10:42 +0200
Message-ID: <1466197847-4937-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set updates the subsystem consistently use tpm_transmit_cmd()
throughout the subsystem the exception being tpm_write() where it makes
sense to use the raw interface because higher level command handling is
delegated to user space.

Jarkko Sakkinen (5):
  tpm: unify tpm_gen_interrupt()
  tpm: return error code from tpm_gen_interrupt()
  tpm: use tpm_transmit_cmd() in tpm2_probe()
  tpm: rename tpm_pcr_read_dev() to tpm1_pcr_read()
  tpm: use tpm1_pcr_read() in tpm_do_selftest()

 drivers/char/tpm/tpm-interface.c | 36 +++++++++++++++++++-----------------
 drivers/char/tpm/tpm-sysfs.c     |  2 +-
 drivers/char/tpm/tpm.h           |  5 ++---
 drivers/char/tpm/tpm2-cmd.c      | 21 +--------------------
 drivers/char/tpm/tpm_tis_core.c  |  7 +++----
 5 files changed, 26 insertions(+), 45 deletions(-)

-- 
2.7.4

