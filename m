From: Petr Vandrovec <petr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Add support for TPM2 log reported via
	ACPI table
Date: Fri, 31 Mar 2017 14:18:23 -0700
Message-ID: <58DEC79F.6000805@vmware.com>
References: <20170329074320.zcbuydd7iydaj3gr@petr-dev3.eng.vmware.com>
	<20170331183923.mmtggrj2bcybwajz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170331183923.mmtggrj2bcybwajz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Jarkko Sakkinen wrote:
> On Wed, Mar 29, 2017 at 12:43:20AM -0700, Petr Vandrovec wrote:
>> Hi Peter,
>>
>> This series of 4 patches adds support for handling TPM2
>> log when it is reported through ACPI TPM2 table, as
>> described in latest TPM ACPI draft (Version 1.2, Revision 8,
>> from February 27th, 2017).
>>
>> I've tested patch on x86 only - I do not have PPC64 system
>> with TPM, and handling of endianness between tpm1_eventlog.c
>> and tpm2_eventlog.c seems inconsistent: tpm1_eventlog.c uses
>> be32_to_cpu() for all log fields on PPC64, while
>> tpm2_eventlog.c uses log uses native endianness.  If it
>> is intentional, and PPC64 has TPM1 logs in big endian
>> while TPM2 logs in native endianness, then 3rd patch
>> needs to be amended.
>>
>> Four patches split task of improving TPM2 support into following
>> subtasks:
>
> This cover letter is a bit chaotic. A cover letter should give an
> understandable description of the what is done. Now you have a 2nd
> version of commit messages here. This looks confusing.

Hi Jarkko,

sorry about that.  I wanted to provide additional details in the cover 
letter.  As far as understandable description, it is more or less 
covered in first paragraph.  Would this summary work for you:

This series adds support for handling TPM2 log when it is reported 
through ACPI TPM2 table, as described in latest TPM ACPI draft (Version 
1.2, Revision 8, from February 27th, 2017).

Second half of the series then improves support for TPM2 log parsing, so 
kernel does not crash when firmware provides TPM log in different format 
than 'Spec ID Event03', or if it uses Event03 format with more than 3 
hashes.


Thanks,
Petr

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
