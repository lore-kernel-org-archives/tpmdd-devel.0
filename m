From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Tue, 26 Sep 2017 14:45:38 +0300
Message-ID: <20170926114538.r5hsyc5osodpaals@linux.intel.com>
References: <20170920081340.7413-1-tweek@google.com>
 <20170920081340.7413-5-tweek@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170920081340.7413-5-tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 20, 2017 at 10:13:39AM +0200, Thiebaud Weksteen wrote:
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

Does not apply:

Applying: tpm: move tpm_eventlog.h outside of drivers folder
Applying: tpm: rename event log provider files
Applying: tpm: add event log format version
Applying: efi: call get_event_log before ExitBootServices
error: sha1 information is lacking or useless (drivers/firmware/efi/efi.c).
error: could not build fake ancestor
Patch failed at 0004 efi: call get_event_log before ExitBootServices
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

Just rebased my tree to the latest security-next.

/Jarkko
