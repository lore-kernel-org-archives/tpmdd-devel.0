From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v4 8/8] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Sun, 9 Oct 2016 07:32:20 +0530
Message-ID: <57F9A52C.7050405@linux.vnet.ibm.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-9-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001115154.GB8664@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161001115154.GB8664-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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



On 10/01/2016 05:21 PM, Jarkko Sakkinen wrote:
> On Wed, Sep 28, 2016 at 04:34:42AM -0400, Nayna Jain wrote:
>> Unlike the device driver support for TPM 1.2, the TPM 2.0 support
>> does not create the securityfs pseudo files for displaying the
>> firmware event log.
>>
>> This patch enables support for providing the TPM 2.0 event log in
>> binary form. TPM 2.0 event log supports a crypto agile format that
>> records multiple digests, which is different from TPM 1.2. This
>> patch adds the TPM 2.0 event log parser to understand the crypto
>> agile format.
>
> I'll got through the patch (the split comment is valid)

Sure, will do it.

>
>> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/char/tpm/Makefile            |   2 +-
>>   drivers/char/tpm/tpm-chip.c          |  26 ++---
>>   drivers/char/tpm/tpm2.h              |  79 +++++++++++++
>>   drivers/char/tpm/tpm2_eventlog.c     | 216 +++++++++++++++++++++++++++++++++++
>>   drivers/char/tpm/tpm_eventlog_init.c |  30 +++--
>>   drivers/char/tpm/tpm_of.c            |  26 ++++-
>>   6 files changed, 348 insertions(+), 31 deletions(-)
>>   create mode 100644 drivers/char/tpm/tpm2.h
>>   create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>>
>> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>> index 1dc2671..f185a6a5 100644
>> --- a/drivers/char/tpm/Makefile
>> +++ b/drivers/char/tpm/Makefile
>> @@ -3,7 +3,7 @@
>>   #
>>   obj-$(CONFIG_TCG_TPM) += tpm.o
>>   tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
>> -		tpm_eventlog.o tpm_eventlog_init.o
>> +		tpm_eventlog.o tpm_eventlog_init.o tpm2_eventlog.o
>>   tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>>   tpm-$(CONFIG_OF) += tpm_of.o
>>   obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 826609d..72715fa 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -278,23 +278,12 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>>
>>   static int tpm1_chip_register(struct tpm_chip *chip)
>>   {
>> -	int rc;
>>   	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>>   		return 0;
>>
>>   	tpm_sysfs_add_device(chip);
>>
>> -	rc = tpm_bios_log_setup(chip);
>> -
>> -	return rc;
>> -}
>> -
>> -static void tpm1_chip_unregister(struct tpm_chip *chip)
>> -{
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> -		return;
>> -
>> -	tpm_bios_log_teardown(chip);
>> +	return 0;
>>   }
>>
>>   static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>> @@ -370,10 +359,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>>   	tpm_add_ppi(chip);
>>
>>   	rc = tpm_add_char_device(chip);
>> -	if (rc) {
>> -		tpm1_chip_unregister(chip);
>> +	if (rc)
>>   		return rc;
>> -	}
>>
>>   	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
>>
>> @@ -383,6 +370,12 @@ int tpm_chip_register(struct tpm_chip *chip)
>>   		return rc;
>>   	}
>>
>> +	rc = tpm_bios_log_setup(chip);
>> +	if (rc) {
>> +		tpm_chip_unregister(chip);
>> +		return rc;
>> +	}
>> +
>>   	return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(tpm_chip_register);
>> @@ -405,9 +398,10 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>>   	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
>>   		return;
>>
>> +	tpm_bios_log_teardown(chip);
>> +
>>   	tpm_del_legacy_sysfs(chip);
>>
>> -	tpm1_chip_unregister(chip);
>>   	tpm_del_char_device(chip);
>>   }
>>   EXPORT_SYMBOL_GPL(tpm_chip_unregister);
>
> This is good place for split. Do a separate patch that moves the BIOS
> log setup to tpm_chip_register(). In the preceding commit, just return
> if the chip is TPM2

Ok. Sure.

>> diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
>> new file mode 100644
>> index 0000000..399c15c
>> --- /dev/null
>> +++ b/drivers/char/tpm/tpm2.h
>> @@ -0,0 +1,79 @@
>> +#ifndef __TPM2_H__
>> +#define __TPM2_H__
>> +
>> +#define TPM_ALG_SHA1_DIGEST_SIZE	20
>> +#define TPM_ALG_SHA256_DIGEST_SIZE	32
>> +#define TPM_ALG_SHA384_DIGEST_SIZE	48
>> +
>> +#define HASH_COUNT	3
>> +#define MAX_TPM_LOG_MSG	128
>> +#define MAX_DIGEST_SIZE	64
>> +
>> +/**
>> + * All the structures related to Event Log are taken from TCG EFI Protocol
>> + * Specification, Family "2.0". Document is available on link
>> + * http://www.trustedcomputinggroup.org/tcg-efi-protocol-specification/
>> + * Information is also available on TCG PC Client Platform Firmware Profile
>> + * Specification, Family "2.0"
>> + * Detailed digest structures for TPM 2.0 are defined in document
>> + * Trusted Platform Module Library Part 2: Structures, Family "2.0".
>> + */
>> +
>> +/* Event log header algorithm spec. */
>> +struct tcg_efispecideventalgorithmsize {
>> +	u16	alg_id;
>> +	u16	digest_size;
>> +} __packed;
>> +
>> +/* Event log header data. */
>> +struct tcg_efispecideventstruct {
>> +	u8					signature[16];
>> +	u32					platform_class;
>> +	u8					spec_version_minor;
>> +	u8					spec_version_major;
>> +	u8					spec_errata;
>> +	u8					uintnsize;
>> +	u32					num_algs;
>> +	struct tcg_efispecideventalgorithmsize	digest_sizes[HASH_COUNT];
>> +	u8					vendor_info_size;
>> +	u8					vendor_info[0];
>> +} __packed;
>
> I think it would be good practice for the subsystem that struct fields
> the fields are not aligned like this because it can easily break down
> (not it in this particular case but some times you need to add nested
> unions to structures).
>
> For enums, it's easy to stay consistent and it improves readability.
> There pros override cons (in a rare occasion you might need to realign
> the fields).
>
> I had discussion about this before with Jason. If I understood his point
> right he was not aligning both for structs and enums. I agree with that
> for structs.
>
> I know that in tpm2-cmd.c I used aligning for structs but I think it
> was not a good idea afterall.

Sure, will change this.

>
>> +
>> +/* Header entry for eventlog. */
>> +struct tcg_pcr_event {
>> +	u32	pcr_idx;
>> +	u32	event_type;
>> +	u8	digest[20];
>> +	u32	event_size;
>> +	u8	event[MAX_TPM_LOG_MSG];
>> +} __packed;
>> +
>> +/* Crypto Agile algorithm and respective digest. */
>> +struct tpmt_ha {
>> +	u16		alg_id;
>> +	u8		digest[MAX_DIGEST_SIZE];
>> +} __packed;
>> +
>> +/* Crypto agile digests list. */
>> +struct tpml_digest_values {
>> +	u32		count;
>> +	struct tpmt_ha	digests[HASH_COUNT];
>> +} __packed;
>> +
>> +/* Event field structure. */
>> +struct tcg_event_field {
>> +	u32	event_size;
>> +	u8      event[MAX_TPM_LOG_MSG];
>> +} __packed;
>> +
>> +/* Crypto agile log entry format for TPM 2.0. */
>> +struct tcg_pcr_event2 {
>> +	u32				pcr_idx;
>> +	u32				event_type;
>> +	struct tpml_digest_values	digests;
>> +	struct tcg_event_field		event;
>> +} __packed;
>> +
>> +extern const struct seq_operations tpm2_binary_b_measurments_seqops;
>
> There's a typo here. Also I'm wondering what this '_b_' stands for?

I guess you mean the typo in measurments spelling.

Naming convention is taken from existing naming for TPM 1.2 eventlog.
And if I understood correctly, _b_ implied bios.. so 
binary_bios_measurements.

>
>> +
>> +#endif
>> diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
>> new file mode 100644
>> index 0000000..32c7d5c
>> --- /dev/null
>> +++ b/drivers/char/tpm/tpm2_eventlog.c
>> @@ -0,0 +1,216 @@
>> +/*
>> + * Copyright (C) 2016 IBM Corporation
>> + *
>> + * Authors:
>> + *      Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> + *
>> + * Access to TPM 2.0 event log as written by Firmware.
>> + * It assumes that writer of event log has followed TCG Spec 2.0
>> + * has written the event struct data in little endian. With that,
>> + * it doesn't need any endian conversion for structure content.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version
>> + * 2 of the License, or (at your option) any later version.
>> + */
>> +
>> +#include <linux/seq_file.h>
>> +#include <linux/fs.h>
>> +#include <linux/security.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +
>> +#include "tpm.h"
>> +#include "tpm2.h"
>> +#include "tpm_eventlog.h"
>> +
>> +
>> +static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
>> +		struct tcg_pcr_event *event_header)
>> +{
>> +	struct tcg_efispecideventstruct *efispecid;
>> +	struct tcg_event_field *event_field;
>> +	void *marker, *marker_start;
>> +	int i, j;
>> +	u16 halg;
>> +	u32 halg_size;
>> +	size_t size = 0;
>> +
>> +	/*
>> +	 * NOTE: TPM 2.0 supports extend to multiple PCR Banks. This implies
>> +	 * event log also has multiple digest values, one for each PCR Bank.
>> +	 * This is called Crypto Agile Log Entry Format.
>> +	 * TCG EFI Protocol Specification defines the procedure to parse
>> +	 * the event log. Below code implements this procedure to parse
>> +	 * correctly the Crypto agile log entry format.
>> +	 * Example of Crypto Agile Log Digests Format :
>> +	 * digest_values.count = 2;
>> +	 * digest_values.digest[0].alg_id = sha1;
>> +	 * digest_values.digest[0].digest.sha1 = {20 bytes raw data};
>> +	 * digest_values.digest[1].alg_id = sha256;
>> +	 * digest_values.digest[1].digest.sha256 = {32 bytes raw data};
>> +	 * Offset of eventsize is sizeof(count) + sizeof(alg_id) + 20
>> +	 *			+ sizeof(alg_id) + 32;
>> +	 *
>> +	 * Since, offset of event_size can vary based on digests count, offset
>> +	 * has to be calculated at run time. void *marker is used to traverse
>> +	 * the dynamic structure and calculate the offset of event_size.
>> +	 */
>> +
>> +	marker = event;
>> +	marker_start = marker;
>> +	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
>> +		+ sizeof(event->digests.count);
>> +
>> +	efispecid = (struct tcg_efispecideventstruct *) event_header->event;
>> +
>> +	for (i = 0; (i < event->digests.count) && (i < HASH_COUNT); i++) {
>> +		halg_size = sizeof(event->digests.digests[i].alg_id);
>> +		memcpy(&halg, marker, halg_size);
>> +		marker = marker + halg_size;
>> +		for (j = 0; (j < efispecid->num_algs); j++) {
>> +			if (halg == efispecid->digest_sizes[j].alg_id) {
>> +				marker = marker +
>> +					efispecid->digest_sizes[j].digest_size;
>> +				break;
>> +			}
>> +		}
>> +	}
>> +
>> +	event_field = (struct tcg_event_field *) marker;
>> +	marker = marker + sizeof(event_field->event_size)
>> +		+ event_field->event_size;
>> +	size = marker - marker_start;
>> +
>> +	if ((event->event_type == 0) && (event_field->event_size == 0))
>> +		return 0;
>> +
>> +	return size;
>> +}
>> +
>> +static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
>> +{
>> +	struct tpm_bios_log *log = m->private;
>> +	void *addr = log->bios_event_log;
>> +	void *limit = log->bios_event_log_end;
>> +	struct tcg_pcr_event *event_header;
>> +	struct tcg_pcr_event2 *event;
>> +	int i;
>> +	size_t size = 0;
>> +
>> +	event_header = addr;
>> +
>> +	size = sizeof(struct tcg_pcr_event) - sizeof(event_header->event)
>> +		+ event_header->event_size;
>> +
>> +
>> +	if (*pos == 0) {
>> +		if (addr + size < limit) {
>> +			if ((event_header->event_type == 0) &&
>> +					(event_header->event_size == 0))
>> +				return NULL;
>> +			return SEQ_START_TOKEN;
>> +		}
>> +	}
>> +
>> +	if (*pos > 0) {
>> +		addr += size;
>> +		event = addr;
>> +		size = calc_tpm2_event_size(event, event_header);
>> +		if ((addr + size >=  limit) || (size == 0))
>> +			return NULL;
>> +	}
>> +
>> +	/* read over *pos measurements */
>> +	for (i = 0; i < (*pos - 1); i++) {
>> +		event = addr;
>> +		size = calc_tpm2_event_size(event, event_header);
>> +
>> +		if ((addr + size >= limit) || (size == 0))
>> +			return NULL;
>> +		addr += size;
>> +	}
>> +
>> +	return addr;
>> +}
>> +
>> +static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
>> +		loff_t *pos)
>> +{
>> +	struct tcg_pcr_event *event_header;
>> +	struct tcg_pcr_event2 *event;
>> +	struct tpm_bios_log *log = m->private;
>> +	void *limit = log->bios_event_log_end;
>> +	void *marker;
>> +	size_t event_size = 0;
>> +
>> +	event_header = log->bios_event_log;
>> +
>> +	if (v == SEQ_START_TOKEN) {
>> +		event_size = sizeof(struct tcg_pcr_event)
>> +			- sizeof(event_header->event)
>> +			+ event_header->event_size;
>> +		marker = event_header;
>> +	} else {
>> +		event = v;
>> +		event_size = calc_tpm2_event_size(event, event_header);
>> +		if (event_size == 0)
>> +			return NULL;
>> +		marker =  event;
>> +	}
>> +
>> +	marker = marker + event_size;
>> +	if (marker >= limit)
>> +		return NULL;
>> +	v = marker;
>> +	event = v;
>> +
>> +	event_size = calc_tpm2_event_size(event, event_header);
>> +	if (((v + event_size) >= limit) || (event_size == 0))
>> +		return NULL;
>> +
>> +	(*pos)++;
>> +	return v;
>> +}
>> +
>> +static void tpm2_bios_measurements_stop(struct seq_file *m, void *v)
>> +{
>> +}
>> +
>> +static int tpm2_binary_bios_measurements_show(struct seq_file *m, void *v)
>> +{
>> +	struct tpm_bios_log *log = m->private;
>> +	struct tcg_pcr_event *event_header = log->bios_event_log;
>> +	struct tcg_pcr_event2 *event = v;
>> +	void *temp_ptr;
>> +	size_t size = 0;
>> +
>> +	if (v == SEQ_START_TOKEN) {
>> +
>
> Extra new line.
Will fix.

>
>> +		size = sizeof(struct tcg_pcr_event)
>> +			- sizeof(event_header->event)
>> +			+ event_header->event_size;
>> +
>> +		temp_ptr = event_header;
>> +
>> +		if (size > 0)
>> +			seq_write(m, temp_ptr, size);
>> +	} else {
>> +
>
> Extra new line.
Will fix.
>
>> +		size = calc_tpm2_event_size(event, event_header);
>> +
>> +		temp_ptr = event;
>> +		if (size > 0)
>> +			seq_write(m, temp_ptr, size);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +const struct seq_operations tpm2_binary_b_measurments_seqops = {
>> +	.start = tpm2_bios_measurements_start,
>> +	.next = tpm2_bios_measurements_next,
>> +	.stop = tpm2_bios_measurements_stop,
>> +	.show = tpm2_binary_bios_measurements_show,
>> +};
>
> I don't want to go too much into reviewing these because I don't have
> facilities to run this code. Overrally it looks good to me (not same
> as reviewed-by).

Sure. Will include the feedbacks in my next version of patches.

Thanks & Regards,
   - Nayna

>
>> diff --git a/drivers/char/tpm/tpm_eventlog_init.c b/drivers/char/tpm/tpm_eventlog_init.c
>> index c4ac42630..aaac0e9 100644
>> --- a/drivers/char/tpm/tpm_eventlog_init.c
>> +++ b/drivers/char/tpm/tpm_eventlog_init.c
>> @@ -28,6 +28,7 @@
>>   #include <linux/slab.h>
>>
>>   #include "tpm.h"
>> +#include "tpm2.h"
>>   #include "tpm_eventlog.h"
>>
>>   static int tpm_bios_measurements_release(struct inode *inode,
>> @@ -114,7 +115,11 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   	chip->bios_dir_count++;
>>
>>   	chip->bin_sfs_data.log = &chip->log;
>> -	chip->bin_sfs_data.seqops = &tpm_binary_b_measurments_seqops;
>> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +		chip->bin_sfs_data.seqops = &tpm2_binary_b_measurments_seqops;
>> +	else
>> +		chip->bin_sfs_data.seqops = &tpm_binary_b_measurments_seqops;
>> +
>>
>>   	chip->bios_dir[chip->bios_dir_count] =
>>   	    securityfs_create_file("binary_bios_measurements",
>> @@ -125,16 +130,19 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   		goto err;
>>   	chip->bios_dir_count++;
>>
>> -	chip->ascii_sfs_data.log = &chip->log;
>> -	chip->ascii_sfs_data.seqops =  &tpm_ascii_b_measurments_seqops;
>> -	chip->bios_dir[chip->bios_dir_count] =
>> -	    securityfs_create_file("ascii_bios_measurements",
>> -				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>> -				   (void *)&chip->ascii_sfs_data,
>> -				   &tpm_bios_measurements_ops);
>> -	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
>> -		goto err;
>> -	chip->bios_dir_count++;
>> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
>> +		chip->ascii_sfs_data.log = &chip->log;
>> +		chip->ascii_sfs_data.seqops =
>> +			&tpm_ascii_b_measurments_seqops;
>> +		chip->bios_dir[chip->bios_dir_count] =
>> +			securityfs_create_file("ascii_bios_measurements",
>> +				       S_IRUSR | S_IRGRP, chip->bios_dir[0],
>> +				       (void *)&chip->ascii_sfs_data,
>> +				       &tpm_bios_measurements_ops);
>> +		if (is_bad(chip->bios_dir[chip->bios_dir_count]))
>> +			goto err;
>> +		chip->bios_dir_count++;
>> +	}
>>
>>   	return 0;
>>
>> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
>> index 1464cae..d4151b5 100644
>> --- a/drivers/char/tpm/tpm_of.c
>> +++ b/drivers/char/tpm/tpm_of.c
>> @@ -17,6 +17,7 @@
>>
>>   #include <linux/slab.h>
>>   #include <linux/of.h>
>> +#include <linux/string.h>
>>
>>   #include "tpm.h"
>>   #include "tpm_eventlog.h"
>> @@ -27,6 +28,7 @@ int read_log_of(struct tpm_chip *chip)
>>   	const u32 *sizep;
>>   	const u64 *basep;
>>   	struct tpm_bios_log *log;
>> +	u32 log_size;
>>
>>   	log = &chip->log;
>>   	if (chip->dev.parent->of_node)
>> @@ -46,19 +48,37 @@ int read_log_of(struct tpm_chip *chip)
>>   		return -EIO;
>>   	}
>>
>> +	/*
>> +	 * For both vtpm/tpm, firmware has log addr and log size in big
>> +	 * endian format. But in case of vtpm, there is a method called
>> +	 * sml-handover which is run during kernel init even before
>> +	 * device tree is setup. This sml-handover function takes care
>> +	 * of endianness and writes to sml-base and sml-size in little
>> +	 * endian format. For this reason, vtpm doesn't need conversion
>> +	 * but physical tpm needs the conversion.
>> +	 */
>> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
>> +		log_size = be32_to_cpup(sizep);
>> +	else
>> +		log_size = *sizep;
>> +
>>   	basep = of_get_property(np, "linux,sml-base", NULL);
>>   	if (basep == NULL) {
>>   		dev_dbg(&chip->dev, "%s: ERROR - SML not found\n", __func__);
>>   		return -EIO;
>>   	}
>>
>> -	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
>> +	log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
>>   	if (!log->bios_event_log)
>>   		return -ENOMEM;
>>
>> -	log->bios_event_log_end = log->bios_event_log + *sizep;
>> +	log->bios_event_log_end = log->bios_event_log + log_size;
>>
>> -	memcpy(log->bios_event_log, __va(*basep), *sizep);
>> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
>> +		memcpy(chip->log.bios_event_log, __va(be64_to_cpup(basep)),
>> +		       log_size);
>> +	else
>> +		memcpy(chip->log.bios_event_log, __va(*basep), log_size);
>>
>>   	return 0;
>>   }
>> --
>> 2.5.0
>>
>
> /Jarkko
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
