From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: add sysfs attributes for tpm2
Date: Mon, 18 Jul 2016 22:16:56 +0300
Message-ID: <20160718191656.GP31463@intel.com>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
	<1468547496-16215-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468547496-16215-2-git-send-email-apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 06:51:35PM -0700, Andrey Pronin wrote:
> Break sysfs attributes into common and TPM 1.2/2.0-specific, and
> create sysfs groups for TPM2.0.

I agree with Jasons comments and wait for revised version.

/Jarkko

> Signed-off-by: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c  | 48 ++++++++++++++++++++++++++++----------------
>  drivers/char/tpm/tpm-sysfs.c | 24 ++++++++++++++++++++--
>  2 files changed, 53 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 5a2f043..6c72671 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -281,8 +281,6 @@ static int tpm1_chip_register(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return 0;
>  
> -	tpm_sysfs_add_device(chip);
> -
>  	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
>  
>  	return 0;
> @@ -300,14 +298,21 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
>  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>  {
>  	struct attribute **i;
> +	int ngrp;
>  
> -	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
> +	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
>  		return;
>  
> -	sysfs_remove_link(&chip->dev.parent->kobj, "ppi");
> -
> -	for (i = chip->groups[0]->attrs; *i != NULL; ++i)
> -		sysfs_remove_link(&chip->dev.parent->kobj, (*i)->name);
> +	for (ngrp = 0; ngrp < chip->groups_cnt; ++ngrp) {
> +		if (chip->groups[ngrp]->name) {
> +			sysfs_remove_link(&chip->dev.parent->kobj,
> +					  chip->groups[ngrp]->name);
> +		} else {
> +			for (i = chip->groups[ngrp]->attrs; *i != NULL; ++i)
> +				sysfs_remove_link(&chip->dev.parent->kobj,
> +						  (*i)->name);
> +		}
> +	}
>  }
>  
>  /* For compatibility with legacy sysfs paths we provide symlinks from the
> @@ -317,20 +322,27 @@ static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>  static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>  {
>  	struct attribute **i;
> -	int rc;
> +	int rc = 0;
> +	int ngrp;
>  
> -	if (chip->flags & (TPM_CHIP_FLAG_TPM2 | TPM_CHIP_FLAG_VIRTUAL))
> +	if (chip->flags & TPM_CHIP_FLAG_VIRTUAL)
>  		return 0;
>  
> -	rc = __compat_only_sysfs_link_entry_to_kobj(
> -		    &chip->dev.parent->kobj, &chip->dev.kobj, "ppi");
> -	if (rc && rc != -ENOENT)
> -		return rc;
> -
>  	/* All the names from tpm-sysfs */
> -	for (i = chip->groups[0]->attrs; *i != NULL; ++i) {
> -		rc = __compat_only_sysfs_link_entry_to_kobj(
> -		    &chip->dev.parent->kobj, &chip->dev.kobj, (*i)->name);
> +	for (ngrp = 0; ngrp < chip->groups_cnt; ++ngrp) {
> +		if (chip->groups[ngrp]->name) {
> +			rc = __compat_only_sysfs_link_entry_to_kobj(
> +				&chip->dev.parent->kobj, &chip->dev.kobj,
> +				chip->groups[ngrp]->name);
> +		} else {
> +			for (i = chip->groups[ngrp]->attrs;
> +			     (*i != NULL) && !rc;
> +			     ++i)
> +				rc = __compat_only_sysfs_link_entry_to_kobj(
> +					&chip->dev.parent->kobj,
> +					&chip->dev.kobj,
> +					(*i)->name);
> +		}
>  		if (rc) {
>  			tpm_del_legacy_sysfs(chip);
>  			return rc;
> @@ -354,6 +366,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> +	tpm_sysfs_add_device(chip);
> +
>  	rc = tpm1_chip_register(chip);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index b46cf70..95ce90d 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -265,6 +265,12 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
>  static DEVICE_ATTR_RO(timeouts);
>  
>  static struct attribute *tpm_dev_attrs[] = {
> +	&dev_attr_durations.attr,
> +	&dev_attr_timeouts.attr,
> +	NULL,
> +};
> +
> +static struct attribute *tpm1_dev_attrs[] = {
>  	&dev_attr_pubek.attr,
>  	&dev_attr_pcrs.attr,
>  	&dev_attr_enabled.attr,
> @@ -273,8 +279,10 @@ static struct attribute *tpm_dev_attrs[] = {
>  	&dev_attr_temp_deactivated.attr,
>  	&dev_attr_caps.attr,
>  	&dev_attr_cancel.attr,
> -	&dev_attr_durations.attr,
> -	&dev_attr_timeouts.attr,
> +	NULL,
> +};
> +
> +static struct attribute *tpm2_dev_attrs[] = {
>  	NULL,
>  };
>  
> @@ -282,6 +290,14 @@ static const struct attribute_group tpm_dev_group = {
>  	.attrs = tpm_dev_attrs,
>  };
>  
> +static const struct attribute_group tpm1_dev_group = {
> +	.attrs = tpm1_dev_attrs,
> +};
> +
> +static const struct attribute_group tpm2_dev_group = {
> +	.attrs = tpm2_dev_attrs,
> +};
> +
>  void tpm_sysfs_add_device(struct tpm_chip *chip)
>  {
>  	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
> @@ -290,4 +306,8 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
>  	 */
>  	WARN_ON(chip->groups_cnt != 0);
>  	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		chip->groups[chip->groups_cnt++] = &tpm2_dev_group;
> +	else
> +		chip->groups[chip->groups_cnt++] = &tpm1_dev_group;
>  }
> -- 
> 2.6.6
> 

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
