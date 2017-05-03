From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/3] Extend the vTPM proxy driver to pass locality to
 emulator
Date: Wed, 3 May 2017 19:42:06 -0400
Message-ID: <72bacff5-5213-b114-ebf4-6e3fe7284bdc@linux.vnet.ibm.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170503223849.qcoc6xqncbyi6jwj@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170503223849.qcoc6xqncbyi6jwj@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 05/03/2017 06:38 PM, Jarkko Sakkinen wrote:
> On Fri, Apr 28, 2017 at 09:02:15AM -0400, Stefan Berger wrote:
>> The purpose of this series of patches is to enable the passing of the locality
>> a command is executing in to a TPM emulator. To enable this we introduce a new
>> flag for the device creation ioctl that requests that the locality be prepended
>> to every command. For applications to check which flags the driver supports, we
>> add a new ioctl that returns a bitmask of supported flags.
> This is a weird change proposal as you could use tpm_vtpm_proxy for
> other than some TPM emulator.

I think in most cases the recipient of the TPM commands from the 
vtpm_proxy driver will be a TPM emulator. What do you have in mind?

>
>> v1->v2:
>>    - fixed return value from function in patch 3/3
>>
>>
>> Stefan Berger (3):
>>    tpm: vtpm_proxy: Add ioctl to get supported flags
>>    tpm: vtpm_proxy: Implement request_locality
>>    tpm: vtpm_proxy: Add ioctl to request locality prepended to command
>>
>>   drivers/char/tpm/tpm_vtpm_proxy.c | 53 +++++++++++++++++++++++++++++++++++----
>>   include/uapi/linux/vtpm_proxy.h   | 15 ++++++++++-
>>   2 files changed, 62 insertions(+), 6 deletions(-)
>>
>> -- 
>> 2.4.3
>>
> /Jarkko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
