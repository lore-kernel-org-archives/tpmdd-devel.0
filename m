From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 2/2] tpm: add securityfs support for TPM 2.0 firmware
 event log
Date: Tue, 3 Jan 2017 13:09:18 +0530
Message-ID: <586B5526.9090703@linux.vnet.ibm.com>
References: <1481434533-3453-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1481434533-3453-3-git-send-email-nayna@linux.vnet.ibm.com>
 <20170102221148.gy3mlubrgs4gm6ey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170102221148.gy3mlubrgs4gm6ey@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 01/03/2017 03:42 AM, Jarkko Sakkinen wrote:
> On Sun, Dec 11, 2016 at 12:35:33AM -0500, Nayna Jain wrote:
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
>> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
>
> There is something fundamentally wrong in this commit.
>
> You must not allow this feature unless CONFIG_OF is set. It is the only
> interface where the supply path of the event log is well defined on
> platforms that include a TPM 2.0 chip.

As per current implementation, if ACPI with TPM 2.0 doesn't support 
event log, tpm_read_log_acpi() is expected to return rc and 
tpm_bios_log_setup will not create securityfs. This is inline with our 
design for TPM 1.2 event log.

>
> There's buch casts in the form '(char *) foo'. They should be
> '(char *)foo'.

Will fix these and other comments.

Thanks & Regards,
     - Nayna

>
>> ---
>>   drivers/char/tpm/Makefile                          |   2 +-
>>   .../char/tpm/{tpm_eventlog.c => tpm1_eventlog.c}   |  35 ++--
>>   drivers/char/tpm/tpm2_eventlog.c                   | 203 +++++++++++++++++++++
>>   drivers/char/tpm/tpm_eventlog.h                    |  70 +++++++
>>   4 files changed, 295 insertions(+), 15 deletions(-)
>>   rename drivers/char/tpm/{tpm_eventlog.c => tpm1_eventlog.c} (95%)
>>   create mode 100644 drivers/char/tpm/tpm2_eventlog.c
>>
>> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
>> index a05b1eb..3d386a8 100644
>> --- a/drivers/char/tpm/Makefile
>> +++ b/drivers/char/tpm/Makefile
>> @@ -3,7 +3,7 @@
>>   #
>>   obj-$(CONFIG_TCG_TPM) += tpm.o
>>   tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o \
>> -		tpm_eventlog.o
>> +		tpm1_eventlog.o tpm2_eventlog.o
>>   tpm-$(CONFIG_ACPI) += tpm_ppi.o tpm_acpi.o
>>   tpm-$(CONFIG_OF) += tpm_of.o
>>   obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
>> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm1_eventlog.c
>> similarity index 95%
>> rename from drivers/char/tpm/tpm_eventlog.c
>> rename to drivers/char/tpm/tpm1_eventlog.c
>> index 11bb113..9a8605e 100644
>> --- a/drivers/char/tpm/tpm_eventlog.c
>> +++ b/drivers/char/tpm/tpm1_eventlog.c
>> @@ -390,9 +390,6 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   	unsigned int cnt;
>>   	int rc = 0;
>>
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> -		return 0;
>> -
>>   	rc = tpm_read_log(chip);
>>   	if (rc)
>>   		return rc;
>> @@ -407,7 +404,13 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   	cnt++;
>>
>>   	chip->bin_log_seqops.chip = chip;
>> -	chip->bin_log_seqops.seqops = &tpm_binary_b_measurements_seqops;
>> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> +		chip->bin_log_seqops.seqops =
>> +			&tpm2_binary_b_measurements_seqops;
>> +	else
>> +		chip->bin_log_seqops.seqops =
>> +			&tpm_binary_b_measurements_seqops;
>> +
>>
>>   	chip->bios_dir[cnt] =
>>   	    securityfs_create_file("binary_bios_measurements",
>> @@ -418,17 +421,21 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>>   		goto err;
>>   	cnt++;
>>
>> -	chip->ascii_log_seqops.chip = chip;
>> -	chip->ascii_log_seqops.seqops = &tpm_ascii_b_measurements_seqops;
>> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
>>
>> -	chip->bios_dir[cnt] =
>> -	    securityfs_create_file("ascii_bios_measurements",
>> -				   0440, chip->bios_dir[0],
>> -				   (void *)&chip->ascii_log_seqops,
>> -				   &tpm_bios_measurements_ops);
>> -	if (IS_ERR(chip->bios_dir[cnt]))
>> -		goto err;
>> -	cnt++;
>> +		chip->ascii_log_seqops.chip = chip;
>> +		chip->ascii_log_seqops.seqops =
>> +			&tpm_ascii_b_measurements_seqops;
>> +
>> +		chip->bios_dir[cnt] =
>> +			securityfs_create_file("ascii_bios_measurements",
>> +					       0440, chip->bios_dir[0],
>> +					       (void *)&chip->ascii_log_seqops,
>> +					       &tpm_bios_measurements_ops);
>> +		if (IS_ERR(chip->bios_dir[cnt]))
>> +			goto err;
>> +		cnt++;
>> +	}
>>
>>   	return 0;
>>
>> diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
>> new file mode 100644
>> index 0000000..63690d3
>> --- /dev/null
>> +++ b/drivers/char/tpm/tpm2_eventlog.c
>> @@ -0,0 +1,203 @@
>> +/*
>> + * Copyright (C) 2016 IBM Corporation
>> + *
>> + * Authors:
>> + *      Nayna Jain <nayna@linux.vnet.ibm.com>
>> + *
>> + * Access to TPM 2.0 event log as written by Firmware.
>> + * It assumes that writer of event log has followed TCG Specification
>> + * for Family "2.0" and written the event data in little endian.
>> + * With that, it doesn't need any endian conversion for structure
>> + * content.
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
>> +#include "tpm_eventlog.h"
>> +
>> +static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
>> +		struct tcg_pcr_event *event_header)
>
> Bad alignment.
>
>> +{
>> +	struct tcg_efi_specid_event *efispecid;
>> +	struct tcg_event_field *event_field;
>> +	void *marker;
>> +	void *marker_start;
>> +	int i;
>> +	int j;
>> +	u16 halg;
>> +	u32 halg_size;
>> +	size_t size;
>> +
>> +	/*
>> +	 * TPM 2.0 supports extend to multiple PCR Banks. This implies
>> +	 * event log also has multiple digest values, one for each PCR Bank.
>> +	 * This is called Crypto Agile Log Entry Format.
>> +	 * Below code implements the procedure defined in TCG EFI Protocol
>> +	 * Specification Family "2.0" to parse the event log in Crypto Agile
>> +	 * Log Entry Format.
>> +	 */
>
> Please, document the function and remove this inline comment.
>
>> +
>> +	marker = event;
>> +	marker_start = marker;
>> +	marker = marker + sizeof(event->pcr_idx) + sizeof(event->event_type)
>> +		+ sizeof(event->digests.count);
>> +
>> +	efispecid = (struct tcg_efi_specid_event *) event_header->event;
>> +
>> +	for (i = 0; (i < event->digests.count) && (i < TPM2_ACTIVE_PCR_BANKS);
>> +	     i++) {
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
>> +	struct tpm_chip *chip = m->private;
>> +	struct tpm_bios_log *log = &chip->log;
>> +	void *addr = log->bios_event_log;
>> +	void *limit = log->bios_event_log_end;
>> +	struct tcg_pcr_event *event_header;
>> +	struct tcg_pcr_event2 *event;
>> +	int i;
>> +	size_t size;
>> +
>> +	event_header = addr;
>> +	size = sizeof(struct tcg_pcr_event) - sizeof(event_header->event)
>> +		+ event_header->event_size;
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
>> +	struct tpm_chip *chip = m->private;
>> +	struct tpm_bios_log *log = &chip->log;
>> +	void *limit = log->bios_event_log_end;
>> +	void *marker;
>> +	size_t event_size;
>> +
>> +	event_header = log->bios_event_log;
>> +
>> +	if (v == SEQ_START_TOKEN) {
>> +		event_size = sizeof(struct tcg_pcr_event)
>> +			- sizeof(event_header->event)
>> +			+ event_header->event_size;
>
> Bad alignment. Please, check the whole commit and if there is more of
> these..
>
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
>> +	struct tpm_chip *chip = m->private;
>> +	struct tpm_bios_log *log = &chip->log;
>> +	struct tcg_pcr_event *event_header = log->bios_event_log;
>> +	struct tcg_pcr_event2 *event = v;
>> +	void *temp_ptr;
>> +	size_t size;
>> +
>> +	if (v == SEQ_START_TOKEN) {
>> +		size = sizeof(struct tcg_pcr_event)
>> +			- sizeof(event_header->event)
>> +			+ event_header->event_size;
>> +
>> +		temp_ptr = event_header;
>> +
>> +		if (size > 0)
>> +			seq_write(m, temp_ptr, size);
>> +	} else {
>> +		size = calc_tpm2_event_size(event, event_header);
>> +		temp_ptr = event;
>> +		if (size > 0)
>> +			seq_write(m, temp_ptr, size);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +const struct seq_operations tpm2_binary_b_measurements_seqops = {
>> +	.start = tpm2_bios_measurements_start,
>> +	.next = tpm2_bios_measurements_next,
>> +	.stop = tpm2_bios_measurements_stop,
>> +	.show = tpm2_binary_bios_measurements_show,
>> +};
>> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
>> index 1660d74..6886a11 100644
>> --- a/drivers/char/tpm/tpm_eventlog.h
>> +++ b/drivers/char/tpm/tpm_eventlog.h
>> @@ -2,9 +2,12 @@
>>   #ifndef __TPM_EVENTLOG_H__
>>   #define __TPM_EVENTLOG_H__
>>
>> +#include <crypto/hash_info.h>
>> +
>>   #define TCG_EVENT_NAME_LEN_MAX	255
>>   #define MAX_TEXT_EVENT		1000	/* Max event string length */
>>   #define ACPI_TCPA_SIG		"TCPA"	/* 0x41504354 /'TCPA' */
>> +#define TPM2_ACTIVE_PCR_BANKS	3
>>
>>   #ifdef CONFIG_PPC64
>>   #define do_endian_conversion(x) be32_to_cpu(x)
>> @@ -73,6 +76,73 @@ enum tcpa_pc_event_ids {
>>   	HOST_TABLE_OF_DEVICES,
>>   };
>>
>> +/*
>> + * All the structures related to TPM 2.0 Event Log are taken from TCG EFI
>> + * Protocol Specification, Family "2.0". Document is available on link
>> + * http://www.trustedcomputinggroup.org/tcg-efi-protocol-specification/ .
>> + * Information is also available on TCG PC Client Platform Firmware Profile
>> + * Specification, Family "2.0".
>> + * Detailed digest structures for TPM 2.0 are defined in document
>> + * Trusted Platform Module Library Part 2: Structures, Family "2.0".
>> + */
>> +
>> +/* TPM 2.0 Event log header algorithm spec. */
>> +struct tcg_efi_specid_event_algs {
>> +	u16 alg_id;
>> +	u16 digest_size;
>> +} __packed;
>> +
>> +/* TPM 2.0 Event log header data. */
>> +struct tcg_efi_specid_event {
>> +	u8 signature[16];
>> +	u32 platform_class;
>> +	u8 spec_version_minor;
>> +	u8 spec_version_major;
>> +	u8 spec_errata;
>> +	u8 uintnsize;
>> +	u32 num_algs;
>> +	struct tcg_efi_specid_event_algs digest_sizes[TPM2_ACTIVE_PCR_BANKS];
>> +	u8 vendor_info_size;
>> +	u8 vendor_info[0];
>> +} __packed;
>> +
>> +/* TPM 2.0 Event Log Header. */
>> +struct tcg_pcr_event {
>> +	u32 pcr_idx;
>> +	u32 event_type;
>> +	u8 digest[20];
>> +	u32 event_size;
>> +	u8 event[0];
>> +} __packed;
>> +
>> +/* TPM 2.0 Crypto agile algorithm and respective digest. */
>> +struct tpmt_ha {
>> +	u16 alg_id;
>> +	u8 digest[SHA384_DIGEST_SIZE];
>> +} __packed;
>> +
>> +/* TPM 2.0 Crypto agile digests list. */
>> +struct tpml_digest_values {
>> +	u32 count;
>> +	struct tpmt_ha digests[TPM2_ACTIVE_PCR_BANKS];
>> +} __packed;
>> +
>> +/* TPM 2.0 Event field structure. */
>> +struct tcg_event_field {
>> +	u32 event_size;
>> +	u8 event[0];
>> +} __packed;
>> +
>> +/* TPM 2.0 Crypto agile log entry format. */
>
> These one line comments are next to useless. Please remove them.
>
>> +struct tcg_pcr_event2 {
>> +	u32 pcr_idx;
>> +	u32 event_type;
>> +	struct tpml_digest_values digests;
>> +	struct tcg_event_field event;
>> +} __packed;
>> +
>> +extern const struct seq_operations tpm2_binary_b_measurements_seqops;
>> +
>>   #if defined(CONFIG_ACPI)
>>   int tpm_read_log_acpi(struct tpm_chip *chip);
>>   #else
>> --
>> 2.5.0
>>
>
> /Jarkko
>

