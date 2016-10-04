From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Tue, 4 Oct 2016 11:12:31 -0600
Message-ID: <20161004171231.GB17149@obsidianresearch.com>
References: <20161001120125.GC8664@intel.com>
	<20161001165436.GB13462@obsidianresearch.com>
	<20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
	<20161003163516.GB6801@obsidianresearch.com>
	<20161003202230.GA14624@intel.com>
	<20161003211129.GA26880@obsidianresearch.com>
	<20161004052651.GB10572@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161004052651.GB10572-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

On Tue, Oct 04, 2016 at 08:26:51AM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 03, 2016 at 03:11:29PM -0600, Jason Gunthorpe wrote:
> > On Mon, Oct 03, 2016 at 11:22:30PM +0300, Jarkko Sakkinen wrote:
> > 
> > > > Sort of, the typical race is broadly
> > > > 
> > > >     CPU0                           CPU1
> > > > 
> > > > fops->open()
> > > >                                 securityfs_remove()
> > > > 				kref_put(chip)
> > > > 				kfree(chip)
> > > > kref_get(data->chip.kref)

> > You need to actually race open and securityfs_remove to see the
> > kref_get() loose its race and then use-after-free.
> 
> So you are worried that get_device() might come when the chip is already
> gone?

Yes, I'm worried that securityfs_remove doesn not guarentee that
all threads running open() have completed and that no new threads can
start an open(). If that is guarenteed then we are fine once the
get_device is added.

There might be some tricky thing guaranteeing that but I haven't found
it..

> > Well, it is not so bad, it is just missing the fence on removal that
> > sysfs has, or the kref tracking that cdev has. Sadly this is a typical
> > error within the fops stuff, I've seen it in many places.
> 
> Do you think that this should be fixed above the driver i.e. add fencing
> to the securityfs code itself?

It appears debugfs choose to do that, so yes.

I'm not sure what a driver is supposed to do. The problem is managing
the lifetime of the 'data' (aka i_private) memory. We are using a kref
for 'data' so we need to know when it is s that open is fenced

synchronize with 

> > That would be very hard to do, racing two calls like that is
> > quite difficult in any sort of automatic way, AFAIK.
> 
> I wonder if SPI has similar file to 'remove' that PCI devices have
> (checking from the documentation later on).

IIRC belive remove comes from the device core, so it should be present
for spi also...

This solution might work.. Assuming the inode_lock is safe to get
within open.

tpm_bios_measurements_open(struct inode *inode)
{
	struct tpm_chip *chip;

	inode_lock(inode);
	if (!inode->i_private) {
		inode_unlock(inode);
		return -ENODEV;
	}
	chip = inode->i_private;
	get_device(&chip->dev);
	inode_unlock(inode);
}

tpm_bios_log_teardown()
{
	for (dentry *I ...) {
	    struct inode *inode = d_inode(I);
	    // securityfs_remove does not fence open, do it ourselves
	    inode_lock(inode);
	    inode->i_private = NULL;
	    inode_unlock(inode);
	    securityfs_remove(I);
	}
}

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
