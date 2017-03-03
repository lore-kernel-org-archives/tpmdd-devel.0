From: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v2] tpm: do not suspend/resume if power
 stays on
Date: Fri, 3 Mar 2017 16:46:21 +0100
Message-ID: <5a762fa1-26ea-55f1-f021-5d7090bd25ad@collabora.com>
References: <20170302154257.10663-1-enric.balletbo@collabora.com>
	<20170303151236.dgqbkuhcxhvmawnq@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170303151236.dgqbkuhcxhvmawnq-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jarkko,

Thanks for the review

On 03/03/17 16:12, Jarkko Sakkinen wrote:
> On Thu, Mar 02, 2017 at 04:42:57PM +0100, Enric Balletbo i Serra wrote:
>> From: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>
>> The suspend/resume behavior of the TPM can be controlled by setting
>> "powered-while-suspended" in the DTS. This is useful for the cases
>> when hardware does not power-off the TPM.
>>
>> Signed-off-by: Sonny Rao <sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Signed-off-by: Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
>> ---
>>
>> Changes since v1:
>>  Jason Gunthorpe :
>>   - Move the code to handle suspend/resume in the common chip code.
>>
>>  Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt | 6 ++++++
>>  drivers/char/tpm/tpm-interface.c                           | 3 +++
>>  drivers/char/tpm/tpm.h                                     | 3 +++
>>  drivers/char/tpm/tpm_of.c                                  | 3 +++
>>  4 files changed, 15 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
>> index 8cb638b..85c8216 100644
>> --- a/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
>> +++ b/Documentation/devicetree/bindings/security/tpm/tpm-i2c.txt
>> @@ -8,6 +8,12 @@ Required properties:
>>                     the firmware event log
>>  - linux,sml-size : size of the memory allocated for the firmware event log
>>  
>> +Optional properties:
>> +
>> +- powered-while-suspended: present when the TPM is left powered on between
>> +                           suspend and resume (makes the suspend/resume
>> +                           callbacks do nothing).
>> +
>>  Example (for OpenPower Systems with Nuvoton TPM 2.0 on I2C)
>>  ----------------------------------------------------------
>>  
>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>> index a2688ac..7f60780 100644
>> --- a/drivers/char/tpm/tpm-interface.c
>> +++ b/drivers/char/tpm/tpm-interface.c
>> @@ -944,6 +944,9 @@ int tpm_pm_suspend(struct device *dev)
>>  	if (chip == NULL)
>>  		return -ENODEV;
>>  
>> +	if (chip->powered_while_suspended)
>> +		return 0;
> 
> Why there can't just be TPM_CHIP_FLAG_ALWAYS_POWERED or something similar?
> 

Right this seems a better way for tpm subsystem. I'll send a v3 today.

>> +
>>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
>>  		tpm2_shutdown(chip, TPM2_SU_STATE);
>>  		return 0;
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 1ae9768..c8f796c 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -183,10 +183,13 @@ struct tpm_chip {
>>  	unsigned long duration[3]; /* jiffies */
>>  	bool duration_adjusted;
>>  
>> +	bool powered_while_suspended;
>> +
>>  	struct dentry *bios_dir[TPM_NUM_EVENT_LOG_FILES];
>>  
>>  	const struct attribute_group *groups[3];
>>  	unsigned int groups_cnt;
>> +
> 
> trailing newline
> 
>>  #ifdef CONFIG_ACPI
>>  	acpi_handle acpi_dev_handle;
>>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
>> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
>> index 7dee42d7..33eddd4 100644
>> --- a/drivers/char/tpm/tpm_of.c
>> +++ b/drivers/char/tpm/tpm_of.c
>> @@ -34,6 +34,9 @@ int tpm_read_log_of(struct tpm_chip *chip)
>>  	else
>>  		return -ENODEV;
>>  
>> +	chip->powered_while_suspended = of_property_read_bool(np,
>> +						"powered-while-suspended");
>> +
>>  	sizep = of_get_property(np, "linux,sml-size", NULL);
>>  	basep = of_get_property(np, "linux,sml-base", NULL);
>>  	if (sizep == NULL && basep == NULL)
>> -- 
>> 2.9.3
>>
>>
>> ------------------------------------------------------------------------------
>> Check out the vibrant tech community on one of the world's most
>> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
>> _______________________________________________
>> tpmdd-devel mailing list
>> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
