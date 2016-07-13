From: Ed Swierk <eswierk@skyportsystems.com>
Subject: Re: [PATCH v9 0/5] tpm: Command duration logging and chip-specific override
Date: Wed, 13 Jul 2016 09:44:05 -0700
Message-ID: <CAO_EM_mpkeiC1psOYWz8RWsuJFR9HAQ7u5AH5qzSzR=VQ_jTPw@mail.gmail.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com> <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Stefan Berger <stefanb@us.ibm.com>, Ed Swierk <eswierk@skyportsystems.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 9:19 AM, Ed Swierk <eswierk@skyportsystems.com> wrote:
> v9: Include command duration in existing error messages rather than
> logging an extra debug message. Rebase onto Jarkko's tree.

Incidentally, with Jarkko's tree the tpm_tis module refuses to
initialize (with or without force=1):

tpm_tis 00:03: can't request region for resource [mem 0xfed40000-0xfed44fff]
tpm_tis: probe of 00:03 failed with error -16

The memory region is not marked reserved by the BIOS:

e820: BIOS-provided physical RAM map:
Xen: [mem 0x0000000000000000-0x000000000005ffff] usable
Xen: [mem 0x0000000000060000-0x0000000000067fff] reserved
Xen: [mem 0x0000000000068000-0x000000000009afff] usable
Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
Xen: [mem 0x0000000000100000-0x0000000075b01fff] usable
Xen: [mem 0x0000000075baf000-0x000000007a1f5fff] usable
Xen: [mem 0x000000007b7d7000-0x000000007b7fffff] usable
Xen: [mem 0x000000007bf00000-0x000000007bffffff] usable
Xen: [mem 0x00000000c7ffc000-0x00000000c7ffcfff] reserved
Xen: [mem 0x00000000fbffc000-0x00000000fbffcfff] reserved
Xen: [mem 0x00000000fec00000-0x00000000fec01fff] reserved
Xen: [mem 0x00000000fec40000-0x00000000fec40fff] reserved
Xen: [mem 0x00000000fed20000-0x00000000fed2ffff] usable
Xen: [mem 0x00000000fee00000-0x00000000feefffff] reserved
Xen: [mem 0x0000000100000000-0x0000000505deafff] usable

With force=1, /proc/iomem shows:

fed30000-fedfffff : RAM buffer
  fed40000-fed44fff : tpm_tis

I can work around this problem by passing memmap=0x5000$0xfed40000 on
the kernel command line.

--Ed
