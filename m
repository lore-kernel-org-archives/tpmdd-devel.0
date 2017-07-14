From: Josh Zimmerman <joshz@google.com>
Subject: [PATCH v1 0/2] Run TPM2_Shutdown on system shutdown
Date: Fri, 14 Jul 2017 12:57:59 -0700
Message-ID: <20170714195803.7035-1-joshz@google.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, gregkh@linuxfoundation.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

This is a backport to the 4.4 stable kernel.

I had to manually apply a couple of cherry picks and resolve some merge
conflicts, so some of this may be worth a closer look and test on Jarkko's or
some other TPM maintainer's part

This patchset causes all devices in the tpm class to issue TPM2_Shutdown
when the system is shutting down.

As a prerequisite, it adds a "shutdown" method to "struct class".

Backporting to 4.4 since this bug can lock users out of their TPMs.

 drivers/base/core.c                 |   6 +++++-
 drivers/char/tpm/tpm-chip.c         | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 drivers/char/tpm/tpm-dev.c          |  15 +++++++++++----
 drivers/char/tpm/tpm-interface.c    |  49 ++++++++++++++++++++++++++-----------------------
 drivers/char/tpm/tpm-sysfs.c        |  18 +++++++++++++++---
 drivers/char/tpm/tpm.h              |  15 +++++++++------
 drivers/char/tpm/tpm2-cmd.c         |   8 ++++----
 drivers/char/tpm/tpm_atmel.c        |  14 +++++++-------
 drivers/char/tpm/tpm_i2c_atmel.c    |  16 ++++++++--------
 drivers/char/tpm/tpm_i2c_infineon.c |   6 +++---
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  22 +++++++++++-----------
 drivers/char/tpm/tpm_infineon.c     |  22 +++++++++++-----------
 drivers/char/tpm/tpm_nsc.c          |  20 ++++++++++----------
 drivers/char/tpm/tpm_tis.c          |  16 ++++++++--------
 include/linux/device.h              |   2 ++
 15 files changed, 237 insertions(+), 113 deletions(-)
