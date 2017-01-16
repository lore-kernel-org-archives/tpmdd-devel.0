From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Mon, 16 Jan 2017 11:09:31 +0200
Message-ID: <20170116090931.dzdv4tcvhj4m4rrl@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
 <1484270243.5807.31.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484270243.5807.31.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 12, 2017 at 05:17:23PM -0800, James Bottomley wrote:
> On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > @@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct device
> > *pdev,
> >  	chip->cdev.owner = THIS_MODULE;
> >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > 
> > +	chip->work_space.context_buf = kzalloc(PAGE_SIZE,
> > GFP_KERNEL);
> > +	if (!chip->work_space.context_buf) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> 
> I think the work_buf handling can be greatly simplified by making it a
> pointer to the space: it's only usable between tpm2_prepare_space() and
> tpm2_commit_space() which are protected by the chip mutex, so there's
> no need for it to exist outside of these calls (i.e. it can be NULL).
> 
> Doing it this way also saves the allocation and copying overhead of
> work_space.
> 
> The patch below can be folded to effect this.

Hey, I have to take my words back. There's a separate buffer for space
for a reason. If the transaction fails for example when RM is doing its
job, we can revert to the previous set of transient objects.

Your change would completely thrawt this. I tried varius ways to heal
when RM decorations fail and this is the most fail safe to do it so lets
stick with it.

> James

/Jarkko
