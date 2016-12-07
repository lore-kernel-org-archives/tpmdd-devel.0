From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3 0/3] Locality support for tpm_crb
Date: Wed,  7 Dec 2016 13:49:57 +0200
Message-ID: <20161207115001.18332-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

The tpm_crb driver should follow the policy of reserving and
relinquishing the locality it uses when multiple localities are used,
like when TXT is another locality.

Jarkko Sakkinen (3):
  tpm_crb: map locality registers
  tpm_crb: encapsulate crb_wait_for_reg_32
  tpm_crb: request and relinquish locality 0

 drivers/char/tpm/tpm_crb.c | 185 +++++++++++++++++++++++++++++++++------------
 1 file changed, 137 insertions(+), 48 deletions(-)

-- 
v2: 
added sanity check for start address of the control area
v3:
do locality request/relinquish as part of send/recv
check priv->regs_h before using it
just assing the base address to regs_h instead of using crb_map_res
2.9.3

