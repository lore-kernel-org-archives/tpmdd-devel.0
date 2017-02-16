From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/7] in-kernel resource manager
Date: Thu, 16 Feb 2017 21:25:13 +0200
Message-ID: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, James.Bottomley@HansenPartnership.com, dhowells@redhat.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set adds support for TPM spaces that provide an isolated
execution context for transient objects and HMAC and policy sessions. A
space is swapped into TPM volatile memory only when it is used and
swapped out after the use.

There's a test script for trying out TPM spaces in

  git://git.infradead.org/users/jjs/tpm2-scripts.git

A simple smoke test suite can be run by

  sudo python -m unittest -v tpm2_smoke.SpaceTest   

v2:
* Substitute virtual handle in ContextSave.
* Substitute virtual handles in GetCapability.
* Validate that the real response length and the one reported in the
  header match in tpm_transmit().

James Bottomley (3):
  tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
  tpm: expose spaces via a device link /dev/tpms<n>
  tpm2: add session handle context saving and restoring to the space
    code

Jarkko Sakkinen (4):
  tpm: move length validation to tpm_transmit()
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: infrastructure for TPM spaces

 drivers/char/tpm/Makefile         |   3 +-
 drivers/char/tpm/tpm-chip.c       |  86 +++++-
 drivers/char/tpm/tpm-dev-common.c | 148 +++++++++++
 drivers/char/tpm/tpm-dev.c        | 143 +---------
 drivers/char/tpm/tpm-dev.h        |  27 ++
 drivers/char/tpm/tpm-interface.c  | 131 +++++++---
 drivers/char/tpm/tpm-sysfs.c      |   2 +-
 drivers/char/tpm/tpm.h            |  49 +++-
 drivers/char/tpm/tpm2-cmd.c       | 168 ++++++++----
 drivers/char/tpm/tpm2-space.c     | 532 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpms-dev.c       |  65 +++++
 11 files changed, 1135 insertions(+), 219 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 drivers/char/tpm/tpms-dev.c

-- 
2.9.3

