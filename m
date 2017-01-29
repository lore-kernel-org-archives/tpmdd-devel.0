From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: add buffer access validation in
 tpm2_get_pcr_allocation()
Date: Sun, 29 Jan 2017 16:40:37 +0200
Message-ID: <20170129144037.sdqd4vutt73isz2i@intel.com>
References: <1485530749-22948-1-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485530749-22948-1-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Fri, Jan 27, 2017 at 10:25:49AM -0500, Nayna Jain wrote:
> This patch add validation in tpm2_get_pcr_allocation to avoid
> access beyond response buffer length.
> 
> Suggested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

This validation looks broken to me.

> ---
>  drivers/char/tpm/tpm2-cmd.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 4aad84c..02c1ea7 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -1008,9 +1008,13 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
>  	struct tpm2_pcr_selection pcr_selection;
>  	struct tpm_buf buf;
>  	void *marker;
> -	unsigned int count = 0;
> +	void *end;
> +	void *pcr_select_offset;
> +	unsigned int count;
> +	u32 sizeof_pcr_selection;
> +	u32 resp_len;

Very cosmetic but we almos almost universally use the acronym 'rsp' in
the TPM driver.

>  	int rc;
> -	int i;
> +	int i = 0;

Why do you need to initialize it?

>  
>  	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
>  	if (rc)
> @@ -1034,15 +1038,29 @@ static ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
>  	}
>  
>  	marker = &buf.data[TPM_HEADER_SIZE + 9];
> +
> +	resp_len = be32_to_cpup((__be32 *)&buf.data[2]);
> +	end = &buf.data[resp_len];

What if the response contains larger length than the buffer size?

> +
>  	for (i = 0; i < count; i++) {
> +		pcr_select_offset = marker +
> +			offsetof(struct tpm2_pcr_selection, size_of_select);
> +		if (pcr_select_offset >= end) {
> +			rc = -EFAULT;
> +			break;
> +		}
> +
>  		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
>  		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
> -		marker = marker + sizeof(struct tpm2_pcr_selection);
> +		sizeof_pcr_selection = sizeof(pcr_selection.hash_alg) +
> +			sizeof(pcr_selection.size_of_select) +
> +			sizeof(u8) * pcr_selection.size_of_select;

Remove "sizeof(u8) * ".

> +		marker = marker + sizeof_pcr_selection;
>  	}
>  
>  out:
> -	if (count < ARRAY_SIZE(chip->active_banks))
> -		chip->active_banks[count] = TPM2_ALG_ERROR;
> +	if (i < ARRAY_SIZE(chip->active_banks))
> +		chip->active_banks[i] = TPM2_ALG_ERROR;
>  
>  	tpm_buf_destroy(&buf);
>  
> -- 
> 2.5.0
> 

I'm sorry but this commit is changing too much. You need to redo the
whole commit and resend the patch set with these fixes. You can keep
Reviewed-by and Tested-by in 1/2 but have to remove them from 2/2.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
