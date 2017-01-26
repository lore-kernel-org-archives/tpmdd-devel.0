From: Ashley Lai <ashleydlai@gmail.com>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Thu, 26 Jan 2017 16:58:15 -0600
Message-ID: <024dadba-a75c-ab59-9d12-a9bea81f9bda@gmail.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
 <20170126220536.GB31937@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170126220536.GB31937@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Michal Such??nek <msuchanek@suse.de>, Nayna Jain <nayna@linux.vnet.ibm.com>, honclo@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Adding Vicky from IBM.


On 01/26/2017 04:05 PM, Jason Gunthorpe wrote:
> On Thu, Jan 26, 2017 at 09:22:48PM +0100, Michal Such??nek wrote:
>
>> This is repeated a few times in the driver so I added memset to quiet
>> gcc and make behavior deterministic in case the unused fields get some
>> meaning in the future.
> Yep, reserved certainly needs to be zeroed.. Can you send a patch?
> memset is overkill...
>
>> However, in tpm_ibmvtpm_send the structure is initialized as
>>
>> 	struct ibmvtpm_crq crq;
>>          __be64 *word = (__be64 *)&crq;
>> ...
>>          crq.valid = (u8)IBMVTPM_VALID_CMD;
>>          crq.msg = (u8)VTPM_TPM_COMMAND;
>>          crq.len = cpu_to_be16(count);
>>          crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);
>>
>> and submitted with
>>
>> 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
>>                                be64_to_cpu(word[1]));
>> meaning it is swapped twice.
> No idea, Nayna may know.
>
> My guess is that '__be64 *word' should be 'u64 *word'...
>
> Jason
