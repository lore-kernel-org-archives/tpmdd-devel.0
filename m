From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] ACPICA: Update TPM2 ACPI table
Date: Fri, 17 Mar 2017 22:32:16 +0200
Message-ID: <20170317203216.xxreazeu5etw7bul@intel.com>
References: <1489541553-2066-1-git-send-email-anjiandi@codeaurora.org>
	<20170315160226.apxecoujeqsbuk67@intel.com>
	<58CB2E11.9030509@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58CB2E11.9030509-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 16, 2017 at 07:30:09PM -0500, Jiandi An wrote:
> On 03/15/17 11:02, Jarkko Sakkinen wrote:
> > On Tue, Mar 14, 2017 at 08:32:32PM -0500, Jiandi An wrote:
> > > TCG ACPI Specification Family "1.2" and "2.0" Version 1.2
> > > Revision 8 introduces new start method for ARM SMC.
> > > 
> > > - Add new start method (type 11) for ARM SMC
> > > - Add start method specific parameters for ARM SMC start method
> > > 
> > > Signed-off-by: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> > > ---
> > >   drivers/char/tpm/tpm_crb.c |  6 +++++-
> > >   drivers/char/tpm/tpm_tis.c |  6 +++++-
> > >   include/acpi/actbl2.h      | 12 ++++++++++++
> > >   3 files changed, 22 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> > > index cb6fb13..089fcf8 100644
> > > --- a/drivers/char/tpm/tpm_crb.c
> > > +++ b/drivers/char/tpm/tpm_crb.c
> > > @@ -410,12 +410,16 @@ static int crb_acpi_add(struct acpi_device
> > *device)
> > >   	struct tpm_chip *chip;
> > >   	struct device *dev = &device->dev;
> > >   	acpi_status status;
> > > +	u32 default_len;
> > >   	u32 sm;
> > >   	int rc;
> > > 
> > > +	default_len = sizeof(struct acpi_table_tpm2) -
> > > +		      sizeof(union platform_params);
> > 
> > Maybe you should consider not putting struct crb_smc to actbl2.h. This
> > makes tpm_crb.c a mess.
> 
> Will fix this in v3.
> - Jiandi
> 
> > 
> > > +
> > >   	status = acpi_get_table(ACPI_SIG_TPM2, 1,
> > >   				(struct acpi_table_header **) &buf);
> > > -	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
> > > +	if (ACPI_FAILURE(status) || buf->header.length < default_len) {
> > >   		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
> > >   		return -EINVAL;
> > >   	}
> > > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > > index c7e1384..0e2e5f6 100644
> > > --- a/drivers/char/tpm/tpm_tis.c
> > > +++ b/drivers/char/tpm/tpm_tis.c
> > > @@ -253,11 +253,15 @@ static int tpm_tis_acpi_init(struct acpi_device
> > *acpi_dev)
> > >   	acpi_status st;
> > >   	struct list_head resources;
> > >   	struct tpm_info tpm_info = {};
> > > +	u32 default_len;
> > >   	int ret;
> > > 
> > > +	default_len = sizeof(struct acpi_table_tpm2) -
> > > +		      sizeof(union platform_params);
> > > +
> > 
> > And more clutter.
> > 
> > >   	st = acpi_get_table(ACPI_SIG_TPM2, 1,
> > >   			    (struct acpi_table_header **) &tbl);
> > > -	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
> > > +	if (ACPI_FAILURE(st) || tbl->header.length < default_len) {
> > >   		dev_err(&acpi_dev->dev,
> > >   			FW_BUG "failed to get TPM2 ACPI table\n");
> > >   		return -EINVAL;
> > > diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> > > index 7aee9fb..9612049 100644
> > > --- a/include/acpi/actbl2.h
> > > +++ b/include/acpi/actbl2.h
> > > @@ -1277,6 +1277,14 @@ struct acpi_table_tcpa_server {
> > >    *
> > > 
> > **************************************************************************
> > ****/
> > > 
> > > +struct tpm2_crb_smc {
> > > +	u32 interrupt;
> > > +	u8 interrupt_flags;
> > > +	u8 op_flags;
> > > +	u16 reserved2;
> > > +	u32 smc_func_id;
> > > +};
> > > +
> > >   struct acpi_table_tpm2 {
> > >   	struct acpi_table_header header;	/* Common ACPI table
> > header */
> > >   	u16 platform_class;
> > > @@ -1285,6 +1293,9 @@ struct acpi_table_tpm2 {
> > >   	u32 start_method;
> > > 
> > >   	/* Platform-specific data follows */
> > > +	union platform_params {
> > > +		struct tpm2_crb_smc smc_params;
> > > +	} platform_data;
> > 
> > Why the union type is not anonymous? ACPICA change should be its
> > own commit.
> > 
> > /Jarkko
> 
> Thanks. I realized it's not a good idea to change the size of
> acpi_table_tpm2.
> I will address this in V3 to avoid clutters in tpm_crb and tpm_tis
> driver and make ACPICA change its own commit.
> 
> - Jiandi

It would make life easier in terms of maintenance of the dirver if
you didn't add this new stuff to ACPICA in the first place. No other
will ever need it. Do you have some specific reason you want to put
it there?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
