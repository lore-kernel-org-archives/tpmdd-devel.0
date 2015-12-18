From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3 3/7] tpm_tis: Do not fall back to a hardcoded address
 for TPM2
Date: Fri, 18 Dec 2015 09:51:27 -0700
Message-ID: <20151218165127.GC7354@obsidianresearch.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1450376600-6970-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20151218093432.GA10581@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151218093432.GA10581@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: g@intel.com, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Martin Wilck <Martin.Wilck@ts.fujitsu.com>, Peter Huewe <peterhuewe@gmx.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Dec 18, 2015 at 11:34:32AM +0200, Jarkko Sakkinen wrote:
> > +	st = acpi_get_table(ACPI_SIG_TPM2, 1,
> > +			    (struct acpi_table_header **) &tbl);
> > +	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
> > +		dev_err(&acpi_dev->dev,
> > +			FW_BUG "failed to get TPM2 ACPI table\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
> >  		return -ENODEV;
> >  
> >  	INIT_LIST_HEAD(&resources);
> > @@ -996,6 +978,12 @@ static int tpm_tis_acpi_init(struct acpi_device *acpi_dev)
> >  
> >  	acpi_dev_free_resource_list(&resources);
> >  
> > +	if (tpm_info.start == 0 && tpm_info.len == 0) {
> > +		dev_err(&acpi_dev->dev,
> > +			FW_BUG "TPM2 ACPI table does not define a memory resource\n");
> > +		return -EINVAL;
> > +	}
> > +
> 
> I guess this the only relevant change in this patch? You should propose
> removal of is_fifo() as a separate patch if that makes sense. This patch
> is now doing orthogonal things.

No, the return code changes are relevant too, and are why is_fifo was
best un-inlined.

The patch is fixing all the ACPI data validatation in one go, not just
the resource range, the description notes this.

Jason
