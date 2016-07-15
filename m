From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/2] tpm: add sysfs attributes for tpm2
Date: Thu, 14 Jul 2016 21:21:45 -0600
Message-ID: <20160715032145.GE9347@obsidianresearch.com>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
 <1468547496-16215-2-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468547496-16215-2-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 06:51:35PM -0700, Andrey Pronin wrote:
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

NAK

No new compat symlinks. Only the existing set of links are permitted.

Any new sysfs entries must use only the new location.

> +static struct attribute *tpm2_dev_attrs[] = {
>  	NULL,
>  };

> +static const struct attribute_group tpm2_dev_group = {
> +	.attrs = tpm2_dev_attrs,
> +};

Don't add dead code, add this and related in the patch that requires it.

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

.. and this can't really happen either..

To make things simple you can just have tpm2 not ever create any links
for any files by never using groups[0]. There is no need to try and
create a shared 'tpm_dev_group'.

Jason
