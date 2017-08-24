From: Jiandi An <anjiandi@codeaurora.org>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Thu, 24 Aug 2017 12:20:35 -0500
Message-ID: <7478e964-6553-9d1e-3d8f-83b044a9a562@codeaurora.org>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
 <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
 <20170824122630.75sxjmkj5f7p7tv5@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824122630.75sxjmkj5f7p7tv5@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/24/2017 07:26 AM, Jarkko Sakkinen wrote:
> On Tue, Aug 22, 2017 at 04:28:54PM -0500, Jiandi An wrote:
>>  > >  {
>>>> -	if ((priv->flags & CRB_FL_ACPI_START) ||
>>>> -	    (priv->flags & CRB_FL_CRB_SMC_START))
>>>> -		return 0;
>>>> -
>>>> -	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>>>> -	/* we don't really care when this settles */
>>>> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0)
>>>> +		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>>>> +		/* we don't really care when this settles */
>>>
>>> It's *exactly* the same condition expessed in different form.
>>>
>>
>> I'm sorry perhaps I didn't fully understand the workaround specific to Intel
>> PPT.  In previous patch thread, you mentioned the following where
>> a platform could report to require start method 2 (ACPI start) which is
>> sm = ACPI_TPM2_START_METHOD, and actually requires start method 8, which
>> is sm = ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD.
>
> What this has to do with the above code change? Those two versions
> compile most likely to almost if not exactly same machine code.
>
> Both the original code and your updated blacklist cases where either
> of those flags is set.

I know they don't change the logic.  This was to address comment from 
Jason.  He wanted to express the exact condition which crb_go_idle(),
crb_cmd_ready(), and the check for "Bad ACPI memory layout" in
crb_map_io() should run, instead of the if not the condition, return.
Since you want it as is, I'll change it back. It's already excluding
CRB_FL_CRB_SMC_START in addition to CRB_FL_ACPI_START which is what's
intended.

Like I said the goal for this patch is to really further exclude
CRB_FL_CRB_SMC_START from the check for "Bad ACPI memory layout"
in crb_map_io() in the code below.

@@ -458,7 +455,7 @@ static int crb_map_io(struct acpi_device *device, 
struct crb_priv *priv,
   * the control area, as one nice sane region except for some older
   * stuff that puts the control area outside the ACPI IO region.
   */
  -if (!(priv->flags & CRB_FL_ACPI_START)) {
  +if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
   		if (buf->control_address == io_res.start +
   		    sizeof(*priv->regs_h))
   			priv->regs_h = priv->iobase;
   		else
   		    dev_warn(dev, FW_BUG "Bad ACPI memory layout");
   }

I'll submit v2 with only this change.  Are you okay which this change?

Thanks
- Jiandi


>
>> But you listed the following code logic which for either sm = 2 or
>> sm = 8, CRB_FL_ACPI_START flag is set.
>>
>> if (sm == ACPI_TPM2_START_METHOD ||
>>     sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>> 	priv->flags |= CRB_FL_ACPI_START;
>>
>> So I'm a little confused about the PPT workaround you mentioned
>>
>> /* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
>>  * report only ACPI start but in practice seems to require both
>>  * ACPI start and CRB start.
>>  */
>> if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
>>     !strcmp(acpi_device_hid(device), "MSFT0101"))
>> 	priv->flags |= CRB_FL_CRB_START;
>>
>> I took it as some platform sm = 2 or sm = 8 which CRB_FL_ACPI_START
>> flag is set, additionally, if HID = MSFT0101, CRB_FL_CRB_START flag
>> is set.
>
> Yes.
>
> I'm starting to think that the code might be easier to follow if we
> removed 'flags' and store sm to the priv struct and put conditionals in
> places where we need them based on sm.
>
> I think the 'flags' field was not a good idea in the first place.
>
> /Jarkko
>


-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a 
Linux Foundation Collaborative Project.
