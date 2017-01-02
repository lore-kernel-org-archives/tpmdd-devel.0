From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Mon,  2 Jan 2017 15:22:06 +0200
Message-ID: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set adds support for TPM spaces that provide a context
for isolating and swapping transient objects. This patch set does
not yet include support for isolating policy and HMAC sessions but
it is trivial to add once the basic approach is settled (and that's
why I created an RFC patch set).

There's a test script for trying out TPM spaces in

  git://git.infradead.org/users/jjs/tpm2-scripts.git

A simple smoke test can be run by

  sudo python -m unittest -v tpm2_smoke.SpaceTest   

Jarkko Sakkinen (4):
  tpm: migrate struct tpm_buf to struct tpm_chip
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: add the infrastructure for TPM space for TPM 2.0

 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      |  15 ++
 drivers/char/tpm/tpm-dev.c       |  80 ++++++++++-
 drivers/char/tpm/tpm-interface.c |  93 +++++++++----
 drivers/char/tpm/tpm-sysfs.c     |   2 +-
 drivers/char/tpm/tpm.h           | 106 ++++++++------
 drivers/char/tpm/tpm2-cmd.c      | 232 ++++++++++++++++---------------
 drivers/char/tpm/tpm2-space.c    | 288 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tpm.h         |  23 ++++
 9 files changed, 662 insertions(+), 179 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 include/uapi/linux/tpm.h

-- 
2.9.3

