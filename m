From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Sat, 1 Oct 2016 22:32:39 +0300
Message-ID: <20161001193239.GA3862@intel.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161001165436.GB13462-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 01, 2016 at 10:54:36AM -0600, Jason Gunthorpe wrote:
> On Sat, Oct 01, 2016 at 03:01:25PM +0300, Jarkko Sakkinen wrote:
> 
> > > +	struct tpm_securityfs_data bin_sfs_data;
> > > +	struct tpm_securityfs_data ascii_sfs_data;
> > 
> > I think this is otherwise right but the struct name is very clunky.
> > First of all it doesn't own the data and IMHO now it kind of implies
> > of owning.

Ok, I'm not going to make this an issue. If you think these are good
names, I'll live with that :)

> These are passed in here:
> 
> > >  	chip->bios_dir[chip->bios_dir_count] =
> > >  	    securityfs_create_file("ascii_bios_measurements",
> > >  				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> > > -				   (void *)&tpm_ascii_b_measurments_seqops,
> > > +				   (void *)&chip->ascii_sfs_data,
> > >  				   &tpm_bios_measurements_ops);
> 
> And the argument to securityfs_create_file is called 'data'..
> 
> The key question with these patches is if all the locking is done
> right and we have the correct lifetime model now.
> 
> Eg how much does securityfs_remove serialize and is the kref on the
> chip held for the duration of any fops. Can open() start after the
> kref is dropped, etc.

Why not make tpm_securityfs_data refcounted in order to remove
binding to the chip?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
