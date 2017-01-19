From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4 1/2] tpm: implement TPM 2.0 capability to get active
 PCR banks
Date: Thu, 19 Jan 2017 12:47:59 +0200
Message-ID: <20170119104759.oqobziiuy7lqnzbf@intel.com>
References: <1484729090-16012-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1484729090-16012-2-git-send-email-nayna@linux.vnet.ibm.com>
 <20170118134522.ftikno7gy3vttv6w@intel.com>
 <587F7252.4070808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <587F7252.4070808@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 18, 2017 at 07:19:06PM +0530, Nayna wrote:
> 
> 
> On 01/18/2017 07:15 PM, Jarkko Sakkinen wrote:
> > On Wed, Jan 18, 2017 at 03:44:49AM -0500, Nayna Jain wrote:
> > > This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> > > retrieve the active PCR banks from the TPM. This is needed
> > > to enable extending all active banks as recommended by TPM 2.0
> > > TCG Specification.
> > > 
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > ---
> > >   drivers/char/tpm/tpm.h      |  4 ++++
> > >   drivers/char/tpm/tpm2-cmd.c | 57 +++++++++++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 61 insertions(+)
> > > 
> > > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > > index 1ae9768..dddd573 100644
> > > --- a/drivers/char/tpm/tpm.h
> > > +++ b/drivers/char/tpm/tpm.h
> > > @@ -127,6 +127,7 @@ enum tpm2_permanent_handles {
> > >   };
> > > 
> > >   enum tpm2_capabilities {
> > > +	TPM2_CAP_PCRS		= 5,
> > >   	TPM2_CAP_TPM_PROPERTIES = 6,
> > >   };
> > > 
> > > @@ -187,6 +188,8 @@ struct tpm_chip {
> > > 
> > >   	const struct attribute_group *groups[3];
> > >   	unsigned int groups_cnt;
> > > +
> > > +	u16 active_banks[7];
> > >   #ifdef CONFIG_ACPI
> > >   	acpi_handle acpi_dev_handle;
> > >   	char ppi_version[TPM_PPI_VERSION_LEN + 1];
> > > @@ -545,4 +548,5 @@ int tpm2_auto_startup(struct tpm_chip *chip);
> > >   void tpm2_shutdown(struct tpm_chip *chip, u16 shutdown_type);
> > >   unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
> > >   int tpm2_probe(struct tpm_chip *chip);
> > > +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip);
> > >   #endif
> > > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > > index 6eda239..75a7546 100644
> > > --- a/drivers/char/tpm/tpm2-cmd.c
> > > +++ b/drivers/char/tpm/tpm2-cmd.c
> > > @@ -998,3 +998,60 @@ int tpm2_auto_startup(struct tpm_chip *chip)
> > >   		rc = -ENODEV;
> > >   	return rc;
> > >   }
> > > +
> > > +struct tpm2_pcr_selection {
> > > +	__be16  hash_alg;
> > > +	u8  size_of_select;
> > > +	u8  pcr_select[3];
> > > +} __packed;
> > > +
> > > +/**
> > > + * tpm2_get_pcr_allocation() - get TPM active PCR banks.
> > > + *
> > > + * @chip: TPM chip to use.
> > > + *
> > > + * Return: Same as with tpm_transmit_cmd.
> > > + */
> > > +ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
> > > +{
> > > +	struct tpm2_pcr_selection pcr_selection;
> > > +	struct tpm_buf buf;
> > > +	void *marker;
> > > +	unsigned int count = 0;
> > 
> > You shouldn't initialize 'count'.
> 
> It is initialized for reason below:
> 
> > 
> > > +	int rc;
> > > +	int i;
> > > +
> > > +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
> > > +	if (rc)
> > > +		return rc;
> > > +
> > > +	tpm_buf_append_u32(&buf, TPM2_CAP_PCRS);
> > > +	tpm_buf_append_u32(&buf, 0);
> > > +	tpm_buf_append_u32(&buf, 1);
> > > +
> > > +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0,
> > > +			      "get tpm pcr allocation");
> > > +	if (rc < 0)
> > > +		goto out;
> 
> if  tpm_transmit_cmd()fails, it jumps to out:
> where count is used in if(..).

Why the out label is placed there and not after?

> 
> Thanks & Regards,
>    - Nayna
> 
> > > +
> > > +	count = be32_to_cpup(
> > > +		(__be32 *)&buf.data[TPM_HEADER_SIZE + 5]);
> > > +
> > > +	if (count > ARRAY_SIZE(chip->active_banks))
> > > +		return -ENODEV;

Hey, here's a regression (didn't notice it last time). You
nee to call tpm_buf_destroy().


> > > +
> > > +	marker = &buf.data[TPM_HEADER_SIZE + 9];
> > > +	for (i = 0; i < count; i++) {
> > > +		memcpy(&pcr_selection, marker, sizeof(pcr_selection));
> > > +		chip->active_banks[i] = be16_to_cpu(pcr_selection.hash_alg);
> > > +		marker = marker + sizeof(struct tpm2_pcr_selection);
> > > +	}
> > > +
> > > +out:
> > > +	if (count < ARRAY_SIZE(chip->active_banks))
> > > +		chip->active_banks[count] = 0;
> > > +
> > > +	tpm_buf_destroy(&buf);
> > > +
> > > +	return rc;
> > > +}
> > > --
> > > 2.5.0
> > 
> > Otherwise,
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko.sakkien@linux.intel.com>
> > 
> > /Jarkko
> > 
> 

/Jarkko
