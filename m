From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] Fixes for sparse reported warnings
Date: Fri, 17 Jun 2016 16:39:27 +0200
Message-ID: <1466174369-7140-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Jarkko Sakkinen (2):
  tpm_vtpm_proxy: fix address space of a user pointer in
    vtpmx_fops_ioctl()
  tpm_crb: fix address space of the return pointer in crb_map_res()

 drivers/char/tpm/tpm_crb.c        | 2 +-
 drivers/char/tpm/tpm_vtpm_proxy.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.7.4

