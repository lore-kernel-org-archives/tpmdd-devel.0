From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 0/3] TPM2.0: Added eventlog support for
 TPM2.0
Date: Wed, 17 Aug 2016 11:28:51 +0530
Message-ID: <57B3FD1B.9040606@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810113243.GF13929@intel.com> <20160810171900.GA11543@intel.com>
	<57AC5802.1090109@linux.vnet.ibm.com> <20160811125818.GA9303@intel.com>
	<57ADC1C0.4030406@linux.vnet.ibm.com>
	<20160815212612.GC25212@intel.com>
	<57B36698.7040904@linux.vnet.ibm.com>
	<20160816194853.GA26364@intel.com>
	<20160817041502.GA8656@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160817041502.GA8656-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: David Heller <hellerda-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

My response inline.

On 08/17/2016 09:45 AM, Jarkko Sakkinen wrote:
> On Tue, Aug 16, 2016 at 10:48:53PM +0300, Jarkko Sakkinen wrote:
>> On Wed, Aug 17, 2016 at 12:46:40AM +0530, Nayna wrote:
>>> Hi Jarkko,
>>>
>>>
>>>
>>> On 08/16/2016 02:56 AM, Jarkko Sakkinen wrote:
>>>> On Fri, Aug 12, 2016 at 06:02:00PM +0530, Nayna wrote:
>>>>>>> Jarkko, Please let me know if it doesn't answer your question. </nayna>
>>>>>>
>>>>>> 1. EFI does not pass the log by any means AFAIK before a boot loader
>>>>>>     calls ExitBootServices().
>>>>>
>>>>> So, is current TCPA support only for TPM1.2 ?
>>>>
>>>> TCPA ACPI table is only available for TPM 1.2.
>>>>
>>>> TPM2 ACPI table does not provide a memory ref for the event log.
>>>>
>>>>> #2, TCG Spec http://www.trustedcomputinggroup.org/wp-content/uploads/EFI-Protocol-Specification-rev13-160330final.pdf
>>>>> talks about
>>>>> EFI_TCG2_PROTOCOL.GetEventLog (Section 6.5), what is that supposed to do ?
>>>>
>>>> Direct quote from your reference:
>>>>
>>>> "Boot Service Drivers are terminated when ExitBootServices() is called
>>>> and all memory resources consumed by the Boot Services Drivers are
>>>> released for use in the operating system environment."
>>>
>>> Thanks Jarkko, I understand now what you meant.
>>>>
>>>>>> 2. I do not have any system with TPM2 that uses DT. And as I stated
>>>>>>     before you didn't have any reference where you derived the DT
>>>>>>     node fields.
>>>>>
>>>>> As per Device Tree, so this is the new node introduced in the device tree to
>>>>> support TPM. And the fields are defined maintaining the requirements from
>>>>> ePAPR specification.
>>>>
>>>> What is ePAPR specification? Can you provide a reference?
>>>
>>> PowerPC systems are based on device tree and derive that from ePAPR
>>> specification, link below for ePAPR specification..
>>>
>>> https://www.power.org/documentation/power-org-standard-for-embedded-power-architecture-platform-requirements-epapr-v1-1-2/
>>
>> Thanks. I'll check that through when I review the next version.
>
> This specification did not define the TPM binding for DT. I searched
> with "tpm" keyword from the specification. Why did you give that link?
>
> You earlier said that fields in TPM binding are derived from that
> specification. For me this looks like total nonsense.

I am sorry Jarkko, if I didn't clearly communicated.
I was trying to say that tpm device tree binding is new binding added 
within i2c node. And for that reason, I am now submitting a patch for 
its binding documentation.

And as ePAPR document explains about device trees and its properties, I 
just meant that fields defined for this new tpm node are also defined as 
per ePAPR spec.

Please let me know if I am still not answering your question, and sorry 
but if you can explain me again what exactly are you looking for.

Thanks & Regards,
   - Nayna

>
> /Jarkko
>


------------------------------------------------------------------------------
