From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v4 1/5] tpm: validate TPM 2.0 commands
Date: Sun, 22 Jan 2017 21:02:17 -0500
Message-ID: <b5837ab8-0edd-86cf-c17d-36d55754219e@linux.vnet.ibm.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
 <20170122234438.12102-2-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170122234438.12102-2-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/22/2017 06:44 PM, Jarkko Sakkinen wrote:
> @@ -1025,8 +1029,60 @@ int tpm2_auto_startup(struct tpm_chip *chip)
>   		}
>   	}
>
> +	rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands, NULL);
> +	if (rc)
> +		goto out;
> +
> +	/* sanity check */
> +	if (nr_commands > INT_MAX) {
> +		rc = -E2BIG;
> +		goto out;
> +	}
> +
> +	chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
> +					  GFP_KERNEL);
> +
> +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
> +	if (rc)
> +		goto out;
> +
> +	tpm_buf_append_u32(&buf, TPM2_CAP_COMMANDS);
> +	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
> +	tpm_buf_append_u32(&buf, nr_commands);
> +
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0, NULL);

You should probably pass the min_rsp_body_size as 5 + 4 + nr_commands * 4

> +	if (rc < 0) {
> +		tpm_buf_destroy(&buf);
> +		goto out;
> +	}
> +
> +	if (nr_commands !=
> +	    be32_to_cpup((__be32 *)&buf.data[TPM_HEADER_SIZE + 5])) {
> +		tpm_buf_destroy(&buf);
> +		goto out;
> +	}
> +
> +	chip->nr_commands = nr_commands;
> +
> +	attrs = (u32 *)&buf.data[TPM_HEADER_SIZE + 9];
> +	for (i = 0; i < nr_commands; i++, attrs++)
> +		chip->cc_attrs_tbl[i] = be32_to_cpup(attrs);
> +
> +	tpm_buf_destroy(&buf);
> +
>   out:
>   	if (rc > 0)
>   		rc = -ENODEV;
>   	return rc;
>   }
> +
> +int tpm2_find_cc(struct tpm_chip *chip, u32 cc)
> +{
> +	int i;
> +
> +	for (i = 0; i < chip->nr_commands; i++)
> +		if (cc == (chip->cc_attrs_tbl[i] & GENMASK(15, 0)))
> +			return i;
> +
> +	return -1;
> +}
