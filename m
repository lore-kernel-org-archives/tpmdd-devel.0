From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi: call get_event_log before ExitBootServices
Date: Thu, 14 Sep 2017 11:43:28 -0700
Message-ID: <20170914184126.eevnstwq3i6fiq4j@linux.intel.com>
References: <20170911100022.7251-1-tweek@google.com>
 <20170911100022.7251-3-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170911100022.7251-3-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 11, 2017 at 12:00:21PM +0200, Thiebaud Weksteen wrote:
> With TPM 2.0 specification, the event logs may only be accessible by
> calling an EFI Boot Service. Modify the EFI stub to copy the log area to
> a new Linux-specific EFI configuration table so it remains accessible
> once booted.
> 
> When calling this service, it is possible to specify the expected format
> of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only the
> first format is retrieved.
> 
> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

With a quick skim the code change looks good but I remember from
Matthew's talk that there was this issue that ExitBootServices() would
cause a yet another event?

I guess you could manually synthetize that event by reading the PCR
values right after ExitBootServices()?

Anyway, great work, thanks for making this effort.

/Jarkko
