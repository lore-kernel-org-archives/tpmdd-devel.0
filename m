From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 14:23:00 -0700
Message-ID: <20170113212300.GA1463@obsidianresearch.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
 <20170112183919.GA12836@obsidianresearch.com>
 <1484335247.2527.28.camel@HansenPartnership.com>
 <20170113194730.GA32214@obsidianresearch.com>
 <1484337756.2527.48.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484337756.2527.48.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 12:02:36PM -0800, James Bottomley wrote:
> > > Actually, no, the devrm is a completely lifetime managed device as
> > > part
> > > of the chip structure.  once you've done a device_del on it, it can
> > > be
> > > kfreed because it's no longer visible to anything else.
> > 
> > No, that isn't enough. Anything else could have obtained a kref on
> > devrm outside of the sphere the device_del manages.
> > 
> > For instance, the cdev does exactly that, via this:
> > 
> > >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > > +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
> > 
> > In the worst case the kref the cdev grabs is not released until after
> > tpm_chip_unregister() returns.
> 
> chip_unregister doesn't tear down either device. It's the final
> release of the chip->dev that does that.

I don't think you are seeing the problem.

I think you are assuming cdev_del waits for userspace to close any
open fds. It does not.

Instead cdev independently holds on to a module lock and a kref on the
chip, once userspace has done close() then the kref is dropped and the
module lock let go. This can happen after chip_unregister, after devm
has done the final put_device, and after the driver core has completed
driver detach.

This is why it is necessary for this:

 +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;

To point to a working kref, such as chip->dev.kobj.

My point is this patch has two very subtle bugs caused by devrm having
a broken kref. Yes we can fix those two cases, but this entire class
of bugs is prevented if devrm has a release function that does
put_device(chip->dev).

We have no idea what will happen down the road; most poeple assume
krefs *work*, having a struct with 4 krefs where only 3 work is pretty
wild, IMHO.

> Now there is a related problem that the owner is actually the *wrong*
> module: it holds the tpm module in place not the actual driver module,
> so I can happily attach tcsd to the TPM device then rmmod tpm_tis,
> which causes some interesting issues.  I can fix this, but it's not a
> problem of the current patch.

No, it is correct as is. The cdev fops rely only on the tpm module.
When tpm_chip_unregister returns to the driver the chips->ops is set
to NULL with proper locking - the driver code becomes uncallable at
that point.

Jason
