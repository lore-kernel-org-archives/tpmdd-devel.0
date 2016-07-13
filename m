From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v9 0/5] tpm: Command duration logging and chip-specific
 override
Date: Wed, 13 Jul 2016 14:59:28 -0600
Message-ID: <20160713205928.GA28234@obsidianresearch.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
 <CAO_EM_mpkeiC1psOYWz8RWsuJFR9HAQ7u5AH5qzSzR=VQ_jTPw@mail.gmail.com>
 <20160713173613.GD19657@obsidianresearch.com>
 <CAO_EM_=9ON4vAxOCvUJ3Z+pic_An6wkriZrh4csZ_0DibHSQYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO_EM_=9ON4vAxOCvUJ3Z+pic_An6wkriZrh4csZ_0DibHSQYQ@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ed Swierk <eswierk@skyportsystems.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Stefan Berger <stefanb@us.ibm.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 01:00:28PM -0700, Ed Swierk wrote:
> On Wed, Jul 13, 2016 at 10:36 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > I think your bios is broken?
> 
> The BIOS is broken in many ways. I already have to pass
> memmap=256M$0x80000000, otherwise PCIe extended config space
> (MMCONFIG) is inaccessible. Also I found memmap=0x7000$0x7a7d0000
> works around "APEI: Can not request [mem 0x7a7d0018-0x7a7d0067] for
> APEI ERST registers", as the BIOS seems to be mistakenly reserving
> 0x7b7d0000-7b7d7000 instead.

Is it is possible whatever causes the 'reserve RAM buffer' behavior in
the kernel is wonky with your BIOS? That seems to be a special Linux
action..

Could it be Xen related? The Xen hypervisor replaces the physical ram
map for the dom0 guest, which is why you get these sorts of prints:
 Xen: [mem 0x0000000000000000-0x000000000005ffff] usable
and not:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable

Jason
