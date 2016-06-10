From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v5 3/4] tpm: Allow TPM chip drivers to override reported
 command durations
Date: Fri, 10 Jun 2016 15:19:57 +0300
Message-ID: <20160610121957.GA6229@intel.com>
References: <1465346740-60120-1-git-send-email-eswierk@skyportsystems.com>
 <1465426818-89356-1-git-send-email-eswierk@skyportsystems.com>
 <1465426818-89356-4-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465426818-89356-4-git-send-email-eswierk@skyportsystems.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ed Swierk <eswierk@skyportsystems.com>
Cc: tpmdd-devel@lists.sourceforge.net, stefanb@us.ibm.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jun 08, 2016 at 04:00:17PM -0700, Ed Swierk wrote:
> Some TPM chips report bogus command durations in their capabilities,
> just as others report incorrect timeouts. Rework tpm_get_timeouts()
> to allow chip drivers to override either via a single callback.
> Also clean up handling of TPMs that report milliseconds instead of
> microseconds.
> 
> Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>
> ---
>  drivers/char/tpm/tpm-interface.c | 177 +++++++++++++++++++++------------------
>  drivers/char/tpm/tpm_tis.c       |  35 ++------
>  include/linux/tpm.h              |   3 +-
>  3 files changed, 106 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index cc1e5bc..b8a08bb 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -502,123 +502,138 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  				"attempting to start the TPM");
>  }
>  
> -int tpm_get_timeouts(struct tpm_chip *chip)
> +static int tpm_get_cap_prop(struct tpm_chip *chip, __be32 type, int size,
> +			    cap_t *cap, char *desc)
>  {
>  	struct tpm_cmd_t tpm_cmd;
> -	unsigned long new_timeout[4];
> -	unsigned long old_timeout[4];
> -	struct duration_t *duration_cap;
>  	ssize_t rc;
>  
>  	tpm_cmd.header.in = tpm_getcap_header;
>  	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>  	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +	tpm_cmd.params.getcap_in.subcap = type;
>  	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
>  
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
>  		   Execute a startup command. */
> -		dev_info(chip->pdev, "Issuing TPM_STARTUP");
> +		dev_info(chip->pdev, "Issuing TPM_STARTUP\n");
>  		if (tpm_startup(chip, TPM_ST_CLEAR))
>  			return rc;
>  
>  		tpm_cmd.header.in = tpm_getcap_header;
>  		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> +		tpm_cmd.params.getcap_in.subcap = type;
>  		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>  				  NULL);
>  	}
> +
>  	if (rc) {
>  		dev_err(chip->pdev,
> -			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> -			rc);
> -		goto duration;
> +			"Error %zd reading %s\n", rc, desc);
> +		return -EINVAL;
>  	}
>  
>  	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
>  	    be32_to_cpu(tpm_cmd.header.out.length)
> -	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
> +	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + size * sizeof(u32)) {
> +		dev_err(chip->pdev,
> +			"Bad return code or length reading %s\n", desc);
>  		return -EINVAL;
> -
> -	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
> -	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
> -	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
> -	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
> -	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
> -
> -	/*
> -	 * Provide ability for vendor overrides of timeout values in case
> -	 * of misreporting.
> -	 */
> -	if (chip->ops->update_timeouts != NULL)
> -		chip->vendor.timeout_adjusted =
> -			chip->ops->update_timeouts(chip, new_timeout);
> -
> -	if (!chip->vendor.timeout_adjusted) {
> -		/* Don't overwrite default if value is 0 */
> -		if (new_timeout[0] != 0 && new_timeout[0] < 1000) {
> -			int i;
> -
> -			/* timeouts in msec rather usec */
> -			for (i = 0; i != ARRAY_SIZE(new_timeout); i++)
> -				new_timeout[i] *= 1000;
> -			chip->vendor.timeout_adjusted = true;
> -		}
>  	}
>  
> -	/* Report adjusted timeouts */
> -	if (chip->vendor.timeout_adjusted) {
> -		dev_info(chip->pdev,
> -			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
> -			 old_timeout[0], new_timeout[0],
> -			 old_timeout[1], new_timeout[1],
> -			 old_timeout[2], new_timeout[2],
> -			 old_timeout[3], new_timeout[3]);
> -	}
> +	memcpy(cap, &tpm_cmd.params.getcap_out.cap, sizeof(cap_t));
>  
> -	chip->vendor.timeout_a = usecs_to_jiffies(new_timeout[0]);
> -	chip->vendor.timeout_b = usecs_to_jiffies(new_timeout[1]);
> -	chip->vendor.timeout_c = usecs_to_jiffies(new_timeout[2]);
> -	chip->vendor.timeout_d = usecs_to_jiffies(new_timeout[3]);
> +	return 0;
> +}
>  
> -duration:
> -	tpm_cmd.header.in = tpm_getcap_header;
> -	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> -	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
> +int tpm_get_timeouts(struct tpm_chip *chip)
> +{
> +	cap_t cap1, cap2;
> +	int rc1, rc2;
> +	struct tpm_vendor_specific orig_vendor;
> +
> +	rc1 = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_TIMEOUT, 4, &cap1,
> +			       "timeouts");
> +	if (rc1 == 0) {
> +		be32_to_cpus(&cap1.timeout.a);
> +		be32_to_cpus(&cap1.timeout.b);
> +		be32_to_cpus(&cap1.timeout.c);
> +		be32_to_cpus(&cap1.timeout.d);
> +		chip->vendor.timeout_a = usecs_to_jiffies(cap1.timeout.a);
> +		chip->vendor.timeout_b = usecs_to_jiffies(cap1.timeout.b);
> +		chip->vendor.timeout_c = usecs_to_jiffies(cap1.timeout.c);
> +		chip->vendor.timeout_d = usecs_to_jiffies(cap1.timeout.d);
> +	}
> +	rc2 = tpm_get_cap_prop(chip, TPM_CAP_PROP_TIS_DURATION, 3, &cap2,
> +			       "durations");
> +	if (rc2 == 0) {
> +		be32_to_cpus(&cap2.duration.tpm_short);
> +		be32_to_cpus(&cap2.duration.tpm_medium);
> +		be32_to_cpus(&cap2.duration.tpm_long);
> +		chip->vendor.duration[TPM_SHORT] =
> +			usecs_to_jiffies(cap2.duration.tpm_short);
> +		chip->vendor.duration[TPM_MEDIUM] =
> +			usecs_to_jiffies(cap2.duration.tpm_medium);
> +		chip->vendor.duration[TPM_LONG] =
> +			usecs_to_jiffies(cap2.duration.tpm_long);
> +	}

This is major change to the semantics. Before -EINVAL would have been
return on error condition.

PS If you want to encapsulate tpm_get_cap_prop(), that step should be
a separate commit (prepend this one).

/Jarkko
