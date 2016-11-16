From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: Check the bios_dir entry for NULL
 before accessing it
Date: Wed, 16 Nov 2016 20:28:30 +0530
Message-ID: <582C7416.7090105@linux.vnet.ibm.com>
References: <1479304573-13601-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1479304573-13601-1-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 11/16/2016 07:26 PM, Stefan Berger wrote:
> Check the bios_dir entry for NULL before accessing it. Currently
> this crashes the driver when a TPM 2 is attached and the entries
> are NULL.

Thanks Stefan !! I think it would be good to also add Fixes in commit 
description here.

Fixes: d660a91a1b9d (tpm: adds NULL check for securityfs pseudo files)

Thanks & Regards,
   - Nayna

>
> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>   drivers/char/tpm/tpm_eventlog.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
> index ebec4ac..fb603a7 100644
> --- a/drivers/char/tpm/tpm_eventlog.c
> +++ b/drivers/char/tpm/tpm_eventlog.c
> @@ -455,10 +455,12 @@ void tpm_bios_log_teardown(struct tpm_chip *chip)
>   	 * This design ensures that open() either safely gets kref or fails.
>   	 */
>   	for (i = (TPM_NUM_EVENT_LOG_FILES - 1); i >= 0; i--) {
> -		inode = d_inode(chip->bios_dir[i]);
> -		inode_lock(inode);
> -		inode->i_private = NULL;
> -		inode_unlock(inode);
> -		securityfs_remove(chip->bios_dir[i]);
> +		if (chip->bios_dir[i]) {
> +			inode = d_inode(chip->bios_dir[i]);
> +			inode_lock(inode);
> +			inode->i_private = NULL;
> +			inode_unlock(inode);
> +			securityfs_remove(chip->bios_dir[i]);
> +		}
>   	}
>   }
>


------------------------------------------------------------------------------
