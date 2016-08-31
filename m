From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 4/7] tpm: Redefine the read_log method
 to check for ACPI/OF properties sequentially
Date: Thu, 1 Sep 2016 00:39:46 +0530
Message-ID: <57C72B7A.8040108@linux.vnet.ibm.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-5-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830175409.GD6373@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160830175409.GD6373-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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



On 08/30/2016 11:24 PM, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 12:50:16AM -0400, Nayna Jain wrote:
>> Currently, the difference in read_log method for ACPI/OF based platforms
>> is handled by defining respective read_log method and handing
>> them using CONFIG based #ifdef condition in Makefile which is not
>> the recommended approach.
>>
>> This patch cleans up the ifdef condition in Makefile by defining
>> single read_log method which checks for ACPI/OF event log memory in
>> sequence.
>>
>> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> Yep, this is what I was looking to see..
>
>> +#if defined(CONFIG_ACPI)
>> +int read_log_acpi(struct tpm_chip *chip);
>> +#else
>> +static inline int read_log_acpi(struct tpm_chip *chip)
>> +{
>> +	return -1;
>> +}
>> +#endif
>> +
>> +#if defined(CONFIG_OF)
>> +int read_log_of(struct tpm_chip *chip);
>> +#else
>> +static inline int read_log_of(struct tpm_chip *chip)
>> +{
>> +	return -1;
>> +}
>> +#endif
>
> Though shouldn't these two be ERRNOs of some kind? -ENODEV?

Sure..
Was just trying to see possible errno. And here are some thoughts.


#define EPERM            1      /* Operation not permitted */
#define ENODEV          19      /* No such device */

Was thinking that since tpm device will still be present and its either 
ACPI or OF way of accessing its properties, and one of them will return 
this errno. So, assuming it is ACPI, that means no OF functions 
permitted. So, how about using EPERM ?

Please let me know if it doesn't sound correct.

Thanks & Regards,
Nayna

>
> Jason
>


------------------------------------------------------------------------------
