From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 4/9] tpm: drop tpm1_chip_register(/unregister)
Date: Tue, 22 Nov 2016 13:22:00 +0200
Message-ID: <20161122112200.55khdxtctt5rel4j@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479117656-12403-5-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479117656-12403-5-git-send-email-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 05:00:51AM -0500, Nayna Jain wrote:
> Check for TPM2 chip in tpm_sysfs_add_device, tpm_bios_log_setup and
> tpm_bios_log_teardown in order to make code flow cleaner and to enable
> to implement TPM 2.0 support later on. This is partially derived from
> the commit by Nayna Jain with the extension that also tpm1_chip_register
> is dropped.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This commit remains unreviewed and tested. I'm in the author role here
so I cannot help with this. If that does not happen soon I cannot put
this into the pull request.

/Jarkko

> ---
>  drivers/char/tpm/tpm-chip.c     | 31 +++++--------------------------
>  drivers/char/tpm/tpm-sysfs.c    |  3 +++
>  drivers/char/tpm/tpm_eventlog.c |  3 +++
>  3 files changed, 11 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index d0c1872..250a651 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -276,28 +276,6 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  	up_write(&chip->ops_sem);
>  }
>  
> -static int tpm1_chip_register(struct tpm_chip *chip)
> -{
> -	int rc;
> -
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		return 0;
> -
> -	tpm_sysfs_add_device(chip);
> -
> -	rc = tpm_bios_log_setup(chip);
> -
> -	return rc;
> -}
> -
> -static void tpm1_chip_unregister(struct tpm_chip *chip)
> -{
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -		return;
> -
> -	tpm_bios_log_teardown(chip);
> -}
> -
>  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
>  {
>  	struct attribute **i;
> @@ -364,7 +342,9 @@ int tpm_chip_register(struct tpm_chip *chip)
>  			return rc;
>  	}
>  
> -	rc = tpm1_chip_register(chip);
> +	tpm_sysfs_add_device(chip);
> +
> +	rc = tpm_bios_log_setup(chip);
>  	if (rc)
>  		return rc;
>  
> @@ -372,7 +352,7 @@ int tpm_chip_register(struct tpm_chip *chip)
>  
>  	rc = tpm_add_char_device(chip);
>  	if (rc) {
> -		tpm1_chip_unregister(chip);
> +		tpm_bios_log_teardown(chip);
>  		return rc;
>  	}
>  
> @@ -402,8 +382,7 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
>  void tpm_chip_unregister(struct tpm_chip *chip)
>  {
>  	tpm_del_legacy_sysfs(chip);
> -
> -	tpm1_chip_unregister(chip);
> +	tpm_bios_log_teardown(chip);
>  	tpm_del_char_device(chip);
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_unregister);
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index 59a1ead..848ad65 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -284,6 +284,9 @@ static const struct attribute_group tpm_dev_group = {
>  
>  void tpm_sysfs_add_device(struct tpm_chip *chip)
>  {
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		return;
> +
>  	/* The sysfs routines rely on an implicit tpm_try_get_ops, device_del
>  	 * is called before ops is null'd and the sysfs core synchronizes this
>  	 * removal so that no callbacks are running or can run again
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index 62e9da6..57ac862 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -373,6 +373,9 @@ int tpm_bios_log_setup(struct tpm_chip *chip)
>  	const char *name = dev_name(&chip->dev);
>  	unsigned int cnt;
>  
> +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +		return 0;
> +
>  	cnt = 0;
>  	chip->bios_dir[cnt] = securityfs_create_dir(name, NULL);
>  	if (is_bad(chip->bios_dir[cnt]))
> -- 
> 2.5.0
> 
