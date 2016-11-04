From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 0/7] tpm: cleanup/fixes in existing
	event log support
Date: Fri, 4 Nov 2016 07:08:28 -0600
Message-ID: <20161104130828.uzxtcoiyn4hzyyrg@intel.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476838185-24007-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Oct 18, 2016 at 08:49:38PM -0400, Nayna Jain wrote:
> This patch set includes the cleanup and bug fixes patches, previously
> part of the "tpm: add the securityfs pseudo files support for TPM 2.0
> firmware event log" patch set, in order to upstream them more quickly.

I realized something that is obviously wrong in this patch set. You
should CC this to linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and probably also
linux-security-module-u79uwXL29TaiAVqoAR/hOA@public.gmane.org It's only sent to this mailing
list. It works for minor changes and RFC but not for this. Do this
for the next version.

Include all seven patches, or more, because it really seems that 4/7
needs to be split into multiple patches.

I have to drop the first patch too because of this reason.

/Jarkko

> Changelog History
> 
> v5:
> 
> - Moved cleanup/fixes patches into this patch set.
> - Patch "fix the race condition between event log access and chip
> getting unregistered"
>   - updated subject line and commit description.
>   - modified fops code to use chip kref.
>   - modified fops to lock inode before accessing inode private data.
>   - renamed tpm_securityfs_data to tpm_chip_seqops, as it no more
>     holds bios log, but associates seqops with respective chip. For
>     the same reason, moved it to tpm.h
> - Patch "replace or remove printk error messages"
>   - cleaned up dev_dbg and used dev_info as applicable.
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
>     to maintain correct order for securityfs_remove() during teardown.
>   - Reset chip->bios_dir_count in teardown() function.
> - Patch "tpm: validate the event log access before tpm_bios_log_setup".
>   - Retain TPM2 check which was removed in previous patch.
>   - Add tpm_bios_log_setup failure handling.
>   - Remove use of private data from v3 version of patch. Add a new
>   member to struct tpm_chip to achieve the same purpose.
> - Patch "tpm: redefine the read_log method to check for ACPI/OF 
> properties sequentially".
>   - Move replacement of CONFIG_TCG_IBMVTPM with CONFIG_OF to
>   this patch from patch 3.
>   - Replace -1 error code with -ENODEV.
> - Patch "tpm: replace the of_find_node_by_name() with dev of_node
> property".
>   - Uses chip->dev.parent->of_node.
>   - Created separate patch for cleanup of pr_err 
>   messages.
> - Patch "tpm: remove printk error messages".
>   - New Patch.
> - Patch "tpm: add the securityfs file support for TPM 2.0 event log".
>   - Parses event digests using event alg_id rather than event log header
>     alg_id.
>   - Uses of_property_match_string to differentiate tpm/vtpm compatible
>     property.
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
>   calling find_device_by_name.
> - read_log differentiates vtpm/tpm using its compatible property.
> - Cleans pr_err with dev_dbg.
> - Commit msgs subject line prefixed with tpm.
> 
> v2:
> 
> - Fixes issues as given in feedback by Jason.
> - Adds documentation for device tree.
> 
> Jarkko Sakkinen (2):
>   tpm: replace dynamically allocated bios_dir with a static array
>   tpm: drop tpm1_chip_register(/unregister)
> 
> Nayna Jain (5):
>   tpm: define a generic open() method for ascii & bios measurements
>   tpm: fix the race condition between event log access and chip getting
>     unregistered
>   tpm: redefine read_log() to handle ACPI/OF at runtime
>   tpm: replace of_find_node_by_name() with dev of_node property
>   tpm: replace or remove printk error messages
> 
>  drivers/char/tpm/Makefile       |  14 +--
>  drivers/char/tpm/tpm-chip.c     |  31 ++----
>  drivers/char/tpm/tpm-sysfs.c    |   3 +
>  drivers/char/tpm/tpm.h          |  14 ++-
>  drivers/char/tpm/tpm_acpi.c     |  36 +++----
>  drivers/char/tpm/tpm_eventlog.c | 208 ++++++++++++++++++++--------------------
>  drivers/char/tpm/tpm_eventlog.h |  22 +++--
>  drivers/char/tpm/tpm_of.c       |  46 ++++-----
>  8 files changed, 176 insertions(+), 198 deletions(-)
> 
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
