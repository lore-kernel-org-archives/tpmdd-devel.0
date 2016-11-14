From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 2/9] tpm: replace symbolic permission
 with octal for securityfs files
Date: Mon, 14 Nov 2016 14:18:40 -0800
Message-ID: <20161114221840.cddivqovydg36og5@intel.com>
References: <1479117656-12403-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479117656-12403-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479117656-12403-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 14, 2016 at 05:00:49AM -0500, Nayna Jain wrote:
> checkpatch.pl flags warning for symbolic permissions and suggests
> to replace with octal value.
> 
> This patch changes securityfs pseudo files permission
> to octal values in tpm_bios_log_setup().
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

/Jarkko

> ---
>  drivers/char/tpm/tpm_eventlog.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index 42b49c4..9467e31 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -378,7 +378,7 @@ struct dentry **tpm_bios_log_setup(const char *name)
>  
>  	bin_file =
>  	    securityfs_create_file("binary_bios_measurements",
> -				   S_IRUSR | S_IRGRP, tpm_dir,
> +				   0440, tpm_dir,
>  				   (void *)&tpm_binary_b_measurements_seqops,
>  				   &tpm_bios_measurements_ops);
>  	if (is_bad(bin_file))
> @@ -386,7 +386,7 @@ struct dentry **tpm_bios_log_setup(const char *name)
>  
>  	ascii_file =
>  	    securityfs_create_file("ascii_bios_measurements",
> -				   S_IRUSR | S_IRGRP, tpm_dir,
> +				   0440, tpm_dir,
>  				   (void *)&tpm_ascii_b_measurements_seqops,
>  				   &tpm_bios_measurements_ops);
>  	if (is_bad(ascii_file))
> -- 
> 2.5.0
> 

------------------------------------------------------------------------------
