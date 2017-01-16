From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Mon, 16 Jan 2017 09:54:20 -0700
Message-ID: <20170116165420.GB20238@obsidianresearch.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
 <20170112183919.GA12836@obsidianresearch.com>
 <1484335247.2527.28.camel@HansenPartnership.com>
 <20170113194730.GA32214@obsidianresearch.com>
 <1484337756.2527.48.camel@HansenPartnership.com>
 <20170113212300.GA1463@obsidianresearch.com>
 <1484356230.2527.76.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484356230.2527.76.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 05:10:30PM -0800, James Bottomley wrote:

> > No, it is correct as is. The cdev fops rely only on the tpm module.
> > When tpm_chip_unregister returns to the driver the chips->ops is set
> > to NULL with proper locking - the driver code becomes uncallable at
> > that point.
>
> So that's the nastily subtle point I was missing.  The patch below will
> add the reference tracking to make sure the chip is held while the
> /dev/tpms<n> is open.  I really hate the additional layer of subtlety
> this adds, though ... I've tried to document the extra nasties, but I
> bet they confuse someone.

Thanks

> Doing it the standard way, where the owner is set to the pdev driver
> module and the references all track up to the pdev, meaning the actual
> device could never go away while a cdev file was open would be far
> easier to understand.

For a long time now devices can be unbound without a module unload. Eg the
'unbind' file in sysfs. Subsystems can no longer rely on module locking to
block unbind.

vtpm makes use of hot-unplug when the server side is closed. We
audited this area extensively when vtpm was introduced to make it work
properly.

Not all subsystems are correct in this regard, and you may still find
vestigial assumptions that module locking is enough to fix
locking/refcounting sins. It is not, those places are just broken. :(

Jason
