From: Nayna Jain <nayna@linux.vnet.ibm.com>
Subject: [PATCH v6 0/9] tpm: cleanup/fixes in existing event log support
Date: Mon, 14 Nov 2016 05:00:47 -0500
Message-ID: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Nayna Jain <nayna@linux.vnet.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

This patch set includes the cleanup and bug fixes patches, previously
part of the "tpm: add the securityfs pseudo files support for TPM 2.0
firmware event log" patch set, in order to upstream them more quickly.

Changelog History:

v6:

- Patch "tpm: replace symbolic permission with octal for securityfs files"
  - New Patch.
- Patch "tpm: have event log use the tpm_chip"
  - Changed commit description as per Jason's suggestion.
  - Fixed bug related to kfree() for bios_event_log.
  - Moved inode_unlock() just after get_device() in open().
  - Returned -ENODEV for read_log() ENOMEM error and other errors as it is.
  - Added comment in tpm_bios_log_teardown() to explain inode_lock()/unlock
    reasoning.
  - Splitted .owner into different patch.
- Patch "tpm: fix the missing .owner in tpm_bios_measurements_ops"
  - New Patch.
- Patch "tpm: cleanup of printk error messages"
  - Replaced dev_info() with dev_warn().
  - Updated commit description subject line.

v5:

- Moved cleanup/fixes patches into this patch set.
- Patch "fix the race condition between event log access and chip
getting unregistered"
  - updated subject line and commit description.
  - modified fops code to use chip kref.
  - modified fops to lock inode before accessing inode private data.
  - renamed tpm_securityfs_data to tpm_chip_seqops, as it no more
  holds bios log, but associates seqops with respective chip. For
  the same reason, moved it to tpm.h
- Patch "replace or remove printk error messages"
  - cleaned up dev_dbg and used dev_info as applicable.

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
- Patch "tpm: validate the event log access before tpm_bios_log_setup".
  - Retain TPM2 check which was removed in previous patch.
  - Add tpm_bios_log_setup failure handling.
  - Remove use of private data from v3 version of patch. Add a new
  member to struct tpm_chip to achieve the same purpose.
- Patch "tpm: redefine the read_log method to check for ACPI/OF 
properties sequentially".
  - Move replacement of CONFIG_TCG_IBMVTPM with CONFIG_OF to
  this patch from patch 3.
  - Replace -1 error code with -ENODEV.
- Patch "tpm: replace the of_find_node_by_name() with dev of_node
property".
 - Uses chip->dev.parent->of_node.
 - Created separate patch for cleanup of pr_err messages.
- Patch "tpm: remove printk error messages".
 - New Patch.
- Patch "tpm: add the securityfs file support for TPM 2.0 event log".
 - Parses event digests using event alg_id rather than event log header
 alg_id.
 - Uses of_property_match_string to differentiate tpm/vtpm compatible
 property.
 - Adds the comment for difference in tpm/vtpm endianness.

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

Nayna Jain (9):
  tpm: define a generic open() method for ascii & bios measurements
  tpm: replace symbolic permission with octal for securityfs files
  tpm: replace dynamically allocated bios_dir with a static array
  tpm: drop tpm1_chip_register(/unregister)
  tpm: have event log use the tpm_chip
  tpm: fix the missing .owner in tpm_bios_measurements_ops
  tpm: redefine read_log() to handle ACPI/OF at runtime
  tpm: replace of_find_node_by_name() with dev of_node property
  tpm: cleanup of printk error messages

 drivers/char/tpm/Makefile       |  14 +--
 drivers/char/tpm/tpm-chip.c     |  33 ++----
 drivers/char/tpm/tpm-sysfs.c    |   3 +
 drivers/char/tpm/tpm.h          |  14 ++-
 drivers/char/tpm/tpm_acpi.c     |  38 +++----
 drivers/char/tpm/tpm_eventlog.c | 222 +++++++++++++++++++++-------------------
 drivers/char/tpm/tpm_eventlog.h |  22 ++--
 drivers/char/tpm/tpm_of.c       |  45 +++-----
 8 files changed, 187 insertions(+), 204 deletions(-)

-- 
2.5.0
