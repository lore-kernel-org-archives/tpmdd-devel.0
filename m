From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH RFC v2 0/5] RFC: in-kernel resource manager
Date: Thu, 12 Jan 2017 19:46:03 +0200
Message-ID: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
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

This patch set adds support for TPM spaces that provide a context
for isolating and swapping transient objects. This patch set does
not yet include support for isolating policy and HMAC sessions but
it is trivial to add once the basic approach is settled (and that's
why I created an RFC patch set).

v2:
Changed to James' proposal of API. I did not make any other changes
except split core TPM space code its own patch because I want to find
consensus on the API before polishing the corners. Thus, this version
also carries the RFC tag. I have not yet locked in my standpoint whether
ioctl or a device file is a better deal.

James Bottomley (2):
  tpm: split out tpm-dev.c into tpm-dev.c and tpm-common-dev.c
  tpm2: expose resource manager via a device link /dev/tpms<n>

Jarkko Sakkinen (3):
  tpm: validate TPM 2.0 commands
  tpm: export tpm2_flush_context_cmd
  tpm: infrastructure for TPM spaces

 drivers/char/tpm/Makefile         |   2 +-
 drivers/char/tpm/tpm-chip.c       |  61 +++++++-
 drivers/char/tpm/tpm-dev-common.c | 145 +++++++++++++++++++
 drivers/char/tpm/tpm-dev.c        | 141 ++----------------
 drivers/char/tpm/tpm-dev.h        |  27 ++++
 drivers/char/tpm/tpm-interface.c  | 106 ++++++++++----
 drivers/char/tpm/tpm-sysfs.c      |   2 +-
 drivers/char/tpm/tpm.h            |  57 ++++++--
 drivers/char/tpm/tpm2-cmd.c       | 144 ++++++++++++------
 drivers/char/tpm/tpm2-space.c     | 298 ++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpms-dev.c       |  57 ++++++++
 11 files changed, 826 insertions(+), 214 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev-common.c
 create mode 100644 drivers/char/tpm/tpm-dev.h
 create mode 100644 drivers/char/tpm/tpm2-space.c
 create mode 100644 drivers/char/tpm/tpms-dev.c

-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
