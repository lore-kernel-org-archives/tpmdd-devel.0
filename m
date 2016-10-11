From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/3] tpm: replace dynamically allocated bios_dir
 with a static array
Date: Tue, 11 Oct 2016 22:49:56 +0530
Message-ID: <57FD1F3C.6070705@linux.vnet.ibm.com>
References: <1475349926-476-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1475349926-476-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <57FBE39B.2030301@linux.vnet.ibm.com> <20161011112315.GB21688@intel.com>
 <20161011165355.GB6881@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161011165355.GB6881@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net



On 10/11/2016 10:23 PM, Jason Gunthorpe wrote:
> On Tue, Oct 11, 2016 at 02:23:15PM +0300, Jarkko Sakkinen wrote:
>>>> +	chip->bios_dir[cnt] =
>>>>   	    securityfs_create_file("ascii_bios_measurements",
>>>> -				   S_IRUSR | S_IRGRP, tpm_dir,
>>>> +				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
>>>>   				   (void *)&tpm_ascii_b_measurments_seqops,
>>>>   				   &tpm_bios_measurements_ops);
>
>>>> +	if (is_bad(chip->bios_dir[cnt]))
>>>> +		goto err;
>
>>>> +err:
>>>> +	chip->bios_dir[cnt] = NULL;
>>>
>>> The updated patch looks fine.
>>> Just, I am not sure if NULL assignment is needed.
>>
>> It's not needed.
>
> It is required to switch an ERR_PTR to NULL, see is_bad()

My understanding is that securityfs_remove() takes care of both NULL and 
ERR_PTR().

 From securityfs_remove():

  if (!dentry || IS_ERR(dentry))
                 return;

Thanks & Regards,
   - Nayna

>
> The original version that used a counter in chip did not need it.
>
> Jason
>
