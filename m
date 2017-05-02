From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 0/3] tpm_pcr_extend() code split
Date: Tue, 2 May 2017 14:31:48 +0200
Message-ID: <20170502123151.24354-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set moves TPM 1.2 specific code to a new function called
tpm1_pcr_extend(). The purpose of splitting is to isolate TPM 2.0 code,
so that it can be more easily modified to handle multiple digests.

With TPM 2.0, a Platform Configuration Register (PCR) could have multiple
values, stored in locations called banks. Each bank stores the values
of PCRs extended with the same hash algorithm.

Currently, the TPM kernel driver does not take advantage of stronger
algorithms because PCRs are always extended with a SHA1 digest, padded
with zeros to match the length of the input for the hash algorithm
being used. Shortly after these patches, a new patch set will be provided
to allow callers of tpm_pcr_extend() to pass a digest for each algorithm
supported by the TPM.

In this patch set, TPM 1.2 specific code will prepare the command buffer
with tpm_buf_init() which, in respect to the previous method, offers
protection against buffer overflow. Moreover, CPU native to big-endian
conversion has been removed from tags and ordinals definition, as it is
already done by tpm_buf_init().

Roberto Sassu (3):
  tpm: use CPU native value for TPM_TAG_RQU_COMMAND
  tpm: move ordinals definition to include/linux/tpm_command.h
  tpm: move TPM 1.2 code of tpm_pcr_extend() to tpm1_pcr_extend()

 drivers/char/tpm/tpm-interface.c | 76 +++++++++++++++++++---------------------
 drivers/char/tpm/tpm-sysfs.c     |  6 ++--
 drivers/char/tpm/tpm.h           |  2 --
 include/linux/tpm_command.h      |  7 ++++
 4 files changed, 46 insertions(+), 45 deletions(-)

-- 
2.9.3
