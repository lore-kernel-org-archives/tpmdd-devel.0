From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd updates for Linux 4.11
Date: Fri, 3 Feb 2017 22:41:55 +0200
Message-ID: <20170203204155.wjycqoojowivn24u@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

This is the second flush of updates for 4.11. 

The pull request include two new features:

1. Extension to tpm_pcr_extend() (used by IMA) to extend all PCR banks
instead of just SHA-1 banks. It is recommended by TCG to do so in order
to prevent malicious use of PCRs.
2. TPM 2.0 event log with backend support for OF device tree.

/Jarkko

The following changes since commit 20f482ab9e0f800d1e01ce748ebd382d085abe56:

  ima: allow to check MAY_APPEND (2017-01-27 14:17:21 -0500)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-20170204

for you to fetch changes up to 70ea163699b68963e222a905e184f6436e8a290d:

  tpm: silence an array overflow warning (2017-02-03 22:33:55 +0200)

----------------------------------------------------------------
tpmdd updates for Linux 4.11

----------------------------------------------------------------
Dan Carpenter (1):
      tpm: silence an array overflow warning

Jarkko Sakkinen (2):
      tpm: remove tpm_read_index and tpm_write_index from tpm.h
      tpm: fix RC value check in tpm2_seal_trusted

Jason Gunthorpe (1):
      tpm: Begin the process to deprecate user_read_timer

Maciej S. Szmigiero (1):
      tpm_tis: fix iTPM probe via probe_itpm() function

Nayna Jain (4):
      tpm: implement TPM 2.0 capability to get active PCR banks
      tpm: enhance TPM 2.0 PCR extend to support multiple banks
      tpm: enhance read_log_of() to support Physical TPM event log
      tpm: add securityfs support for TPM 2.0 firmware event log

Stefan Berger (1):
      tpm: fix the type of owned field in cap_t

 drivers/char/tpm/Kconfig                           |   1 +
 drivers/char/tpm/Makefile                          |   2 +-
 drivers/char/tpm/tpm-dev.c                         |   5 +-
 drivers/char/tpm/tpm-interface.c                   |  14 +-
 drivers/char/tpm/tpm.h                             |  39 ++--
 .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
 drivers/char/tpm/tpm2-cmd.c                        | 170 ++++++++++++-----
 drivers/char/tpm/tpm2_eventlog.c                   | 203 +++++++++++++++++++++
 drivers/char/tpm/tpm_acpi.c                        |   3 +
 drivers/char/tpm/tpm_atmel.h                       |   6 +
 drivers/char/tpm/tpm_eventlog.h                    |  51 +++++-
 drivers/char/tpm/tpm_nsc.c                         |  12 ++
 drivers/char/tpm/tpm_of.c                          |  27 ++-
 drivers/char/tpm/tpm_tis_core.c                    |  25 +--
 14 files changed, 497 insertions(+), 96 deletions(-)
 rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
 create mode 100644 drivers/char/tpm/tpm2_eventlog.c
