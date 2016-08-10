From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] TPM2.0:Adds securityfs support for
 TPM2.0 eventlog
Date: Wed, 10 Aug 2016 14:25:30 +0300
Message-ID: <20160810112142.GC13929@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-4-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470771295-15680-4-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 03:34:55PM -0400, Nayna Jain wrote:
> Adds securityfs support for TPM2.0.
> This patch currently supports only binary_bios_measurements.
> 
> Changelog v2:
>         * Single tpm_of.c for reading both tpm and vtpm device tree values.
>         * Some of the issues are fixed in Patch 1 itself.
>         * Comments in tpm2.h give reference to the standard from where structs
> 	are taken.
> 	* Now, tpm_of.c has same code applied for both tpm and vtpm, so I think
> 	that now it is needed to have generic types rather than endian specific type.
> 
> There are few preexisting issues as being mentioned in feedback and are not 
> addressed in this patch. Reason being, I don't have much expertise of ACPI side as of now, 
> and these changes will affect acpi,tpm,vtpm, all paths, so I would like to go slow
> and fix them as different patch later after better understanding.
> Hope this sounds ok to have them as different patch.
> 
> Issues which are not addressed are as below:
>         * tpm_eventlog.h still has #ifdef defined, for tpm_bios_log_setup()
>         * tpm_bios_log_setup is still being called in tpm-chip register function.

I do not understand your changelog entries. Please provide a nice one or
most two paragraph english language description and keep breakdowns and
changelogs in the cover letter.

Commit message does not equal to a discussion forum and I do not have
any idea what feedback you are talking about...

Not reviewing this further. This is just terrible.

/Jarkko

> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/char/tpm/Makefile            |   8 +-
>  drivers/char/tpm/tpm-chip.c          |  20 +---
>  drivers/char/tpm/tpm2.h              |  85 +++++++++++++
>  drivers/char/tpm/tpm2_eventlog.c     | 224 +++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_eventlog.h      |   2 +-
>  drivers/char/tpm/tpm_eventlog_init.c |  43 +++++--
>  drivers/char/tpm/tpm_of.c            |  17 ++-
>  7 files changed, 366 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2.h
>  create mode 100644 drivers/char/tpm/tpm2_eventlog.c
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 9136762..509ace2 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -6,10 +6,14 @@ tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
>  tpm-$(CONFIG_ACPI) += tpm_ppi.o
>  
>  ifdef CONFIG_ACPI
> -	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_acpi.o
> +	tpm-y += tpm_eventlog_init.o tpm2_eventlog.o tpm_eventlog.o tpm_acpi.o
>  else
>  ifdef CONFIG_TCG_IBMVTPM
> -	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_of.o
> +	tpm-y += tpm_eventlog_init.o tpm2_eventlog.o tpm_eventlog.o tpm_of.o
> +else
> +ifdef CONFIG_PPC64
> +	tpm-y += tpm_eventlog_init.o tpm2_eventlog.o tpm_eventlog.o tpm_of.o
> +endif
>  endif
>  endif
>  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 7f6cdab..3f1c489 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -285,20 +285,9 @@ static int tpm1_chip_register(struct tpm_chip *chip)
>  
>  	tpm_sysfs_add_device(chip);
>  
> -	tpm_bios_log_setup(chip);
> -
>  	return 0;
>  }
>  
> -static void tpm1_chip_unregister(struct tpm_chip *chip)
> -{
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		return;
> -
> -	if (chip->bios_dir)
> -		tpm_bios_log_teardown(chip);
> -}
> -
>  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>  {
>  	struct attribute **i;
> @@ -372,10 +361,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>  	tpm_add_ppi(chip);
>  
>  	rc = tpm_add_char_device(chip);
> -	if (rc) {
> -		tpm1_chip_unregister(chip);
> +	if (rc)
>  		return rc;
> -	}
>  
>  	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
>  
> @@ -385,6 +372,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>  		return rc;
>  	}
>  
> +	tpm_bios_log_setup(chip);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_register);
> @@ -409,7 +398,8 @@ void tpm_chip_unregister(struct tpm_chip *chip)
>  
>  	tpm_del_legacy_sysfs(chip);
>  
> -	tpm1_chip_unregister(chip);
> +	tpm_bios_log_teardown(chip);
> +
>  	tpm_del_char_device(chip);
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> diff --git a/drivers/char/tpm/tpm2.h b/drivers/char/tpm/tpm2.h
> new file mode 100644
> index 0000000..38a8073
> --- /dev/null
> +++ b/drivers/char/tpm/tpm2.h
> @@ -0,0 +1,85 @@
> +#ifndef __TPM2_H__
> +#define __TPM2_H__
> +
> +#define TPM_ALG_SHA1_DIGEST_SIZE	20
> +#define TPM_ALG_SHA256_DIGEST_SIZE	32
> +#define TPM_ALG_SHA384_DIGEST_SIZE	48
> +
> +#define HASH_COUNT	3
> +#define MAX_TPM_LOG_MSG	128
> +
> +/**
> + * All the structures related to Event Log are taken from TCG EFI Protocol
> + * Specification, Family "2.0". Document is available on link
> + * http://www.trustedcomputinggroup.org/tcg-efi-protocol-specification/
> + * Information is also available on TCG PC Client Platform Firmware Profile
> + * Specification, Family "2.0"
> + * Detailed digest structures for TPM2.0 are defined in document
> + * Trusted Platform Module Library Part 2: Structures, Family "2.0".
> + */
> +
> +/* Event log header algorithm spec. */
> +struct tcg_efispecideventalgorithmsize {
> +	u16	algorithm_id;
> +	u16	digest_size;
> +} __packed;
> +
> +/* Event log header data. */
> +struct tcg_efispecideventstruct {
> +	u8					signature[16];
> +	u32					platform_class;
> +	u8					spec_version_minor;
> +	u8					spec_version_major;
> +	u8					spec_errata;
> +	u8					uintnsize;
> +	u32					num_algs;
> +	struct tcg_efispecideventalgorithmsize	digest_sizes[HASH_COUNT];
> +	u8					vendor_info_size;
> +	u8					vendor_info[0];
> +} __packed;
> +
> +/* Header entry for eventlog. */
> +struct tcg_pcr_event {
> +	u32	pcr_index;
> +	u32	event_type;
> +	u8	digest[20];
> +	u32	event_size;
> +	u8	event[MAX_TPM_LOG_MSG];
> +} __packed;
> +
> +/* Digest union for crypto agility. */
> +union tpmu_ha {
> +	u8	 sha1[TPM_ALG_SHA1_DIGEST_SIZE];
> +	u8	 sha256[TPM_ALG_SHA256_DIGEST_SIZE];
> +	u8	 sha384[TPM_ALG_SHA384_DIGEST_SIZE];
> +} __packed;
> +
> +/* Crypto Agile algorithm and respective digest. */
> +struct tpmt_ha {
> +	u16		algorithm_id;
> +	union tpmu_ha	digest;
> +} __packed;
> +
> +/* Crypto agile digests list. */
> +struct tpml_digest_values {
> +	u32		count;
> +	struct tpmt_ha	digests[HASH_COUNT];
> +} __packed;
> +
> +/* Event field structure. */
> +struct tcg_event_field {
> +	u32	event_size;
> +	u8      event[MAX_TPM_LOG_MSG];
> +} __packed;
> +
> +/* Crypto agile log entry format for TPM 2.0. */
> +struct tcg_pcr_event2 {
> +	u32				pcr_index;
> +	u32				event_type;
> +	struct tpml_digest_values	digests;
> +	struct tcg_event_field		event;
> +} __packed;
> +
> +extern const struct seq_operations tpm2_binary_b_measurments_seqops;
> +
> +#endif
> diff --git a/drivers/char/tpm/tpm2_eventlog.c b/drivers/char/tpm/tpm2_eventlog.c
> new file mode 100644
> index 0000000..f1e8c4a
> --- /dev/null
> +++ b/drivers/char/tpm/tpm2_eventlog.c
> @@ -0,0 +1,224 @@
> +/*
> + * Copyright (C) 2016 IBM Corporation
> + *
> + * Authors:
> + *      Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> +
> + * Access to TPM2.0 event log as written by Firmware.
> + * It assumes that writer of event log has followed TCG Spec 2.0
> + * has written the event struct data in little endian. With that,
> + * it doesn't need any endian conversion for structure content.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/seq_file.h>
> +#include <linux/fs.h>
> +#include <linux/security.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +
> +#include "tpm.h"
> +#include "tpm2.h"
> +#include "tpm_eventlog.h"
> +
> +
> +static int calc_tpm2_event_size(struct tcg_pcr_event2 *event,
> +		struct tcg_pcr_event *event_header)
> +{
> +	struct tcg_efispecideventstruct *efispecid;
> +	struct tcg_event_field *event_field;
> +	void *marker, *marker_start;
> +	int j;
> +	size_t size = 0;
> +
> +	/*
> +	 * NOTE: TPM2.0 allows support for extend to multiple PCR Banks.
> +	 * This implies that eventlog also has multiple digest values
> +	 * one for each PCR Bank. This is called Crypto Agile Log Entry
> +	 * Format. Current support implementation is for SHA1 and SHA256.
> +	 * Number of digest values are identified by parsing first
> +	 * structure stored in event log also called event header.
> +	 * Further, the eventlog is written in packed form so to calculate
> +	 * offset it is important to know the type of algorithm used.
> +	 * Eg. 1:
> +	 * digest_values.count = 1;
> +	 * digest_values.digest[0].algorithm_id = sha1;
> +	 * digest_values.digest[0].digest.sha1 = {20 bytes raw data};
> +	 * Offset of eventsize is sizeof(count) + sizeof(algorithm_id) + 20
> +	 *
> +	 * Eg. 2:
> +	 * digest_values.count = 1;
> +	 * digest_values.digest[0].algorithm_id = sha256;
> +	 * digest_values.digest[0].digest.sha1 = {32 bytes raw data};
> +	 * Offset of eventsize is sizeof(count) + sizeof(algorithm_id) + 32
> +
> +	 * Eg. 3:
> +	 * digest_values.count = 2;
> +	 * digest_values.digest[0].algorithm_id = sha1;
> +	 * digest_values.digest[0].digest.sha1 = {20 bytes raw data};
> +	 * digest_values.digest[1].algorithm_id = sha256;
> +	 * digest_values.digest[1].digest.sha256 = {32 bytes raw data};
> +	 * Offset of eventsize is sizeof(count) + sizeof(algorithm_id) + 20
> +	 *			+ sizeof(algorithm_id) + 32;
> +	 *
> +	 * So, it implies that offset of event_size can vary based on digest
> +	 * values as defined by vendor. And so we have to calculate the
> +	 * offset by parsing through number and type of digests being used.
> +	 * And this is the purpose of using *marker to traverse the structure
> +	 * and calculate the offset of event_size. This function uses *marker
> +	 * to parse and calculate the dynamic size of the whole event structure.
> +	 */
> +
> +	marker = event;
> +	marker_start = marker;
> +	marker = marker + sizeof(event->pcr_index) + sizeof(event->event_type)
> +		+ sizeof(event->digests.count);
> +
> +	efispecid = (struct tcg_efispecideventstruct *) event_header->event;
> +
> +	for (j = 0; (j < efispecid->num_algs) && (j < HASH_COUNT); j++) {
> +		marker = marker
> +			+ sizeof(efispecid->digest_sizes[j].algorithm_id);
> +		marker = marker + efispecid->digest_sizes[j].digest_size;
> +	}
> +
> +	event_field = (struct tcg_event_field *) marker;
> +	marker = marker + sizeof(event_field->event_size)
> +		+ event_field->event_size;
> +	size = marker - marker_start;
> +
> +	if ((event->event_type == 0) && (event_field->event_size == 0))
> +		return 0;
> +
> +	return size;
> +}
> +
> +static void *tpm2_bios_measurements_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct tpm_bios_log *log = m->private;
> +	void *addr = log->bios_event_log;
> +	void *limit = log->bios_event_log_end;
> +	struct tcg_pcr_event *event_header;
> +	struct tcg_pcr_event2 *event;
> +	int i;
> +	size_t size = 0;
> +
> +	event_header = addr;
> +
> +	size = sizeof(struct tcg_pcr_event) - sizeof(event_header->event)
> +		+ event_header->event_size;
> +
> +
> +	if (*pos == 0) {
> +		if (addr + size < limit) {
> +			if ((event_header->event_type == 0) &&
> +					(event_header->event_size == 0))
> +				return NULL;
> +			return SEQ_START_TOKEN;
> +		}
> +	}
> +
> +	if (*pos > 0) {
> +		addr += size;
> +		event = addr;
> +		size = calc_tpm2_event_size(event, event_header);
> +		if ((addr + size >=  limit) || (size == 0))
> +			return NULL;
> +	}
> +
> +	/* read over *pos measurements */
> +	for (i = 0; i < (*pos - 1); i++) {
> +		event = addr;
> +		size = calc_tpm2_event_size(event, event_header);
> +
> +		if ((addr + size >= limit) || (size == 0))
> +			return NULL;
> +		addr += size;
> +	}
> +
> +	return addr;
> +}
> +
> +static void *tpm2_bios_measurements_next(struct seq_file *m, void *v,
> +		loff_t *pos)
> +{
> +	struct tcg_pcr_event *event_header;
> +	struct tcg_pcr_event2 *event;
> +	struct tpm_bios_log *log = m->private;
> +	void *limit = log->bios_event_log_end;
> +	void *marker;
> +	size_t event_size = 0;
> +
> +	event_header = log->bios_event_log;
> +
> +	if (v == SEQ_START_TOKEN) {
> +		event_size = sizeof(struct tcg_pcr_event)
> +			- sizeof(event_header->event)
> +			+ event_header->event_size;
> +		marker = event_header;
> +	} else {
> +		event = v;
> +		event_size = calc_tpm2_event_size(event, event_header);
> +		if (event_size == 0)
> +			return NULL;
> +		marker =  event;
> +	}
> +
> +	marker = marker + event_size;
> +	if (marker >= limit)
> +		return NULL;
> +	v = marker;
> +	event = v;
> +
> +	event_size = calc_tpm2_event_size(event, event_header);
> +	if (((v + event_size) >= limit) || (event_size == 0))
> +		return NULL;
> +
> +	(*pos)++;
> +	return v;
> +}
> +
> +static void tpm2_bios_measurements_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +static int tpm2_binary_bios_measurements_show(struct seq_file *m, void *v)
> +{
> +	struct tpm_bios_log *log = m->private;
> +	struct tcg_pcr_event *event_header = log->bios_event_log;
> +	struct tcg_pcr_event2 *event = v;
> +	void *temp_ptr;
> +	size_t size = 0;
> +
> +	if (v == SEQ_START_TOKEN) {
> +
> +		size = sizeof(struct tcg_pcr_event)
> +			- sizeof(event_header->event)
> +			+ event_header->event_size;
> +
> +		temp_ptr = event_header;
> +
> +		if (size > 0)
> +			seq_write(m, temp_ptr, size);
> +	} else {
> +
> +		size = calc_tpm2_event_size(event, event_header);
> +
> +		temp_ptr = event;
> +		if (size > 0)
> +			seq_write(m, temp_ptr, size);
> +	}
> +
> +	return 0;
> +}
> +
> +const struct seq_operations tpm2_binary_b_measurments_seqops = {
> +	.start = tpm2_bios_measurements_start,
> +	.next = tpm2_bios_measurements_next,
> +	.stop = tpm2_bios_measurements_stop,
> +	.show = tpm2_binary_bios_measurements_show,
> +};
> diff --git a/drivers/char/tpm/tpm_eventlog.h b/drivers/char/tpm/tpm_eventlog.h
> index b888c77..3297fda 100644
> --- a/drivers/char/tpm/tpm_eventlog.h
> +++ b/drivers/char/tpm/tpm_eventlog.h
> @@ -78,7 +78,7 @@ enum tcpa_pc_event_ids {
>  int read_log(struct tpm_bios_log *log, struct tpm_chip *chip);
>  
>  #if defined(CONFIG_TCG_IBMVTPM) || defined(CONFIG_TCG_IBMVTPM_MODULE) || \
> -	defined(CONFIG_ACPI)
> +	defined(CONFIG_ACPI) || defined(CONFIG_PPC64)
>  extern void tpm_bios_log_setup(struct tpm_chip *chip);
>  extern void tpm_bios_log_teardown(struct tpm_chip *chip);
>  #else
> diff --git a/drivers/char/tpm/tpm_eventlog_init.c b/drivers/char/tpm/tpm_eventlog_init.c
> index dd5dbc4..a3fb5bc 100644
> --- a/drivers/char/tpm/tpm_eventlog_init.c
> +++ b/drivers/char/tpm/tpm_eventlog_init.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  
>  #include "tpm.h"
> +#include "tpm2.h"
>  #include "tpm_eventlog.h"
>  
>  
> @@ -103,36 +104,54 @@ void tpm_bios_log_setup(struct tpm_chip *chip)
>  {
>  	struct dentry *tpm_dir, *bin_file, *ascii_file;
>  	const char *name = dev_name(&chip->dev);
> +	void *seq_ops;
> +	int num_files = 0;
>  	int i;
>  
>  	for (i = 0; i < 3; i++)
>  		chip->bios_dir[i] = NULL;
>  
> +	/*
> +	 * NOTE: Currently, support is added only for binary_bios_measurements
> +	 * for TPM2.0. And so it is required to check that if device is TPM2,
> +	 * only 2 entries are allocated i.e. tpm0 dir and
> +	 * binary_bios_measurements file.
> +	 */
> +
> +	num_files = chip->flags & TPM_CHIP_FLAG_TPM2 ? 2 : 3;
> +
>  	tpm_dir = securityfs_create_dir(name, NULL);
>  	if (is_bad(tpm_dir))
>  		goto out;
>  
>  	tpm_dir->d_inode->i_private = chip;
>  
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		seq_ops = (void *)&tpm2_binary_b_measurments_seqops;
> +	else
> +		seq_ops = (void *)&tpm_binary_b_measurments_seqops;
> +
>  	bin_file =
>  	    securityfs_create_file("binary_bios_measurements",
>  				   S_IRUSR | S_IRGRP, tpm_dir,
> -				   (void *)&tpm_binary_b_measurments_seqops,
> +				   seq_ops,
>  				   &tpm_bios_measurements_ops);
>  	if (is_bad(bin_file))
>  		goto out_tpm;
>  
> -	ascii_file =
> -	    securityfs_create_file("ascii_bios_measurements",
> -				   S_IRUSR | S_IRGRP, tpm_dir,
> -				   (void *)&tpm_ascii_b_measurments_seqops,
> -				   &tpm_bios_measurements_ops);
> -	if (is_bad(ascii_file))
> -		goto out_bin;
> -
> -	chip->bios_dir[0] = ascii_file;
> -	chip->bios_dir[1] = bin_file;
> -	chip->bios_dir[2] = tpm_dir;
> +	chip->bios_dir[num_files-1] = tpm_dir;
> +	chip->bios_dir[num_files-2] = bin_file;
> +
> +	if (num_files == 3) {
> +		ascii_file =
> +			securityfs_create_file("ascii_bios_measurements",
> +					S_IRUSR | S_IRGRP, tpm_dir,
> +					(void *)&tpm_ascii_b_measurments_seqops,
> +					&tpm_bios_measurements_ops);
> +		if (is_bad(ascii_file))
> +			goto out_bin;
> +		chip->bios_dir[num_files-3] = ascii_file;
> +	}
>  
>  	return;
>  
> diff --git a/drivers/char/tpm/tpm_of.c b/drivers/char/tpm/tpm_of.c
> index 30a9905..d3c72ce 100644
> --- a/drivers/char/tpm/tpm_of.c
> +++ b/drivers/char/tpm/tpm_of.c
> @@ -26,6 +26,7 @@ int read_log(struct tpm_bios_log *log, struct tpm_chip *chip)
>  	struct device_node *np;
>  	const u32 *sizep;
>  	const u64 *basep;
> +	u32 log_size;
>  
>  	if (log->bios_event_log != NULL) {
>  		pr_err("%s: ERROR - Eventlog already initialized\n", __func__);
> @@ -52,6 +53,11 @@ int read_log(struct tpm_bios_log *log, struct tpm_chip *chip)
>  		goto cleanup_eio;
>  	}
>  
> +	if (!strncmp(np->name, "tpm", 3))
> +		log_size = be32_to_cpup(sizep);
> +	else
> +		log_size = *sizep;
> +
>  	basep = of_get_property(np, "linux,sml-base", NULL);
>  	if (basep == NULL) {
>  		dev_dbg(&chip->dev, "%s: ERROR - SML not found\n",
> @@ -59,15 +65,20 @@ int read_log(struct tpm_bios_log *log, struct tpm_chip *chip)
>  		goto cleanup_eio;
>  	}
>  
> -	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
> +	log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
>  	if (!log->bios_event_log) {
>  		of_node_put(np);
>  		return -ENOMEM;
>  	}
>  
> -	log->bios_event_log_end = log->bios_event_log + *sizep;
> +	log->bios_event_log_end = log->bios_event_log + log_size;
> +
> +	if (!strncmp(np->name, "tpm", 3))
> +		memcpy(log->bios_event_log, __va(be64_to_cpup(basep)),
> +		log_size);
> +	else
> +		memcpy(log->bios_event_log, __va(*basep), log_size);
>  
> -	memcpy(log->bios_event_log, __va(*basep), *sizep);
>  	of_node_put(np);
>  
>  	return 0;
> -- 
> 2.5.0
> 
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity 
> planning reports. http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
