From: "Peter Huewe" <PeterHuewe@gmx.de>
Subject: Aw: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Wed, 9 Aug 2017 22:43:07 +0200
Message-ID: <trinity-56ff4f3f-5e08-4aac-9353-a7b88fe91f01-1502311387207@3c-app-gmx-bs76>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <819e3d38-3f16-a32b-1928-c425b763d5f8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <819e3d38-3f16-a32b-1928-c425b763d5f8@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Ken,

(speaking on behalf of myself here, not my employer :) )
> On Mon, Aug 07, 2017 at 01:52:34PM +0200, Peter Huewe wrote:
>> Imho: NACK from my side.
> After these viewpoints definitive NACK from my side too...


> I responded to the thread comments separately. However, assuming NACK
> is the final response, I have a question.

Nothing is ever final :)

> The problem is the 5 msec sleep between polls of burst count. In the
> case of one TPM with an 8 byte FIFO, a 32 byte transfer incurs 4 of
> these sleeps.

Yes that's bad, especially with current msleep(5) is actually msleep(20).
However, please also keep in mind SPI tpms show a much higher burst count value,  (255)
our I2C TPM SLB9645 even shows something in the range of 1k. :)


> Would another solution be to reduce the burst count poll and sleep to,
> e.g., 100 usec or even 10 usec? This would probably help greatly, but
> till not incur the wait states that triggered the NACK.

Imho the 5ms were an arbitrary chosen value for old old tpms.
Back then also only msleep was available which was msleep(20) anyway.


> My worry is that the scheduler would not be able to context switch that
> fast, and so we wouldn't actually see usec speed polling.
> Can a kernel expert offer an opinion?
If you use sleep it's not guaranteed that you wakeup after exactly xx specified amount of time.
Just that you sleep at least xx amount of time. Otherwise you would have to do delay/busywaiting.

https://www.kernel.org/doc/Documentation/timers/timers-howto.txt


Imho the best option is to
figure out whether any vendor can determine the "FIFO flush time" i.e. how much time does it take to empty the fifo and fillup the burstcount and use this on the lower bound of an usleep range.
I don't think tpms are in the range of < 10 us...

@Ken: Maybe can you check in DDWG?

What we often see/saw during some performance optimization tests is something like 
burstcount 7, burstcount 1, burstcount 7, burstcount 1...
which is the oposite of what you want to achieve.

You'd like to have something like
burstcount 8, burstcount 8, burstcount 8....

Unfortunately TPMS don't report their max burstcount (afaik),
otherwise it would be easy to write a calibration routine for the poll times.


Thanks,
Peter
