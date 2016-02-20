From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] remaining tpmdd fixes for Linux 4.5
Date: Sat, 20 Feb 2016 10:17:05 +0200
Message-ID: <20160220081705.GA12981@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi James,

I'm sorry for the late pull request for 4.5. The reason for this was
the latency in my previous one. I picked with care the absolutely
critical fixes so that we can make a sound tpmdd release.

I really hope you can still pick these as one of them is absolutely
critical to get authorization policy sealing API right (kernel keeps
it finger out of user space created objects).

BR,
/Jarkko

The following changes since commit 8e0ee3c9faed7ca68807ea45141775856c438ac0:

  tpm: fix the cleanup of struct tpm_chip (2016-02-10 04:12:08 +0200)

are available in the git repository at:

  https://github.com/jsakkine/linux-tpmdd.git tags/tpmdd-next-20160220

for you to fetch changes up to 99cda8cb4639de81cde785b5bab9bc52e916e594:

  tpm_crb: tpm2_shutdown() must be called before tpm_chip_unregister() (2016-02-20 09:59:33 +0200)

----------------------------------------------------------------
remaining tpmdd fixes for Linux 4.5

----------------------------------------------------------------
Harald Hoyer (1):
      tpm_eventlog.c: fix binary_bios_measurements

Jarkko Sakkinen (4):
      tpm: fix: set continueSession attribute for the unseal operation
      tpm: fix: return rc when devm_add_action() fails
      tpm_crb/tis: fix: use dev_name() for /proc/iomem
      tpm_crb: tpm2_shutdown() must be called before tpm_chip_unregister()

 drivers/char/tpm/tpm-chip.c     |  7 ++++++-
 drivers/char/tpm/tpm2-cmd.c     | 10 +++++++---
 drivers/char/tpm/tpm_crb.c      |  8 +++++---
 drivers/char/tpm/tpm_eventlog.c | 14 ++++++++++----
 drivers/char/tpm/tpm_tis.c      |  4 +++-
 5 files changed, 31 insertions(+), 12 deletions(-)
