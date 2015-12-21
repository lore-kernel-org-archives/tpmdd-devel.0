From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd updates for Linux 4.5
Date: Mon, 21 Dec 2015 10:42:58 +0200
Message-ID: <20151221084258.GA3101@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

Here are tpmdd updates for Linux 4.5. Sorry I didn't send this already
last week but I had to hold until I get ack from Peter and Mimi before
doing anything. Patches are quite well baked for a while now with the
exception of small fix from Stefan to tpm_ibmvtpm, which I considered
trivial enough to be included.

Thanks, hope I did this right and apologies for the delay.

/Jarkko

The following changes since commit ebd68df3f24b318d391d15c458d6f43f340ba36a:

  Sync to Linus v4.4-rc2 for LSM developers. (2015-11-23 22:46:28 +1100)

are available in the git repository at:

  https://github.com/jsakkine/linux-tpmdd.git tags/tpmdd-next-20151221

for you to fetch changes up to 5beb0c435bdde35a09376566b0e28f7df87c9f68:

  keys, trusted: seal with a TPM2 authorization policy (2015-12-20 15:27:13 +0200)

----------------------------------------------------------------
tpmdd updates for Linux 4.5

----------------------------------------------------------------
Jarkko Sakkinen (3):
      keys, trusted: fix: *do not* allow duplicate key options
      keys, trusted: select hash algorithm for TPM2 chips
      keys, trusted: seal with a TPM2 authorization policy

Jason Gunthorpe (6):
      tpm_tis: Use devm_free_irq not free_irq
      tpm_tis: Ensure interrupts are disabled when the driver starts
      tpm: rework tpm_get_timeouts()
      tpm_tis: Get rid of the duplicate IRQ probing code
      tpm_tis: Refactor the interrupt setup
      tpm_tis: Tighten IRQ auto-probing

Martin Wilck (1):
      tpm_tis: further simplify calculation of ordinal duration

Stefan Berger (1):
      tpm_ibmvtpm: properly handle interrupted packet receptions

 Documentation/security/keys-trusted-encrypted.txt |  31 ++-
 crypto/hash_info.c                                |   2 +
 drivers/char/tpm/tpm-interface.c                  |  23 +-
 drivers/char/tpm/tpm.h                            |  11 +-
 drivers/char/tpm/tpm2-cmd.c                       |  60 ++++-
 drivers/char/tpm/tpm_crb.c                        |  14 +-
 drivers/char/tpm/tpm_ibmvtpm.c                    |  22 +-
 drivers/char/tpm/tpm_ibmvtpm.h                    |   1 +
 drivers/char/tpm/tpm_tis.c                        | 256 +++++++++-------------
 include/crypto/hash_info.h                        |   3 +
 include/keys/trusted-type.h                       |   5 +
 include/uapi/linux/hash_info.h                    |   1 +
 security/keys/Kconfig                             |   1 +
 security/keys/trusted.c                           |  56 ++++-
 14 files changed, 300 insertions(+), 186 deletions(-)
