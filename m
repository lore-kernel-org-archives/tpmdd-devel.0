From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
 support
Date: Thu, 1 Sep 2016 17:52:50 +0300
Message-ID: <20160901145250.GA19529@intel.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830071032.GB6215@intel.com>
	<57C71A48.8020505@linux.vnet.ibm.com>
	<20160901134501.GA14627@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901134501.GA14627-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 01, 2016 at 04:45:01PM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 31, 2016 at 11:26:24PM +0530, Nayna wrote:
> > Thanks Jarkko for the review. I will address all your comments in my next
> > version of patches.
> 
> OK maybe the point I'm trying to make if you forget all the whining is
> that with this particular feature we have to be extremely careful
> because of the number of stakeholders that depend on it.
> 
> This is not something I would put into 4.10 and no matter who is doing
> it, it might take a few more iterations to get right. So take your time.
> There's no rush (or more like there can't be rush).

Sorry, a typo. I meant the 4.9 release :) 4.10 release is an open
question. This should be in production quality by 4.9-rc4/5 in order
to make that happen.

The good timeline for topic branch would be end of Oct before LPC so
that I could carry a setup involving Minnowboard and a discrete TPM
module and demo this. I already have a topic branch called 'tabrm'
in place for the same conference.

/Jarkko

> In the meanwhile I'm still in progress on getting the suitable hardware
> so that I could test at least the DT stuff.
> 
> PS. It's better to keep the attribute names the same since the code is
> already depending those names even if I don't like the naming :)
> 
> /Jarkko
> 
> > Thanks & Regards,
> >   - Nayna
> > 
> > On 08/30/2016 12:40 PM, Jarkko Sakkinen wrote:
> > >On Tue, Aug 30, 2016 at 12:50:12AM -0400, Nayna Jain wrote:
> > >>Existing TPM2.0 support lacks the support for eventlog securityfs file.
> > >>This patch adds the binary_bios_measurements to TPM2.0 eventlog
> > >>securityfs file.
> > >>
> > >>Additionally, it also includes the review feedbacks as suggested by
> > >>Jason.
> > >>
> > >>Further, commit msg subject line is prefixed with tpm as was suggested
> > >>by Jarkko.
> > >
> > >Please start using get_maintainers.pl...
> > >
> > >>Changelog v3:
> > >>
> > >>* Includes the review feedbacks as suggested by Jason
> > >>         * Split of patches into one patch per idea
> > >>         * Generic open() method for ascii/bios measurements
> > >>         * Replacement of of **bios_dir with *bios_dir[3]
> > >>         * Verifying readlog() is successful before creating
> > >>         securityfs entries
> > >>         * Generic readlog() to check for ACPI/OF in sequence
> > >>	* read_log_of() method now uses of_node propertry rather than
> > >>         calling find_device_by_name
> > >>	* read_log differentiates vtpm/tpm using its compatible property
> > >>	* Cleans pr_err with dev_dbg
> > >>	* Commit msgs subject line prefixed with tpm
> > >
> > >Where is the changlog for v2?
> > >
> > >/Jarkko
> > >
> > >>
> > >>Nayna Jain (7):
> > >>   tpm: Define a generic open() method for ascii & bios measurements.
> > >>   tpm: Replace the dynamically allocated bios_dir as struct dentry
> > >>     array.
> > >>   tpm: Validate the eventlog access before tpm_bios_log_setup
> > >>   tpm: Redefine the read_log method to check for ACPI/OF properties
> > >>     sequentially
> > >>   tpm: Replace the of_find_node_by_name() with dev of_node property
> > >>   tpm: Moves the eventlog init functions to tpm_eventlog_init.c
> > >>   tpm: Adds securityfs support for TPM2.0 eventlog
> > >>
> > >>  drivers/char/tpm/Makefile            |  13 +-
> > >>  drivers/char/tpm/tpm-chip.c          |  21 +---
> > >>  drivers/char/tpm/tpm.h               |   7 +-
> > >>  drivers/char/tpm/tpm2.h              |  85 +++++++++++++
> > >>  drivers/char/tpm/tpm2_eventlog.c     | 224 +++++++++++++++++++++++++++++++++++
> > >>  drivers/char/tpm/tpm_acpi.c          |  19 +--
> > >>  drivers/char/tpm/tpm_eventlog.c      | 154 +-----------------------
> > >>  drivers/char/tpm/tpm_eventlog.h      |  26 ++--
> > >>  drivers/char/tpm/tpm_eventlog_init.c | 153 ++++++++++++++++++++++++
> > >>  drivers/char/tpm/tpm_of.c            |  65 ++++++----
> > >>  10 files changed, 543 insertions(+), 224 deletions(-)
> > >>  create mode 100644 drivers/char/tpm/tpm2.h
> > >>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c
> > >>  create mode 100644 drivers/char/tpm/tpm_eventlog_init.c
> > >>
> > >>--
> > >>2.5.0
> > >>
> > >>
> > >>------------------------------------------------------------------------------
> > >>_______________________________________________
> > >>tpmdd-devel mailing list
> > >>tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> > >>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> > >
> > 

------------------------------------------------------------------------------
