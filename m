From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 3/9] tpm: replace dynamically allocated bios_dir with a
 static array
Date: Wed, 23 Nov 2016 00:56:19 +0530
Message-ID: <58349BDB.4040005@linux.vnet.ibm.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-4-git-send-email-nayna@linux.vnet.ibm.com>
 <20161122112333.7ootyrbssd6pkrjb@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20161122112333.7ootyrbssd6pkrjb@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/22/2016 04:53 PM, Jarkko Sakkinen wrote:
> On Mon, Nov 14, 2016 at 05:00:50AM -0500, Nayna Jain wrote:
>> This commit is based on a commit by Nayna Jain. Replaced dynamically
>> allocated bios_dir with a static array as the size is always constant.
>>
>> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
> This commit remains unreviewed and tested. I'm in the author role here
> so I cannot help with this. If that does not happen soon I cannot put
> this into the pull request.

Tested-By: Nayna Jain <nayna@linux.vnet.ibm.com>

Thanks & Regards,
   - Nayna

>
> /Jarkko
>
>
>> ---
>>   drivers/char/tpm/tpm-chip.c     |  9 ++++---
>>   drivers/char/tpm/tpm.h          |  3 ++-
>>   drivers/char/tpm/tpm_eventlog.c | 59 ++++++++++++++++++-----------------------
>>   drivers/char/tpm/tpm_eventlog.h | 10 +++----
>>   4 files changed, 38 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 836f056..d0c1872 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -278,14 +278,16 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>>
>>   static int tpm1_chip_register(struct tpm_chip *chip)
>>   {
>> +	int rc;
>> +
>>   	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>>   		return 0;
>>
>>   	tpm_sysfs_add_device(chip);
>>
>> -	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
>> +	rc = tpm_bios_log_setup(chip);
>>
>> -	return 0;
>> +	return rc;
>>   }
>>
>>   static void tpm1_chip_unregister(struct tpm_chip *chip)
>> @@ -293,8 +295,7 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
>>   	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>>   		return;
>>
>> -	if (chip->bios_dir)
>> -		tpm_bios_log_teardown(chip->bios_dir);
>> +	tpm_bios_log_teardown(chip);
>>   }
>>
>>   static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index f9401ca..9d69580 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -40,6 +40,7 @@ enum tpm_const {
>>   	TPM_BUFSIZE = 4096,
>>   	TPM_NUM_DEVICES = 65536,
>>   	TPM_RETRY = 50,		/* 5 seconds */
>> +	TPM_NUM_EVENT_LOG_FILES = 3,
>>   };
>>
>>   enum tpm_timeout {
>> @@ -171,7 +172,7 @@ struct tpm_chip {
>>   	unsigned long duration[3]; /* jiffies */
>>   	bool duration_adjusted;
>>
>> -	struct dentry **bios_dir;
>> +	struct dentry *bios_dir[TPM_NUM_EVENT_LOG_FILES];
>>
>>   	const struct attribute_group *groups[3];
>>   	unsigned int groups_cnt;
>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
>> index 9467e31..62e9da6 100644
>> --- a/drivers/char/tpm/tpm_eventlog.c
>> +++ b/drivers/char/tpm/tpm_eventlog.c
>> @@ -368,54 +368,47 @@ static int is_bad(void *p)
>>   	return 0;
>>   }
>>
>> -struct dentry **tpm_bios_log_setup(const char *name)
>> +int tpm_bios_log_setup(struct tpm_chip *chip)
>>   {
>> -	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
>> +	const char *name = dev_name(&chip->dev);
>> +	unsigned int cnt;
>>
>> -	tpm_dir = securityfs_create_dir(name, NULL);
>> -	if (is_bad(tpm_dir))
>> -		goto out;
>> +	cnt = 0;
>> +	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
>> +	if (is_bad(chip->bios_dir[cnt]))
>> +		goto err;
>> +	cnt++;
>>
>> -	bin_file =
>> +	chip->bios_dir[cnt] =
>>   	    securityfs_create_file("binary_bios_measurements",
>> -				   0440, tpm_dir,
>> +				   0440, chip->bios_dir[0],
>>   				   (void *)&tpm_binary_b_measurements_seqops,
>>   				   &tpm_bios_measurements_ops);
>> -	if (is_bad(bin_file))
>> -		goto out_tpm;
>> +	if (is_bad(chip->bios_dir[cnt]))
>> +		goto err;
>> +	cnt++;
>>
>> -	ascii_file =
>> +	chip->bios_dir[cnt] =
>>   	    securityfs_create_file("ascii_bios_measurements",
>> -				   0440, tpm_dir,
>> +				   0440, chip->bios_dir[0],
>>   				   (void *)&tpm_ascii_b_measurements_seqops,
>>   				   &tpm_bios_measurements_ops);
>> -	if (is_bad(ascii_file))
>> -		goto out_bin;
>> +	if (is_bad(chip->bios_dir[cnt]))
>> +		goto err;
>> +	cnt++;
>>
>> -	ret = kmalloc(3 * sizeof(struct dentry *), GFP_KERNEL);
>> -	if (!ret)
>> -		goto out_ascii;
>> -
>> -	ret[0] = ascii_file;
>> -	ret[1] = bin_file;
>> -	ret[2] = tpm_dir;
>> -
>> -	return ret;
>> +	return 0;
>>
>> -out_ascii:
>> -	securityfs_remove(ascii_file);
>> -out_bin:
>> -	securityfs_remove(bin_file);
>> -out_tpm:
>> -	securityfs_remove(tpm_dir);
>> -out:
>> -	return NULL;
>> +err:
>> +	chip->bios_dir[cnt] = NULL;
>> +	tpm_bios_log_teardown(chip);
>> +	return -EIO;
>>   }
>>
>> -void tpm_bios_log_teardown(struct dentry **lst)
>> +void tpm_bios_log_teardown(struct tpm_chip *chip)
>>   {
>>   	int i;
>>
>> -	for (i = 0; i < 3; i++)
>> -		securityfs_remove(lst[i]);
>> +	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--)
>> +		securityfs_remove(chip->bios_dir[i]);
>>   }
>> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
>> index 8de62b0..fd3357e 100644
>> --- a/drivers/char/tpm/tpm_eventlog.h
>> +++ b/drivers/char/tpm/tpm_eventlog.h
>> @@ -77,14 +77,14 @@ int read_log(struct tpm_bios_log *log);
>>
>>   #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
>>   	defined(CONFIG_ACPI)
>> -extern struct dentry **tpm_bios_log_setup(const char *);
>> -extern void tpm_bios_log_teardown(struct dentry **);
>> +extern int tpm_bios_log_setup(struct tpm_chip *chip);
>> +extern void tpm_bios_log_teardown(struct tpm_chip *chip);
>>   #else
>> -static inline struct dentry **tpm_bios_log_setup(const char *name)
>> +static inline int tpm_bios_log_setup(struct tpm_chip *chip)
>>   {
>> -	return NULL;
>> +	return 0;
>>   }
>> -static inline void tpm_bios_log_teardown(struct dentry **dir)
>> +static inline void tpm_bios_log_teardown(struct tpm_chip *chip)
>>   {
>>   }
>>   #endif
>> --
>> 2.5.0
>>
>

