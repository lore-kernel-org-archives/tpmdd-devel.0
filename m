From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/3] Runtime PM for TPM2 CRB chips
Date: Wed,  8 Jun 2016 02:01:59 +0300
Message-ID: <1465340522-1112-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Support for runtime PM with TPM2 CRB chips such as PTT in Skylake.

Jarkko Sakkinen (3):
  tpm_crb: fix crb_req_canceled behavior
  tpm, tpm_crb: remove wmb()'s
  tpm, tpm_crb: runtime power management

 drivers/char/tpm/tpm-interface.c |  3 ++
 drivers/char/tpm/tpm_crb.c       | 72 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 7 deletions(-)

-- 
2.7.4
