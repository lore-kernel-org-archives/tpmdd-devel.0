From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/6] in-kernel resource manager
Date: Wed,  8 Feb 2017 13:07:02 +0200
Message-ID: <20170208110713.14070-1-jarkko.sakkinen@linux.intel.com>
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
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set adds support for TPM spaces that provide an isolated
for transient objects and HMAC and policy sessions. A space is swapped
into TPM volatile memory only when it is used and swapped out after
the use.

There's a test script for trying out TPM spaces in

  git://git.infradead.org/users/jjs/tpm2-scripts.git

A simple smoke test can be run by

  sudo python -m unittest -v tpm2_smoke.SpaceTest   

James Bottomley (3):
  tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
  tpm: expose spaces via a device link /dev/tpms<n>
  tpm2: add session handle context saving and restoring to the space
    code

Jarkko Sakkinen (3):
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: infrastructure for TPM spaces

 drivers/char/tpm/Makefile         |   3 +-
 drivers/char/tpm/tpm-chip.c       |  86 +++++++-
 drivers/char/tpm/tpm-dev-common.c | 148 +++++++++++++
 drivers/char/tpm/tpm-dev.c        | 143 ++----------
 drivers/char/tpm/tpm-dev.h        |  27 +++
 drivers/char/tpm/tpm-interface.c  | 114 +++++++---
 drivers/char/tpm/tpm-sysfs.c      |   2 +-
 drivers/char/tpm/tpm.h            |  48 +++-
 drivers/char/tpm/tpm2-cmd.c       | 166 ++++++++++----
 drivers/char/tpm/tpm2-space.c     | 450 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpms-dev.c       |  65 ++++++
 11 files changed, 1040 insertions(+), 212 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 drivers/char/tpm/tpms-dev.c

-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
