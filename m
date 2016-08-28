From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: fix a race condition in
	tpm2_unseal_trusted()
Date: Sun, 28 Aug 2016 12:51:49 -0600
Message-ID: <20160828185149.GF12783@obsidianresearch.com>
References: <1472366212-8571-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472366212-8571-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Aug 28, 2016 at 08:36:52AM +0200, Jarkko Sakkinen wrote:
>  
> @@ -576,7 +576,8 @@ static int tpm2_load(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob");
> +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_TRANSMIT_UNLOCKED,
> +			      "loading blob");

I still don't like this, required mutex's should not be split outside the
function that needs them without more a more obvious indication:

> +	mutex_lock(&chip->tpm_mutex);
>  	rc = tpm2_load(chip, payload, options, &blob_handle);
>  	if (rc)
> -		return rc;

I recommend you stick with the idiom and do this:

        mutex_lock(&chip->tpm_mutex);
  	rc = tpm2_load(chip, payload, options, &blob_handle, TPM_TRANSMIT_UNLOCKED);

Which makes it easy to see we are doing it right everywhere.

Jason

------------------------------------------------------------------------------
