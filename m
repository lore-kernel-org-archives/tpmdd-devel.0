From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 4/4] tpm: use tpm_msleep() value as max delay
Date: Tue, 12 Sep 2017 17:47:03 -0700
Message-ID: <20170913004703.wtebzfp7mlgk57xf@linux.intel.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-5-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170906125643.5070-5-nayna@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 06, 2017 at 08:56:39AM -0400, Nayna Jain wrote:
> Currently, tpm_msleep() uses delay_msec as the minimum value in
> usleep_range. However, that is the maximum time we want to wait.
> The function is modified to use the delay_msec as the maximum
> value, not the minimum value.
> 
> After this change, performance on a TPM 1.2 with an 8 byte
> burstcount for 1000 extends improved from ~9sec to ~8sec.
> 
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index eb2f8818eded..ff5a8b7b80b9 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -533,8 +533,8 @@ int wait_for_tpm_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>  
>  static inline void tpm_msleep(unsigned int delay_msec)
>  {
> -	usleep_range(delay_msec * 1000,
> -		     (delay_msec * 1000) + TPM_TIMEOUT_RANGE_US);
> +	usleep_range((delay_msec * 1000) - TPM_TIMEOUT_RANGE_US,
> +		     delay_msec * 1000);
>  };
>  
>  struct tpm_chip *tpm_chip_find_get(int chip_num);
> -- 
> 2.13.3
> 

Doesn't this need a Fixes tag?

/Jarkko
