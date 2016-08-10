From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Wed, 10 Aug 2016 20:19:00 +0300
Message-ID: <20160810171900.GA11543@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810113243.GF13929@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810113243.GF13929-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Wed, Aug 10, 2016 at 02:32:43PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 09, 2016 at 03:34:52PM -0400, Nayna Jain wrote:
> > Overview:
> > =========
> > 
> > This patch adds support for enabling securityfs for TPM2.0, currently
> > driver has eventlog support only for TPM1.2.
> > The patch currently adds support for only binary_bios_measurements.
> > 
> > The structure for TPM2.0 is compliant with TCG Spec for 2.0 family.
> > Also , the reading of data has the assumption that writer would have
> > followed TCG Spec and so everything is in little-endian.
> > 
> > The tpm device driver code has been refactored to:
> > * Identify the TPM version - 1.2 or 2.0
> > * Calls corresponding compatible seq_ops for iterating over eventlog.
> > 
> > Files Description:
> > ===================
> > 
> > * tpm-chip.c : Adds call to setup bios log for TPM2.0.
> > 
> > * tpm2_of.c : Reads the device tree entries to find the location
> > and size of event.
> > 
> > * tpm_eventlog_init.c : Provides common initialization functions
> >  between TPM2.0 and TPM1.2 to setup securityfs entries and seq_ops
> >   iterator.  The functions has been moved from tpm_eventlog.c into this file.
> > 
> >   * tpm_eventlog.c : Provides functions only specific to TPM1.2
> >   version. Common initialization functions are moved to tpm_eventlog_init.c
> > 
> >   * tpm2_eventlog.c : Provides functions specific only for TPM2.0
> >   eventlog format.
> > 
> >   * tpm2.h : Header file for TPM2.0 structures and functions.
> 
> diffstat shows changed files. Your commit messages will give detailed
> descriptions. Please remove this. Cover letter would be the right place
> to tell about missing ACPI support.
> 
> BTW, how this can be tested?

As for ACPI you stated that

"Reason being, I don't have much expertise of ACPI side as of now, and
these changes will affect acpi,tpm,vtpm, all paths, so I would like to
go slow and fix them as different patch later after better
understanding."

Don't get me wrong but that really is an unacceptable statement. It
gives very strong evidence that you don't know what you are doing and
the patches are not ready for public consumption.

You have two better alternatives:

1. Do a little bit of research. You would have found that there's no
   ACPI support for the event log defined by TCG at the moment.
2. Ask first. This is the right mailing list to do that.

You do not have to implement ACPI support as part of the patch set but
at least it would be good to research the constraints so that we can
check that the implementation will be best for ACPI too.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
