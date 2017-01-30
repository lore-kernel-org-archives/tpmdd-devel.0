From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Mon, 30 Jan 2017 15:32:40 +1100
Message-ID: <87tw8hw4k7.fsf@concordia.ellerman.id.au>
References: <20170126212248.3f3e9103@kitsune.suse.cz> <d55b06cc-cb7a-1ef1-05b7-d7d4114d0c48@linux.vnet.ibm.com> <1485481819.2980.82.camel@kernel.crashing.org> <CAOMqctQtspCTTpfEUyUVyE9GKYOavZNhkXnRPUrPZrDZ6-eG0w@mail.gmail.com> <73c1e5be-0820-8dca-c86a-8cf3ffeb5efe@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <73c1e5be-0820-8dca-c86a-8cf3ffeb5efe@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Michal Suchanek <hramrach@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>, Ashley Lai <ashleydlai@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

> On 01/27/2017 01:03 AM, Michal Suchanek wrote:
>> On 27 January 2017 at 02:50, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>>> On Thu, 2017-01-26 at 17:42 -0800, Tyrel Datwyler wrote:
>>>> On 01/26/2017 12:22 PM, Michal Suchánek wrote:
>>>>> Hello,
>>>>>
>>>>> building ibmvtpm I noticed gcc warning complaining that second word
>>>>> of
>>>>> struct ibmvtpm_crq in tpm_ibmvtpm_suspend is uninitialized.
>>>>>
>>>>> The structure is defined as
>>>>>
>>>>> struct ibmvtpm_crq {
>>>>>         u8 valid;
>>>>>         u8 msg;
>>>>>         __be16 len;
>>>>>         __be32 data;
>>>>>         __be64 reserved;
>>>>> } __attribute__((packed, aligned(8)));
>>>>>
>>>>> initialized as
>>>>>
>>>>>         struct ibmvtpm_crq crq;
>>>>>         u64 *buf = (u64 *) &crq;
>>>>> ...
>>>>>         crq.valid = (u8)IBMVTPM_VALID_CMD;
>>>>>         crq.msg = (u8)VTPM_PREPARE_TO_SUSPEND;
>>>>>
>>>>> and submitted with
>>>>>
>>>>>         rc = ibmvtpm_send_crq(ibmvtpm->vdev, cpu_to_be64(buf[0]),
>>>>>                               cpu_to_be64(buf[1]));
>>>>
>>>> These should be be64_to_cpu() here. The underlying hcall made by
>>>> ibmvtpm_send_crq() requires parameters to be in cpu endian unlike the
>>>> RTAS interface which requires data in BE.
>>>
>>> Hrm... an hcall takes register arguments. Register arguments don't have
>>> an endianness.
>>>
>>> The problem is that we are packing an in-memory structure into 2
>>> registers and it's expected that this structure is laid out in the
>>> registers as if it had been loaded by a BE CPU.
>>>
>>> So we have two things at play here:
>>>
>>>   - The >8-bit fields should be laid out BE in the memory image
>>>   - That whole 128-bit structure should be loaded into 2 64-bit
>>> registers MSB first.
>>>
>>> So the "double" swap is somewhat needed. The uglyness comes from the
>>> passing-by-register of the h-call but it should work.
>>>
>>> That said, be64_to_cpup(buf) and be64_to_cpup(buf+1) might give you
>>> better result (though recent gcc's might not make a difference).
>> 
>> If this should work then the below case that swaps the fields separately is
>> broken.
>> 
>> Anyway, structures have no endianess so when they start with a byte they
>> start with that byte no matter the host endian.
>> crq.valid is the first byte always. And then each field is to be swapped
>> separately.
>> 
>> On the other hand, bitfields are part of an integer and the field should be
>> swapped as part of the integer.
>> 
>> That is,
>> #define CRQ_VALID ((buf[0] >> 56) & 0xff)
>> CRQ_VALID is part of an integer in buf and would be laid out differently
>> on start or end depending on the host being BE or LE.
>> 
>> And the question is what the PAPR actually defines because both ways are
>> used in the code. You can describe an in-memory layout either way.
>
> Byte  |   0   |   1   |   2   |   3   |   4   |   5   |   6   |   7
> -----------------------------------------------------------------------
> Word0 | Valid | Type  |     Length    |              Data
> -----------------------------------------------------------------------
> Word1 |				Reserved
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

Well it's a partial match.

Your layout above doesn't define which byte of Length or Data is the MSB
or LSB. So going by that we still don't know the endianness of either
field.

cheers
