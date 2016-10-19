From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm,
 tpm_crb: remove redundant CRB_FL_CRB_START flag
Date: Wed, 19 Oct 2016 10:28:29 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
	<20161017225113.qnghq5vroxlmsurc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161017225113.qnghq5vroxlmsurc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net



> 
> On Mon, Oct 17, 2016 at 11:42:24PM +0300, Jarkko Sakkinen wrote:
> > Because all the existing hardware have HID MSFT0101 we end up always
> > setting CRB_FL_CRB_START flag as a workaround for 4th Gen Core CPUs.
> > Even if ACPI start is used, the driver will always issue also CRB start.

Do you have some more historical data about this fix, I was wondering about this quirk before, when restructuring the start method parsing. 
The description is ' in practice seems to require both'  sounds not certain about the root cause of this.


> > This commit makes the invocation of CRB start unconditional.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  drivers/char/tpm/tpm_crb.c | 16 +++++-----------
> >  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> I will include this to the next version of locale series if this is accepted. Just
> wanted to make sure that this is OK before I make the next version of the
> series.
> 
> /Jarkko
> 
> >
> > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > index 65040d7..5928ec8 100644
> > --- a/drivers/char/tpm/tpm_crb.c
> > +++ b/drivers/char/tpm/tpm_crb.c
> > @@ -72,7 +72,6 @@ enum crb_status {
> >
> >  enum crb_flags {
> >  	CRB_FL_ACPI_START	= BIT(0),
> > -	CRB_FL_CRB_START	= BIT(1),
> >  };
> >
> >  struct crb_priv {
> > @@ -226,8 +225,11 @@ static int crb_send(struct tpm_chip *chip, u8 *buf,
> size_t len)
> >  	/* Make sure that cmd is populated before issuing start. */
> >  	wmb();
> >
> > -	if (priv->flags & CRB_FL_CRB_START)
> > -		iowrite32(CRB_START_INVOKE, &priv->cca->start);
> > +
> > +	/* At least some of the 4th Gen Core CPUs that report only needing
> ACPI
> > +	 * start require also CRB start so we always set it just in case.
> > +	 */
> > +	iowrite32(CRB_START_INVOKE, &priv->cca->start);
> >
> >  	if (priv->flags & CRB_FL_ACPI_START)
> >  		rc = crb_do_acpi_start(chip);
> > @@ -407,14 +409,6 @@ static int crb_acpi_add(struct acpi_device *device)
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
> >  	if (sm == ACPI_TPM2_START_METHOD ||
> >  	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
> >  		priv->flags |= CRB_FL_ACPI_START;
> > --
> > 2.9.3
> >
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
