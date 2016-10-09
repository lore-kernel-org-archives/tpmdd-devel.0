From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 0/2] tpm: enhance TPM 2.0 extend function
 to support multiple PCR banks
Date: Sun, 9 Oct 2016 15:30:18 +0530
Message-ID: <57FA1532.30603@linux.vnet.ibm.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20161009090827.GC31891@intel.com> <20161009092911.GF31891@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161009092911.GF31891-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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



On 10/09/2016 02:59 PM, Jarkko Sakkinen wrote:
> On Sun, Oct 09, 2016 at 12:08:27PM +0300, Jarkko Sakkinen wrote:
>> On Sat, Oct 08, 2016 at 10:15:55PM -0400, Nayna Jain wrote:
>>> The existing in-kernel interface for extending a TPM PCR extends
>>> the SHA1 PCR bank. For TPM 1.2, that is the one and only PCR bank
>>> defined. TPM 2.0 adds support for multiple PCR banks, to support
>>> different hash algorithms. The TPM 2.0 Specification[1]
>>> recommends extending all active PCR banks. This patch set enhances
>>> the existing TPM 2.0 extend function and corresponding in-kernel
>>> interface to support extending all active PCR banks.
>>>
>>> The first patch implements the TPM 2.0 capability to retrieve
>>> the list of active PCR banks.
>>>
>>> The second patch modifies the TPM 2.0 device driver extend function
>>> to support extending multiple PCR banks. The existing in-kernel
>>> interface expects only a SHA1 digest. Hence, to extend all active
>>> PCR banks with differing digest sizes for TPM 2.0, the SHA1 digest
>>> is padded with 0's as needed.
>>>
>>> This approach is taken to maintain backwards compatibility for the
>>> existing users (i.e. IMA) in order to continue working with both
>>> TPM 1.2 and TPM 2.0 without any changes and still comply with the
>>> TPM 2.0 Specification[1] requirement of extending all active PCR
>>> banks.
>>>
>>> This patch series has a prerequisite(header file tpm2.h) of TPM 2.0
>>> event log patch series.
>>
>> This is an unacceptable requirement. I don't even like the idea
>> of having tpm2.h (rather would keep stuff in tpm2-cmd.c).
>>
>> Also I seriously cannot accept patch sets that add code without
>> giving value.
>
> I would propose that you work on a PoC for IMA with TPM 2.0 that
> includes these patches. Then we can try it out. Depending on half
> finished patch sets is not just right way to do it. I'm happy to
> test if you have someting runnable :)

I actually created tpm2.h in eventlog patch series thinking just like 
tpm.h and tpm_eventlog.h is meant for TPM 1.2 specific structs, there 
can be tpm2.h specific to TPM 2.0 structs. It was just my thought to 
segregate the headers, but if it doesn't look good idea, I can change it 
to more recommended way.

Also, struct tpml_digest_values are used by both eventlog and extend 
function as shown below:

struct tcg_pcr_event2 {
u32 pcr_idx;
u32 event_type;
struct tpml_digest_values digests;
struct tcg_event_field event;
} __packed;

/* Crypto agile extend format. */
struct tpm2_pcr_extend_in {
__be32 pcr_idx;
__be32 auth_area_size;
struct tpm2_null_auth_area auth_area;
struct tpml_digest_values digests;
} __packed;

So, I continued using tpm2.h for this patch series and created a 
pre-requisite on eventlog patch series.

I have applied to upstream and tested on top of eventlog patch series, 
so yes, it doesn't apply directly to upstream without eventlog patches 
because of tpm2.h file.

If this doesn't look an acceptable approach, I would be happy to redo it 
in new way which is more acceptable.

I will post next patch series with no tpm2.h and moving data types into 
tpm2-cmd.c and existing header file as applicable.

Please suggest if I am missing something.

Thanks & Regards,
    - Nayna

>
> /Jarkko
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
