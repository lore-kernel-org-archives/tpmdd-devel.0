From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Wed, 16 Nov 2016 10:41:43 -0500
Message-ID: <3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161116153731.pmmnxiai7ouuj6qf-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On 11/16/2016 10:37 AM, Jarkko Sakkinen wrote:
> On Wed, Nov 16, 2016 at 09:24:05AM -0500, Stefan Berger wrote:
>> The virtual TPM driver must not access the hosts's event log,
>> otherwise we get crashes from that.
>>
>> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Can you give me a "Fixes" line (no need to send a new patch)?

I haven't bisected, yet.... but will do that today.

Also I am wondering whether we should introduce a flag 
TPM_CHIP_NO_FIRMWARE_LOG that is checked below. The 
TPM_CHIP_FLAG_VIRTUAL may not be ideal, also because it is set due to 
the device not having a parent device, which may not be related. 
Thoughts? That new flag would only be set by the vtpm proxy driver.

    Stefan

>
>> ---
>>   drivers/char/tpm/tpm_eventlog.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
>> index fb603a7..e0abf40 100644
>> --- a/drivers/char/tpm/tpm_eventlog.c
>> +++ b/drivers/char/tpm/tpm_eventlog.c
>> @@ -369,6 +369,9 @@ static int tpm_read_log(struct tpm_chip *chip)
>>   {
>>   	int rc;
>>   
>> +	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
>> +		return -EFAULT;
>> +
>>   	if (chip->log.bios_event_log != NULL) {
>>   		dev_dbg(&chip->dev,
>>   			"%s: ERROR - event log already initialized\n",
>> -- 
>> 2.4.3
>>
> /Jarkko
>


------------------------------------------------------------------------------
