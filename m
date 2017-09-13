From: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm: parse TPM event logs based on EFI table
Date: Wed, 13 Sep 2017 18:43:49 +0200
Message-ID: <CA+zpnLfEscJDi3Yd3LiWH5v7iNuzV6gRk6Cmdkrme3f1ivLbLg@mail.gmail.com>
References: <20170911100022.7251-4-tweek@google.com> <201709140034.ESdZA8H8%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201709140034.ESdZA8H8%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Fixed in next patch set

On Wed, Sep 13, 2017 at 6:27 PM, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi Thiebaud,
>
> [auto build test ERROR on efi/next]
> [also build test ERROR on next-20170913]
> [cannot apply to char-misc/char-misc-testing linus/master v4.13]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Thiebaud-Weksteen/Call-GetEventLog-before-ExitBootServices/20170913-221312
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
> config: i386-randconfig-x076-201737 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>>> drivers/char/tpm/tpm_efi.c:20:5: error: redefinition of 'tpm_read_log_efi'
>     int tpm_read_log_efi(struct tpm_chip *chip)
>         ^~~~~~~~~~~~~~~~
>    In file included from drivers/char/tpm/tpm_efi.c:17:0:
>    drivers/char/tpm/tpm.h:603:19: note: previous definition of 'tpm_read_log_efi' was here
>     static inline int tpm_read_log_efi(struct tpm_chip *chip)
>                       ^~~~~~~~~~~~~~~~
>
> vim +/tpm_read_log_efi +20 drivers/char/tpm/tpm_efi.c
>
>     18
>     19  /* read binary bios log from EFI configuration table */
>   > 20  int tpm_read_log_efi(struct tpm_chip *chip)
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
