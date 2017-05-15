From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v5 0/2] Extend the vTPM proxy driver to pass locality
Date: Mon, 15 May 2017 12:51:43 -0400
Message-ID: <1494867105-30722-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The purpose of this series of patches is to enable the passing of the locality
a command is executing in to a recipient, i.e., TPM emulator. To enable this we
introduce vendor-specific TPM commands for TPM 1.2 and TPM 2 that the driver
sends to the TPM emulator.

v4->v5:
  - introduce TPM_TRANSMIT_RAW to be able to call tpm_transmit without
    recursing into requesting the locality.

v3->v4:
  - addressed Jarkko's comments: largely a rewrite of the patches

v2->v3:
  - addressed Jarkko's comments

v1->v2:
  - fixed return value from function in patch 3/3

Stefan Berger (2):
  tpm: Introduce flag TPM_TRANSMIT_RAW
  tpm: vtpm_proxy: Implement request_locality function.

 drivers/char/tpm/tpm-interface.c  |  4 +++-
 drivers/char/tpm/tpm.h            |  1 +
 drivers/char/tpm/tpm_vtpm_proxy.c | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vtpm_proxy.h   |  4 ++++
 4 files changed, 44 insertions(+), 1 deletion(-)

-- 
2.4.3

