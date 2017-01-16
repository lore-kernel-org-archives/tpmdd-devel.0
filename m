From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Mon, 16 Jan 2017 06:24:48 -0800
Message-ID: <1484576688.2540.18.camel@linux.vnet.ibm.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
         <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
         <1484270243.5807.31.camel@linux.vnet.ibm.com>
         <20170116090931.dzdv4tcvhj4m4rrl@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170116090931.dzdv4tcvhj4m4rrl@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-16 at 11:09 +0200, Jarkko Sakkinen wrote:
> On Thu, Jan 12, 2017 at 05:17:23PM -0800, James Bottomley wrote:
> > On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > > @@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct
> > > device
> > > *pdev,
> > >  	chip->cdev.owner = THIS_MODULE;
> > >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > > 
> > > +	chip->work_space.context_buf = kzalloc(PAGE_SIZE,
> > > GFP_KERNEL);
> > > +	if (!chip->work_space.context_buf) {
> > > +		rc = -ENOMEM;
> > > +		goto out;
> > > +	}
> > > +
> > 
> > I think the work_buf handling can be greatly simplified by making 
> > it a pointer to the space: it's only usable between 
> > tpm2_prepare_space() and tpm2_commit_space() which are protected by 
> > the chip mutex, so there's no need for it to exist outside of these 
> > calls (i.e. it can be NULL).
> > 
> > Doing it this way also saves the allocation and copying overhead of
> > work_space.
> > 
> > The patch below can be folded to effect this.
> 
> Hey, I have to take my words back. There's a separate buffer for 
> space for a reason. If the transaction fails for example when RM is 
> doing its job, we can revert to the previous set of transient
> objects.
> 
> Your change would completely thrawt this. I tried varius ways to heal
> when RM decorations fail and this is the most fail safe to do it so 
> lets stick with it.

That's why I added the return code check in the other patch: if the
command fails in the TPM, the space state isn't updated at all, the net
result being that nothing changes in the space, thus you don't need the
copy, because there's nothing to revert on a failure.

If you're thinking transaction being a sequence of TPM commands, then
we might need an ioctl to transfer the space state to/from userspace,
so it can do rollback for several commands, but that too wouldn't need
us to have a single prior command saved copy.

James

