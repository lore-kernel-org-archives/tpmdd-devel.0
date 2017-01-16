From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 3/5] tpm: infrastructure for TPM
 spaces
Date: Mon, 16 Jan 2017 18:52:25 +0200
Message-ID: <20170116165225.gjchmn7pylpakjck@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-4-jarkko.sakkinen@linux.intel.com>
 <1484270243.5807.31.camel@linux.vnet.ibm.com>
 <20170116090931.dzdv4tcvhj4m4rrl@intel.com>
 <1484576688.2540.18.camel@linux.vnet.ibm.com>
 <20170116144847.p7nh3vvmqdoqlq7y@intel.com>
 <1484578724.2540.30.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484578724.2540.30.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 06:58:44AM -0800, James Bottomley wrote:
> On Mon, 2017-01-16 at 16:48 +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 16, 2017 at 06:24:48AM -0800, James Bottomley wrote:
> > > On Mon, 2017-01-16 at 11:09 +0200, Jarkko Sakkinen wrote:
> > > > On Thu, Jan 12, 2017 at 05:17:23PM -0800, James Bottomley wrote:
> > > > > On Thu, 2017-01-12 at 19:46 +0200, Jarkko Sakkinen wrote:
> > > > > > @@ -189,6 +190,12 @@ struct tpm_chip *tpm_chip_alloc(struct
> > > > > > device
> > > > > > *pdev,
> > > > > >  	chip->cdev.owner = THIS_MODULE;
> > > > > >  	chip->cdev.kobj.parent = &chip->dev.kobj;
> > > > > > 
> > > > > > +	chip->work_space.context_buf = kzalloc(PAGE_SIZE,
> > > > > > GFP_KERNEL);
> > > > > > +	if (!chip->work_space.context_buf) {
> > > > > > +		rc = -ENOMEM;
> > > > > > +		goto out;
> > > > > > +	}
> > > > > > +
> > > > > 
> > > > > I think the work_buf handling can be greatly simplified by 
> > > > > making it a pointer to the space: it's only usable between
> > > > > tpm2_prepare_space() and tpm2_commit_space() which are 
> > > > > protected by the chip mutex, so there's no need for it to exist 
> > > > > outside of these calls (i.e. it can be NULL).
> > > > > 
> > > > > Doing it this way also saves the allocation and copying 
> > > > > overhead of work_space.
> > > > > 
> > > > > The patch below can be folded to effect this.
> > > > 
> > > > Hey, I have to take my words back. There's a separate buffer for 
> > > > space for a reason. If the transaction fails for example when RM 
> > > > is doing its job, we can revert to the previous set of transient
> > > > objects.
> > > > 
> > > > Your change would completely thrawt this. I tried varius ways to 
> > > > heal when RM decorations fail and this is the most fail safe to 
> > > > do it so lets stick with it.
> > > 
> > > That's why I added the return code check in the other patch: if the
> > > command fails in the TPM, the space state isn't updated at all, the 
> > > net result being that nothing changes in the space, thus you don't 
> > > need the copy, because there's nothing to revert on a failure.
> > 
> > You are right in what you say but what if you save lets say 5 
> > transient contexts and ContextSave fails on 2nd. It's not for the 
> > command itself but for falling back to a sane state when 
> > tpm2_commit_space fails (to the previous set of transient objects).
> > 
> > I've never meant it as a fallback for the command itself...
> 
> Current error handling is to flush the entire space and abort ... and I
> think that's correct.  There can't be any recovery because the TPM just
> signalled it's in an insane state (it failed a command that should
> succeed, either because our state is wrong and the TPM doesn't have the
> handle we think it does or the TPM has had some internal error).  If
> I'm the user, I'm likely going to have to reset the TPM and restart and
> I likely wouldn't trust any state it gave me before this.
> 
> James

The *current* fallback in the patch set is what I said. It keeps
previously saved set of transient objects and will try to load them next
time. Only when contexts are succesfully saved the code overwrite the
buffers with new stuff.

tpm2_flush_context() is only used to clean up remaining contexts after
ContextSave fails. It's not *the* fallback. Reverting to the previous
set of transient contexts is.

That's why I didn't check for TPM error in tpm2_commit_response (except
now I have the check in v3 because this wasn't bright in my mind at the
time).

The reasons for this fallback have nothing to do with mixed up TPM
state. There are legit reasons for tpm2_commit_response to fail like
running out of virtual handle slots or out of backing storage.

/Jarkko
