From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] tpm: check whether all digests have
 been provided for TPM 2.0 extend
Date: Wed, 5 Apr 2017 14:25:17 +0200
Message-ID: <e0c01100-df24-6632-fed5-dfe355470ac6@huawei.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<20170329102452.32212-2-roberto.sassu@huawei.com>
	<20170405121200.rjbojlwchfw43ted@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170405121200.rjbojlwchfw43ted-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 4/5/2017 2:12 PM, Jarkko Sakkinen wrote:
> On Wed, Mar 29, 2017 at 12:24:49PM +0200, Roberto Sassu wrote:
>> TCG mandates that all PCR banks must be extended during the same operation.
>> tpm2_pcr_extend() will check whether all digests have been provided.
>>
>> The check is necessary because tpm2_pcr_extend() will be called by a new
>> function, allowing callers to provide a digest for each PCR bank.
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> When can this happen?

Hi Jarkko

I'm extending IMA to calculate the event data digest multiple
times, for each algorithm selected by the user and supported by
the TPM.

You can have a look at the cover letter of the patch set:

https://sourceforge.net/p/linux-ima/mailman/message/35757172/


and at the patch which calls the functions I added to the
TPM driver interface:

https://sourceforge.net/p/linux-ima/mailman/message/35757195/

Thanks

Roberto

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
