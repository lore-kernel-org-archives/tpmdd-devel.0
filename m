From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] Clean up handling of event log files
Date: Sat,  1 Oct 2016 15:41:15 +0300
Message-ID: <1475325678-16573-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

Meld a common function for opening measurements files and keep the
dentries in a static array.

Jarkko Sakkinen (1):
  tpm: replace dynamically allocated bios_dir with a static array

Nayna Jain (1):
  tpm: define a generic open() method for ascii & bios measurements

 drivers/char/tpm/tpm-chip.c     |   9 +--
 drivers/char/tpm/tpm.h          |   3 +-
 drivers/char/tpm/tpm_eventlog.c | 123 ++++++++++++++--------------------------
 drivers/char/tpm/tpm_eventlog.h |  10 ++--
 4 files changed, 55 insertions(+), 90 deletions(-)

-- 
2.7.4
