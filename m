From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Fri, 27 Jan 2017 12:32:43 -0800
Message-ID: <48dc15a0-eaba-29e4-f39e-500177f98638@linux.vnet.ibm.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
 <d55b06cc-cb7a-1ef1-05b7-d7d4114d0c48@linux.vnet.ibm.com>
 <1485481819.2980.82.camel@kernel.crashing.org>
 <e518682f-e563-9533-9ffd-f465c662e998@linux.vnet.ibm.com>
 <1485547137.2980.94.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1485547137.2980.94.camel@kernel.crashing.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>, Ashley Lai <ashleydlai@gmail.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/27/2017 11:58 AM, Benjamin Herrenschmidt wrote:
> On Fri, 2017-01-27 at 10:02 -0800, Tyrel Datwyler wrote:
>>> The problem is that we are packing an in-memory structure into 2
>>> registers and it's expected that this structure is laid out in the
>>> registers as if it had been loaded by a BE CPU.
>>
>> This is only the case if the cpu is BE. If the cpu is LE, regardless of
>> the fact that our in memory structure is laid out BE, when we break it
>> into 2 words each of those words needs to be loaded LE.
> 
> That doesn't make sense and doesn't match the code... The structure
> needs to always have the same in-register layout regardless of the
> endianness of the CPU, especially since the underlying hypervisor
> will most likely be BE :-)
> 
> Thta's why the code does a be64_to_cpu() when loading it, this in
> effect performs a "BE" load, which on a BE CPU is just a normal load
> and on LE is a swap to compensate for the CPU loading it the "wrong way
> around".

Its possible being the end of the week I'm just a little dense, but
wouldn't be64_to_cpu() imply that we are byte-swapping something that is
already, or supposedly already, in BE format to cpu endianness? Which on
a BE cpu I would expect a no-op, and on a LE cpu the 64bit word to have
been swapped from BE --> LE?

In my eyes the code does seem to support what I've argued. The same
thing is done in the scsi VIO drivers. The CRQ structure is laid out and
annotated BE. We use cpu_to_be() calls to load any non 8bit field.
Finally, each word is swapped to cpu endian when we hand it off for the
hcall.

from ibmvfc_send_event():

        __be64 *crq_as_u64 = (__be64 *) &evt->crq;

	<..snip..>

        if ((rc = ibmvfc_send_crq(vhost, be64_to_cpu(crq_as_u64[0]),
                                  be64_to_cpu(crq_as_u64[1])))) {

Again, maybe I'm missing something.

-Tyrel

> 
> Cheers,
> Ben.
> 
