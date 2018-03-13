From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Tue, 13 Mar 2018 15:00:22 +0000
Message-ID: <CA+zpnLdiqvRcsjbVW248LQHr13NBTLd8bo1dY0T_sc+yhh9itg@mail.gmail.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
 <010001620bafa06b-41525407-603e-40a9-ba11-6033b2f5dcc7-000000@email.amazonses.com>
 <CA+zpnLdmg30Beg+uUJNgBQ5gbjXuJ0uVhyzCgf6m7xbx2yARBg@mail.gmail.com>
 <CAKv+Gu-KPU+kQ0z3jJ+CcgNPq3PuqjF_CCB_2LR_5VoYaynTJw@mail.gmail.com>
 <010001621a9e5069-0b1a6328-97e4-4396-9438-b90f5b8c82a4-000000@email.amazonses.com>
 <CAKv+Gu8+x=5nU9MmYQKKc=3fhMXoUYjGSjYYfhjaFtdGG2NkaA@mail.gmail.com>
 <010001621b287e42-58955302-cc14-4212-b7b0-e6e358633dab-000000@email.amazonses.com>
 <CAKv+Gu_hLR3YNZF=taLM++LdfqmPpGG+vR1O8NfKNP00PNeiYA@mail.gmail.com>
 <CA+zpnLdxGT08citakzZwZsSQAFeTJw-j6S7udHk6-sEJ9R3xpA@mail.gmail.com>
 <010001621b7ce5a3-b80c55b8-be68-4b44-ab52-4949e8ddb8d0-000000@email.amazonses.com>
 <CA+zpnLf=JDUxyorH7yP=08FD_u=+UoQ6ubsKyVLD+4w9raYAKQ@mail.gmail.com>
 <bf12c497-db2a-f1f0-efc3-07e6a6ee9daa@redhat.com> <CAKv+Gu9_rYv_XocRwTLdH+P7dVq+3=CQRJ9O9kKyry_=Ekz0aQ@mail.gmail.com>
 <010001621f97c0bb-898ceaeb-668d-4543-8835-dc374ba02539-000000@email.amazonses.com>
 <CAKv+Gu98sgrk8Jn9gNG-g-Ku77scxO_3JuMDSOLCULZCo26XPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu98sgrk8Jn9gNG-g-Ku77scxO_3JuMDSOLCULZCo26XPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, hdegoede@redhat.com, Jeremy Cline <jeremy@jcline.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 13, 2018 at 2:43 PM Ard Biesheuvel <ard.biesheuvel@linaro.org>
wrote:

> On 13 March 2018 at 13:41, Jeremy Cline <jeremy@jcline.org> wrote:
> > On 03/13/2018 03:59 AM, Ard Biesheuvel wrote:
> >> On 13 March 2018 at 07:47, Hans de Goede <hdegoede@redhat.com> wrote:
> >>> Hi,
> >>>
> >>>
> >>> On 12-03-18 20:55, Thiebaud Weksteen wrote:
> >>>>
> >> ...
> >>>>
> >>>> Hans, you said you configured the tablet to use the 32-bit version
of grub
> >>>> instead
> >>>> of 64. Why's that?
> >>>
> >>>
> >>> Because this tablet, like (almost?) all Bay Trail hardware has a 32
bit
> >>> UEFI,
> >>> even though the processor is 64 bit capable (AFAIK 64 bit Windows
drivers
> >>> were
> >>> not ready in time so all Bay Trail devices shipped with a 32 bit
Windows).
> >>>
> >>> So this is running a 32 bit grub which boots a 64 bit kernel.
> >>>
> >>>> Jeremy, could you confirm if you are building the kernel in 64bit
mode? Is
> >>>> your Android install working? (that is, what happens if you boot
> >>>> Boot0000)?
> >>>
> >>>
> >>> AFAIK the kernel on Jeremy's tablet (which I initially installed) is
64 bit.
> >>>
> >>> Could the problem perhaps be that the new code for the TPM event-log
is
> >>> missing some handling to deal with running on a 32 bit firmware? I
know the
> >>> rest of the kernel has special code to deal with this.
> >>>
> >>
> >> That is a very good point, and I missed that this is a 64-bit kernel
> >> running on 32-bit UEFI.
> >>
> >> The TPM code does use efi_call_proto() directly, and now I am thinking
> >> it is perhaps the allocate_pages() call that simply only initializes
> >> the low 32-bits of log_tbl.
> >>
> >> Jeremy, could you please try initializing tcg2_protocol and log_tbl to
> >> NULL at the start of the function?
> >>
> >
> > That was it, it boots when those are initialized to NULL.
> >

> Thanks for confirming. I'll send out a patch.

Sweet!
Jeremy, Hans, thanks for the help debugging!
Ard, thanks for the help fixing the issue!
