From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] fixes for 4.9.96
Date: Wed,  2 May 2018 17:38:27 +0300
Message-ID: <20180502143830.3534-1-jarkko.sakkinen@linux.intel.com>
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

 drivers/char/tpm/tpm-interface.c | 7 +++++++
 drivers/char/tpm/tpm.h           | 2 ++
 drivers/char/tpm/tpm_of.c        | 3 +++
 3 files changed, 12 insertions(+)

-- 
2.17.0
