From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v3 0/3]  Extend the vTPM proxy driver to pass locality
Date: Thu,  4 May 2017 10:56:24 -0400
Message-ID: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com
Cc: jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The purpose of this series of patches is to enable the passing of the locality
a command is executing in to a recipeint, i.e., TPM emulator. To enable this we
introduce a new flag for the device creation ioctl that requests that the
locality be prepended to every command. For applications to check which flags
the driver supports, we add a new ioctl that returns a bitmask of supported flags.

v2->v3:
  - addressed Jarkko's comments

v1->v2:
  - fixed return value from function in patch 3/3

Stefan Berger (3):
  tpm: vtpm_proxy: Implement new ioctl to get supported flags
  tpm: vtpm_proxy: Implement request_locality function.
  tpm: vtpm_proxy: Add flag for ioctl to request locality prepended to
    command

 drivers/char/tpm/tpm_vtpm_proxy.c | 53 ++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/vtpm_proxy.h   | 17 +++++++++++--
 2 files changed, 64 insertions(+), 6 deletions(-)

-- 
2.4.3
