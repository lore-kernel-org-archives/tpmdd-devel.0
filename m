From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 3/4] tpm: reduce tpm_msleep() time in get_burstcount()
Date: Tue, 12 Sep 2017 18:00:11 -0700
Message-ID: <20170913010011.myvhrj2f4i3piphl@linux.intel.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-4-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170906125643.5070-4-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 06, 2017 at 08:56:38AM -0400, Nayna Jain wrote:
> Currently, get_burstcount() function sleeps for 5msec in a loop
> before retrying for next query to burstcount. However, if it takes
> lesser time for TPM to return, this 5 msec delay is longer
> than necessary.
> 
> This patch replaces the tpm_msleep time from 5msec to 1msec.
> 
> After this change, performance on a TPM 1.2 with an 8 byte
> burstcount for 1000 extends improved from ~10sec to ~9sec.
> 
> Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/tpm_tis_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> index d1eab29cb447..d710bbc4608b 100644
> --- a/drivers/char/tpm/tpm_tis_core.c
> +++ b/drivers/char/tpm/tpm_tis_core.c
> @@ -169,7 +169,7 @@ static int get_burstcount(struct tpm_chip *chip)
>  		burstcnt = (value >> 8) & 0xFFFF;
>  		if (burstcnt)
>  			return burstcnt;
> -		tpm_msleep(TPM_TIMEOUT);
> +		tpm_msleep(1);
>  	} while (time_before(jiffies, stop));
>  	return -EBUSY;
>  }
> -- 
> 2.13.3

How did you pick 1 ms delay? Should there be a constant defining it?

/Jarkko
