From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/4] Add support for TPM2 log reported via
	ACPI table
Date: Fri, 31 Mar 2017 21:39:23 +0300
Message-ID: <20170331183923.mmtggrj2bcybwajz@intel.com>
References: <20170329074320.zcbuydd7iydaj3gr@petr-dev3.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170329074320.zcbuydd7iydaj3gr-WbvboCQVrrgDIl+Cyo8nDyLysJ1jNyTM@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 29, 2017 at 12:43:20AM -0700, Petr Vandrovec wrote:
> Hi Peter,
> 
> This series of 4 patches adds support for handling TPM2
> log when it is reported through ACPI TPM2 table, as
> described in latest TPM ACPI draft (Version 1.2, Revision 8,
> from February 27th, 2017).
> 
> I've tested patch on x86 only - I do not have PPC64 system
> with TPM, and handling of endianness between tpm1_eventlog.c
> and tpm2_eventlog.c seems inconsistent: tpm1_eventlog.c uses
> be32_to_cpu() for all log fields on PPC64, while
> tpm2_eventlog.c uses log uses native endianness.  If it
> is intentional, and PPC64 has TPM1 logs in big endian
> while TPM2 logs in native endianness, then 3rd patch
> needs to be amended.
> 
> Four patches split task of improving TPM2 support into following
> subtasks:

This cover letter is a bit chaotic. A cover letter should give an
understandable description of the what is done. Now you have a 2nd
version of commit messages here. This looks confusing.

/Jarkko

> 
> 
> 1. Add log start/length fields to TPM2 table
> 
> This patch adds 1.2 rev 8 structures to TPM2 table, and
> modifies tpm_tis and tpm_crb to use
> offsetofend(tpm2, field_accessed) rather than sizeof(tpm2)
> to verify that TPM2 table is big enough.
> 
> 
> 2. Read TCG log from TPM2 table
> 
> This patch modifies tpm_acpi code to read log start/length
> from TPM2 table similar way it does so from TCPA table.
> 
> 
> 3. Autodetect TCG event log version
> 
> This patch modifies tpm1_eventlog to make decision whether
> to use TPM1 or TPM2 format based on log content, rather
> than from chip version: on x86 there is dozen of firmwares
> that use TPM1 log with TPM2 chip.
> 
> Other part of the change is to validate content of specid
> event to make sure kernel does not crash when faced with
> specid event that claims there is 2^32-1 hashes in the
> event list.
> 
> 
> 4. Improve handling of TPM2 event logs
> 
> Current code does not report any error when digest's hash
> is not listed in specid event, or if event reports 2^32-1
> digests (which is BIOS bug), or if event has more than
> 3 digests (that is kernel bug).  Instead it will try to
> vmalloc() all available memory when event log is read by
> userspace application.
> 
> This patch updates code so that it can handle arbitrary
> number of digests, as long as they are all described
> in specid event, and stops parsing as soon as any malformed
> event is detected.
> 
> 
> Let me know if there are any improvements I can make to
> this patch series.
> 
> Thanks,
> Petr Vandrovec
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
