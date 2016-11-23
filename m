From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 2/3] tpm: enhance read_log_of() to
 support Physical TPM event log
Date: Wed, 23 Nov 2016 12:37:00 -0700
Message-ID: <20161123193700.GA13927@obsidianresearch.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479922057-8752-3-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479922057-8752-3-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Wed, Nov 23, 2016 at 12:27:36PM -0500, Nayna Jain wrote:
>  	sizep = of_get_property(np, "linux,sml-size", NULL);
> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
> +		log_size = be32_to_cpup(sizep);
> +	else
> +		log_size = *sizep;
> +

Uh, no, sizep can be null at this point:

>  	basep = of_get_property(np, "linux,sml-base", NULL);
>  	if (sizep == NULL && basep == NULL)
>  		return -ENODEV;
>  	if (sizep == NULL || basep == NULL)
>  		return -EIO;

Move the if here.

> -	if (*sizep == 0) {
> +	if (log_size == 0) {
>  		dev_warn(&chip->dev, "%s: Event log area empty\n", __func__);
>  		return -EIO;
>  	}
>  
> -	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
> +	log->bios_event_log = kmalloc(log_size, GFP_KERNEL);
>  	if (!log->bios_event_log)
>  		return -ENOMEM;
>  
> -	log->bios_event_log_end = log->bios_event_log + *sizep;
> +	log->bios_event_log_end = log->bios_event_log + log_size;
>  
> -	memcpy(log->bios_event_log, __va(*basep), *sizep);
> +	if (of_property_match_string(np, "compatible", "IBM,vtpm") < 0)
> +		memcpy(chip->log.bios_event_log, __va(be64_to_cpup(basep)),
> +		       log_size);
> +	else
> +		memcpy(chip->log.bios_event_log, __va(*basep),
> log_size);

And move the conditional swap of basep up to be along side sizep as
well (ie get rid of the second of_property_match_string)

Jason

------------------------------------------------------------------------------
