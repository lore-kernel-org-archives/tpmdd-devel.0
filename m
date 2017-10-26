From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Thu, 26 Oct 2017 20:58:53 +0200
Message-ID: <20171026185853.bfh7jidixrxb6ozj@linux.intel.com>
References: <CA+zpnLcYWcO8Gf6b8rAHgcLkAndC0uyPH+Kxa01giVsochP3Ug@mail.gmail.com>
 <20170929171617.yq4dvn66czvnebns@linux.intel.com>
 <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
 <CA+zpnLdg4km1vMUUZaYfRg6M68+nSdC+vASULmH-aKu4vYyy4Q@mail.gmail.com>
 <20171010141419.e4uv4fkmcmpc7sdc@linux.intel.com>
 <alpine.LRH.2.21.1710111250260.22885@namei.org>
 <20171011115254.2n4zs77ixyl2mdgm@linux.intel.com>
 <20171016112833.txbg2sm5tjocp6qh@linux.intel.com>
 <20171016114946.phj3n6vyjdbpj2sj@linux.intel.com>
 <CA+zpnLc038dv-WAE7fdD8i6DpGV3zCLEieg-KPTAvaW7yt-tLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+zpnLc038dv-WAE7fdD8i6DpGV3zCLEieg-KPTAvaW7yt-tLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 17, 2017 at 10:00:15AM +0200, Thiebaud Weksteen wrote:
> This patch was mainly developed and tested on Kabylake with PTT as well.
> 
> It could be a few things. Are you booting with the EFI stub? Is the
> TPM enabled within the BIOS? Does tpm_tis get loaded? Does it produce
> any log?

Nope, and it should not get loaded anyway as I'm using PTT. With PTT you
use tpm_crb. TPM is working just fine.

> If the logs are recovered (but not parsed), you should already see an
> entry in the logs like:
> 
> efi:  SMBIOS=0x7fed6000  ACPI=0x7ff00000  TPMEventLog=0x.....
> 
> Can you see the TPMEventLog part?

I can check this when I'm back in Finland. Still in Prague. Tried to
test this with my work laptop (XPS13 with dTPM) now but the USB stick I
have with seems to be broken :-(

This is anyway almost guaranteed to go to 4.16  and I don't want to push
this to 4.15 so there is no rush right now (already sent my PR).

> The issue with extra logging is that the log recovery happens within
> the EFI stub phase where limited logging is available (which I think
> has been limited to error and fatal message only).
> For now, it cannot be a version mismatch as the stub will only request
> the version 1.2 format.

Right, I see.

/Jarkko
