From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 17:10:30 -0800
Message-ID: <1484356230.2527.76.camel@HansenPartnership.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
         <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
         <20170112183919.GA12836@obsidianresearch.com>
         <1484335247.2527.28.camel@HansenPartnership.com>
         <20170113194730.GA32214@obsidianresearch.com>
         <1484337756.2527.48.camel@HansenPartnership.com>
         <20170113212300.GA1463@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170113212300.GA1463@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-13 at 14:23 -0700, Jason Gunthorpe wrote:
> On Fri, Jan 13, 2017 at 12:02:36PM -0800, James Bottomley wrote:
> > > > Actually, no, the devrm is a completely lifetime managed device 
> > > > as part of the chip structure.  once you've done a device_del 
> > > > on it, it can be kfreed because it's no longer visible to
> > > > anything else.
> > > 
> > > No, that isn't enough. Anything else could have obtained a kref 
> > > on devrm outside of the sphere the device_del manages.
> > > 
> > > For instance, the cdev does exactly that, via this:
> > > 
> > > >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > > > +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
> > > 
> > > In the worst case the kref the cdev grabs is not released until 
> > > after tpm_chip_unregister() returns.
> > 
> > chip_unregister doesn't tear down either device. It's the final
> > release of the chip->dev that does that.
> 
> I don't think you are seeing the problem.
> 
> I think you are assuming cdev_del waits for userspace to close any
> open fds. It does not.
> 
> Instead cdev independently holds on to a module lock and a kref on 
> the chip, once userspace has done close() then the kref is dropped 
> and the module lock let go. This can happen after chip_unregister, 
> after devm has done the final put_device, and after the driver core 
> has completed driver detach.
> 
> This is why it is necessary for this:
> 
>  +	chip->cdevrm.kobj.parent = &chip->devrm.kobj;
> 
> To point to a working kref, such as chip->dev.kobj.
> 
> My point is this patch has two very subtle bugs caused by devrm 
> having a broken kref. Yes we can fix those two cases, but this entire 
> class of bugs is prevented if devrm has a release function that does
> put_device(chip->dev).
> 
> We have no idea what will happen down the road; most poeple assume
> krefs *work*, having a struct with 4 krefs where only 3 work is 
> pretty wild, IMHO.
> 
> > Now there is a related problem that the owner is actually the 
> > *wrong* module: it holds the tpm module in place not the actual 
> > driver module, so I can happily attach tcsd to the TPM device then 
> > rmmod tpm_tis, which causes some interesting issues.  I can fix 
> > this, but it's not a problem of the current patch.
> 
> No, it is correct as is. The cdev fops rely only on the tpm module.
> When tpm_chip_unregister returns to the driver the chips->ops is set
> to NULL with proper locking - the driver code becomes uncallable at
> that point.

So that's the nastily subtle point I was missing.  The patch below will
add the reference tracking to make sure the chip is held while the
/dev/tpms<n> is open.  I really hate the additional layer of subtlety
this adds, though ... I've tried to document the extra nasties, but I
bet they confuse someone.

Doing it the standard way, where the owner is set to the pdev driver
module and the references all track up to the pdev, meaning the actual
device could never go away while a cdev file was open would be far
easier to understand.

James

---


diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 07d7607..338592c 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -132,6 +132,14 @@ static void tpm_dev_release(struct device *dev)
 	kfree(chip);
 }
 
+static void tpm_devrm_release(struct device *dev)
+{
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, devrm);
+
+	/* release the master device reference */
+	put_device(&chip->dev);
+}
+
 /**
  * tpm_chip_alloc() - allocate a new struct tpm_chip instance
  * @pdev: device to which the chip is associated
@@ -178,6 +186,12 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 
 	chip->devrm.parent = pdev;
 	chip->devrm.class = tpm_rm_class;
+	chip->devrm.release = tpm_devrm_release;
+	/* get extra reference on main device to hold on
+	 * behalf of devrm.  This holds the chip structure
+	 * while cdevrm is in use.  The corresponding put
+	 * is in the tpm_devrm_release */
+	get_device(&chip->dev);
 
 	if (chip->dev_num == 0)
 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
@@ -207,6 +221,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	return chip;
 
 out:
+	put_device(&chip->devrm);
 	put_device(&chip->dev);
 	return ERR_PTR(rc);
 }
@@ -323,6 +338,9 @@ static void tpm_del_char_device(struct tpm_chip *chip)
 		tpm2_shutdown(chip, TPM2_SU_CLEAR);
 	chip->ops = NULL;
 	up_write(&chip->ops_sem);
+	/* will release the devrm reference to the chip->dev unless
+	 * something has cdevrm open */
+	put_device(&chip->devrm);
 }
 
 static void tpm_del_legacy_sysfs(struct tpm_chip *chip)

