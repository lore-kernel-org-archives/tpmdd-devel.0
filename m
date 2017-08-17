From: Haris Okanovic <haris.okanovic-acOepvfBmUk@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: fix stall after iowrite*()s
Date: Thu, 17 Aug 2017 15:12:01 -0500
Message-ID: <d2d75a03-ce03-271e-ca9e-0ad453a650f7@ni.com>
References: <20170804215651.29247-1-haris.okanovic@ni.com>
 <20170815201308.20024-1-haris.okanovic@ni.com>
 <13741b28-1b5c-de55-3945-e05911e5a4e2@linux.vnet.ibm.com>
 <20170817103807.ubrbylnud6wxod3s@linutronix.de>
 <20170817171732.GA22792@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170817171732.GA22792-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sebastian Andrzej Siewior <sebastian.siewior-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: julia.cartwright-acOepvfBmUk@public.gmane.org, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, harisokn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, eric.gardiner-acOepvfBmUk@public.gmane.org, jonathan.david-acOepvfBmUk@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, scott.hartman-acOepvfBmUk@public.gmane.org, chris.graf-acOepvfBmUk@public.gmane.org, gratian.crisan-acOepvfBmUk@public.gmane.org, brad.mouring-acOepvfBmUk@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Neither wmb() nor mb() have any effect when substituted for 
ioread8(iobase + TPM_ACCESS(0)) in tpm_tis_flush(). I still see 300 - 
400 us spikes in cyclictest invoking my TPM chip's RNG.

-- Haris


On 08/17/2017 12:17 PM, Jason Gunthorpe wrote:
> On Thu, Aug 17, 2017 at 12:38:07PM +0200, Sebastian Andrzej Siewior wrote:
> 
>>> I worry a bit about "appears to fix".  It seems odd that the TPM device
>>> driver would be the first code to uncover this.  Can anyone confirm that the
>>> chipset does indeed have this bug?
>>
>> What Haris says makes sense. It is just not all architectures
>> accumulate/ batch writes to HW.
> 
> It doesn't seem that odd to me.. In modern Intel chipsets the physical
> LPC bus is used for very little. Maybe some flash and possibly a
> winbond super IO at worst?  Plus the TPM.
> 
> I can't confirm what Intel has done, but if writes are posted, then it
> is not a 'bug', but expected operation for a PCI/LPC bridge device to
> have an ordered queue of posted writes, and thus higher latency when
> processing reads due to ordering requirments.
> 
> Other drivers may not see it because most LPC usages would not be
> write heavy, or might use IO instructions which are not posted..
> 
> I can confirm that my ARM systems with a custom PCI-LPC bridge will
> have exactly the same problem, and that the readl is the only
> solution.
> 
> This is becuase writes to LPC are posted over PCI and will be buffered
> in the root complex, device end port and internally in the LPC
> bridge. Since they are posted there is no way for the CPU to know when
> the complete and when it would be 'low latency' to issue a read.
> 
>> So powerpc (for instance) has a sync operation after each write to HW. I
>> am wondering if we could need something like that on x86.
> 
> Even on something like PPC 'sync' is not defined to globally flush
> posted writes, and wil not help. WMB is probably similar.
> 
> Jason
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
