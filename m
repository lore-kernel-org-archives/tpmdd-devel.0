From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/7] tpm_tis: Do not fall back to a
 hardcoded address for TPM2
Date: Sun, 20 Dec 2015 14:34:34 +0200
Message-ID: <20151220123434.GA8232@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-4-git-send-email-jgunthorpe@obsidianresearch.com>
	<20151218093432.GA10581@intel.com>
	<20151218165127.GC7354@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151218165127.GC7354-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Martin Wilck <Martin.Wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, g@intel.com, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 18, 2015 at 09:51:27AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 18, 2015 at 11:34:32AM +0200, Jarkko Sakkinen wrote:
> > > +	st = acpi_get_table(ACPI_SIG_TPM2, 1,
> > > +			    (struct acpi_table_header **) &tbl);
> > > +	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
> > > +		dev_err(&acpi_dev->dev,
> > > +			FW_BUG "failed to get TPM2 ACPI table\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
> > >  		return -ENODEV;
> > >  
> > >  	INIT_LIST_HEAD(&resources);
> > > @@ -996,6 +978,12 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
> > >  
> > >  	acpi_dev_free_resource_list(&resources);
> > >  
> > > +	if (tpm_info.start == 0 && tpm_info.len == 0) {
> > > +		dev_err(&acpi_dev->dev,
> > > +			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > 
> > I guess this the only relevant change in this patch? You should propose
> > removal of is_fifo() as a separate patch if that makes sense. This patch
> > is now doing orthogonal things.
> 
> No, the return code changes are relevant too, and are why is_fifo was
> best un-inlined.
> 
> The patch is fixing all the ACPI data validatation in one go, not just
> the resource range, the description notes this.

Got you. I think I'm good with this patch.

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> Jason

/Jarkko

------------------------------------------------------------------------------
