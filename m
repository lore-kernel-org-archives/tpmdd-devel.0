From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 3/5] tpm: Clean up reading of timeout and duration
 capabilities
Date: Mon, 18 Jul 2016 21:15:47 +0300
Message-ID: <20160718181547.GD31463@intel.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-4-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468426776-42762-4-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ed Swierk <eswierk@skyportsystems.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, stefanb@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 09:19:34AM -0700, Ed Swierk wrote:
> Call tpm_getcap() from tpm_get_timeouts() to eliminate redundant
> code. Return all errors to the caller rather than swallowing them
> (e.g. when tpm_transmit_cmd() returns nonzero).
> 
> Signed-off-by: Ed Swierk <eswierk@skyportsystems.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko

> ---
>  drivers/char/tpm/tpm-interface.c | 74 +++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index a4beb53..dc492ee 100644
> --- a/drivers/char/tpm/tpm-interface.c
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -460,9 +460,19 @@ ssize_t tpm_getcap(struct tpm_chip *chip, __be32 subcap_id, cap_t *cap,
>  		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
>  		tpm_cmd.params.getcap_in.subcap = subcap_id;
>  	}
> +
>  	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, desc);
> +
> +	if (!rc &&
> +	    ((subcap_id == TPM_CAP_PROP_TIS_TIMEOUT &&
> +	      be32_to_cpu(tpm_cmd.header.out.length) != TPM_HEADER_SIZE + 20) ||
> +	     (subcap_id == TPM_CAP_PROP_TIS_DURATION &&
> +	      be32_to_cpu(tpm_cmd.header.out.length) != TPM_HEADER_SIZE + 16)))
> +		rc = -EINVAL;
> +
>  	if (!rc)
>  		*cap = tpm_cmd.params.getcap_out.cap;
> +
>  	return rc;
>  }
>  
> @@ -503,10 +513,9 @@ static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
>  
>  int tpm_get_timeouts(struct tpm_chip *chip)
>  {
> -	struct tpm_cmd_t tpm_cmd;
> +	cap_t cap;
>  	unsigned long new_timeout[4];
>  	unsigned long old_timeout[4];
> -	struct duration_t *duration_cap;
>  	ssize_t rc;
>  
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> @@ -524,42 +533,25 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  		return 0;
>  	}
>  
> -	tpm_cmd.header.in = tpm_getcap_header;
> -	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> -	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE, NULL);
> -
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> +			"attempting to determine the timeouts");
>  	if (rc == TPM_ERR_INVALID_POSTINIT) {
>  		/* The TPM is not started, we are the first to talk to it.
>  		   Execute a startup command. */
> -		dev_info(&chip->dev, "Issuing TPM_STARTUP");
> +		dev_info(&chip->dev, "Issuing TPM_STARTUP\n");
>  		if (tpm_startup(chip, TPM_ST_CLEAR))
>  			return rc;
>  
> -		tpm_cmd.header.in = tpm_getcap_header;
> -		tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> -		tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -		tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_TIMEOUT;
> -		rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> -				  NULL);
> -	}
> -	if (rc) {
> -		dev_err(&chip->dev,
> -			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> -			rc);
> -		goto duration;
> +		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> +				"attempting to determine the timeouts");
>  	}
> +	if (rc)
> +		return rc;
>  
> -	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> -	    be32_to_cpu(tpm_cmd.header.out.length)
> -	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 4 * sizeof(u32))
> -		return -EINVAL;
> -
> -	old_timeout[0] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.a);
> -	old_timeout[1] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.b);
> -	old_timeout[2] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.c);
> -	old_timeout[3] = be32_to_cpu(tpm_cmd.params.getcap_out.cap.timeout.d);
> +	old_timeout[0] = be32_to_cpu(cap.timeout.a);
> +	old_timeout[1] = be32_to_cpu(cap.timeout.b);
> +	old_timeout[2] = be32_to_cpu(cap.timeout.c);
> +	old_timeout[3] = be32_to_cpu(cap.timeout.d);
>  	memcpy(new_timeout, old_timeout, sizeof(new_timeout));
>  
>  	/*
> @@ -597,29 +589,17 @@ int tpm_get_timeouts(struct tpm_chip *chip)
>  	chip->timeout_c = usecs_to_jiffies(new_timeout[2]);
>  	chip->timeout_d = usecs_to_jiffies(new_timeout[3]);
>  
> -duration:
> -	tpm_cmd.header.in = tpm_getcap_header;
> -	tpm_cmd.params.getcap_in.cap = TPM_CAP_PROP;
> -	tpm_cmd.params.getcap_in.subcap_size = cpu_to_be32(4);
> -	tpm_cmd.params.getcap_in.subcap = TPM_CAP_PROP_TIS_DURATION;
> -
> -	rc = tpm_transmit_cmd(chip, &tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
> -			      "attempting to determine the durations");
> +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_DURATION, &cap,
> +			"attempting to determine the durations");
>  	if (rc)
>  		return rc;
>  
> -	if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
> -	    be32_to_cpu(tpm_cmd.header.out.length)
> -	    != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
> -		return -EINVAL;
> -
> -	duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
>  	chip->duration[TPM_SHORT] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));
> +		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_short));
>  	chip->duration[TPM_MEDIUM] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_medium));
> +		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_medium));
>  	chip->duration[TPM_LONG] =
> -	    usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_long));
> +		usecs_to_jiffies(be32_to_cpu(cap.duration.tpm_long));
>  
>  	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
>  	 * value wrong and apparently reports msecs rather than usecs. So we
> -- 
> 1.9.1
> 
