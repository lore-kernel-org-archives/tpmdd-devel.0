From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] TPM2.0: Refactored eventlog init
 functions.
Date: Wed, 10 Aug 2016 13:51:24 +0300
Message-ID: <20160810105123.GA13929@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20160809222740.GD5535@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160809222740.GD5535-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 09, 2016 at 04:27:40PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 09, 2016 at 03:34:53PM -0400, Nayna Jain wrote:
> > Refactored eventlog.c file into tpm_eventlog.c and tpm_eventlog_init.c
> > 
> > Breakdown is:
> > 
> > * tpm_eventlog_init.c : Moved eventlog initialization methods like
> > to setup securityfs, to open and release seqfile from tpm_eventlog.c
> > to this file. This is to keep the logic of initialization for TPM1.2
> > and TPM2.0 in common file.
> > 
> > * tpm_eventlog.c : This file now has only methods specific to parsing
> > and iterate TPM1.2 entry log formats. It can understand only TPM1.2
> > and is called by methods in tpm_eventlog_init if identified TPM device
> > is TPM1.2.
> > 
> > Changelog v2:
> > 
> >         * Using of_node property of device rather than direct reading
> >         the device node.
> >         * Cleaned up the code to have generic open() for ascii and bios
> >         measurements
> >         * Removed dyncamic allocation for bios_dir and having dentry array
> > 	directly into tpm-chip.
> >         * Using dev_dbg instead of pr_err in tpm_of.c
> >         * readlog(...) now accepts struct tpm_chip * as parameter.
> 
> This patch needs to be split.
> 
> One patch per idea please.

And changelog per patch *set*.

/Jarkko

> >  ifdef CONFIG_ACPI
> > -	tpm-y += tpm_eventlog.o tpm_acpi.o
> > +	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_acpi.o
> >  else
> >  ifdef CONFIG_TCG_IBMVTPM
> > -	tpm-y += tpm_eventlog.o tpm_of.o
> > +	tpm-y += tpm_eventlog_init.o tpm_eventlog.o tpm_of.o
> >  endif
> 
> Still need to fix this, more like
> 
> tpm_of should be included if CONFIG_OF is set,
> and tpm_acpi if CONFIG_ACPI is set, do not do this based on random
> other configus..
> 
> 
> >  endif
> >  obj-$(CONFIG_TCG_TIS_CORE) += tpm_tis_core.o
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index e595013..7f6cdab 100644
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -171,6 +171,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *dev,
> >  	chip->dev.release = tpm_dev_release;
> >  	chip->dev.parent = dev;
> >  	chip->dev.groups = chip->groups;
> > +	if (dev->of_node)
> > +		chip->dev.of_node = dev->of_node;
> 
> No. chip->dev.parent->of_node.
> 
> > -extern struct dentry **tpm_bios_log_setup(const char *);
> > -extern void tpm_bios_log_teardown(struct dentry **);
> > +extern void tpm_bios_log_setup(struct tpm_chip *chip);
> > +extern void tpm_bios_log_teardown(struct tpm_chip *chip);
> 
> We are trying to get rid of these extra externs..
> 
> > +
> > +	bin_file =
> > +	    securityfs_create_file("binary_bios_measurements",
> 
> No, do
> 
> chip->bios_dir_count = 0;
> chip->bios_dir[chip->bios_dir_count] = [..]
> if (is_bad(chip->bios_dir[chip->bios_dir_count])
>   goto err
> chip->bios_dir_count++
> 
> err:
> for (I = 0; I != chip->bios_dir_count; ++I)
>    securityfs_remove(chip->bios_dir[I]);
> 
> > +	for (i = 0; i < 3; i++) {
> > +		if (chip->bios_dir[i])
> > +			securityfs_remove(chip->bios_dir[i]);
> 
> Same logic as err: example above
> >  
> > -	np = of_find_node_by_name(NULL, "vtpm");
> > +	if (chip->dev.of_node)
> > +		np = chip->dev.of_node;
> >  	if (!np) {
> > -		pr_err("%s: ERROR - IBMVTPM not supported\n", __func__);
> > +		dev_dbg(&chip->dev, "%s: ERROR - IBMVTPM not supported\n",
> > +		__func__);
> >  		return -ENODEV;
> >  	}
> 
> Where you able to test this on IBM's 'vtpm' stuff as well?
> 
> >  
> >  	sizep = of_get_property(np, "linux,sml-size", NULL);
> >  	if (sizep == NULL) {
> > -		pr_err("%s: ERROR - SML size not found\n", __func__);
> > +		dev_dbg(&chip->dev, "%s: ERROR - SML size not found\n",
> > +		__func__);
> >  		goto cleanup_eio;
> >  	}
> >  	if (*sizep == 0) {
> > -		pr_err("%s: ERROR - event log area empty\n", __func__);
> > +		dev_dbg(&chip->dev, "%s: ERROR - event log area empty\n",
> > +		__func__);
> >  		goto cleanup_eio;
> >  	}
> >  
> >  	basep = of_get_property(np, "linux,sml-base", NULL);
> >  	if (basep == NULL) {
> > -		pr_err("%s: ERROR - SML not found\n", __func__);
> > +		dev_dbg(&chip->dev, "%s: ERROR - SML not found\n",
> > +		__func__);
> >  		goto cleanup_eio;
> >  	}
> >  
> >  	log->bios_event_log = kmalloc(*sizep, GFP_KERNEL);
> >  	if (!log->bios_event_log) {
> > -		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
> > -		       __func__);
> >  		of_node_put(np);
> 
> Why is there an of_node_put here but not in other error paths? Where is
> the get this is putting?
> 
> Jason
> 
> ------------------------------------------------------------------------------
> What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
> patterns at an interface-level. Reveals which users, apps, and protocols are 
> consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
> J-Flow, sFlow and other flows. Make informed decisions using capacity 
> planning reports. http://sdm.link/zohodev2dev
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
