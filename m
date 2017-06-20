From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm: consolidate the TPM startup code
Date: Tue, 20 Jun 2017 18:16:22 -0400
Message-ID: <f3483724-0ad6-0c12-3c02-2a511069ed17@linux.vnet.ibm.com>
References: <20170620181334.28363-1-jarkko.sakkinen@linux.intel.com>
 <20170620193152.GA3368@obsidianresearch.com>
 <20170620205529.ku3nueglj3mqkd3s@linux.intel.com>
 <bcae756a-ab3a-f8ba-554c-61952e992844@linux.vnet.ibm.com>
 <20170620213241.x3rclqsb4a2gbthz@linux.intel.com>
 <20170620213804.t2ddp5pniuu4ssal@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170620213804.t2ddp5pniuu4ssal@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 06/20/2017 05:38 PM, Jarkko Sakkinen wrote:
> On Tue, Jun 20, 2017 at 11:32:41PM +0200, Jarkko Sakkinen wrote:
>> On Tue, Jun 20, 2017 at 05:25:57PM -0400, Stefan Berger wrote:
>>> On 06/20/2017 04:55 PM, Jarkko Sakkinen wrote:
>>>> On Tue, Jun 20, 2017 at 01:31:52PM -0600, Jason Gunthorpe wrote:
>>>>> On Tue, Jun 20, 2017 at 08:13:34PM +0200, Jarkko Sakkinen wrote:
>>>>>> Consolidated all the "manual" TPM startup code to a single function
>>>>>> in order to make code flows a bit cleaner and migrate to tpm_buf.
>>>>>>
>>>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>>>>>    drivers/char/tpm/tpm-interface.c | 67 +++++++++++++++++++++++++---------------
>>>>>>    drivers/char/tpm/tpm.h           |  6 +---
>>>>>>    drivers/char/tpm/tpm2-cmd.c      | 32 +------------------
>>>>>>    3 files changed, 44 insertions(+), 61 deletions(-)
>>>>> Makes sense to me
>>>>>
>>>>>> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
>>>>>> index d2b4df6d9894..fbef47d8bd06 100644
>>>>>> +++ b/drivers/char/tpm/tpm-interface.c
>>>>>> @@ -540,6 +540,47 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, struct tpm_space *space,
>>>>>>    }
>>>>>>    EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
>>>>>> +#define TPM_ORD_STARTUP 153
>>>>>> +#define TPM_ST_CLEAR 1
>>>>> We should really have a tpm1.h and tpm2.h that has all these various
>>>>> constants and things instead of open coding them randomly all over..
>>>>>
>>>>> Jason
>>>> I agree.
>>>>
>>>> Is this patch acceptable to be applied?
>>>>
>>>> Stefan, can you peer test this with a TPM emulator? For convenient testing
>>>> I created 'readpubek' branch that includes also my readpubek bug fixes.
>>>> Seeing that the module loads and you can output pubek sysfs attribute is
>>>> sufficient for seeing that all the three patches work.
>>> Doesn't work. The startup_type is be16, but you are appending a u32 now for
>>> both TPM1.2 and TPM2.
>>>
>>> +               tpm_buf_append_u32(&buf, TPM_ST_CLEAR);
>> Ah. Thanks. I'll fix that.
> It's fixed in the 'readpubek' branch. If that is the only concern, can
> you test that branch and see if it is OK so that we don't need a new
> cycle for the patch set?

TPM1.2 works now. TPM2 does not work and also needs u16 I think.

    Stefan


>
> /Jarkko
>

