From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/4] Small fixes and cleanups for tpm_crb
Date: Fri,  2 Sep 2016 22:34:16 +0300
Message-ID: <1472844861-24599-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

A set of small fixes and clean ups for tpm_crb.

Jarkko Sakkinen (4):
  tpm_crb: fix crb_req_canceled behavior
  tpm_crb: remove wmb()'s
  tpm_crb: refine the naming of constants
  tpm_crb: fix incorrect values of cmdReady and goIdle bits

 drivers/char/tpm/tpm_crb.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

-- 
2.7.4

