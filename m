From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
 support
Date: Tue, 30 Aug 2016 13:16:11 +0300
Message-ID: <20160830101611.GA11819@intel.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532619-22170-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Aug 30, 2016 at 12:50:12AM -0400, Nayna Jain wrote:
> Existing TPM2.0 support lacks the support for eventlog securityfs file.
> This patch adds the binary_bios_measurements to TPM2.0 eventlog
> securityfs file.

This is kind of patch set that would require very elaborate description
how the problem was solved. I cannot really mirror the patches to
anything (especially as the commit messages in commits are also very low
quality).

If you write bad commit messages, it leaves me worried that the quality
is low by other measure.

This is just an example but I do not know how this scales with algorithmic 
agility. 

You also fail to explain how this should work with ACPI even though
we know that there does not exist any kind for event log through ACPI
with TPM 2.0 hardware. I.e. just by reading the commits I can obviously
see that you are doing major untested code path changes.

This will need a lot of rework...

> Additionally, it also includes the review feedbacks as suggested by
> Jason.
> 
> Further, commit msg subject line is prefixed with tpm as was suggested
> by Jarkko.
> 
> Changelog v3:
> 
> * Includes the review feedbacks as suggested by Jason
>         * Split of patches into one patch per idea
>         * Generic open() method for ascii/bios measurements
>         * Replacement of of **bios_dir with *bios_dir[3]
>         * Verifying readlog() is successful before creating
>         securityfs entries
>         * Generic readlog() to check for ACPI/OF in sequence
> 	* read_log_of() method now uses of_node propertry rather than
>         calling find_device_by_name
> 	* read_log differentiates vtpm/tpm using its compatible property
> 	* Cleans pr_err with dev_dbg
> 	* Commit msgs subject line prefixed with tpm

BTW, what is the logic in this indentation.

> 
> Nayna Jain (7):
>   tpm: Define a generic open() method for ascii & bios measurements.
>   tpm: Replace the dynamically allocated bios_dir as struct dentry
>     array.
>   tpm: Validate the eventlog access before tpm_bios_log_setup
>   tpm: Redefine the read_log method to check for ACPI/OF properties
>     sequentially
>   tpm: Replace the of_find_node_by_name() with dev of_node property
>   tpm: Moves the eventlog init functions to tpm_eventlog_init.c
>   tpm: Adds securityfs support for TPM2.0 eventlog
> 
>  drivers/char/tpm/Makefile            |  13 +-
>  drivers/char/tpm/tpm-chip.c          |  21 +---
>  drivers/char/tpm/tpm.h               |   7 +-
>  drivers/char/tpm/tpm2.h              |  85 +++++++++++++
>  drivers/char/tpm/tpm2_eventlog.c     | 224 +++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_acpi.c          |  19 +--
>  drivers/char/tpm/tpm_eventlog.c      | 154 +-----------------------
>  drivers/char/tpm/tpm_eventlog.h      |  26 ++--
>  drivers/char/tpm/tpm_eventlog_init.c | 153 ++++++++++++++++++++++++
>  drivers/char/tpm/tpm_of.c            |  65 ++++++----
>  10 files changed, 543 insertions(+), 224 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>  create mode 100644 drivers/char/tpm/tpm_eventlog_init.c
> 
> -- 
> 2.5.0
> 
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

/Jarkko

------------------------------------------------------------------------------
