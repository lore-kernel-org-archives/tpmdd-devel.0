From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: revamp starting method
	setting.
Date: Wed, 5 Oct 2016 15:34:02 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F537C@hasmsx108.ger.corp.intel.com>
References: <1475673128-32262-1-git-send-email-tomas.winkler@intel.com>
	<20161005151946.GB9847@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161005151946.GB9847-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

> On Wed, Oct 05, 2016 at 04:12:08PM +0300, Tomas Winkler wrote:
> > Encapsulate the start method parsing in a single function and add
> > needed debug printouts.
> > It eliminates small issue with useless double checking for
> > ACPI_TPM2_MEMORY_MAPPED.
> 
> Start method is trival to check from TPM2 dump. I'm not sure which problem is
> this commit trying to solve.

There is not really issue with the implementation, I believe this is just more readable and it helped me with debugging quicker.
Some platforms are coming with discreet TPM (TIS) and some are PTT so this gives me quick answer for that and mostly 
It's coming from the same logging facility you don't have to go to acpi dump. 

Second, it there is this little issue here, were 'sm == ACPI_TPM2_MEMORY_MAPPED' cannot be really hit, as the code has bailed on that before.

if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
	    !strcmp(acpi_device_hid(device), "MSFT0101"))

Last it handles the parsing on one place,  before allocating the private data.

I think this change has some value, but no strong feelings about it.

Tomas



> /Jarkko
> 
> > Signed-off-by: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 65
> > +++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 50 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > index aa0ef742ac03..aeec313384d7 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -381,6 +381,52 @@ out:
> >  	return ret;
> >  }
> >
> > +/**
> > + * crb_start_method - parse starting method
> > + *
> > + * @device: acpi device
> > + * @sm: starting method
> > + *
> > + * Return 0 if supported starting method was not found
> > + *    CRB_FL_CRB_START or CRB_FL_ACPI_START otherwise
> > + */
> > +static unsigned int crb_start_method(struct acpi_device *device, u32
> > +sm) {
> > +	struct device *dev = &device->dev;
> > +	u32 flags;
> > +
> > +	switch (sm) {
> > +	/* Should the FIFO driver handle this? */
> > +	case ACPI_TPM2_MEMORY_MAPPED:
> > +		dev_dbg(dev, "starting method[%d]: MM\n", sm);
> > +		return 0;
> > +	case ACPI_TPM2_COMMAND_BUFFER:
> > +		flags = CRB_FL_CRB_START;
> > +		dev_dbg(dev, "starting method[%d]: CB\n", sm);
> > +		break;
> > +	case ACPI_TPM2_START_METHOD:
> > +		flags = CRB_FL_ACPI_START;
> > +		dev_dbg(dev, "starting method[%d]: SM\n", sm);
> > +		break;
> > +	case ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD:
> > +		flags = CRB_FL_ACPI_START;
> > +		dev_dbg(dev, "starting method[%d]: CB w/ SM\n",
> > +			sm);
> > +		break;
> > +	default:
> > +		return 0;
> > +	}
> > +
> > +	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
> > +	 * report only ACPI start but in practice seems to require both
> > +	 * ACPI start and CRB start.
> > +	 */
> > +	if (!strcmp(acpi_device_hid(device), "MSFT0101"))
> > +		flags |= CRB_FL_CRB_START;
> > +
> > +	return flags;
> > +}
> > +
> >  static int crb_acpi_add(struct acpi_device *device)  {
> >  	struct acpi_table_tpm2 *buf;
> > @@ -388,7 +434,7 @@ static int crb_acpi_add(struct acpi_device *device)
> >  	struct tpm_chip *chip;
> >  	struct device *dev = &device->dev;
> >  	acpi_status status;
> > -	u32 sm;
> > +	unsigned int sm;
> >  	int rc;
> >
> >  	status = acpi_get_table(ACPI_SIG_TPM2, 1, @@ -398,26 +444,15 @@
> > static int crb_acpi_add(struct acpi_device *device)
> >  		return -EINVAL;
> >  	}
> >
> > -	/* Should the FIFO driver handle this? */
> > -	sm = buf->start_method;
> > -	if (sm == ACPI_TPM2_MEMORY_MAPPED)
> > +	sm = crb_start_method(device, buf->start_method);
> > +	if (!sm)
> >  		return -ENODEV;
> >
> >  	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
> >  	if (!priv)
> >  		return -ENOMEM;
> >
> > -	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
> > -	 * report only ACPI start but in practice seems to require both
> > -	 * ACPI start and CRB start.
> > -	 */
> > -	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm ==
> ACPI_TPM2_MEMORY_MAPPED ||
> > -	    !strcmp(acpi_device_hid(device), "MSFT0101"))
> > -		priv->flags |= CRB_FL_CRB_START;
> > -
> > -	if (sm == ACPI_TPM2_START_METHOD ||
> > -	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
> > -		priv->flags |= CRB_FL_ACPI_START;
> > +	priv->flags = sm;
> >
> >  	rc = crb_map_io(device, priv, buf);
> >  	if (rc)
> > --
> > 2.7.4
> >

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
