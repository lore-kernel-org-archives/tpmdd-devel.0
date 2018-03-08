From: Thiebaud Weksteen <tweek@google.com>
Subject: Re: Regression from efi: call get_event_log before ExitBootServices
Date: Thu, 08 Mar 2018 08:45:22 +0000
Message-ID: <CA+zpnLf1WNxYY-FaoFbas480GmkUW6kw_L7zi5mES3EPhL7egA@mail.gmail.com>
References: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
 <CA+zpnLdSyuyKjJEH3Oowmha2mF0B-j5b4A7CLuXXY7RH47SiFQ@mail.gmail.com> <0100016201863c0f-70600bd6-12d3-461d-9173-e4d61e8d09d5-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0100016201863c0f-70600bd6-12d3-461d-9173-e4d61e8d09d5-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Cline <jeremy@jcline.org>
Cc: Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, hdegoede@redhat.com, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Mar 7, 2018 at 6:33 PM Jeremy Cline <jeremy@jcline.org> wrote:

> On 03/07/2018 03:41 AM, Thiebaud Weksteen wrote:
> > Hi,
> >
> > Thanks for testing and sending this report! This patch relies heavily on
> > the functions exposed by the firmware. My first guess would be that
some of
> > these may not be implemented correctly by the manufacturer.
> >
> > Could you share more information on this specific device?
> > Do you have any link to the manufacturer website (I found [1] but it is
> > based on an ARM CPU)?
> > Do you have the option to update your firmware? Is a copy of the
firmware
> > available from the manufacturer?

> I couldn't find a copy of the firmware, unfortunately.

No worries, thanks for looking that up.


> > On your side, I assume no error message got displayed on the screen when
> > booting. Would you be able to try to boot in an UEFI shell [2] and
execute
> > the command "dh -v"?

> Yup, no errors on the screen. I've attached the output of dh -v from the
> UEFI shell.

Great, thanks for that. There is a module that exposes the EfiTcg2Protocol
(TrEEDxe). So I'm going to assume this is properly located and then called.
Unfortunately, this is so early in the boot that we can only rely on the
EFI functions for logging/debugging.

Jeremy, Hans, could you both describe precisely how your boot is
configured? This feature is only triggered when booting the EFI stub of the
kernel so this may be not executed if you are using something else in
between.

Jeremy, would you be able to modify the efi_retrieve_tpm2_eventlog_1_2
function to add multiple efi_printk(sys_table_arg,  "message\n"); to test:
if you get the output on your screen; and isolate which call might be the
cause of the hang?
I can forward a debug patch if that helps.

Thanks



> Regards,
> Jeremy
