From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: fix a race condition
	tpm2_unseal_trusted()
Date: Thu, 25 Aug 2016 12:30:59 -0600
Message-ID: <20160825183059.GB1142@obsidianresearch.com>
References: <1472000243-7088-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472000243-7088-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Tue, Aug 23, 2016 at 08:57:22PM -0400, Jarkko Sakkinen wrote:

> +     if (flags & TPM_TRANSMIT_LOCK)
> +             mutex_lock(&chip->tpm_mutex);

I think I would invert this. UNLOCKED is the exceptional case, so I'd
make the 0 flags lock. If we see UNLOCKED in the caller then we know
to audit for locking, 0 is much less obvious.

> @@ -576,7 +576,7 @@ static int tpm2_load(struct tpm_chip *chip,
>  		goto out;
>  	}
>  
> -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob");
> +	rc = __tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob", 0);

All these points should accept a flags too and the caller should pass
in the TPM_TRASNMIT_UNLOCKED if it needs it..

> +	mutex_lock(&chip->tpm_mutex);
>  	rc = tpm2_load(chip, payload, options, &blob_handle);
>  	if (rc)

So when we read here we see the pattern:

> +	mutex_lock(&chip->tpm_mutex);
>  	rc = tpm2_load(chip, payload, options, &blob_handle, TPM_TRASNMIT_UNLOCKED);

Which is much easier to audit..

Jason

------------------------------------------------------------------------------
