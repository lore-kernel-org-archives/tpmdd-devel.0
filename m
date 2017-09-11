From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Mon, 11 Sep 2017 10:47:50 -0600
Message-ID: <20170911164750.GA2607@obsidianresearch.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-4-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170911100022.7251-4-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 11, 2017 at 12:00:22PM +0200, Thiebaud Weksteen wrote:
  
>  	chip->bin_log_seqops.chip = chip;
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> +
> +	if (log_version == EFI_TCG2_EVENT_LOG_FORMAT_TCG_2 ||
> +	    (!log_version && (chip->flags & TPM_CHIP_FLAG_TPM2)))
>  		chip->bin_log_seqops.seqops =
>  			&tpm2_binary_b_measurements_seqops;

Lets have all the read_log_* versions return the postitive log_version
and get rid of the chip->flags check here.

ie Doesn't ACPI always return the TPM 1 version?

Jason
