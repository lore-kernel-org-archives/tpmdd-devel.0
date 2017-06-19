From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [GIT PULL] tpmdd fixes for 4.13
Date: Mon, 19 Jun 2017 02:58:45 +0200
Message-ID: <1497833925.14670.3.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hi

Here are thpdates for 4.13.

Major changes:

- Releasing and relinquishing of locality in tpm_vtpm_proxy for each
  command/response sequence.
- Consolidating platform and ACPI driver in tpm_tis.
- Sanitize endian conversions for TPM 1.2 commands i.e. call
  cpu_to_be32() in place when required. Do not have it in the constant
  definition.

BR,
/Jarkko

The following changes since commit
33f2eadabba59cf1c763c46c4470279ec2054099:

  apparmor: export that basic profile namespaces are supported (2017-
06-10 17:11:48 -0700)

are available in the git repository at:

  git://git.infradead.org/users/jjs/linux-tpmdd.git tags/tpmdd-next-
20170619

for you to fetch changes up to
e4b0852798bc15ed1a3ed6768ef2c4d2a1cb7599:

  tpm/tpm_atmel: remove unnecessary NULL check (2017-06-19 02:36:04
+0200)

----------------------------------------------------------------
tpmdd updates for Linux 4.13

----------------------------------------------------------------
Andy Shevchenko (1):
      tpm/st33zp24: Switch to devm_acpi_dev_add_driver_gpios()

Bryan Freed (1):
      tpm: Apply a sane minimum adapterlimit value for retransmission.

Gustavo A. R. Silva (1):
      tpm/tpm_atmel: remove unnecessary NULL check

Jarkko Sakkinen (3):
      tpm: fix byte order related arithmetic inconsistency in
tpm_getcap()
      tpm, tpm_infineon: remove useless snprintf() calls
      tpm: remove struct tpm_pcrextend_in

Jason Gunthorpe (3):
      tpm_tis: Fix IRQ autoprobing when using platform_device
      tpm_tis: Use platform_get_irq
      tpm_tis: Consolidate the platform and acpi probe flow

Peter Huewe (1):
      tpm, tpmrm: Mark tpmrm_write as static

Roberto Sassu (3):
      tpm: move endianness conversion of TPM_TAG_RQU_COMMAND to
tpm_input_header
      tpm: move endianness conversion of ordinals to tpm_input_header
      tpm: move TPM 1.2 code of tpm_pcr_extend() to tpm1_pcr_extend()

Stefan Berger (4):
      tpm: vtpm_proxy: Suppress error logging when in closed state
      tpm: Introduce flag TPM_TRANSMIT_RAW
      tpm: vtpm_proxy: Implement request_locality function.
      tpm: vtpm_proxy: Prevent userspace from sending driver command

 drivers/char/tpm/st33zp24/i2c.c     |   3 +-
 drivers/char/tpm/st33zp24/spi.c     |   3 +-
 drivers/char/tpm/tpm-interface.c    | 118 +++++++++++++-----------
 drivers/char/tpm/tpm-sysfs.c        |   6 +-
 drivers/char/tpm/tpm.h              |  22 +----
 drivers/char/tpm/tpm2-cmd.c         |   2 +-
 drivers/char/tpm/tpm_atmel.c        |  12 ++-
 drivers/char/tpm/tpm_i2c_infineon.c |  76 +++++++++++-----
 drivers/char/tpm/tpm_infineon.c     |   8 +-
 drivers/char/tpm/tpm_tis.c          | 175 ++++++++++++--------------
----------
 drivers/char/tpm/tpm_vtpm_proxy.c   |  69 ++++++++++++++
 drivers/char/tpm/tpmrm-dev.c        |   2 +-
 include/uapi/linux/vtpm_proxy.h     |   4 +
 13 files changed, 269 insertions(+), 231 deletions(-)
