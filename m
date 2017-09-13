From: anjiandi@codeaurora.org
Subject: Re: [PATCH] tpm/tpm_crb: Use start method value from ACPI table
 directly
Date: Wed, 13 Sep 2017 15:33:51 -0500
Message-ID: <824d1fdbbc34cbe7d224a73004d258a9@codeaurora.org>
References: <1503703735-2332-1-git-send-email-anjiandi@codeaurora.org>
 <20170906123902.ovirukgahfvjldxa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170906123902.ovirukgahfvjldxa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 2017-09-06 07:39, Jarkko Sakkinen wrote:
> On Fri, Aug 25, 2017 at 06:28:55PM -0500, Jiandi An wrote:
>> This patch gets rid of dealing with intermediate flag for start method
>> and use start method value from ACPI table directly.
>> 
>> For ARM64, the locality is handled by Trust Zone in FW.  The layout
>> does not have crb_regs_head.  It is hitting the following line.
>> dev_warn(dev, FW_BUG "Bad ACPI memory layout");
>> 
>> Current code excludes CRB_FL_ACPI_START for this check.  Now since
>> ARM64 support for TPM CRB is added, CRB_FL_CRB_SMC_START should also 
>> be
>> excluded from this check.
>> 
>> For goIdle and cmdReady where code was excluding CRB_FL_ACPI_START 
>> only
>> (do nothing for ACPI start method), CRB_FL_CRB_SMC_START was also
>> excluded as ARM64 SMC start method does not have TPM_CRB_CTRL_REQ.
>> 
>> However with special PPT workaround requiring CRB_FL_CRB_START to be
>> set in addition to CRB_FL_ACPI_START and the addition flag of SMC
>> start method CRB_FL_CRB_SMC_START, the code has become difficult to
>> maintain and undrestand.  It is better to make code deal with start
>> method value from ACPI table directly.
>> 
>> Signed-off-by: Jiandi An <anjiandi@codeaurora.org>
>> ---
>>  drivers/char/tpm/tpm_crb.c | 59 
>> +++++++++++++++++++++++-----------------------
>>  1 file changed, 29 insertions(+), 30 deletions(-)
>> 
>> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
>> index 8f0a98d..7b3c2a8 100644
>> --- a/drivers/char/tpm/tpm_crb.c
>> +++ b/drivers/char/tpm/tpm_crb.c
>> @@ -92,14 +92,9 @@ enum crb_status {
>>  	CRB_DRV_STS_COMPLETE	= BIT(0),
>>  };
>> 
>> -enum crb_flags {
>> -	CRB_FL_ACPI_START	= BIT(0),
>> -	CRB_FL_CRB_START	= BIT(1),
>> -	CRB_FL_CRB_SMC_START	= BIT(2),
>> -};
>> -
>>  struct crb_priv {
>> -	unsigned int flags;
>> +	u32 sm;
>> +	const char *hid;
>>  	void __iomem *iobase;
>>  	struct crb_regs_head __iomem *regs_h;
>>  	struct crb_regs_tail __iomem *regs_t;
>> @@ -128,14 +123,16 @@ struct tpm2_crb_smc {
>>   * Anyhow, we do not wait here as a consequent CMD_READY request
>>   * will be handled correctly even if idle was not completed.
>>   *
>> - * The function does nothing for devices with ACPI-start method.
>> + * The function does nothing for devices with ACPI-start method
>> + * or SMC-start method.
>>   *
>>   * Return: 0 always
>>   */
>>  static int __maybe_unused crb_go_idle(struct device *dev, struct 
>> crb_priv *priv)
>>  {
>> -	if ((priv->flags & CRB_FL_ACPI_START) ||
>> -	    (priv->flags & CRB_FL_CRB_SMC_START))
>> +	if ((priv->sm == ACPI_TPM2_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC))
>>  		return 0;
>> 
>>  	iowrite32(CRB_CTRL_REQ_GO_IDLE, &priv->regs_t->ctrl_req);
>> @@ -174,14 +171,16 @@ static bool crb_wait_for_reg_32(u32 __iomem 
>> *reg, u32 mask, u32 value,
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
>> +	if ((priv->sm == ACPI_TPM2_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC))
>>  		return 0;
>> 
>>  	iowrite32(CRB_CTRL_REQ_CMD_READY, &priv->regs_t->ctrl_req);
>> @@ -325,13 +324,20 @@ static int crb_send(struct tpm_chip *chip, u8 
>> *buf, size_t len)
>>  	/* Make sure that cmd is populated before issuing start. */
>>  	wmb();
>> 
>> -	if (priv->flags & CRB_FL_CRB_START)
>> +	/* The reason for the extra quirk is that the PTT in 4th Gen Core 
>> CPUs
>> +	 * report only ACPI start but in practice seems to require both
>> +	 * CRB start, hence invoking CRB start method if hid == MSFT0101.
>> +	 */
>> +	if ((priv->sm == ACPI_TPM2_COMMAND_BUFFER) ||
>> +	    (priv->sm == ACPI_TPM2_MEMORY_MAPPED) ||
>> +	    (!strcmp(priv->hid, "MSFT0101")))
>>  		iowrite32(CRB_START_INVOKE, &priv->regs_t->ctrl_start);
>> 
>> -	if (priv->flags & CRB_FL_ACPI_START)
>> +	if ((priv->sm == ACPI_TPM2_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD))
>>  		rc = crb_do_acpi_start(chip);
>> 
>> -	if (priv->flags & CRB_FL_CRB_SMC_START) {
>> +	if (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC) {
>>  		iowrite32(CRB_START_INVOKE, &priv->regs_t->ctrl_start);
>>  		rc = tpm_crb_smc_start(&chip->dev, priv->smc_func_id);
>>  	}
>> @@ -345,7 +351,9 @@ static void crb_cancel(struct tpm_chip *chip)
>> 
>>  	iowrite32(CRB_CANCEL_INVOKE, &priv->regs_t->ctrl_cancel);
>> 
>> -	if ((priv->flags & CRB_FL_ACPI_START) && crb_do_acpi_start(chip))
>> +	if (((priv->sm == ACPI_TPM2_START_METHOD) ||
>> +	    (priv->sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)) &&
>> +	     crb_do_acpi_start(chip))
>>  		dev_err(&chip->dev, "ACPI Start failed\n");
>>  }
>> 
>> @@ -458,7 +466,8 @@ static int crb_map_io(struct acpi_device *device, 
>> struct crb_priv *priv,
>>  	 * the control area, as one nice sane region except for some older
>>  	 * stuff that puts the control area outside the ACPI IO region.
>>  	 */
>> -	if (!(priv->flags & CRB_FL_ACPI_START)) {
>> +	if ((priv->sm == ACPI_TPM2_COMMAND_BUFFER) ||
>> +	    (priv->sm == ACPI_TPM2_MEMORY_MAPPED)) {
>>  		if (buf->control_address == io_res.start +
>>  		    sizeof(*priv->regs_h))
>>  			priv->regs_h = priv->iobase;
>> @@ -552,18 +561,6 @@ static int crb_acpi_add(struct acpi_device 
>> *device)
>>  	if (!priv)
>>  		return -ENOMEM;
>> 
>> -	/* The reason for the extra quirk is that the PTT in 4th Gen Core 
>> CPUs
>> -	 * report only ACPI start but in practice seems to require both
>> -	 * ACPI start and CRB start.
>> -	 */
>> -	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED 
>> ||
>> -	    !strcmp(acpi_device_hid(device), "MSFT0101"))
>> -		priv->flags |= CRB_FL_CRB_START;
>> -
>> -	if (sm == ACPI_TPM2_START_METHOD ||
>> -	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>> -		priv->flags |= CRB_FL_ACPI_START;
>> -
>>  	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC) {
>>  		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
>>  			dev_err(dev,
>> @@ -574,9 +571,11 @@ static int crb_acpi_add(struct acpi_device 
>> *device)
>>  		}
>>  		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
>>  		priv->smc_func_id = crb_smc->smc_func_id;
>> -		priv->flags |= CRB_FL_CRB_SMC_START;
>>  	}
>> 
>> +	priv->sm = sm;
>> +	priv->hid = acpi_device_hid(device);
>> +
>>  	rc = crb_map_io(device, priv, buf);
>>  	if (rc)
>>  		return rc;
>> --
>> Jiandi An
>> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm 
>> Technologies, Inc.
>> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a 
>> Linux Foundation Collaborative Project.
> 
> Tested-by: Jarkko Sakkinen <jarkko.sakkine@linux.intel.com>
> 
> I run smoke test suite [1]:
> 
> $ python -m unittest -v tpm2_smoke
> test_seal_with_auth (tpm2_smoke.SmokeTest) ... ok
> test_seal_with_policy (tpm2_smoke.SmokeTest) ... ok
> test_seal_with_too_long_auth (tpm2_smoke.SmokeTest) ... ok
> test_unseal_with_wrong_auth (tpm2_smoke.SmokeTest) ... ok
> test_unseal_with_wrong_policy (tpm2_smoke.SmokeTest) ... ok
> test_flush_context (tpm2_smoke.SpaceTest) ... ok
> test_get_handles (tpm2_smoke.SpaceTest) ... ok
> test_make_two_spaces (tpm2_smoke.SpaceTest) ... ok
> 
> ----------------------------------------------------------------------
> Ran 8 tests in 25.816s
> 
> OK
> 
> This doesn't verify that things work on ARM64 because for that I do not
> pose a test platform. However, since tpm_crb is not in wide use yet on
> that platform I do not think it matters. And the code changes do not
> have huge potential to cause collateral damage even if they were broken
> on that platform.
> 
> [1] https://github.com/jsakkine-intel/tpm2-scripts
> 
> /Jarkko

Hi Jarkko,

I tested on ARM64 on Qualcomm QDF2400 platform.  Will this be pulled to 
linux-next or your tree for 4.14 merge window?
Thanks.
