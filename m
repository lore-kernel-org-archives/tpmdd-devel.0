From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd updates for Linux 4.11
Date: Mon, 23 Jan 2017 18:36:20 +0200
Message-ID: <20170123163620.s3cz7v3jd3rngx44@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

This pull request contains tpmdd updates for Linux 4.11. This release
contains only bug fixes and minor enhancements.

/Jarkko

The following changes since commit b25e67161c295c98acda92123b2dd1e7d8642901:

  seccomp: dump core when using SECCOMP_RET_KILL (2017-01-23 21:42:42 +1100)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170123

for you to fetch changes up to c659af78eb7b7d7be40f23d9d97bde58eb1368ac:

  tpm: Check size of response before accessing data (2017-01-23 18:28:18 +0200)

----------------------------------------------------------------
tpmdd updates for Linux 4.11

----------------------------------------------------------------
Corentin Labbe (1):
      tpm/st33zp24: Remove unneeded linux/miscdevice.h include

Geliang Tang (1):
      tpm/tpm_tis_spi: drop duplicate header module.h

Jason Gunthorpe (1):
      tpm: Do not print an error message when doing TPM auto startup

Jiandi An (1):
      tpm, tpm_crb: Handle 64-bit resource in crb_check_resource()

Maciej S. Szmigiero (1):
      tpm_tis: use default timeout value if chip reports it as zero

Stefan Berger (1):
      tpm: Check size of response before accessing data

Winkler, Tomas (4):
      tpm: add kdoc for tpm_transmit and tpm_transmit_cmd
      tpm/tpm2-chip: fix kdoc errors
      tmp: use pdev for parent device in tpm_chip_alloc
      tpm/vtpm: fix kdoc warnings

 drivers/char/tpm/st33zp24/st33zp24.c |   1 -
 drivers/char/tpm/tpm-chip.c          |   8 +-
 drivers/char/tpm/tpm-interface.c     | 159 ++++++++++++++++++++++----------
 drivers/char/tpm/tpm-sysfs.c         |  28 ++++--
 drivers/char/tpm/tpm.h               |   7 +-
 drivers/char/tpm/tpm2-cmd.c          | 170 +++++++++++++++++++++--------------
 drivers/char/tpm/tpm_crb.c           |   8 +-
 drivers/char/tpm/tpm_ibmvtpm.c       | 106 +++++++++++-----------
 drivers/char/tpm/tpm_tis.c           |   2 +-
 drivers/char/tpm/tpm_tis_core.c      |   9 +-
 drivers/char/tpm/tpm_tis_core.h      |   2 +-
 drivers/char/tpm/tpm_tis_spi.c       |   1 -
 drivers/char/tpm/tpm_vtpm_proxy.c    |  48 +++++++---
 13 files changed, 347 insertions(+), 202 deletions(-)
