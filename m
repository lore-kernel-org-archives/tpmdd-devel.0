From: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3 0/2] tpm/tpm_crb: Enable TPM CRB interface
	for ARM64
Date: Fri, 17 Mar 2017 18:43:11 -0500
Message-ID: <1489794193-17233-1-git-send-email-anjiandi@codeaurora.org>
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

TCG ACPI Specification Family "1.2" and "2.0" Version 1.2 Revision 8
introduces a new start method (type 11) for ARM64, along with platform
specific parameters for this new start method.  This new start method
invokes a Secure Monitor Call to request the firmware to execute or
cancel a TPM 2.0 command.

v3 Change Log:
- Added start method specific parameter offset define
- Moved tpm_crb_smc definition to tpm_crb.c
- Removed platform_params union from acpi_table_tpm2
- Removed clutter on length calculation of acpi_table_tpm2
  caused by changing size of acpi_table_tpm2

Jiandi An (2):
  ACPICA: Update TPM2 ACPI table
  tpm/tpm_crb: Enable TPM CRB interface for ARM64

 drivers/char/tpm/Kconfig   |  2 +-
 drivers/char/tpm/tpm_crb.c | 64 ++++++++++++++++++++++++++++++++++++++++++++--
 include/acpi/actbl2.h      |  3 +++
 3 files changed, 66 insertions(+), 3 deletions(-)

-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
