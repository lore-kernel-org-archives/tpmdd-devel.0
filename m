From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 7/7] tpm: replace or remove printk
 error messages
Date: Wed, 26 Oct 2016 13:56:49 +0300
Message-ID: <20161026105649.kgav732btjfv4pfw@intel.com>
References: <1476838185-24007-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1476838185-24007-8-git-send-email-nayna@linux.vnet.ibm.com>
	<20161019161854.iuzgacimusfcivvf@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B5430045A@hasmsx108.ger.corp.intel.com>
	<20161020112400.75pwp5ttk3yxuinq@intel.com>
	<580989E6.3060103@linux.vnet.ibm.com>
	<20161021150250.24dyyi427rbnkpba@intel.com>
	<5810137D.2010002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5810137D.2010002-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Wed, Oct 26, 2016 at 07:52:53AM +0530, Nayna wrote:
> 
> 
> On 10/21/2016 08:32 PM, Jarkko Sakkinen wrote:
> > On Fri, Oct 21, 2016 at 08:52:14AM +0530, Nayna wrote:
> > > 
> > > 
> > > On 10/20/2016 04:54 PM, Jarkko Sakkinen wrote:
> > > > On Thu, Oct 20, 2016 at 07:34:37AM +0000, Winkler, Tomas wrote:
> > > > > > On Tue, Oct 18, 2016 at 08:49:45PM -0400, Nayna Jain wrote:
> > > > > > > This patch removes the unnecessary error messages on failing to
> > > > > > > allocate memory and replaces pr_err/printk with dev_dbg/dev_info as
> > > > > > > applicable.
> > > > > > > 
> > > > > > > Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > > > > > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > > > > 
> > > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > > > > 
> > > > > > /Jarkko
> > > > > > 
> > > > > > > ---
> > > > > > >    drivers/char/tpm/tpm_acpi.c | 17 +++++------------
> > > > > > >    drivers/char/tpm/tpm_of.c   | 30 ++++++++++--------------------
> > > > > > >    2 files changed, 15 insertions(+), 32 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
> > > > > > > index 859bdba..22e42da 100644
> > > > > > > --- a/drivers/char/tpm/tpm_acpi.c
> > > > > > > +++ b/drivers/char/tpm/tpm_acpi.c
> > > > > > > @@ -60,11 +60,8 @@ int read_log_acpi(struct tpm_chip *chip)
> > > > > > >    	status = acpi_get_table(ACPI_SIG_TCPA, 1,
> > > > > > >    				(struct acpi_table_header **)&buff);
> > > > > > > 
> > > > > > > -	if (ACPI_FAILURE(status)) {
> > > > > > > -		printk(KERN_ERR "%s: ERROR - Could not get TCPA table\n",
> > > > > > > -		       __func__);
> > > > > > > +	if (ACPI_FAILURE(status))
> > > > > > >    		return -EIO;
> > > > > > > -	}
> > > > > > > 
> > > > > > >    	switch(buff->platform_class) {
> > > > > > >    	case BIOS_SERVER:
> > > > > > > @@ -78,25 +75,21 @@ int read_log_acpi(struct tpm_chip *chip)
> > > > > > >    		break;
> > > > > > >    	}
> > > > > > >    	if (!len) {
> > > > > > > -		printk(KERN_ERR "%s: ERROR - TCPA log area empty\n",
> > > > > > __func__);
> > > > > > > +		dev_dbg(&chip->dev, "%s: ERROR - TCPA log area empty\n",
> > > > > > > +			__func__);
> > > > > 
> > > > > 
> > > > > Why to keep __func__ here, dev_dbg already does it for you.
> > > > 
> > > > Good catch. I would actually consider also changing this to
> > > > 
> > > > dev_err(dev, FW_BUG "TCPA log area empty\n");
> > > > 
> > > > If TCPA exists but it's empty, that's most likely a FW bug.
> > > 
> > > If it can be possibly a FW bug, should it fail the probe also just like
> > > -ENOMEM error ?
> > 
> > I think so but I hold for second opinion on this. I mean wouldn't
> > it seem like a bit broken situation where TCPA tabe would exist but
> > would also be empty?
> 
> Hmm, is it possible for this to be firmware implementation dependent ?

Let me put it this way. Why would anyone expose TCPA to the user space
that is empty? What would be the point?

/Jarkko

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
