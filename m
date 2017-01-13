From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 2/2] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Fri, 13 Jan 2017 15:35:40 -0500
Message-ID: <9e823fb6-dcc7-a097-1cba-948aeffe2eb6@linux.vnet.ibm.com>
References: <1484121262-25732-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1484121262-25732-3-git-send-email-nayna@linux.vnet.ibm.com>
	<9c605b61-bd5f-eb74-8fc0-ac3587852808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <9c605b61-bd5f-eb74-8fc0-ac3587852808-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/13/2017 01:09 PM, Stefan Berger wrote:
> On 01/11/2017 02:54 AM, Nayna Jain wrote:
>> Unlike the device driver support for TPM 1.2, the TPM 2.0 does
>> not support the securityfs pseudo files for displaying the
>> firmware event log.
>>
>> This patch enables support for providing the TPM 2.0 event log in
>> binary form. TPM 2.0 event log supports a crypto agile format that
>> records multiple digests, which is different from TPM 1.2. This
>> patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
>> event log parser which understand the TPM 2.0 crypto agile format.
>>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/char/tpm/Makefile                          |   2 +-
>>   .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
>>   drivers/char/tpm/tpm2_eventlog.c                   | 203 
>> +++++++++++++++++++++
>>   drivers/char/tpm/tpm_acpi.c                        |   3 +
>>   drivers/char/tpm/tpm_eventlog.h                    |  63 +++++++
>>   5 files changed, 291 insertions(+), 15 deletions(-)
>>   rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
>>   create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>>
>>
>> diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
>> index b7718c9..169edf3 100644
>> --- a/drivers/char/tpm/tpm_acpi.c
>> +++ b/drivers/char/tpm/tpm_acpi.c
>> @@ -54,6 +54,9 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
>>       u64 len, start;
>>       struct tpm_bios_log *log;
>>
>> +    if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +        return -ENODEV;
>> +
>
>
> Works with SeaBIOS when this check is disabled.
>

-> Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>




------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
