From: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v9 0/5] tpm: Command duration logging and
	chip-specific override
Date: Wed, 13 Jul 2016 13:00:28 -0700
Message-ID: <CAO_EM_=9ON4vAxOCvUJ3Z+pic_An6wkriZrh4csZ_0DibHSQYQ@mail.gmail.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
	<1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
	<CAO_EM_mpkeiC1psOYWz8RWsuJFR9HAQ7u5AH5qzSzR=VQ_jTPw@mail.gmail.com>
	<20160713173613.GD19657@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160713173613.GD19657-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 10:36 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I think your bios is broken?

The BIOS is broken in many ways. I already have to pass
memmap=256M$0x80000000, otherwise PCIe extended config space
(MMCONFIG) is inaccessible. Also I found memmap=0x7000$0x7a7d0000
works around "APEI: Can not request [mem 0x7a7d0018-0x7a7d0067] for
APEI ERST registers", as the BIOS seems to be mistakenly reserving
0x7b7d0000-7b7d7000 instead.

> A working BIOS will look like this:
>
>  $ cat /proc/iomem  | grep -i fed400
>  fed40000-fed44fff : pnp 00:00
>
> It sets aside the struct resource during pnp:
>
>  [    0.097318] pnp: PnP ACPI init
>  [    0.097366] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
>
> What did your system do?
>
> You should see prints like this:
>
>                 printk(KERN_DEBUG
>                        "e820: reserve RAM buffer [mem %#010llx-%#010llx]\n",
>                        start, end);
>
> Which only happen if E820_RAM is set, which is certainly not right for
> TPM memory.

On my system I see

e820: reserve RAM buffer [mem 0x0009b000-0x0009ffff]
e820: reserve RAM buffer [mem 0x75b02000-0x77ffffff]
e820: reserve RAM buffer [mem 0x7a1f6000-0x7bffffff]
e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
e820: reserve RAM buffer [mem 0xfed30000-0xffffffff]
e820: reserve RAM buffer [mem 0x505deb000-0x507ffffff]

which doesn't make a whole lot of sense, as several of those areas
overlap each other, never mind devices.

> I don't know what kernel convention is to handle these sorts of
> defects?
>
> Is the use of the memmap kernel command line an appropriate work
> around?

It works for me, though I would like to know if there's another approach.

--Ed

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
