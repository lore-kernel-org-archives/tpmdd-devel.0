From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC v3 0/5] RFC: in-kernel resource manager
Date: Mon, 16 Jan 2017 15:12:06 +0200
Message-ID: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
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

v2:
Changed to James' proposal of API. I did not make any other changes
except split core TPM space code its own patch because I want to find
consensus on the API before polishing the corners. Thus, this version
also carries the RFC tag. I have not yet locked in my standpoint whether
ioctl or a device file is a better deal.

v3:
- Check TPM return code in tpm_map_response.
- Reference tracking for /dev/tpms0.
- clear_bit(is_open) was removed from tpm-dev.c. Added it back.
- Use response length as the buffer size limit in tpm2_commit_space.
- This version now passes again my smoke tests.

James Bottomley (2):
  tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
  tpm2: expose resource manager via a device link /dev/tpms<n>

Jarkko Sakkinen (3):
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: infrastructure for TPM spaces

 drivers/char/tpm/Makefile         |   2 +-
 drivers/char/tpm/tpm-chip.c       |  79 +++++++++-
 drivers/char/tpm/tpm-dev-common.c | 145 ++++++++++++++++++
 drivers/char/tpm/tpm-dev.c        | 140 ++---------------
 drivers/char/tpm/tpm-dev.h        |  27 ++++
 drivers/char/tpm/tpm-interface.c  | 100 +++++++++----
 drivers/char/tpm/tpm-sysfs.c      |   2 +-
 drivers/char/tpm/tpm.h            |  56 +++++--
 drivers/char/tpm/tpm2-cmd.c       | 146 ++++++++++++------
 drivers/char/tpm/tpm2-space.c     | 305 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpms-dev.c       |  62 ++++++++
 11 files changed, 852 insertions(+), 212 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 drivers/char/tpm/tpms-dev.c

-- 
2.9.3

