From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Tue, 30 Aug 2016 10:31:57 +0530
Message-ID: <57C51345.5080103@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810113243.GF13929@intel.com> <20160810171900.GA11543@intel.com>
	<57AC5802.1090109@linux.vnet.ibm.com>
	<20160813025915.GC26929@obsidianresearch.com>
	<57B2D429.8050508@linux.vnet.ibm.com>
	<20160818195521.GC3676@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160818195521.GC3676-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/19/2016 01:25 AM, Jason Gunthorpe wrote:
> On Tue, Aug 16, 2016 at 02:21:53PM +0530, Nayna wrote:
>
>> I tried the suggested approach and since ACPI specific functions won't be
>> available for arch using CONFIG_OF, so the compilation fails and vice versa
>> for CONFIG_ACPI..
>
> Right, you need to stub out the read_X function with an empty inline
> when not available.
Ok

>
>> Jason, for understanding.. can you explain the issue with existing design
>> for read_log, where arch specific read_log is compiled based on CONFIG
>> option.. And then, we can just change in Makefile.. where currently it is
>> like
>>
>> ifdef CONFIG_ACPI
>>         tpm-y += tpm_acpi.o
>> else
>> ifdef CONFIG_OF
>>         tpm-y += tpm_of.o
>> endif
>> endif
>
> The 'else' is the main issue
Ok
>
>
>> this can be changed to
>> tpm-$(CONFIG_ACPI) += tpm_acpi.o
>> tpm-$(CONFIG_OF) += tpm_of.o
>
> This is fine by me, *however* only if the .o files do not define
> overlapping symbols as they do today (eg tpm_acpi contains read_log_acpi)
>
> Use some small #ifdef logic in the header file to create the inline
> stub.

Sure, my latest posted PATCH v3 4/7 does the fix as suggested here.

Thanks & Regards,
   - Nayna

>
> Jason
>


------------------------------------------------------------------------------
