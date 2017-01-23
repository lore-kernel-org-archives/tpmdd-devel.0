From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v9 0/2] securityfs support for TPM 2.0 firmware event log
Date: Mon, 23 Jan 2017 02:26:25 -0500
Message-ID: <1485156387-7735-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

The TPM device driver defines ascii and binary methods for
displaying the TPM 1.2 event log via securityfs files, which are
needed for validating a TPM quote. The device driver for TPM 2.0
does not have similar support for displaying the TPM 2.0
event log. This patch set adds the support for displaying
TPM 2.0 event log in binary format.

The parsing mechanism to display the TPM 2.0 event log in binary
format is implemented as defined in the TPM 2.0 TCG specification[1].
If the firmware event log support exists and is successfully read,
the securityfs file is created to provide the event log in binary
format for both the OF device tree and ACPI.

   - Patch 1 adds the device tree bindings support for Physical TPM.
   - Patch 2 adds the support for creating securityfs files and for
     displaying the TPM 2.0 crypto agile event log in binary format.

[1] TCG EFI Protocol Specification, Family "2.0" - Section 5 "Event
Log Structure"

Changelog History

v9:
- Rebased to the Jarkko's latest master branch (9b7f425 tpm: Check size of 
  response before accessing data)
- Patch "tpm: add securityfs support for TPM 2.0 firmware event log" 
  - Renamed struct tpmt_ha to struct tpm2_hash.
  - Removed struct tpml_digest_values.

v8:
- Rebased to the Jarkko's latest master branch (8e25809 tpm:
  Do not print an error message when doing TPM auto startup)
- Patch "tpm: add securityfs support for TPM 2.0 firmware event log" 
  - Added feedbacks from Jarkko
    - tpm_read_log_acpi() returns -ENODEV for TPM 2.0.
    - Fixed code formatting and comments.

v7:
- Rebased to the Jarkko's latest master branch (b2505f6 tpm/vtpm:
  fix kdoc warnings)
- Included Jarkko's feedbacks on version v6.
- Cleaned up #defines in tpm2_eventlog.c
  - renamed HASH_COUNT to TPM2_ACTIVE_PCR_BANKS
  - deleted MAX_DIGEST_SIZE, used SHA384_DIGEST_SIZE directly from 
  <crypto/hash_info.h>
  - deleted MAX_TPM_LOG_MSG. Redefined event[MAX_TPM_LOG_MSG]
  as event[0].

v6:

- Rebased to the Jarkko's latest master branch (e717b5c:tpm: vtpm_proxy: 
  conditionally call tpm_chip_unregister)
- Retained securityfs setup functions in tpm_eventlog.c
- Renamed tpm_eventlog.c to tpm1_eventlog.c
- Fixed tpm_read_log_of() for NULL check and memcpy function.

v5:

- Upstreamed cleanup and fixes as different patchset
- Rebased to the Jarkko's latest master branch (e5be084 tpm: vtpm_proxy:
  Do not access host's event log)
- Patch "tpm: enhance read_log_of() to support Physical TPM event log
  - New Patch.
- Patch "tpm: add securityfs support for TPM 2.0 firmware event log"
  - Moved the changes in read_log_of() to a different patch
  - TPM 2.0 event log data types are declared in tpm_eventlog.h, tpm2.h
  is removed.
  - Included other feedbacks also from Jarkko on aligment and extra
    line

v4:

- Includes feedbacks from Jarkko and Jason.
- Patch "tpm: define a generic open() method for ascii & bios
measurements".
  - Fix indentation issue.
- Patch "tpm: replace the dynamically allocated bios_dir as
  struct dentry array".
  - Continue to use bios_dir_count variable to use is_bad() checks and
    to maintain correct order for securityfs_remove() during teardown.
  - Reset chip->bios_dir_count in teardown() function.
- Patch "tpm: validate the eventlog access before tpm_bios_log_setup".
  - Retain TPM2 check which was removed in previous patch.
  - Add tpm_bios_log_setup failure handling.
  - Remove use of private data from v3 version of patch. Add a
  new member to struct tpm_chip to achieve the same purpose.
- Patch "tpm: redefine the read_log method to check for ACPI/OF 
properties sequentially".
  - Move replacement of CONFIG_TCG_IBMVTPM with CONFIG_OF to this
    patch from patch 3.
  - Replace -1 error code with -ENODEV.
- Patch "tpm: replace the of_find_node_by_name() with dev of_node
property".
  - Uses chip->dev.parent->of_node.
  - Created separate patch for cleanup of pr_err messages.
- Patch "tpm: remove printk error messages".
  - New Patch.
- Patch "tpm: add the securityfs file support for TPM 2.0 eventlog".
  - Parses event digests using event alg_id rather than event log header
    alg_id.
  - Uses of_property_match_string to differentiate tpm/vtpm compatible

v3:

- Includes the review feedbacks as suggested by Jason.
- Split of patches into one patch per idea.
- Generic open() method for ascii/bios measurements.
- Replacement of of **bios_dir with *bios_dir[3].
- Verifying readlog() is successful before creating securityfs entries.
- Generic readlog() to check for ACPI/OF in sequence.
- read_log_of() method now uses of_node propertry rather than
calling find_device_by_name.
- read_log differentiates vtpm/tpm using its compatible property.
- Cleans pr_err with dev_dbg.
- Commit msgs subject line prefixed with tpm.

v2:

- Fixes issues as given in feedback by Jason.
- Adds documentation for device tree.

Nayna Jain (2):
  tpm: enhance read_log_of() to support Physical TPM event log
  tpm: add securityfs support for TPM 2.0 firmware event log

 drivers/char/tpm/Makefile                          |   2 +-
 .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
 drivers/char/tpm/tpm2_eventlog.c                   | 203 +++++++++++++++++++++
 drivers/char/tpm/tpm_acpi.c                        |   3 +
 drivers/char/tpm/tpm_eventlog.h                    |  59 ++++++
 drivers/char/tpm/tpm_of.c                          |  27 ++-
 6 files changed, 310 insertions(+), 19 deletions(-)
 rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
 create mode 100644 drivers/char/tpm/tpm2_eventlog.c

-- 
2.5.0
