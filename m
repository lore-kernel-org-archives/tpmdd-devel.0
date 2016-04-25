From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v11 1/4] tpm: Remove all uses of drvdata from the TPM Core
Date: Mon, 25 Apr 2016 15:13:26 -0400
Message-ID: <571E6C56.4080305@linux.vnet.ibm.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1461000376-2888-2-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160422150645.GA21128@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160422150645.GA21128@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 04/22/2016 11:06 AM, Jarkko Sakkinen wrote:
> On Mon, Apr 18, 2016 at 01:26:13PM -0400, Stefan Berger wrote:
>> From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>>
>> The final thing preventing this was the way the sysfs files were
>> attached to the pdev. Follow the approach developed for ppi and move
>> the sysfs files to the chip->dev with symlinks from the pdev
>> for compatibility. Everything in the core now sanely uses container_of
>> to get the chip.
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>
> Three configurations:
>
> * Haswell NUC with PTT (tpm_crb)
> * Another NUC with dTPM 2.0 chip
> * Dell E6420, which has TPM 1.2 chip
>
> Things seem to be unbroken.
>
> Stefan, have you verified that sysfs attributes work through routes:
>
> 1. From char device sysfs directory
> 2. Through link

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

>
> An also tried insmod/rmmod couple of rounds?

Works as-is in polling mode but requires Jason's patch "tpm: Fix IRQ 
unwind ordering in TIS" for interrupt mode to not throw errors on 'rmmod'.

Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
