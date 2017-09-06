From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 1/4] tpm: ignore burstcount to improve tpm_tis send()
 performance.
Date: Wed, 6 Sep 2017 10:12:46 -0600
Message-ID: <20170906161246.GA9747@obsidianresearch.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-2-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170906125643.5070-2-nayna@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 06, 2017 at 08:56:36AM -0400, Nayna Jain wrote:

> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 4e303be83df6..3c59bb91e1ee 100644
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1465,6 +1465,14 @@
>  			mode generally follows that for the NaN encoding,
>  			except where unsupported by hardware.
>  
> +	ignore_burst_count [TPM_TIS_CORE]
> +			tpm_tis_core driver queries for the burstcount before
> +			every send call in a loop. However, it causes delay to
> +			the send command for TPMs with low burstcount value.
> +			Setting this value to 1, will make driver to query for
> +			burstcount only once in the loop to improve the
> +			performance. By default, its value is set to 0.

Really don't want to see a kernel command line parameter for this..

Please figure out a different approach or at least a better name..

> +		/*
> +		 * Get the initial burstcount to ensure TPM is ready to
> +		 * accept data, even when waiting for burstcount is disabled.
> +		 */
>  		burstcnt = get_burstcount(chip);
>  		if (burstcnt < 0) {
>  			dev_err(&chip->dev, "Unable to read burstcount\n");
>  			rc = burstcnt;
>  			goto out_err;
>  		}
> -		burstcnt = min_t(int, burstcnt, len - count - 1);
> +
> +		if (ignore_burst_count)
> +			sendcnt = len - 1;
> +		else
> +			sendcnt = min_t(int, burstcnt, len - count - 1);
> +
>  		rc = tpm_tis_write_bytes(priv, TPM_DATA_FIFO(priv->locality),
> -					 burstcnt, buf + count);
> +					 sendcnt, buf + count);

The problem with this approach is that the TPM could totally block the CPU for
very long periods of time.

It seems very risky to enable..

Jason
