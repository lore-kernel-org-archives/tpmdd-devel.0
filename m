From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3] tpm: add sysfs attributes for tpm2
Date: Tue, 9 Aug 2016 13:25:33 +0300
Message-ID: <20160809102533.GD13566@intel.com>
References: <1468547496-16215-1-git-send-email-apronin@chromium.org>
 <1469678766-117528-1-git-send-email-apronin@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469678766-117528-1-git-send-email-apronin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Pronin <apronin@chromium.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Christophe Ricard <christophe.ricard@gmail.com>, dtor@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

This commit has a really nice changelog in the long description but
completely lacks why and how. Just by reading the description it would
be nice to know why you want to do this and by what means this commit
reaches that goal.

/Jarkko

On Wed, Jul 27, 2016 at 09:06:06PM -0700, Andrey Pronin wrote:
> Add sysfs attributes in TPM2.0 case for:
>  - TPM_PT_PERMANENT flags
>  - TPM_PT_STARTUP_CLEAR flags
>  - lockout-related properties
> 
> v2: Dropped adding driver-specific attributes.
>     No legacy links for TPM2 attributes.
>     All attributes created in groups[0].
>     Added actual attributes for flags and lockout properties.
> 
> v3: Avoid creating a separate 'show' function for each attribute.
> 
> Signed-off-by: Andrey Pronin <apronin@chromium.org>
> ---
>  drivers/char/tpm/tpm-chip.c  |   4 +-
>  drivers/char/tpm/tpm-sysfs.c | 122 +++++++++++++++++++++++++++++++++++++++++--
>  drivers/char/tpm/tpm.h       |  30 +++++++++++
>  3 files changed, 150 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index e595013..ede2ca0 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -281,8 +281,6 @@ static int tpm1_chip_register(struct tpm_chip *chip)
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		return 0;
>  
> -	tpm_sysfs_add_device(chip);
> -
>  	chip->bios_dir = tpm_bios_log_setup(dev_name(&chip->dev));
>  
>  	return 0;
> @@ -363,6 +361,8 @@ int tpm_chip_register(struct tpm_chip *chip)
>  			return rc;
>  	}
>  
> +	tpm_sysfs_add_device(chip);
> +
>  	rc = tpm1_chip_register(chip);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> index b46cf70..62940ef 100644
> --- a/drivers/char/tpm/tpm-sysfs.c
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -264,7 +264,7 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(timeouts);
>  
> -static struct attribute *tpm_dev_attrs[] = {
> +static struct attribute *tpm1_dev_attrs[] = {
>  	&dev_attr_pubek.attr,
>  	&dev_attr_pcrs.attr,
>  	&dev_attr_enabled.attr,
> @@ -278,8 +278,120 @@ static struct attribute *tpm_dev_attrs[] = {
>  	NULL,
>  };
>  
> -static const struct attribute_group tpm_dev_group = {
> -	.attrs = tpm_dev_attrs,
> +static const struct attribute_group tpm1_dev_group = {
> +	.attrs = tpm1_dev_attrs,
> +};
> +
> +struct tpm2_prop_flag_dev_attribute {
> +	struct device_attribute attr;
> +	u32 property_id;
> +	u32 flag_mask;
> +};
> +
> +struct tpm2_prop_u32_dev_attribute {
> +	struct device_attribute attr;
> +	u32 property_id;
> +};
> +
> +static ssize_t tpm2_prop_flag_show(struct device *dev,
> +				   struct device_attribute *attr,
> +				   char *buf)
> +{
> +	struct tpm2_prop_flag_dev_attribute *pa =
> +		container_of(attr, struct tpm2_prop_flag_dev_attribute, attr);
> +	u32 flags;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(to_tpm_chip(dev), pa->property_id, &flags,
> +			     "reading property");
> +	if (rc)
> +		return 0;
> +
> +	return sprintf(buf, "%d\n", !!(flags & pa->flag_mask));
> +}
> +
> +static ssize_t tpm2_prop_u32_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	struct tpm2_prop_u32_dev_attribute *pa =
> +		container_of(attr, struct tpm2_prop_u32_dev_attribute, attr);
> +	u32 value;
> +	ssize_t rc;
> +
> +	rc = tpm2_get_tpm_pt(to_tpm_chip(dev), pa->property_id, &value,
> +			     "reading property");
> +	if (rc)
> +		return 0;
> +
> +	return sprintf(buf, "%u\n", value);
> +}
> +
> +#define TPM2_PROP_FLAG_ATTR(_name, _property_id, _flag_mask)           \
> +	struct tpm2_prop_flag_dev_attribute attr_tpm2_prop_##_name = { \
> +		__ATTR(_name, S_IRUGO, tpm2_prop_flag_show, NULL),     \
> +		_property_id, _flag_mask                               \
> +	}
> +
> +#define TPM2_PROP_U32_ATTR(_name, _property_id)                        \
> +	struct tpm2_prop_u32_dev_attribute attr_tpm2_prop_##_name = {  \
> +		__ATTR(_name, S_IRUGO, tpm2_prop_u32_show, NULL),      \
> +		_property_id                                           \
> +	}
> +
> +TPM2_PROP_FLAG_ATTR(owner_auth_set,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_OWNER_AUTH_SET);
> +TPM2_PROP_FLAG_ATTR(endorsement_auth_set,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_ENDORSEMENT_AUTH_SET);
> +TPM2_PROP_FLAG_ATTR(lockout_auth_set,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_LOCKOUT_AUTH_SET);
> +TPM2_PROP_FLAG_ATTR(disable_clear,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_DISABLE_CLEAR);
> +TPM2_PROP_FLAG_ATTR(in_lockout,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_IN_LOCKOUT);
> +TPM2_PROP_FLAG_ATTR(tpm_generated_eps,
> +		    TPM2_PT_PERMANENT, TPM2_ATTR_TPM_GENERATED_EPS);
> +
> +TPM2_PROP_FLAG_ATTR(ph_enable,
> +		    TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_PH_ENABLE);
> +TPM2_PROP_FLAG_ATTR(sh_enable,
> +		    TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_SH_ENABLE);
> +TPM2_PROP_FLAG_ATTR(eh_enable,
> +		    TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_EH_ENABLE);
> +TPM2_PROP_FLAG_ATTR(ph_enable_nv,
> +		    TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_PH_ENABLE_NV);
> +TPM2_PROP_FLAG_ATTR(orderly,
> +		    TPM2_PT_STARTUP_CLEAR, TPM2_ATTR_ORDERLY);
> +
> +TPM2_PROP_U32_ATTR(lockout_counter, TPM2_PT_LOCKOUT_COUNTER);
> +TPM2_PROP_U32_ATTR(max_auth_fail, TPM2_PT_MAX_AUTH_FAIL);
> +TPM2_PROP_U32_ATTR(lockout_interval, TPM2_PT_LOCKOUT_INTERVAL);
> +TPM2_PROP_U32_ATTR(lockout_recovery, TPM2_PT_LOCKOUT_RECOVERY);
> +
> +#define ATTR_FOR_TPM2_PROP(_name) (&attr_tpm2_prop_##_name.attr.attr)
> +static struct attribute *tpm2_dev_attrs[] = {
> +	ATTR_FOR_TPM2_PROP(owner_auth_set),
> +	ATTR_FOR_TPM2_PROP(endorsement_auth_set),
> +	ATTR_FOR_TPM2_PROP(lockout_auth_set),
> +	ATTR_FOR_TPM2_PROP(disable_clear),
> +	ATTR_FOR_TPM2_PROP(in_lockout),
> +	ATTR_FOR_TPM2_PROP(tpm_generated_eps),
> +	ATTR_FOR_TPM2_PROP(ph_enable),
> +	ATTR_FOR_TPM2_PROP(sh_enable),
> +	ATTR_FOR_TPM2_PROP(eh_enable),
> +	ATTR_FOR_TPM2_PROP(ph_enable_nv),
> +	ATTR_FOR_TPM2_PROP(orderly),
> +	ATTR_FOR_TPM2_PROP(lockout_counter),
> +	ATTR_FOR_TPM2_PROP(max_auth_fail),
> +	ATTR_FOR_TPM2_PROP(lockout_interval),
> +	ATTR_FOR_TPM2_PROP(lockout_recovery),
> +	&dev_attr_durations.attr,
> +	&dev_attr_timeouts.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group tpm2_dev_group = {
> +	.attrs = tpm2_dev_attrs,
>  };
>  
>  void tpm_sysfs_add_device(struct tpm_chip *chip)
> @@ -289,5 +401,7 @@ void tpm_sysfs_add_device(struct tpm_chip *chip)
>  	 * removal so that no callbacks are running or can run again
>  	 */
>  	WARN_ON(chip->groups_cnt != 0);
> -	chip->groups[chip->groups_cnt++] = &tpm_dev_group;
> +	chip->groups[chip->groups_cnt++] =
> +		(chip->flags & TPM_CHIP_FLAG_TPM2) ?
> +		&tpm2_dev_group : &tpm1_dev_group;
>  }
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 6e002c4..9feb023 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -127,6 +127,36 @@ enum tpm2_capabilities {
>  	TPM2_CAP_TPM_PROPERTIES = 6,
>  };
>  
> +enum tpm2_properties {
> +	TPM2_PT_NONE			= 0,
> +	TPM2_PT_GROUP			= 0x100,
> +	TPM2_PT_FIXED			= TPM2_PT_GROUP,
> +	TPM2_PT_VAR			= TPM2_PT_GROUP * 2,
> +	TPM2_PT_PERMANENT		= TPM2_PT_VAR + 0,
> +	TPM2_PT_STARTUP_CLEAR		= TPM2_PT_VAR + 1,
> +	TPM2_PT_LOCKOUT_COUNTER		= TPM2_PT_VAR + 14,
> +	TPM2_PT_MAX_AUTH_FAIL		= TPM2_PT_VAR + 15,
> +	TPM2_PT_LOCKOUT_INTERVAL	= TPM2_PT_VAR + 16,
> +	TPM2_PT_LOCKOUT_RECOVERY	= TPM2_PT_VAR + 17,
> +};
> +
> +enum tpm2_attr_permanent {
> +	TPM2_ATTR_OWNER_AUTH_SET	= BIT(0),
> +	TPM2_ATTR_ENDORSEMENT_AUTH_SET	= BIT(1),
> +	TPM2_ATTR_LOCKOUT_AUTH_SET	= BIT(2),
> +	TPM2_ATTR_DISABLE_CLEAR		= BIT(8),
> +	TPM2_ATTR_IN_LOCKOUT		= BIT(9),
> +	TPM2_ATTR_TPM_GENERATED_EPS	= BIT(10),
> +};
> +
> +enum tpm2_attr_startup_clear {
> +	TPM2_ATTR_PH_ENABLE		= BIT(0),
> +	TPM2_ATTR_SH_ENABLE		= BIT(1),
> +	TPM2_ATTR_EH_ENABLE		= BIT(2),
> +	TPM2_ATTR_PH_ENABLE_NV		= BIT(3),
> +	TPM2_ATTR_ORDERLY		= BIT(31),
> +};
> +
>  enum tpm2_startup_types {
>  	TPM2_SU_CLEAR	= 0x0000,
>  	TPM2_SU_STATE	= 0x0001,
> -- 
> 2.6.6
> 
