From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/5] tpm: introduce
 tpm_pcr_algo_to_crypto() and tpm_pcr_algo_from_crypto()
Date: Mon, 22 May 2017 09:21:28 +0200
Message-ID: <0b04a33c-248b-6597-473f-c5bc4ccaba62@huawei.com>
References: <20170505142152.29795-1-roberto.sassu@huawei.com>
	<20170505142152.29795-3-roberto.sassu@huawei.com>
	<20170515111629.urjvbhqzohv4vakc@intel.com>
	<0deed9be-d0c3-3a69-d510-1c8aa3513ba8@huawei.com>
	<20170520132217.t7n7l2pjn7i63hbm@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170520132217.t7n7l2pjn7i63hbm-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 5/20/2017 3:22 PM, Jarkko Sakkinen wrote:
> On Mon, May 15, 2017 at 04:22:22PM +0200, Roberto Sassu wrote:
>> On 5/15/2017 1:16 PM, Jarkko Sakkinen wrote:
>>> On Fri, May 05, 2017 at 04:21:49PM +0200, Roberto Sassu wrote:
>>>> tpm_pcr_algorithms() returns to its callers the IDs of the hash algorithms
>>>> supported by the TPM. This patch introduces tpm_pcr_algo_to_crypto(),
>>>> so that the callers can use the crypto subsystem to calculate the digest
>>>> to be passed to tpm_pcr_extend().
>>>>
>>>> tpm_pcr_algo_from_crypto(), implemented for completeness, is instead used
>>>
>>> What do you mean by completeness? Please, never add unused stuff.
>>>
>>>> by tpm2_seal_trusted() to perform the opposite conversion.
>>>>
>>>> Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>> v2
>>>>
>>>> - fixed return values of tpm2_pcr_algo_to_crypto() and
>>>>   tpm2_pcr_algo_from_crypto() if TPM support is disabled in the kernel
>>>
>>> Change Log only to the cover letter.
>>>
>>>>  drivers/char/tpm/tpm-interface.c | 51 ++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/char/tpm/tpm2-cmd.c      | 42 +++++++++------------------------
>>>>  include/linux/tpm.h              | 13 ++++++++++
>>>>  3 files changed, 75 insertions(+), 31 deletions(-)
>>>
>>> This commit is just deadly wrong in so many ways.
>>>
>>> I would suggest to make extend always just take crypto ID in so you
>>> don't have to add these bizarre conversion functions.
>>
>> The reason of this choice (as I explained in the cover letter)
>> is that TPM users might want to produce an event log with
>> the TCG format (which includes the TPM algorithm ID). Also,
>> TPM IDs should be preferred because, with them, TPM users
>> can calculate a digest directly with the TPM.
>>
>> Taking crypto IDs means relying on the fact that there
>> is always a mapping between TPM IDs and crypto IDs.
>> Otherwise, tpm_pcr_algorithms() cannot return the algorithms
>> to its callers and PCRs cannot be extended. If TPM IDs are used,
>> TPM users have two alternatives: calculate the digest with
>> the TPM, or pass a SHA1 digest to tpm_pcr_extend(), so that
>> it can be padded to extend remanining PCR banks.
>>
>> However, this second option will work only when the TPM driver
>> determines the size of an algorithm without relying on the crypto
>> subsystem. At the moment, if a TPM ID is not mapped to a crypto ID,
>> tpm2_pcr_extend() ignores the digest.
>>
>> Roberto
>
> What if tpm_pcr_algorithms would convert TPM IDs to crypto IDs?
>
> Externally other subsystems would have to then deal with only crypto
> IDs.

Then, other subsystems cannot:

- use the TPM to calculate a digest
- create an event log with the TCG format

Roberto

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
