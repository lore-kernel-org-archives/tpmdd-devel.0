From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd updates for 4.12
Date: Tue, 4 Apr 2017 18:38:26 +0300
Message-ID: <20170404153826.hxzphlvzqcesg7rt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi James,

Here is the pull request for 4.12.

Major new features have been landed:

1. TPM resource manager. There's a new device called /dev/tpmrm0. When this
device is opened, a new session is created that is isolated from other users.
Each user has its own set of volatile objects. There is also a new internal
structure called struct tpm_space. This structure can be passed to tpm_transmit
function and have own session to interact with the TPM. This could be
potentially utilized by other kernel subsystems in the future.
2. ARM64 for support for tpm_crb.
3. Support for requesting and relinquishing locality 0 in tpm_crb. TXT uses
locality 2 so we cannot assume that locality 0 is readily reserved when used
in combination with TXT.
4. Comprehensive overhaul to tpm_tis_spi by Peter Huewe.

/Jarkko

The following changes since commit ddb99e118e37f324a4be65a411bb60ae62795cf9:

  security, keys: convert key_user.usage from atomic_t to refcount_t (2017-04-03 10:49:06 +1000)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170404

for you to fetch changes up to 08eff49d63ca2bf4cd98c4bdc07dc9d07d52f8f5:

  tpm/tpm_crb: Enable TPM CRB interface for ARM64 (2017-04-03 22:46:03 +0300)

----------------------------------------------------------------
tpmdd updates for Linux 4.12

----------------------------------------------------------------
Alexander Steffen (1):
      tpm_tis_core: Choose appropriate timeout for reading burstcount

Andy Shevchenko (1):
      tpm/st33zp24: Add GPIO ACPI mapping table

Arnd Bergmann (1):
      tpm: select CONFIG_CRYPTO

Hon Ching \(Vicky\) Lo (1):
      vTPM: Fix missing NULL check

James Bottomley (3):
      tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
      tpm: expose spaces via a device link /dev/tpmrm<n>
      tpm2: add session handle context saving and restoring to the space code

Jarkko Sakkinen (7):
      tpm_crb: map locality registers
      tpm_crb: encapsulate crb_wait_for_reg_32
      tpm: move length validation to tpm_transmit()
      tpm: export tpm2_flush_context_cmd
      tpm: validate TPM 2.0 commands
      tpm: infrastructure for TPM spaces
      tpm_crb: request and relinquish locality 0

Jason Gunthorpe (1):
      tpm crb: Work around BIOS's that report the wrong ACPI region size

Jerry Snitselaar (2):
      tpm_crb: check for bad response size
      tpm: make check_locality return bool

Jiandi An (2):
      ACPICA: Update TPM2 ACPI table
      tpm/tpm_crb: Enable TPM CRB interface for ARM64

Jérémy Lefaure (1):
      tpm/tpm_crb: fix unused warnings on suspend/resume functions

Nayna Jain (2):
      tpm: msleep() delays - replace with usleep_range() in i2c nuvoton driver
      tpm: add sleep only for retry in i2c_nuvoton_write_status()

Peter Huewe (5):
      tpm_tis_spi: Use single function to transfer data
      tpm_tis_spi: Abort transfer when too many wait states are signaled
      tpm_tis_spi: Check correct byte for wait state indicator
      tpm_tis_spi: Remove limitation of transfers to MAX_SPI_FRAMESIZE bytes
      tpm_tis_spi: Add small delay after last transfer

Winkler, Tomas (1):
      tpm/tpm_crb: enter the low power state upon device suspend

 drivers/char/tpm/Kconfig             |   3 +-
 drivers/char/tpm/Makefile            |   3 +-
 drivers/char/tpm/st33zp24/i2c.c      |  23 +-
 drivers/char/tpm/st33zp24/spi.c      |  23 +-
 drivers/char/tpm/st33zp24/st33zp24.c |  12 +-
 drivers/char/tpm/tpm-chip.c          |  70 ++++-
 drivers/char/tpm/tpm-dev-common.c    | 148 ++++++++++
 drivers/char/tpm/tpm-dev.c           | 143 +---------
 drivers/char/tpm/tpm-dev.h           |  27 ++
 drivers/char/tpm/tpm-interface.c     | 152 +++++++---
 drivers/char/tpm/tpm-sysfs.c         |   2 +-
 drivers/char/tpm/tpm.h               |  52 +++-
 drivers/char/tpm/tpm2-cmd.c          | 173 ++++++++----
 drivers/char/tpm/tpm2-space.c        | 528 +++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_crb.c           | 280 +++++++++++++++----
 drivers/char/tpm/tpm_i2c_infineon.c  |  12 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c   |  24 +-
 drivers/char/tpm/tpm_ibmvtpm.c       |   8 +-
 drivers/char/tpm/tpm_tis_core.c      |  26 +-
 drivers/char/tpm/tpm_tis_spi.c       | 160 +++++------
 drivers/char/tpm/tpmrm-dev.c         |  65 +++++
 include/acpi/actbl2.h                |   3 +
 include/linux/tpm.h                  |   3 +-
 23 files changed, 1536 insertions(+), 404 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 drivers/char/tpm/tpmrm-dev.c
