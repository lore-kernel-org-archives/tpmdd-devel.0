From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Sat, 1 Oct 2016 10:54:36 -0600
Message-ID: <20161001165436.GB13462@obsidianresearch.com>
References: <1475051682-23060-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475051682-23060-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161001120125.GC8664@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161001120125.GC8664-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 01, 2016 at 03:01:25PM +0300, Jarkko Sakkinen wrote:

> > +	struct tpm_securityfs_data bin_sfs_data;
> > +	struct tpm_securityfs_data ascii_sfs_data;
> 
> I think this is otherwise right but the struct name is very clunky.
> First of all it doesn't own the data and IMHO now it kind of implies
> of owning.

These are passed in here:

> >  	chip->bios_dir[chip->bios_dir_count] =
> >  	    securityfs_create_file("ascii_bios_measurements",
> >  				   S_IRUSR | S_IRGRP, chip->bios_dir[0],
> > -				   (void *)&tpm_ascii_b_measurments_seqops,
> > +				   (void *)&chip->ascii_sfs_data,
> >  				   &tpm_bios_measurements_ops);

And the argument to securityfs_create_file is called 'data'..

The key question with these patches is if all the locking is done
right and we have the correct lifetime model now.

Eg how much does securityfs_remove serialize and is the kref on the
chip held for the duration of any fops. Can open() start after the
kref is dropped, etc.

Otherwise this scheme isn't good enough either :/

I haven't looked in detail at that topic yet.. Maybe Nayna can explain
what is expected here. Would be excellend to get someone from security to
review this lifetime model.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
