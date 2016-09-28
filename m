From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 0/8] tpm: add the securityfs pseudo
 files support for TPM 2.0 firmware event log
Date: Wed, 28 Sep 2016 12:43:12 +0300
Message-ID: <20160928094312.GA19946@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475051682-23060-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 28, 2016 at 04:34:34AM -0400, Nayna Jain wrote:
> The TPM device driver defines ascii and binary methods for
> displaying the TPM 1.2 event log via securityfs files, which are
> needed for validating a TPM quote. The device driver for TPM 2.0
> does not have similar support for displaying the TPM 2.0
> event log. This patch set adds the support for displaying
> TPM 2.0 event log in binary format.
> 
> The parsing mechanism to display the TPM 2.0 event log in binary
> format is implemented as defined in the TPM 2.0 TCG specification[1].
> If the firmware event log support exists and is successfully read,
> the securityfs file is created to provide the event log in binary
> format for both the OF device tree and ACPI.
> 
> - Patches 1 - 6 clean up the code and fix pre-existing issues.
> - Patch 7 moves the common TPM 1.2 and 2.0 event log initialization
> functions to a new file named tpm_eventlog_init.c.
> - Patch 8 adds the support for creating securityfs files and for
> displaying the TPM 2.0 crypto agile event log in binary format.
> 
> With that, this patch set splits the event log functionality into
> initialization functions, TPM 1.2 event log parsing and TPM 2.0 event
> log parsing.
> 
> [1] TCG EFI Protocol Specification, Family "2.0" - Section 5 "Event
> Log Structure"

Thanks, I'm sorry but I'll have to most probably postpone reviewing
for next week.

/Jarkko

> 
> Changelog History:
> 
> v4:
> 
> - Includes feedbacks from Jarkko and Jason.
> - Patch "tpm: define a generic open() method for ascii & bios
> measurements".
>   - Fix indentation issue.
> - Patch "tpm: replace the dynamically allocated bios_dir as
> struct dentry array".
>   - Continue to use bios_dir_count variable to use is_bad() checks and
>   to maintain correct order for securityfs_remove() during teardown.
>   - Reset chip->bios_dir_count in teardown() function.
> - Patch "tpm: validate the eventlog access before tpm_bios_log_setup".
>   - Retain TPM2 check which was removed in previous patch.
>   - Add tpm_bios_log_setup failure handling.
>   - Remove use of private data from v3 version of patch. Add a new 
>   member to struct tpm_chip to achieve the same purpose.
> - Patch "tpm: redefine the read_log method to check for ACPI/OF 
> properties sequentially".
>   - Move replacement of CONFIG_TCG_IBMVTPM with CONFIG_OF to this
>   patch from patch 3.
>   - Replace -1 error code with -ENODEV.
>   - Patch "tpm: replace the of_find_node_by_name() with dev of_node 
>   property".
>   - Uses chip->dev.parent->of_node.
>   - Created separate patch for cleanup of pr_err messages.
> - Patch "tpm: remove printk error messages".
>   - New Patch.
> - Patch "tpm: add the securityfs file support for TPM 2.0 eventlog".
>   - Parses event digests using event alg_id rather than event log header 
>   alg_id.
>   - Uses of_property_match_string to differentiate tpm/vtpm compatible 
>   property.
>   - Adds the comment for difference in tpm/vtpm endianness.
> 
> v3:
> 
> - Includes the review feedbacks as suggested by Jason.
> - Split of patches into one patch per idea.
> - Generic open() method for ascii/bios measurements.
> - Replacement of of **bios_dir with *bios_dir[3].
> - Verifying readlog() is successful before creating securityfs entries.
> - Generic readlog() to check for ACPI/OF in sequence.
> - read_log_of() method now uses of_node propertry rather than
> calling find_device_by_name.
> - read_log differentiates vtpm/tpm using its compatible property.
> - Cleans pr_err with dev_dbg.
> - Commit msgs subject line prefixed with tpm.
> 
> v2:
> 
> - Fixes issues as given in feedback by Jason.
> - Adds documentation for device tree.
> 
> Nayna Jain (8):
>   tpm: define a generic open() method for ascii & bios measurements
>   tpm: replace dynamically allocated bios_dir with dentry array
>   tpm: validate event log access before tpm_bios_log_setup
>   tpm: redefine read_log() to handle ACPI/OF at runtime
>   tpm: replace of_find_node_by_name() with dev of_node property
>   tpm: remove printk error messages
>   tpm: move event log init functions to tpm_eventlog_init.c
>   tpm: add securityfs support for TPM 2.0 firmware event log
> 
>  drivers/char/tpm/Makefile            |  14 +--
>  drivers/char/tpm/tpm-chip.c          |  24 ++--
>  drivers/char/tpm/tpm.h               |   9 +-
>  drivers/char/tpm/tpm2.h              |  79 +++++++++++++
>  drivers/char/tpm/tpm2_eventlog.c     | 216 +++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_acpi.c          |  36 +++---
>  drivers/char/tpm/tpm_eventlog.c      | 157 +------------------------
>  drivers/char/tpm/tpm_eventlog.h      |  30 +++--
>  drivers/char/tpm/tpm_eventlog_init.c | 163 ++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_of.c            |  68 ++++++-----
>  10 files changed, 559 insertions(+), 237 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>  create mode 100644 drivers/char/tpm/tpm_eventlog_init.c
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
