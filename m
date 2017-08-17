From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [tpmdd-devel] [PATCH v2] tpm_tis: fix stall after iowrite*()s
Date: Thu, 17 Aug 2017 07:57:08 +0200
Message-ID: <2684601.PnLOm3uNmr@ws-stein>
References: <20170804215651.29247-1-haris.okanovic@ni.com> <20170815201308.20024-1-haris.okanovic@ni.com> <13741b28-1b5c-de55-3945-e05911e5a4e2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13741b28-1b5c-de55-3945-e05911e5a4e2@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wednesday 16 August 2017 17:15:55, Ken Goldman wrote:
> On 8/15/2017 4:13 PM, Haris Okanovic wrote:
> > ioread8() operations to TPM MMIO addresses can stall the cpu when
> > immediately following a sequence of iowrite*()'s to the same region.
> > 
> > For example, cyclitest measures ~400us latency spikes when a non-RT
> > usermode application communicates with an SPI-based TPM chip (Intel Atom
> > E3940 system, PREEMPT_RT_FULL kernel). The spikes are caused by a
> > stalling ioread8() operation following a sequence of 30+ iowrite8()s to
> > the same address. I believe this happens because the write sequence is
> > buffered (in cpu or somewhere along the bus), and gets flushed on the
> > first LOAD instruction (ioread*()) that follows.
> > 
> > The enclosed change appears to fix this issue: read the TPM chip's
> > access register (status code) after every iowrite*() operation to
> > amortize the cost of flushing data to chip across multiple instructions.
> 
> I worry a bit about "appears to fix".  It seems odd that the TPM device
> driver would be the first code to uncover this.  Can anyone confirm that
> the chipset does indeed have this bug?

No, there was already a similar problem in e1000e where a PCIe read stalled 
the CPU, hence no interrupts are serviced. See 
https://www.spinics.net/lists/linux-rt-users/msg14077.html
AFAIK there was no outcome though.

> I'd also like an indication of the performance penalty.  We're doing a
> lot of work to improve the performance and I worry that "do a read after
> every write" will have a performance impact.

Realtime will always affect performance, but IMHO the latter is much more 
important.

Best regards,
Alexander
