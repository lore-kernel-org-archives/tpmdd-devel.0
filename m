From: Jiandi An <anjiandi@codeaurora.org>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI and non-SMC
 start method
Date: Tue, 22 Aug 2017 16:28:54 -0500
Message-ID: <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 08/22/2017 12:39 PM, Jarkko Sakkinen wrote:
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
>> ---
>>  drivers/char/tpm/tpm_crb.c | 35 ++++++++++++++++-------------------
>>  1 file changed, 16 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>> index 8f0a98d..cbfdbdde 100644
>> --- a/drivers/char/tpm/tpm_crb.c
>> +++ b/drivers/char/tpm/tpm_crb.c
>> @@ -128,18 +128,16 @@ struct tpm2_crb_smc {
>>   * Anyhow, we do not wait here as a consequent CMD_READY request
>>   * will be handled correctly even if idle was not completed.
>>   *
>> - * The function does nothing for devices with ACPI-start method.
>> + * The function does nothing for devices with ACPI-start method
>> + * or SMC-start method.
>>   *
>>   * Return: 0 always
>>   */
>>  static int __maybe_unused crb_go_idle(struct device *dev, struct crb_priv *priv)
>>  {
>> -	if ((priv->flags & CRB_FL_ACPI_START) ||
>> -	    (priv->flags & CRB_FL_CRB_SMC_START))
>> -		return 0;
>> -
>> -	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>> -	/* we don't really care when this settles */
>> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0)
>> +		iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>> +		/* we don't really care when this settles */
>
> It's *exactly* the same condition expessed in different form.
>

I'm sorry perhaps I didn't fully understand the workaround specific to 
Intel PPT.  In previous patch thread, you mentioned the following where
a platform could report to require start method 2 (ACPI start) which is
sm = ACPI_TPM2_START_METHOD, and actually requires start method 8, which
is sm = ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD.

But you listed the following code logic which for either sm = 2 or
sm = 8, CRB_FL_ACPI_START flag is set.

if (sm == ACPI_TPM2_START_METHOD ||
     sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
	priv->flags |= CRB_FL_ACPI_START;

So I'm a little confused about the PPT workaround you mentioned

/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
  * report only ACPI start but in practice seems to require both
  * ACPI start and CRB start.
  */
if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
     !strcmp(acpi_device_hid(device), "MSFT0101"))
	priv->flags |= CRB_FL_CRB_START;

I took it as some platform sm = 2 or sm = 8 which CRB_FL_ACPI_START
flag is set, additionally, if HID = MSFT0101, CRB_FL_CRB_START flag
is set.

So I took it as the PPT workaround you mentioned is an instance where
both CRB_FL_ACPI_START and CRB_FL_CRB_START are set.

The original code logic for crb_go_idle() and crb_cmd_ready() only
exclude CRB_FL_ACPI_START, saying crb_go_idle() and crb_cmd_ready()
do nothing if CRB_FL_ACPI_START is set.

static int __maybe_unused crb_go_idle(struct device *dev,
                                       struct crb_priv *priv)
{
      if (priv->flags & CRB_FL_ACPI_START)
          return 0;

So even in the case when both CRB_FL_ACPI_START and CRB_FL_CRB_START
are set, crb_go_idle() and crb_cmd_ready() will not do anything because
CRB_FL_ACPI_START is set.

And when SMC start method was enabled for ARM64, I further excluded
CRB_FL_CRB_SMC_START

static int __maybe_unused crb_go_idle(struct device *dev,
                                       struct crb_priv *priv)
{
      if ((priv->flags & CRB_FL_ACPI_START) ||
          (prive->flags & CRB_FL_CRB_SMC_START))
          return 0;

And Jason's comment was telling me to have these list the cases where
crb_go_idle() and crb_cmd_ready() are known to be required.  Less
brittle that way.  And he gave example...

if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_START)) == 0)
        return 0


The following is your comment and Jason's comment in the other patch
thread discussion here
https://sourceforge.net/p/tpmdd/mailman/message/35984747/

*****************************
What about platforms with firmware bug that they report only requiring
ACPI start but actually also require CRB start.

if (sm == ACPI_TPM2_START_METHOD ||
     sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
	priv->flags |= CRB_FL_ACPI_START;

I've encountered a platform that reports to require start method 2 (ACPI
start) while it actually requires start method 8.

That's why we have this nasty workaround:

/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
  * report only ACPI start but in practice seems to require both
  * ACPI start and CRB start.
  */
if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
     !strcmp(acpi_device_hid(device), "MSFT0101"))
	priv->flags |= CRB_FL_CRB_START;

Also, since start method 8 exist in the spec, it is a legit config.

/Jarkko


I think it would be better to have these list the cases where go_idle
is known to be required. Less brittle that way..

   if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_START)) == 0)
        return 0

Jason
*****************************

The intent of this patch is to additionally exclude CRB_FL_CRB_SMC_START
from crb_go_idle(), crb_cmd_ready(), and the check for "Bad ACPI memory
layout" in crb_map_io(), on top of current conditions.

The original code just has as long as CRB_FL_ACPI_START is not set,
don't do crb_go_idle(), crb_cmd_ready() and the additional check for
"Bad ACPI memory layout" in crb_map_io().

Could you share some insight on what exact conditions are for 
crb_go_idle(), crb_cmd_ready(), and the check "BAD ACPI memory layout" 
in crb_map_io()?

Is it as long as !CRB_FL_ACPI_START? (before SMC was added, that just
means CRB_FL_CRB_START is set).
So with the PTT workaround condition, are you suggesting the following
conditions are when crb_go_idle(), crb_cmd_ready(), and check for "Bad 
ACPI memory layout" in crb_map_io() should run?

1. CRB_FL_CRB_START is set.
2. CRB_FL_CRB_START and CRB_FL_ACPI_START are set.

Thanks.
- Jiandi

>
>>
>>  	return 0;
>>  }
>> @@ -174,23 +172,22 @@ static bool crb_wait_for_reg_32(u32 __iomem *reg, u32 mask, u32 value,
>>   * The device should respond within TIMEOUT_C.
>>   *
>>   * The function does nothing for devices with ACPI-start method
>> + * or SMC-start method.
>>   *
>>   * Return: 0 on success -ETIME on timeout;
>>   */
>>  static int __maybe_unused crb_cmd_ready(struct device *dev,
>>  					struct crb_priv *priv)
>>  {
>> -	if ((priv->flags & CRB_FL_ACPI_START) ||
>> -	    (priv->flags & CRB_FL_CRB_SMC_START))
>> -		return 0;
>> -
>> -	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
>> -	if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
>> -				 CRB_CTRL_REQ_CMD_READY /* mask */,
>> -				 0, /* value */
>> -				 TPM2_TIMEOUT_C)) {
>> -		dev_warn(dev, "cmdReady timed out\n");
>> -		return -ETIME;
>> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
>> +		iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
>> +		if (!crb_wait_for_reg_32(&priv->regs_t->ctrl_req,
>> +					 CRB_CTRL_REQ_CMD_READY /* mask */,
>> +					 0, /* value */
>> +					 TPM2_TIMEOUT_C)) {
>> +			dev_warn(dev, "cmdReady timed out\n");
>> +			return -ETIME;
>> +		}
>>  	}
>>
>>  	return 0;
>> @@ -458,7 +455,7 @@ static int crb_map_io(struct acpi_device *device, struct crb_priv *priv,
>>  	 * the control area, as one nice sane region except for some older
>>  	 * stuff that puts the control area outside the ACPI IO region.
>>  	 */
>> -	if (!(priv->flags & CRB_FL_ACPI_START)) {
>> +	if ((priv->flags & (CRB_FL_ACPI_START | CRB_FL_CRB_SMC_START)) == 0) {
>>  		if (buf->control_address == io_res.start +
>>  		    sizeof(*priv->regs_h))
>>  			priv->regs_h = priv->iobase;
>> --
>> Jiandi An
>> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
>> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
>>
>
> NAK
>
> /Jarkko
>

-- 
Jiandi An
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a 
Linux Foundation Collaborative Project.
