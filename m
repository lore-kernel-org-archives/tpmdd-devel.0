From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 1/2] tpm: implement TPM 2.0 capability to get active
 PCR banks
Date: Fri, 13 Jan 2017 18:45:24 +0200
Message-ID: <20170113164524.4xhqhbsfhgzyv4y4@intel.com>
References: <1484240290-4306-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1484240290-4306-2-git-send-email-nayna@linux.vnet.ibm.com>
 <20170112182507.w5lpzupqw4hwhtfn@intel.com>
 <5878809C.8020408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5878809C.8020408@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 12:54:12PM +0530, Nayna wrote:
> 
> 
> On 01/12/2017 11:55 PM, Jarkko Sakkinen wrote:
> > On Thu, Jan 12, 2017 at 11:58:09AM -0500, Nayna Jain wrote:
> > > This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> > > retrieve the active PCR banks from the TPM. This is needed
> > > to enable extending all active banks as recommended by TPM 2.0
> > > TCG Specification.
> > > 
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > ---
> > >   drivers/char/tpm/tpm.h      |  4 +++
> > >   drivers/char/tpm/tpm2-cmd.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 63 insertions(+)
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
> > > index 6eda239..87388921 100644
> > > --- a/drivers/char/tpm/tpm2-cmd.c
> > > +++ b/drivers/char/tpm/tpm2-cmd.c
> > > @@ -83,6 +83,12 @@ struct tpm2_get_tpm_pt_out {
> > >   	__be32	value;
> > >   } __packed;
> > > 
> > > +struct tpm2_tpms_pcr_selection {
> > > +	__be16  hash_alg;
> > > +	u8  size_of_select;
> > > +	u8  pcr_select[3];
> > > +} __packed;
> > 
> > Please move this right before tpm2_get_pcr_allocation.
> > Drop 'tpms_'.
> 
> Sure, will do this. But didn't understand why. I think all structs are
> defined in start of file..
> 
> Thanks & Regards,
>    - Nayna
> 
> > 
> > > +
> > >   struct tpm2_get_random_in {
> > >   	__be16	size;
> > >   } __packed;
> > > @@ -993,8 +999,61 @@ int tpm2_auto_startup(struct tpm_chip *chip)
> > >   		}
> > >   	}
> > > 
> > > +	rc = tpm2_get_pcr_allocation(chip);
> > > +
> > 
> > Please have this call in the commit where you actually use it
> > Does not make any sense here
> > 
> > >   out:
> > >   	if (rc > 0)
> > >   		rc = -ENODEV;
> > >   	return rc;
> > >   }
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
> > > +	struct tpm2_tpms_pcr_selection pcr_selection;
> > > +	struct tpm_buf buf;
> > > +	void *marker;
> > > +	unsigned int count = 0;
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
> > > +
> > > +	count = be32_to_cpup(
> > > +		(__be32 *) &buf.data[TPM_HEADER_SIZE + 5]);
> > 
> > Please do not add a space after cast. This has been an issue in your
> > previous patches too so try to do it right next time.

It is only used internally by that function. I think this would
make sense for other structures too that are only used by one
function.

/Jarkko
