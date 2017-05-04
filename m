From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/3] tpm: vtpm_proxy: Implement new ioctl to get
 supported flags
Date: Thu, 4 May 2017 13:28:17 -0400
Message-ID: <cfa2642e-5b6e-de69-b1a0-ddcbfaf691c6@linux.vnet.ibm.com>
References: <1493909787-1848-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1493909787-1848-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170504153416.GA15930@obsidianresearch.com>
 <56703d75-b238-0bad-386a-5b6963e250a1@linux.vnet.ibm.com>
 <20170504172042.GA19932@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170504172042.GA19932@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jarkko.sakkinen@linux.intel.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 05/04/2017 01:20 PM, Jason Gunthorpe wrote:
> On Thu, May 04, 2017 at 01:13:18PM -0400, Stefan Berger wrote:
>> On 05/04/2017 11:34 AM, Jason Gunthorpe wrote:
>>> On Thu, May 04, 2017 at 10:56:25AM -0400, Stefan Berger wrote:
>>>> Implement VTPM_PROXY_IOC_GET_SUPT_FLAGS ioctl to get the bitmask
>>>> of flags that the vtpm_proxy driver supports in the
>>>> VTPM_PROXY_IOC_NEW_DEV ioctl. This helps user space in deciding
>>>> which flags to set in that ioctl.
>>> you might be better off just having a VTPM_PROXY_IO_ENABLE_FEATURE
>>> .feature = LOCALITY
>> Do you have an example driver that shows how to do this ? Can user space
>> query that feature?
> Try and enable the feature, if it fails then there is no feature in
> the kernel.
>
> This is the usual way to add new syscalls..
>
>>> If that fails then the feature is not supported, no real need for the
>>> query in that case.
>>>
>>> Not sure about Jarkko's point on request/release locality.. Is there a
>>> scenario where the emulator should fail the request locality?
>> We could filter localities 5 and higher on the level of the driver (patch
>> 2/3) since basically there are only 5 localities (0-4) in any TPM interface
>> today. The typical hardware locality 4 would be filtered by the emulator per
>> policy passed via command line, but I would allow it on the level of this
>> driver. An error message would be returned for any command executed in that
>> locality, unless the 'policy' allows it. Localities 0-3 should just be
>> selectable. The TPM TIS (in the hardware) implements some complicated scheme
>> when it comes to allowing the selection of a locality and I would say we
>> need none of that but just tell the vTPM proxy driver the locality (patch
>> 2/3) in which the next command will be executed.
> Well, if TIS hardware has some scheme I feel like the emulator uAPI should
> have enough fidelity to ecompass existing hardware, even if your
> current emulator does not need it.
>
> So allowing request_locality to fail from userspace seems reasonable.

What's the best interface to use for this ?


