From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 12:02:36 -0800
Message-ID: <1484337756.2527.48.camel@HansenPartnership.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
	<20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
	<20170112183919.GA12836@obsidianresearch.com>
	<1484335247.2527.28.camel@HansenPartnership.com>
	<20170113194730.GA32214@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170113194730.GA32214-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-13 at 12:47 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 13, 2017 at 11:20:47AM -0800, James Bottomley wrote:
> > On Thu, 2017-01-12 at 11:39 -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 12, 2017 at 07:46:08PM +0200, Jarkko Sakkinen wrote:
> > > 
> > > >  struct tpm_chip {
> > > > -	struct device dev;
> > > > -	struct cdev cdev;
> > > > +	struct device dev, devrm;
> > > 
> > > Hum.. devrm adds a new kref but doesn't do anything with the
> > > release
> > > function, so that is going to use after free, ie here:
> > > 
> > > > 	put_device(&chip->dev);
> > > > +	put_device(&chip->devrm);
> > > > 	return ERR_PTR(rc);
> > > 
> > > And other places.
> > > 
> > > One solution is to get_device(chip->dev) after
> > > device_initialize(dev->rm) and add a devrm->dev.release function
> > > to
> > > do put_device(chip->dev)
> > 
> > Actually, no, the devrm is a completely lifetime managed device as
> > part
> > of the chip structure.  once you've done a device_del on it, it can
> > be
> > kfreed because it's no longer visible to anything else.
> 
> No, that isn't enough. Anything else could have obtained a kref on
> devrm outside of the sphere the device_del manages.
> 
> For instance, the cdev does exactly that, via this:
> 
> >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
> 
> In the worst case the kref the cdev grabs is not released until after
> tpm_chip_unregister() returns.

chip_unregister doesn't tear down either device.  It's the final
release of the chip->dev that does that.  chip->devrm is simply a
subordinate in that process, which is why it doesn't need to be
separately managed.  We have to be careful to call cdev_del() before
device_del on devrm, but we do that, so we're guaranteed no visible
references by the time the chip->dev release is called.

> Having a kref that doesn't work is just asking for trouble, please
> make it work properly.

Actually, as shown above, these krefs are managed ... However, they're
not actually what holds the tpm module in place.  The try_module_get on
open via the owner field does that.  So, by the time tpm_exit() is
called we know there are no devrm references simply because we manage
the cdevrm entity as well.

Now there is a related problem that the owner is actually the *wrong*
module: it holds the tpm module in place not the actual driver module,
so I can happily attach tcsd to the TPM device then rmmod tpm_tis,
which causes some interesting issues.  I can fix this, but it's not a
problem of the current patch.

James



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
