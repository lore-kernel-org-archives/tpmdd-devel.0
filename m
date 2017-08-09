From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send() performance by
 ignoring burstcount
Date: Wed, 9 Aug 2017 16:23:12 -0400
Message-ID: <819e3d38-3f16-a32b-1928-c425b763d5f8@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
 <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
 <20170808191145.kggmoczd5laiccrn@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808191145.kggmoczd5laiccrn@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 8/8/2017 3:11 PM, Jarkko Sakkinen wrote:
> On Mon, Aug 07, 2017 at 01:52:34PM +0200, Peter Huewe wrote:
>> Imho: NACK from my side.
> After these viewpoints definitive NACK from my side too...


I responded to the thread comments separately.  However, assuming NACK 
is the final response, I have a question.

The problem is the 5 msec sleep between polls of burst count.  In the 
case of one TPM with an 8 byte FIFO, a 32 byte transfer incurs 4 of 
these sleeps.

Would another solution be to reduce the burst count poll and sleep to, 
e.g., 100 usec or even 10 usec?  This would probably help greatly, but 
still not incur the wait states that triggered the NACK.

My worry is that the scheduler would not be able to context switch that 
fast, and so we wouldn't actually see usec speed polling.

Can a kernel expert offer an opinion?
