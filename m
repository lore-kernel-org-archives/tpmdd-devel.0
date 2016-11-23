From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v2 0/4] tpm: kdoc cleanup
Date: Wed, 23 Nov 2016 12:04:10 +0200
Message-ID: <1479895454-15076-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: tpmdd-devel@lists.sourceforge.net

Cleanup tpm in-code documentation.

Tomas Winkler (4):
  tpm: add kdoc for tpm_transmit and tpm_transmit_cmd
  tpm/tpm2-chip: fix kdoc errors
  tmp: use pdev for parent device in tpm_chip_alloc
  tpm/vtpm: fix kdoc warnings

 drivers/char/tpm/tpm-chip.c       |   8 +--
 drivers/char/tpm/tpm-interface.c  |  33 ++++++++++--
 drivers/char/tpm/tpm2-cmd.c       | 105 +++++++++++++++++++++-----------------
 drivers/char/tpm/tpm_ibmvtpm.c    |  51 +++++++++---------
 drivers/char/tpm/tpm_vtpm_proxy.c |  48 ++++++++++++-----
 5 files changed, 150 insertions(+), 95 deletions(-)

-- 
2.7.4
