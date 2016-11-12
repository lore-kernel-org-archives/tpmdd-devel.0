From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 2/2] tpm: refactor tpm2_get_tpm_pt to
 tpm2_getcap_cmd
Date: Fri, 11 Nov 2016 16:02:43 -0800
Message-ID: <20161112000242.63hgv5ujmkr7hy6a@intel.com>
References: <1476008057-2395-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1476008057-2395-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <58254759.80406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58254759.80406@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 11, 2016 at 09:51:45AM +0530, Nayna wrote:
> 
> 
> On 10/09/2016 03:44 PM, Jarkko Sakkinen wrote:
> > Refactored tpm2_get_tpm_pt to tpm2_getcap_cmd, which means that it also
> > takes capability ID as input. This is required to access
> > TPM_CAP_HANDLES, which contains metadata needed for swapping transient
> > data.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >   drivers/char/tpm/tpm.h          |  6 +++-
> >   drivers/char/tpm/tpm2-cmd.c     | 64 ++++++++++++++++++++---------------------
> >   drivers/char/tpm/tpm_tis_core.c |  3 +-
> >   3 files changed, 38 insertions(+), 35 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 0fab6d5..8176f42 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -85,6 +85,10 @@ enum tpm2_capabilities {
> >   	TPM2_CAP_TPM_PROPERTIES = 6,
> >   };
> > 
> > +enum tpm2_properties {
> > +	TPM2_PT_FAMILY_INDICATOR	= 0x100,
> > +};
> > +
> >   enum tpm2_startup_types {
> >   	TPM2_SU_CLEAR	= 0x0000,
> >   	TPM2_SU_STATE	= 0x0001,
> > @@ -485,7 +489,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> >   int tpm2_unseal_trusted(struct tpm_chip *chip,
> >   			struct trusted_key_payload *payload,
> >   			struct trusted_key_options *options);
> > -ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
> > +ssize_t tpm2_getcap_cmd(struct tpm_chip *chip, u32 cap_id, u32 property_id,
> >   			u32 *value, const char *desc);
> > 
> >   int tpm2_auto_startup(struct tpm_chip *chip);
> > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > index 2900e18..fcf3d86 100644
> > --- a/drivers/char/tpm/tpm2-cmd.c
> > +++ b/drivers/char/tpm/tpm2-cmd.c
> > @@ -111,13 +111,13 @@ struct tpm2_pcr_extend_in {
> >   	u8				digest[TPM_DIGEST_SIZE];
> >   } __packed;
> > 
> > -struct tpm2_get_tpm_pt_in {
> > +struct tpm2_getcap_in {
> >   	__be32	cap_id;
> >   	__be32	property_id;
> >   	__be32	property_cnt;
> >   } __packed;
> > 
> > -struct tpm2_get_tpm_pt_out {
> > +struct tpm2_getcap_out {
> >   	u8	more_data;
> >   	__be32	subcap_id;
> >   	__be32	property_cnt;
> > @@ -140,8 +140,8 @@ union tpm2_cmd_params {
> >   	struct	tpm2_pcr_read_in	pcrread_in;
> >   	struct	tpm2_pcr_read_out	pcrread_out;
> >   	struct	tpm2_pcr_extend_in	pcrextend_in;
> > -	struct	tpm2_get_tpm_pt_in	get_tpm_pt_in;
> > -	struct	tpm2_get_tpm_pt_out	get_tpm_pt_out;
> > +	struct	tpm2_getcap_in		getcap_in;
> > +	struct	tpm2_getcap_out		getcap_out;
> >   	struct	tpm2_get_random_in	getrandom_in;
> >   	struct	tpm2_get_random_out	getrandom_out;
> >   };
> > @@ -435,16 +435,6 @@ int tpm2_get_random(struct tpm_chip *chip, u8 *out, size_t max)
> >   	return total ? total : -EIO;
> >   }
> > 
> > -#define TPM2_GET_TPM_PT_IN_SIZE \
> > -	(sizeof(struct tpm_input_header) + \
> > -	 sizeof(struct tpm2_get_tpm_pt_in))
> > -
> > -static const struct tpm_input_header tpm2_get_tpm_pt_header = {
> > -	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> > -	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
> > -	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> > -};
> > -
> >   /**
> >    * Append TPMS_AUTH_COMMAND to the buffer. The buffer must be allocated with
> >    * tpm_buf_alloc().
> > @@ -750,35 +740,43 @@ out:
> >   	return rc;
> >   }
> > 
> > +#define TPM2_GETCAP_IN_SIZE \
> > +	(sizeof(struct tpm_input_header) + sizeof(struct tpm2_getcap_in))
> > +
> > +static const struct tpm_input_header tpm2_getcap_header = {
> > +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> > +	.length = cpu_to_be32(TPM2_GETCAP_IN_SIZE),
> > +	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> > +};
> > +
> >   /**
> > - * tpm2_get_tpm_pt() - get value of a TPM_CAP_TPM_PROPERTIES type property
> > - * @chip:		TPM chip to use.
> > - * @property_id:	property ID.
> > - * @value:		output variable.
> > + * tpm2_getcap_cmd() - execute a TPM2_GetCapability command
> > + * @chip:		TPM chip to use
> > + * @cap_id:		capability ID
> > + * @property_id:	property ID
> > + * @value:		value of the property
> >    * @desc:		passed to tpm_transmit_cmd()
> >    *
> > - * 0 is returned when the operation is successful. If a negative number is
> > - * returned it remarks a POSIX error code. If a positive number is returned
> > - * it remarks a TPM error.
> > + * Return: same as with tpm_transmit_cmd
> >    */
> > -ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
> > -			const char *desc)
> > +ssize_t tpm2_getcap_cmd(struct tpm_chip *chip, u32 cap_id, u32 property_id,
> > +			u32 *value, const char *desc)
> 
> This function currently returns single value "u32 *value" as output data.
> 
> Some calling function expect list of values from capabilities output.
> For eg., get_active_banks() use TPM_CAP_PCRS capability to retrieve list of
> active banks. And this capability returns array of pcr selections(which is a
> struct representing each active PCR bank)
> 
> I was thinking, can we define output parameter as struct of cap_id and union
> of expected cap_data ?

Unless you have major concerns about performance, which I think are not
relevant here, calling this in a loop is perfectly adequate and a lot of
simpler than having a generic version (with moreData handling and
everything).

I would rather see uses of struct cap_t to shrink than to expand. The
same goes for other horrific unions that exist today in the driver.

/Jarkko
