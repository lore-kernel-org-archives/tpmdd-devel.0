From: Jiandi An <anjiandi@codeaurora.org>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Sun, 20 Aug 2017 22:41:38 -0500
Message-ID: <424ce770-e21b-749c-df5c-b12a2691269e@codeaurora.org>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170819170500.xayh6pzidl5ury2d@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170819170500.xayh6pzidl5ury2d@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/19/2017 12:05 PM, Jarkko Sakkinen wrote:
> On Thu, Aug 17, 2017 at 11:15:36PM -0500, Jiandi An wrote:
>> For ARM64, the locality is handled by Trust Zone in FW.
>> The layout does not have crb_regs_head.  It is hitting
>> the following line.
>> dev_warn(dev, FW_BUG "Bad ACPI memory layout");
>>
>> Current code excludes CRB_FL_ACPI_START and when
>> CRB_FL_CRB_SMC_START is added around the same time
>> locality support is added, it should also be excluded.
>>
>> For goIdle and cmdReady where code was excluding
>> CRB_FL_ACPI_START only (do nothing for ACPI start method),
>> CRB_FL_CRB_SMC_START was also excluded as ARM64 SMC start
>> method does not have TPM_CRB_CTRL_REQ.
>> Change if confition to white list instead of black list.
>>
>> Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
>
> Is this v2? If so, where is the change log?
Based on the previous comments, I now understand that
because of Intel PTT bug workaround, it is not appropriate
for the patch to have title/subject "Access locality for
only CRB_START method"

So the more descriptive patch title is "Access locality for
only non-ACPI and non-SMC start method".  Because the patch
is changed, I thought I start a new series.  Would you like
me to tag this v3 and put change log even though patch title
has changed?

Thanks
- Jiandi

>
> /Jarkko
>

-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a 
Linux Foundation Collaborative Project.
