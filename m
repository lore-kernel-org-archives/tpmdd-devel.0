From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd updates for Linux 4.10
Date: Mon, 28 Nov 2016 01:40:30 +0200
Message-ID: <20161127234030.zhupzkizruv36o5n@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi James,

This pull request contains tpmdd updates for Linux 4.10. This release
contains two major changes: power gating support tpm_crb and precursory
cleanup work for the event log so that in a future release we will be
able to add event log for TPM 2.0.

/Jarkko

The following changes since commit 0821e30cd2f246a93c5271f6c23d7134f809d70d:

  Merge branch 'stable-4.10' of git://git.infradead.org/users/pcmoore/selinux into next (2016-11-24 11:21:25 +1100)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20161128

for you to fetch changes up to 9430066a15d6f55a3d008a6f99bb462480870207:

  tpm: adjust return value of tpm_read_log (2016-11-28 01:31:33 +0200)

----------------------------------------------------------------
tpmdd updates for Linux 4.10

----------------------------------------------------------------
Baruch Siach (1):
      char: tpm: fix kerneldoc tpm2_unseal_trusted name typo

Colin Ian King (1):
      tpm: return -ENODEV if np is not set

Ed Swierk (1):
      tpm: Clean up reading of timeout and duration capabilities

Jarkko Sakkinen (4):
      tpm: sanitize constant expressions
      tpm, tpm_vtpm_proxy: add kdoc comments for VTPM_PROXY_IOC_NEW_DEV
      tpm: replace dynamically allocated bios_dir with a static array
      tpm: drop tpm1_chip_register(/unregister)

Jason Gunthorpe (7):
      tpm tis: Do not print timeout messages twice
      tpm xen: Remove bogus tpm_chip_unregister
      tpm: Get rid of TPM_CHIP_FLAG_REGISTERED
      tpm_tis: Allow tpm_tis to be bound using DT
      tpm: Fix handling of missing event log
      tpm: vtpm_proxy: conditionally call tpm_chip_unregister
      tpm: adjust return value of tpm_read_log

Josh Zimmerman (1):
      tpm_tis: Check return values from get_burstcount.

Nayna Jain (9):
      Documentation: tpm: add the IBM Virtual TPM device tree binding documentation
      Documentation: tpm: add the Physical TPM device tree binding documentation
      tpm: define a generic open() method for ascii & bios measurements
      tpm: replace symbolic permission with octal for securityfs files
      tpm: have event log use the tpm_chip
      tpm: fix the missing .owner in tpm_bios_measurements_ops
      tpm: redefine read_log() to handle ACPI/OF at runtime
      tpm: replace of_find_node_by_name() with dev of_node property
      tpm: cleanup of printk error messages

Peter Huewe (1):
      char/tpm: Check return code of wait_for_tpm_stat

Stefan Berger (2):
      tpm: Only call pm_runtime_get_sync if device has a parent
      tpm: Check the bios_dir entry for NULL before accessing it

Winkler, Tomas (5):
      tpm/tpm_crb: implement tpm crb idle state
      tmp/tpm_crb: fix Intel PTT hw bug during idle state
      tpm/tpm_crb: open code the crb_init into acpi_add
      tmp/tpm_crb: implement runtime pm for tpm_crb
      tpm: place kdoc just above tpm_pcr_extend

 .../devicetree/bindings/security/tpm/ibmvtpm.txt   |  41 ++++
 .../devicetree/bindings/security/tpm/tpm-i2c.txt   |  21 ++
 .../bindings/security/tpm/tpm_tis_mmio.txt         |  25 +++
 drivers/char/tpm/Kconfig                           |   2 +-
 drivers/char/tpm/Makefile                          |  14 +-
 drivers/char/tpm/tpm-chip.c                        |  38 +---
 drivers/char/tpm/tpm-interface.c                   | 110 +++++-----
 drivers/char/tpm/tpm-sysfs.c                       |   7 +-
 drivers/char/tpm/tpm.h                             |  41 ++--
 drivers/char/tpm/tpm2-cmd.c                        |   2 +-
 drivers/char/tpm/tpm_acpi.c                        |  46 ++---
 drivers/char/tpm/tpm_crb.c                         | 173 +++++++++++++---
 drivers/char/tpm/tpm_eventlog.c                    | 230 +++++++++++----------
 drivers/char/tpm/tpm_eventlog.h                    |  22 +-
 drivers/char/tpm/tpm_of.c                          |  48 ++---
 drivers/char/tpm/tpm_tis.c                         |  11 +
 drivers/char/tpm/tpm_tis_core.c                    |  64 ++++--
 drivers/char/tpm/tpm_vtpm_proxy.c                  |  85 +++++---
 drivers/char/tpm/xen-tpmfront.c                    |   1 -
 include/uapi/linux/vtpm_proxy.h                    |  23 ++-
 20 files changed, 624 insertions(+), 380 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/security/tpm/ibmvtpm.txt
 create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
 create mode 100644 Documentation/devicetree/bindings/security/tpm/tpm_tis_mmio.txt
