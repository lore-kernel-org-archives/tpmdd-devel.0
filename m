From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 2/8] tpm: replace dynamically allocated
 bios_dir with dentry array
Date: Sat, 1 Oct 2016 15:27:14 +0300
Message-ID: <20161001122714.GA7637@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475051682-23060-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Wed, Sep 28, 2016 at 04:34:36AM -0400, Nayna Jain wrote:
> bios_dir is defined as struct dentry **bios_dir, which results in
> dynamic allocation and therefore possibly a memory leak. This patch
> replaces it with struct dentry array(struct dentry *bios_dir[3])
> similar to what is done for sysfs groups.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/char/tpm/tpm-chip.c     |  8 +++---
>  drivers/char/tpm/tpm.h          |  3 +-
>  drivers/char/tpm/tpm_eventlog.c | 63 +++++++++++++++++++----------------------
>  drivers/char/tpm/tpm_eventlog.h | 10 +++----
>  4 files changed, 40 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index e595013..826609d 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -278,14 +278,15 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>  
>  static int tpm1_chip_register(struct tpm_chip *chip)
>  {
> +	int rc;
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return 0;
>  
>  	tpm_sysfs_add_device(chip);
>  
> -	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
> +	rc = tpm_bios_log_setup(chip);
>  
> -	return 0;
> +	return rc;
>  }
>  
>  static void tpm1_chip_unregister(struct tpm_chip *chip)
> @@ -293,8 +294,7 @@ static void tpm1_chip_unregister(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return;
>  
> -	if (chip->bios_dir)
> -		tpm_bios_log_teardown(chip->bios_dir);
> +	tpm_bios_log_teardown(chip);
>  }
>  
>  static void tpm_del_legacy_sysfs(struct tpm_chip *chip)
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 3e952fb..b5866bb 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -171,7 +171,8 @@ struct tpm_chip {
>  	unsigned long duration[3]; /* jiffies */
>  	bool duration_adjusted;
>  
> -	struct dentry **bios_dir;
> +	struct dentry *bios_dir[3];
> +	unsigned int bios_dir_count;
>  
>  	const struct attribute_group *groups[3];
>  	unsigned int groups_cnt;
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index 75e6644..f1df782 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -332,7 +332,8 @@ static int tpm_bios_measurements_open(struct inode *inode,
>  	if (!log)
>  		return -ENOMEM;
>  
> -	if ((err = read_log(log)))
> +	err = read_log(log);
> +	if (err)
>  		goto out_free;
>  
>  	/* now register seq file */
> @@ -368,54 +369,48 @@ static int is_bad(void *p)
>  	return 0;
>  }
>  
> -struct dentry **tpm_bios_log_setup(const char *name)
> +int tpm_bios_log_setup(struct tpm_chip *chip)
>  {
> -	struct dentry **ret = NULL, *tpm_dir, *bin_file, *ascii_file;
> +	const char *name = dev_name(&chip->dev);
>  
> -	tpm_dir = securityfs_create_dir(name, NULL);
> -	if (is_bad(tpm_dir))
> -		goto out;
> +	chip->bios_dir_count = 0;
> +	chip->bios_dir[chip->bios_dir_count] =
> +		securityfs_create_dir(name, NULL);
> +	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
> +		goto err;
> +	chip->bios_dir_count++;
>  
> -	bin_file =
> +	chip->bios_dir[chip->bios_dir_count] =
>  	    securityfs_create_file("binary_bios_measurements",
> -				   S_IRUSR | S_IRGRP, tpm_dir,
> +				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>  				   (void *)&tpm_binary_b_measurments_seqops,
>  				   &tpm_bios_measurements_ops);
> -	if (is_bad(bin_file))
> -		goto out_tpm;
> +	if (is_bad(chip->bios_dir[chip->bios_dir_count]))
> +		goto err;
> +	chip->bios_dir_count++;
>  
> -	ascii_file =
> +	chip->bios_dir[chip->bios_dir_count] =
>  	    securityfs_create_file("ascii_bios_measurements",
> -				   S_IRUSR | S_IRGRP, tpm_dir,
> +				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>  				   (void *)&tpm_ascii_b_measurments_seqops,
>  				   &tpm_bios_measurements_ops);

The following securityfs_create_file calls overwrite the same field,
which leaks memory, as you pass chip->biod_dir[0] to these calls.

I guess securityfs_remove() returns with NULL input (haven't checked).

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
