From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 0/3] tpm/tpm_crb: Enable TPM CRB interface for
	ARM64
Date: Fri, 10 Mar 2017 03:58:06 -0600
Message-ID: <1489139889-14376-1-git-send-email-anjiandi@codeaurora.org>
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
Cc: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

TCG ACPI Specification Family "1.2" and "2.0" Version 1.2
Revision 8 introduces a new start method (type 11) for ARM64,
along with platform specific paramters for this new start
method.  This new start method invokes a Secure Monitor Call
to request the firmware to execute or cancel a TPM 2.0 command.
These 3 patches enables TPM CRB driver for ARM64 and implements
the new start method for ARM64 in the TPM CRB driver.

Jiandi An (3):
  ACPICA: Update TPM2 ACPI table
  tpm: Add start method for ARM Secure Monitor Call
  tpm/tpm_crb: Enable TPM CRB interface for ARM64

 drivers/char/tpm/Kconfig   |  2 +-
 drivers/char/tpm/tpm.h     | 29 +++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_crb.c | 30 +++++++++++++++++++++++++++---
 drivers/char/tpm/tpm_tis.c |  6 +++++-
 include/acpi/actbl2.h      | 12 ++++++++++++
 5 files changed, 74 insertions(+), 5 deletions(-)

-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.


------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
