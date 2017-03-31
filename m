From: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 0/4] Add support for TPM2 log reported via
 ACPI table
Date: Fri, 31 Mar 2017 10:43:32 -0400
Message-ID: <1e3208ff-2565-7d11-6670-1b1e72cf8e5c@linux.vnet.ibm.com>
References: <20170329074320.zcbuydd7iydaj3gr@petr-dev3.eng.vmware.com>
	<58DC8EBF.40700@linux.vnet.ibm.com> <58DCBE41.3060507@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <58DCBE41.3060507-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/30/2017 4:13 AM, Petr Vandrovec wrote:
> Nayna wrote:
>>
>>
>> On 03/29/2017 01:13 PM, Petr Vandrovec wrote:
>> [snip]
>>> tpm2_eventlog.c uses log uses native endianness. If it
>>> is intentional, and PPC64 has TPM1 logs in big endian
>>
>> Yes, in case of ppc64, the tpm1 code logs are in big endian format.
>
> Thanks.  What about tpm2 logs?  Is first (specid) event in big endian
> format too, or no?

Formally, according to the TCG specifications, the firmware event log
is little endian.

My opinion (but I may be wrong) ...

It doesn't matter, as long as the platform knows what it did.

When the platform sends the log to the attestation server, it should be
a consistent format, regardless of the endian'ness of the platform.

In my attestation implementation, I use big endian, because that's what
the TPM uses. Thus, I reuse all the TPM and TSS marshaling and
unmarshaling code.


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
