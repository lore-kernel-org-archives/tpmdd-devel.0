From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Wed, 4 Oct 2017 14:20:52 +0300
Message-ID: <20171004112052.7fiwkpun62zphawi@linux.intel.com>
References: <20170920081340.7413-1-tweek@google.com>
 <20170920081340.7413-5-tweek@google.com>
 <20170926114538.r5hsyc5osodpaals@linux.intel.com>
 <CA+zpnLcYWcO8Gf6b8rAHgcLkAndC0uyPH+Kxa01giVsochP3Ug@mail.gmail.com>
 <20170929171617.yq4dvn66czvnebns@linux.intel.com>
 <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171004105113.mcho3rlytaxfruyf-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 04, 2017 at 01:51:13PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 29, 2017 at 08:16:17PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Sep 26, 2017 at 02:49:31PM +0200, Thiebaud Weksteen wrote:
> > > On Tue, Sep 26, 2017 at 1:45 PM, Jarkko Sakkinen
> > > <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > > On Wed, Sep 20, 2017 at 10:13:39AM +0200, Thiebaud Weksteen wrote:
> > > >> With TPM 2.0 specification, the event logs may only be accessible by
> > > >> calling an EFI Boot Service. Modify the EFI stub to copy the log area to
> > > >> a new Linux-specific EFI configuration table so it remains accessible
> > > >> once booted.
> > > >>
> > > >> When calling this service, it is possible to specify the expected format
> > > >> of the logs: TPM 1.2 (SHA1) or TPM 2.0 ("Crypto Agile"). For now, only the
> > > >> first format is retrieved.
> > > >>
> > > >> Signed-off-by: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > Does not apply:
> > > >
> > > > Applying: tpm: move tpm_eventlog.h outside of drivers folder
> > > > Applying: tpm: rename event log provider files
> > > > Applying: tpm: add event log format version
> > > > Applying: efi: call get_event_log before ExitBootServices
> > > > error: sha1 information is lacking or useless (drivers/firmware/efi/efi.c).
> > > > error: could not build fake ancestor
> > > > Patch failed at 0004 efi: call get_event_log before ExitBootServices
> > > > The copy of the patch that failed is found in: .git/rebase-apply/patch
> > > > When you have resolved this problem, run "git am --continue".
> > > > If you prefer to skip this patch, run "git am --skip" instead.
> > > > To restore the original branch and stop patching, run "git am --abort".
> > > >
> > > > Just rebased my tree to the latest security-next.
> > > 
> > > It applies fine on security/next-general which is more up-to-date.
> > > (security/next does not include
> > > ccc829ba3624beb9a703fc995d016b836d9eead8 on which this patch set is
> > > based)
> > 
> > Thanks, my bad, I though that I had it updated.
> > 
> > I'll update my tree and retry.
> > 
> > /Jarkko
> 
> My master is up to date with security/next.
> 
> Still get the same result:
> 
> $ git am -3 ~/Downloads/v3-4-5-efi-call-get_event_log-before-ExitBootServices.patch
> Applying: efi: call get_event_log before ExitBootServices
> error: sha1 information is lacking or useless (drivers/firmware/efi/efi.c).
> error: could not build fake ancestor
> Patch failed at 0001 efi: call get_event_log before ExitBootServices
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> Maybe you have some other trees fetched in your local GIT so that it
> finds the ancestors? Anyway, cannot test this at this point.
> 
> /Jarkko

I pushed the first three patches to my master as they looked OK. You
should still consider them unreviewed.

/Jarkko
