From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v9 0/4] Multi-instance vTPM proxy driver
Date: Tue, 29 Mar 2016 14:19:10 -0400
Message-ID: <1459275554-12915-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The following series of patches implements a multi-instance vTPM 
proxy driver that can dynamically create TPM 'server' and client device
pairs.

Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
and a server side file descriptor is created. The file descriptor must
be passed to a TPM emulator. The device driver will initialize the
emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
the command durations from the device in case of a TPM 1.2. The choice
of emulated TPM device (1.2 or 2) must be provided with a flag in
the ioctl.

The patches are based on a recent checkout of Jarkko's tree (master branch).

   Stefan

v8->v9:
 - move constant from public header into tpm_vtpm_proxy.c
 - Replaced VTPM_PROXY_MAGIC in ioctl definition with its value (0xa1)
 - Check for the STATE_OPEN_FLAG in wait_event_interruptable and after
   returning from it

v7->v8:
 - minor tweaks on the documentation
 - Reordered function calls in the VTPM proxy driver's server side release
   function so that a client holding the 'ops' lock releases it before the
   driver tries to grab the lock when unregistering the device.

v6->v7:
 - Adjusted name of driver to tpm_vtpm_proxy from tpm_vtpm. Adjust function
   names, names of structures, and names of constants.
 - Adjusted IOCTL to use magic 0xa1 rather than the completely used 0xa0.
 - Extended driver documentation and added documentation of ioctl.
 - Moved test program to own project (dropped patch 11).

v5->v6:
 - Adapted errno's for unsupported flags and ioctls following Jason's
   comments

v4->v5:
 - Introduced different error codes for unsupported flags and ioctls
 - Added documentation patch


Stefan Berger (4):
  tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
  tpm: Proxy driver for supporting multiple emulated TPMs
  tpm: Initialize TPM and get durations and timeouts
  tpm: Add documentation for the tpm_vtpm device driver

 Documentation/ioctl/ioctl-number.txt |   1 +
 Documentation/tpm/tpm_vtpm_proxy.txt |  71 ++++
 drivers/char/tpm/Kconfig             |  10 +
 drivers/char/tpm/Makefile            |   1 +
 drivers/char/tpm/tpm-chip.c          |   9 +-
 drivers/char/tpm/tpm-sysfs.c         |  15 +-
 drivers/char/tpm/tpm.h               |   5 +-
 drivers/char/tpm/tpm_vtpm_proxy.c    | 650 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/vtpm_proxy.h      |  36 ++
 10 files changed, 789 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/tpm/tpm_vtpm_proxy.txt
 create mode 100644 drivers/char/tpm/tpm_vtpm_proxy.c
 create mode 100644 include/uapi/linux/vtpm_proxy.h

-- 
2.4.3
