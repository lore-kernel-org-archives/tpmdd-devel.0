From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: Aw: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Fri, 11 Aug 2017 17:54:19 -0400
Message-ID: <b8693dd5-7c28-f8f0-fa27-1f204ef7e64c@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
 <819e3d38-3f16-a32b-1928-c425b763d5f8@linux.vnet.ibm.com>
 <trinity-56ff4f3f-5e08-4aac-9353-a7b88fe91f01-1502311387207@3c-app-gmx-bs76>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <trinity-56ff4f3f-5e08-4aac-9353-a7b88fe91f01-1502311387207@3c-app-gmx-bs76>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 8/9/2017 4:43 PM, Peter Huewe wrote:
> 
> Yes that's bad, especially with current msleep(5) is actually
> msleep(20). However, please also keep in mind SPI tpms show a much
> higher burst count value,  (255) our I2C TPM SLB9645 even shows
> something in the range of 1k. :)

One of our platforms has a TPM 1.2 with an 8 byte FIFO and a static 
burst count.  This is where we're debugging.

>> Would another solution be to reduce the burst count poll and sleep
>> to, e.g., 100 usec or even 10 usec? This would probably help
>> greatly, but till not incur the wait states that triggered the
>> NACK.
>
> If you use sleep it's not guaranteed that you wakeup after exactly xx
> specified amount of time. Just that you sleep at least xx amount of
> time. Otherwise you would have to do delay/busywaiting.

Understood.  However, if the DD maintainers will not accept ignoring 
burstCount, would a short sleep (e.g., 10 usec) be acceptable.

If so, we can benchmark it.

> Imho the best option is to figure out whether any vendor can
> determine the "FIFO flush time" i.e. how much time does it take to
> empty the fifo and fillup the burstcount and use this on the lower
> bound of an usleep range. I don't think tpms are in the range of < 10
> us...
> 
> @Ken: Maybe can you check in DDWG?

I asked this week.

Nuvoton, ST Micro, and Infineon confirmed that the TPM empties a byte 
from the FIFO in under 1 usec.  So, even with a static burst count, the 
entire FIFO would empty in under 10 usec.
