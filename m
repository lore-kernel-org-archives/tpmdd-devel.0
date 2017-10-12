From: Javier Martinez Canillas <javier-0uQlZySMnqxg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 4/5] efi: call get_event_log before ExitBootServices
Date: Thu, 12 Oct 2017 17:03:38 +0200
Message-ID: <CABxcv=neJZjA407pbmNesNbGY9k3VRbhawut6ewofw_UB5U1_w@mail.gmail.com>
References: <20170920081340.7413-5-tweek@google.com> <20170926114538.r5hsyc5osodpaals@linux.intel.com>
 <CA+zpnLcYWcO8Gf6b8rAHgcLkAndC0uyPH+Kxa01giVsochP3Ug@mail.gmail.com>
 <20170929171617.yq4dvn66czvnebns@linux.intel.com> <20171004105113.mcho3rlytaxfruyf@linux.intel.com>
 <CA+zpnLdg4km1vMUUZaYfRg6M68+nSdC+vASULmH-aKu4vYyy4Q@mail.gmail.com>
 <20171010141419.e4uv4fkmcmpc7sdc@linux.intel.com> <alpine.LRH.2.21.1710111250260.22885@namei.org>
 <20171011115254.2n4zs77ixyl2mdgm@linux.intel.com> <20171011115318.i342rzq3akqbrovv@linux.intel.com>
 <20171012113844.ptfynppgx3tkwe7g@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171012113844.ptfynppgx3tkwe7g-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, peterhuewe-Mmb7MZpHnFY@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 12, 2017 at 1:38 PM, Jarkko Sakkinen
<jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

[snip]

>
> Now all Thiebaud's patches have been applied to the master of
>
>   git://git.infradead.org/users/jjs/linux-tpmdd.git
>
> Testing is still pending.
>

I provided my reviewed and tested by tags for the patches but I
noticed that weren't picked. Probably my fault though since I answered
to the cover letter instead of the individual patches.

> /Jarkko

Best regards,
Javier
