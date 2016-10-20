From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 7/7] tpm: replace or remove printk
 error messages
Date: Thu, 20 Oct 2016 16:43:21 +0300
Message-ID: <20161020134321.gne3an3alok2pubb@intel.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1476838185-24007-8-git-send-email-nayna@linux.vnet.ibm.com>
	<20161019161854.iuzgacimusfcivvf@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B5430045A@hasmsx108.ger.corp.intel.com>
	<5808C747.4040709@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5808C747.4040709-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 20, 2016 at 07:01:51PM +0530, Nayna wrote:
> 
> 
> On 10/20/2016 01:04 PM, Winkler, Tomas wrote:
> > > On Tue, Oct 18, 2016 at 08:49:45PM -0400, Nayna Jain wrote:
> > > > This patch removes the unnecessary error messages on failing to
> > > > allocate memory and replaces pr_err/printk with dev_dbg/dev_info as
> > > > applicable.
> > > > 
> > > > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > 
> > > /Jarkko
> > > 
> > > > ---
> > > >   drivers/char/tpm/tpm_acpi.c | 17 +++++------------
> > > >   drivers/char/tpm/tpm_of.c   | 30 ++++++++++--------------------
> > > >   2 files changed, 15 insertions(+), 32 deletions(-)
> > > > 
> > > > diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> > > > index 859bdba..22e42da 100644
> > > > --- a/drivers/char/tpm/tpm_acpi.c
> > > > +++ b/drivers/char/tpm/tpm_acpi.c
> > > > @@ -60,11 +60,8 @@ int read_log_acpi(struct tpm_chip *chip)
> > > >   	status = acpi_get_table(ACPI_SIG_TCPA, 1,
> > > >   				(struct acpi_table_header **)&buff);
> > > > 
> > > > -	if (ACPI_FAILURE(status)) {
> > > > -		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
> > > > -		       __func__);
> > > > +	if (ACPI_FAILURE(status))
> > > >   		return -EIO;
> > > > -	}
> > > > 
> > > >   	switch(buff->platform_class) {
> > > >   	case BIOS_SERVER:
> > > > @@ -78,25 +75,21 @@ int read_log_acpi(struct tpm_chip *chip)
> > > >   		break;
> > > >   	}
> > > >   	if (!len) {
> > > > -		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n",
> > > __func__);
> > > > +		dev_dbg(&chip->dev, "%s: ERROR - TCPA log area empty\n",
> > > > +			__func__);
> > 
> > 
> > Why to keep __func__ here, dev_dbg already does it for you.
> 
> I tried to trace through dev_dbg
> - http://lxr.free-electrons.com/source/include/linux/device.h#L1195
> which further calls dev_printk from
> http://lxr.free-electrons.com/source/drivers/base/core.c#L2199
> 
> I couldn't find it printing __func__ anywhere.. I just see it printing
> "driver" and "dev" as tpm : tpm0.
> 
> Please let me know if I am missing something
> 
> Thanks & Regards,
> - Nayna

Sorry I mixed up in my last response. You can filter in dynamic
debug with a function name but doesn't print function name.

Anyway I would recommend to change this to dev_err in a way that
I explained in my response.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
