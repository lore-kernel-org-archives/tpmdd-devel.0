From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 2/7] tpm: Replace the dynamically
 allocated bios_dir as struct dentry array.
Date: Tue, 30 Aug 2016 11:11:32 -0600
Message-ID: <20160830171132.GB6373@obsidianresearch.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472532619-22170-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Tue, Aug 30, 2016 at 12:50:14AM -0400, Nayna Jain wrote:
> bios_dir is defined as struct dentry **bios_dir, which results in
> dynamic allocation and possible memory leak. This patch replaces
> it with struct dentry array i.e. struct dentry *bios_dir[3]
> similar to what is done for sysfs groups.
> 
> Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Yep, looks sane too.

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

I wonder if it needs a Fixes line?

> -	struct dentry **bios_dir;
> +	struct dentry *bios_dir[3];
> +	unsigned int bios_dir_count;

Regarding Jarkko's comment - I don't care either way. If you want to
use null or the count. We use a count for the sysfs scheme, but it is
also more dynamic.

> +	chip->bios_dir_count = 0;
> +	chip->bios_dir[chip->bios_dir_count] = securityfs_create_dir(name,
> +	NULL);

Indenting again.

Are you running your patches through scripts/checkpatch.pl ?

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

This idiom is why the count works better, since we are storing
non-null in the array before doing the error check.

> -void tpm_bios_log_teardown(struct dentry **lst)
> +void tpm_bios_log_teardown(struct tpm_chip *chip)
>  {
>  	int i;
>  
> -	for (i = 0; i < 3; i++)
> -		securityfs_remove(lst[i]);
> +	for (i = chip->bios_dir_count; i > 0; --i)
> +		securityfs_remove(chip->bios_dir[i-1]);

Regarding Jarkko's comment..

I think you need to keep it like this. There is clearly an ordering
requirement with security_remove, so reverse iterating is the right
thing to do.

> +static inline void tpm_bios_log_setup(struct tpm_chip *chip)
>  {
> -	return NULL;
> +	chip->bios_dir_count = 0;

This assignment is probably not necessary since the teardown is
stubbed too.

Jason

------------------------------------------------------------------------------
