From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/2] fixes for v4.4
Date: Wed, 30 May 2018 23:44:38 +0300
Message-ID: <20180530204440.27299-1-jarkko.sakkinen@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Decided to add Enric's commit because it is also a bug fix instead
of modifying Chris commit.

Chris Chiu (1):
  tpm: self test failure should not cause suspend to fail

Enric Balletbo i Serra (1):
  tpm: do not suspend/resume if power stays on

 drivers/char/tpm/tpm-chip.c      | 12 ++++++++++++
 drivers/char/tpm/tpm-interface.c |  7 +++++++
 drivers/char/tpm/tpm.h           |  1 +
 3 files changed, 20 insertions(+)

-- 
v2: moved the check from tpm_of.c to tpm-chip.c as in v4.4 chip is
unreachable otherwise. I did compilation test now with BuildRoot
for power arch.
2.17.0
