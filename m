From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 00/11] Multi-instance vTPM driver
Date: Fri, 19 Feb 2016 07:41:57 -0500
Message-ID: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The following series of patches implements a multi-instance vTPM driver
that can dynamically create TPM 'server' and client device pairs.

Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
and a server side file descriptor is created. The file descriptor must
be passed to a TPM emulator. The device driver will initialize the
emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
the command durations from the device in case of a TPM 1.2. The choice
of emulated TPM device (1.2 or 2) must be provided with a flag in
the ioctl.

The driver is based on Linux 4.4 and uses several recently posted patches
from Jason and Jarkko. I may have adapted them to fit on top of Linux 4.4.

   Stefan


Jarkko Sakkinen (1):
  tpm: fix the cleanup of struct tpm_chip

Jason Gunthorpe (4):
  tpm: Get rid of chip->pdev
  tpm: Get rid of devname
  tpm: Provide strong locking for device removal
  tpm: Split out the devm stuff from tpmm_chip_alloc

Stefan Berger (6):
  tpm: Get rid of module locking
  tpm: Replace device number bitmap with IDR
  tpm: Introduce TPM_CHIP_FLAG_VIRTUAL
  tpm: Driver for supporting multiple emulated TPMs
  tpm: Initialize TPM and get durations and timeouts
  A test program for vTPM device creation

 drivers/char/tpm/Kconfig            |  10 +
 drivers/char/tpm/Makefile           |   1 +
 drivers/char/tpm/tpm-chip.c         | 217 +++++++++----
 drivers/char/tpm/tpm-dev.c          |  15 +-
 drivers/char/tpm/tpm-interface.c    |  49 +--
 drivers/char/tpm/tpm-sysfs.c        |  20 +-
 drivers/char/tpm/tpm-vtpm.c         | 610 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm.h              |  30 +-
 drivers/char/tpm/tpm2-cmd.c         |   8 +-
 drivers/char/tpm/tpm_atmel.c        |  14 +-
 drivers/char/tpm/tpm_eventlog.c     |   2 +-
 drivers/char/tpm/tpm_eventlog.h     |   2 +-
 drivers/char/tpm/tpm_i2c_atmel.c    |  16 +-
 drivers/char/tpm/tpm_i2c_infineon.c |   6 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  24 +-
 drivers/char/tpm/tpm_infineon.c     |  22 +-
 drivers/char/tpm/tpm_nsc.c          |  20 +-
 drivers/char/tpm/tpm_tis.c          |  18 +-
 include/uapi/linux/Kbuild           |   1 +
 include/uapi/linux/vtpm.h           |  38 +++
 vtpmctrl.c                          | 163 ++++++++++
 21 files changed, 1111 insertions(+), 175 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-vtpm.c
 create mode 100644 include/uapi/linux/vtpm.h
 create mode 100644 vtpmctrl.c

-- 
2.4.3


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
