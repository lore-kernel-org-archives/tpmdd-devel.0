From: msuchanek <msuchanek@suse.de>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Sat, 28 Jan 2017 01:35:27 +0100
Message-ID: <5420c93884aee76cbbf5b961d709ba3d@suse.de>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
 <d55b06cc-cb7a-1ef1-05b7-d7d4114d0c48@linux.vnet.ibm.com>
 <1485481819.2980.82.camel@kernel.crashing.org>
 <e518682f-e563-9533-9ffd-f465c662e998@linux.vnet.ibm.com>
 <1485547137.2980.94.camel@kernel.crashing.org>
 <48dc15a0-eaba-29e4-f39e-500177f98638@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <48dc15a0-eaba-29e4-f39e-500177f98638@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ashley Lai <ashleydlai@gmail.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hello,

On 2017-01-27 21:32, Tyrel Datwyler wrote:
> On 01/27/2017 11:58 AM, Benjamin Herrenschmidt wrote:
>> On Fri, 2017-01-27 at 10:02 -0800, Tyrel Datwyler wrote:
>>>> The problem is that we are packing an in-memory structure into 2
>>>> registers and it's expected that this structure is laid out in the
>>>> registers as if it had been loaded by a BE CPU.
>>> 
>>> This is only the case if the cpu is BE. If the cpu is LE, regardless 
>>> of
>>> the fact that our in memory structure is laid out BE, when we break 
>>> it
>>> into 2 words each of those words needs to be loaded LE.
>> 
>> That doesn't make sense and doesn't match the code... The structure
>> needs to always have the same in-register layout regardless of the
>> endianness of the CPU, especially since the underlying hypervisor
>> will most likely be BE :-)
>> 
>> Thta's why the code does a be64_to_cpu() when loading it, this in
>> effect performs a "BE" load, which on a BE CPU is just a normal load
>> and on LE is a swap to compensate for the CPU loading it the "wrong 
>> way
>> around".
> 
> Its possible being the end of the week I'm just a little dense, but
> wouldn't be64_to_cpu() imply that we are byte-swapping something that 
> is
> already, or supposedly already, in BE format to cpu endianness? Which 
> on
> a BE cpu I would expect a no-op, and on a LE cpu the 64bit word to have
> been swapped from BE --> LE?
> 
> In my eyes the code does seem to support what I've argued. The same
> thing is done in the scsi VIO drivers. The CRQ structure is laid out 
> and
> annotated BE. We use cpu_to_be() calls to load any non 8bit field.
> Finally, each word is swapped to cpu endian when we hand it off for the
> hcall.
> 
> from ibmvfc_send_event():
> 
>         __be64 *crq_as_u64 = (__be64 *) &evt->crq;
> 
> 	<..snip..>
> 
>         if ((rc = ibmvfc_send_crq(vhost, be64_to_cpu(crq_as_u64[0]),
>                                   be64_to_cpu(crq_as_u64[1])))) {
> 
> Again, maybe I'm missing something.
> 

Ok, so you perform really difficult operation for no good reason. You 
say
that the ppc dual-endian works like this: there is an internal in-cpu
representation of numbers which is always the same. What is affected by
switching endian is how memory loads and stores work.

If you pass these two words in registers you never need to swap 
anything.

> Byte  |   0   |   1   |   2   |   3   |   4   |   5   |   6   |   7
> -----------------------------------------------------------------------
> Word0 | Valid | Type  |     Length    |              Data
> -----------------------------------------------------------------------
> Word1 |                Reserved
> -----------------------------------------------------------------------
> 
> The following definition looks to match:
> 
> struct ibmvtpm_crq {
>         u8 valid;
>         u8 msg;
>         __be16 len;
>         __be32 data;
>         __be64 reserved;
> } __attribute__((packed, aligned(8)));

If under BE valid is first byte then it is MSB and you would get value
to pass in word 0 as (valid << 56) | (type << 48) | (length << 32 ) | 
data.

No swaps involved.

To achieve same with structure and swaps you would indeed first swap the
members and then the whole word. Much harder to read code that way, 
though.

Thanks

Michal
