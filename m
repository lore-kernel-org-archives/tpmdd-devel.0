From: Josh Zimmerman <joshz@google.com>
Subject: [PATCH v1 0/2] Run TPM2_Shutdown on system shutdown
Date: Wed, 12 Jul 2017 17:41:19 -0700
Message-ID: <20170713004121.21750-1-joshz@google.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, gregkh@linuxfoundation.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

This patchset causes all devices in the tpm class to issue TPM2_Shutdown
when the system is shutting down.

As a prerequisite, it adds a "shutdown" method to "struct class".

Backporting to 4.9 since this bug can lock users out of their TPMs.

Backport of f77af1516584 'Add "shutdown" to "struct class".' and
d1bd4a792d39 'tpm: Issue a TPM2_Shutdown for TPM2 devices.'

 drivers/base/core.c          |  6 +++++-
 drivers/char/tpm/tpm-chip.c  | 36 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-sysfs.c |  5 +++++
 include/linux/device.h       |  2 ++
 4 files changed, 48 insertions(+), 1 deletion(-)
