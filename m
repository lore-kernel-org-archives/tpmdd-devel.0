From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v9 0/5] tpm: Command duration logging and
 chip-specific override
Date: Wed, 13 Jul 2016 11:36:13 -0600
Message-ID: <20160713173613.GD19657@obsidianresearch.com>
References: <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
	<1468426776-42762-1-git-send-email-eswierk@skyportsystems.com>
	<CAO_EM_mpkeiC1psOYWz8RWsuJFR9HAQ7u5AH5qzSzR=VQ_jTPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAO_EM_mpkeiC1psOYWz8RWsuJFR9HAQ7u5AH5qzSzR=VQ_jTPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 13, 2016 at 09:44:05AM -0700, Ed Swierk wrote:
> On Wed, Jul 13, 2016 at 9:19 AM, Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org> wrote:
> > v9: Include command duration in existing error messages rather than
> > logging an extra debug message. Rebase onto Jarkko's tree.
> 
> Incidentally, with Jarkko's tree the tpm_tis module refuses to
> initialize (with or without force=1):
> 
> tpm_tis 00:03: can't request region for resource [mem 0xfed40000-0xfed44fff]
> tpm_tis: probe of 00:03 failed with error -16
>
> The memory region is not marked reserved by the BIOS:
> fed30000-fedfffff : RAM buffer

I think your bios is broken?

A working BIOS will look like this:

 $ cat /proc/iomem  | grep -i fed400
 fed40000-fed44fff : pnp 00:00

It sets aside the struct resource during pnp:

 [    0.097318] pnp: PnP ACPI init
 [    0.097366] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved

What did your system do?

You should see prints like this:

                printk(KERN_DEBUG
                       "e820: reserve RAM buffer [mem %#010llx-%#010llx]\n",
                       start, end);

Which only happen if E820_RAM is set, which is certainly not right for
TPM memory.

I don't know what kernel convention is to handle these sorts of
defects?

Is the use of the memmap kernel command line an appropriate work
around?

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
