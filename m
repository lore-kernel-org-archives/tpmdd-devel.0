From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] fix bad constant expressions in tpm.h
Date: Mon, 19 Sep 2016 23:22:07 +0300
Message-ID: <1474316530-17315-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Even though the cpu_to_be32() is open coded it is not a good convention
to call it in the enum definitions. This will also sparse errors about
invalid constant expressions.

Ed Swierk (1):
  tpm: Clean up reading of timeout and duration capabilities

Jarkko Sakkinen (1):
  tpm: fix bad constant expressions

 drivers/char/tpm/tpm-interface.c | 78 +++++++++++++---------------------------
 drivers/char/tpm/tpm-sysfs.c     |  4 +--
 drivers/char/tpm/tpm.h           | 23 ++++++------
 3 files changed, 38 insertions(+), 67 deletions(-)

-- 
2.7.4
