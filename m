From: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/2] Cover Letter - TPM2.0: Add securityfs
	support for
Date: Fri, 29 Jul 2016 02:44:37 -0400
Message-ID: <1469774679-25232-1-git-send-email-nayna@linux.vnet.ibm.com>
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

Overview:
=========
Patch adds support for enabling securityfs for TPM2.0.
The patch currently adds support for only binary_bios_measurements.

The structure for TPM2.0 is compliant with TCG Spec for 2.0 family.
Also , the reading of data has the assumption that writer would have
followed TCG Spec and so everything is in little-endian.

The tpm device driver code has been refactored to:
* Identify the TPM version - 1.2 or 2.0
* Calls corresponding compatible seq_ops for iterating over eventlog.

Files Description:
===================

* tpm-chip.c : Adds call to setup bios log for TPM2.0.

* tpm2_of.c : Reads the device tree entries to find the location
and size of event.

* tpm_eventlog_init.c : Provides common initialization functions
 between TPM2.0 and TPM1.2 to setup securityfs entries and seq_ops
 iterator.  The functions has been moved from tpm_eventlog.c into this file.

* tpm_eventlog.c : Provides functions only specific to TPM1.2
version. Common initialization functions are moved to tpm_eventlog_init.c

* tpm2_eventlog.c : Provides functions specific only for TPM2.0
eventlog format.

* tpm2.h : Header file for TPM2.0 structures and functions.

Nayna Jain (2):
  TPM2.0: Refactor eventlog methods.
  TPM2.0:Adds securityfs support for TPM2.0 eventlog

 drivers/char/tpm/Makefile            |   8 +-
 drivers/char/tpm/tpm-chip.c          |  20 ++--
 drivers/char/tpm/tpm2.h              |  75 ++++++++++++
 drivers/char/tpm/tpm2_eventlog.c     | 224 +++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2_of.c           |  77 ++++++++++++
 drivers/char/tpm/tpm_eventlog.c      | 156 +-----------------------
 drivers/char/tpm/tpm_eventlog.h      |  13 +-
 drivers/char/tpm/tpm_eventlog_init.c | 216 +++++++++++++++++++++++++++++++++
 8 files changed, 617 insertions(+), 172 deletions(-)
 create mode 100644 drivers/char/tpm/tpm2.h
 create mode 100644 drivers/char/tpm/tpm2_eventlog.c
 create mode 100644 drivers/char/tpm/tpm2_of.c
 create mode 100644 drivers/char/tpm/tpm_eventlog_init.c

-- 
2.5.0


------------------------------------------------------------------------------
