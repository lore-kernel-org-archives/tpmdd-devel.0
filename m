From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v6 0/3] Extend the vTPM proxy driver to pass locality
Date: Wed, 24 May 2017 17:39:38 -0400
Message-ID: <1495661981-27249-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: jarkko.sakkinen@linux.intel.com, tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The purpose of this series of patches is to enable the passing of the locality
a command is executing in to a recipient, i.e., TPM emulator. To enable this we
introduce vendor-specific TPM commands for TPM 1.2 and TPM 2 that the driver
sends to the TPM emulator.

v5->v6:
  - Added patch 3/3.

v4->v5:
  - introduce TPM_TRANSMIT_RAW to be able to call tpm_transmit without
    recursing into requesting the locality.

v3->v4:
  - addressed Jarkko's comments: largely a rewrite of the patches

v2->v3:
  - addressed Jarkko's comments

v1->v2:
  - fixed return value from function in patch 3/3


Stefan Berger (3):
  tpm: Introduce flag TPM_TRANSMIT_RAW
  tpm: vtpm_proxy: Implement request_locality function.
  tpm: vtpm_proxy: Prevent userspace from sending driver command

 drivers/char/tpm/tpm-interface.c  |  4 ++-
 drivers/char/tpm/tpm.h            |  1 +
 drivers/char/tpm/tpm_vtpm_proxy.c | 69 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   |  4 +++
 4 files changed, 77 insertions(+), 1 deletion(-)

-- 
2.4.3

