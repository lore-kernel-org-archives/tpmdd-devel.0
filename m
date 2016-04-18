From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH v11 0/4] Multi-instance vTPM proxy driver
Date: Mon, 18 Apr 2016 13:26:12 -0400
Message-ID: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
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

The patches are based on the tip of a recent checkout of Jarkko's tree
(master branch).

   Stefan

v10->v11:
 - patch 3: merge of v10 patches 3 and 4
 - patch 3: removed unnecessary NULL pointer checks
 - Added Jason's Reviewed-by's

v9->v10:
 - add new patch 1 with sysfs related rework; reworked patch 2 as a consequence
 - patch 3: fixed ioctl from using _IOW to using _IOWR (reinstall headers
   and rebuild test tools)
 - patch 3: do not use priv field anymore but uses dev_set_drvdata /
   dev_get_drvdata instead now

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


Jason Gunthorpe (1):
  tpm: Remove all uses of drvdata from the TPM Core

Stefan Berger (3):
  tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
  tpm: Proxy driver for supporting multiple emulated TPMs
  tpm: Add documentation for the tpm_vtpm_proxy device driver

 Documentation/ioctl/ioctl-number.txt |   1 +
 Documentation/tpm/tpm_vtpm_proxy.txt |  71 ++++
 drivers/char/tpm/Kconfig             |  10 +
 drivers/char/tpm/Makefile            |   1 +
 drivers/char/tpm/tpm-chip.c          |  76 +++--
 drivers/char/tpm/tpm-interface.c     |   7 +-
 drivers/char/tpm/tpm-sysfs.c         |  61 ++--
 drivers/char/tpm/tpm.h               |  11 +-
 drivers/char/tpm/tpm_vtpm_proxy.c    | 644 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/Kbuild            |   1 +
 include/uapi/linux/vtpm_proxy.h      |  36 ++
 11 files changed, 852 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/tpm/tpm_vtpm_proxy.txt
 create mode 100644 drivers/char/tpm/tpm_vtpm_proxy.c
 create mode 100644 include/uapi/linux/vtpm_proxy.h

-- 
2.4.3

