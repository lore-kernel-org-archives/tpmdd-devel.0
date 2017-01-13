From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Fri, 13 Jan 2017 18:31:40 +0200
Message-ID: <20170113163140.tjzprbo23duiqc4g@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
 <1484270243.5807.31.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484270243.5807.31.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 05:17:23PM -0800, James Bottomley wrote:
> On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > @@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct device
> > *pdev,
> >  	chip->cdev.owner = THIS_MODULE;
> >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > 
> > +	chip->work_space.context_buf = kzalloc(PAGE_SIZE,
> > GFP_KERNEL);
> > +	if (!chip->work_space.context_buf) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> 
> I think the work_buf handling can be greatly simplified by making it a
> pointer to the space: it's only usable between tpm2_prepare_space() and
> tpm2_commit_space() which are protected by the chip mutex, so there's
> no need for it to exist outside of these calls (i.e. it can be NULL).
> 
> Doing it this way also saves the allocation and copying overhead of
> work_space.
> 
> The patch below can be folded to effect this.
> 
> James
> 
> ---
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 13cac09..770a8c0 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -131,7 +131,6 @@ static void tpm_dev_release(struct device *dev)
>  	mutex_unlock(&idr_lock);
>  
>  	kfree(chip->log.bios_event_log);
> -	kfree(chip->work_space.context_buf);
>  	kfree(chip);
>  }
>  
> @@ -206,12 +205,6 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>  	chip->cdev.kobj.parent = &chip->dev.kobj;
>  	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
>  
> -	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!chip->work_space.context_buf) {
> -		rc = -ENOMEM;
> -		goto out;
> -	}
> -
>  	return chip;
>  
>  out:
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 8009ed4..adf7810 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -211,7 +211,7 @@ struct tpm_chip {
>  	char ppi_version[TPM_PPI_VERSION_LEN + 1];
>  #endif /* CONFIG_ACPI */
>  
> -	struct tpm_space work_space;
> +	struct tpm_space *work_space;
>  	u32 nr_commands;
>  	u32 *cc_attrs_tbl;
>  };
> diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
> index 44e5501..285361e 100644
> --- a/drivers/char/tpm/tpm2-space.c
> +++ b/drivers/char/tpm/tpm2-space.c
> @@ -27,7 +27,7 @@ enum tpm2_handle_types {
>  
>  static void tpm2_flush_space(struct tpm_chip *chip)
>  {
> -	struct tpm_space *space = &chip->work_space;
> +	struct tpm_space *space = chip->work_space;
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(space->context_tbl); i++)
> @@ -45,7 +45,7 @@ struct tpm2_context {
>  
>  static int tpm2_load_space(struct tpm_chip *chip)
>  {
> -	struct tpm_space *space = &chip->work_space;
> +	struct tpm_space *space = chip->work_space;
>  	struct tpm2_context *ctx;
>  	struct tpm_buf buf;
>  	int i;
> @@ -99,7 +99,7 @@ static int tpm2_load_space(struct tpm_chip *chip)
>  
>  static int tpm2_map_command(struct tpm_chip *chip, u32 cc, u8 *cmd, size_t len)
>  {
> -	struct tpm_space *space = &chip->work_space;
> +	struct tpm_space *space = chip->work_space;
>  	unsigned int nr_handles;
>  	u32 vhandle;
>  	u32 phandle;
> @@ -147,9 +147,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
>  	if (!space)
>  		return 0;
>  
> -	memcpy(&chip->work_space.context_tbl, &space->context_tbl,
> -	       sizeof(space->context_tbl));
> -	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
> +	chip->work_space = space;
>  
>  	rc = tpm2_load_space(chip);
>  	if (rc)
> @@ -164,7 +162,7 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space,
>  
>  static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
>  {
> -	struct tpm_space *space = &chip->work_space;
> +	struct tpm_space *space = chip->work_space;
>  	u32 phandle;
>  	u32 vhandle;
>  	u32 attrs;
> @@ -222,7 +220,7 @@ static int tpm2_map_response(struct tpm_chip *chip, u32 cc, u8 *rsp, size_t len)
>  
>  static int tpm2_save_space(struct tpm_chip *chip)
>  {
> -	struct tpm_space *space = &chip->work_space;
> +	struct tpm_space *space = chip->work_space;
>  	struct tpm_buf buf;
>  	int i;
>  	int j;
> @@ -295,9 +293,7 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
>  	if (rc)
>  		return rc;
>  
> -	memcpy(&space->context_tbl, &chip->work_space.context_tbl,
> -	       sizeof(space->context_tbl));
> -	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
> +	chip->work_space = NULL;
>  
>  	return 0;
>  }

[x]

/Jarkko
