From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Tue, 31 Jan 2017 19:38:32 +1100
Message-ID: <87a8a7vd2v.fsf@concordia.ellerman.id.au>
References: <20170126212248.3f3e9103@kitsune.suse.cz> <d55b06cc-cb7a-1ef1-05b7-d7d4114d0c48@linux.vnet.ibm.com> <1485481819.2980.82.camel@kernel.crashing.org> <CAOMqctQtspCTTpfEUyUVyE9GKYOavZNhkXnRPUrPZrDZ6-eG0w@mail.gmail.com> <73c1e5be-0820-8dca-c86a-8cf3ffeb5efe@linux.vnet.ibm.com> <87tw8hw4k7.fsf@concordia.ellerman.id.au> <d2da4b82-9686-187c-c514-96a506e994cc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d2da4b82-9686-187c-c514-96a506e994cc@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Michal Suchanek <hramrach@gmail.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>, Ashley Lai <ashleydlai@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Michal =?utf-8?Q?Such=C3=A1nek?= <msuchanek@suse.de>, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:
> On 01/29/2017 08:32 PM, Michael Ellerman wrote:
>> Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:
>>>
>>> Byte  |   0   |   1   |   2   |   3   |   4   |   5   |   6   |   7
>>> -----------------------------------------------------------------------
>>> Word0 | Valid | Type  |     Length    |              Data
>>> -----------------------------------------------------------------------
>>> Word1 |				Reserved
>>> -----------------------------------------------------------------------
>>>
>>> The following definition looks to match:
>>>
>>> struct ibmvtpm_crq {
>>>         u8 valid;
>>>         u8 msg;
>>>         __be16 len;
>>>         __be32 data;
>>>         __be64 reserved;
>>> } __attribute__((packed, aligned(8)));
>> 
>> Well it's a partial match.
>> 
>> Your layout above doesn't define which byte of Length or Data is the MSB
>> or LSB. So going by that we still don't know the endianness of either
>
> I should have been explicit that PAPR uses Big Endian bit and byte
> numbering throughout the spec unless otherwise noted.

OK. I didn't actually remember that so yeah good to be explicit.

cheers
