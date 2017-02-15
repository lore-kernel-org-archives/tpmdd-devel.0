From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: Fix expected number of response
 bytes of TPM1.2 PCR Extend
Date: Wed, 15 Feb 2017 13:17:48 -0500
Message-ID: <0329f461-b475-5fbc-a41f-05c28829381a@linux.vnet.ibm.com>
References: <1487177783-15687-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170215180903.3simazptqnlhbqi6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170215180903.3simazptqnlhbqi6-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 02/15/2017 01:09 PM, Jarkko Sakkinen wrote:
> On Wed, Feb 15, 2017 at 11:56:23AM -0500, Stefan Berger wrote:
>> The TPM1.2 PCR Extend operation only returns 20 bytes in the body,
>> which is the size of the PCR state.
>>
>> This fixes a problem where IMA gets errors with every PCR Extend.
>>
>> Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Acked-by: Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> /Jarkko
>
>> ---
>>   drivers/char/tpm/tpm-interface.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index 6e368ee..bd2128e 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -767,7 +767,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
>>   
>>   #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
>>   #define EXTEND_PCR_RESULT_SIZE 34


We should probably rename the above to EXTEND_PCR_BUFFER_SIZE. It's the 
input buffer that's size 34, the output is 30 bytes.

    Stefan


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
