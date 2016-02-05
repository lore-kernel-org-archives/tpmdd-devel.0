From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: fix rollback/cleanup before
 tpm_chip_register()
Date: Fri, 5 Feb 2016 08:49:40 -0800
Message-ID: <20160205164940.GB8112@intel.com>
References: <1454205942-13033-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160202231353.GA32711@obsidianresearch.com>
 <20160203160235.GA15567@intel.com>
 <20160204003437.GB26123@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160204003437.GB26123@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, stable@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Feb 03, 2016 at 05:34:37PM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 03, 2016 at 08:02:35AM -0800, Jarkko Sakkinen wrote:
> 
> > Would s/the platform device/the parent device/ be better?
> 
> Yes
> 
> > > > +	/* Associate character device with the platform device only after
> > > > +	 * it is properly initialized.
> > > > +	 */
> > > > +	dev_set_drvdata(pdev, chip);
> > > > +	devm_add_action(pdev, (void (*)(void *)) tpm_dev_release,
> > > > &chip->dev);
> > > 
> > > No, a release function can never be called naked. The action needs
> > > to do put_device, which is the error unwind for device_initialize().
> > 
> > Got it (already from your first comment)!
> > 
> > What does "called naked" even mean? I just don't understand the
> > english here and want to be sure that I understand what you are saying
> > and not make false assumptions.
> 
> 'called naked' would refer to just open coding a call to
> tpm_dev_release, using it as a devm_add_action is the same as open
> coding.
> 
> The function must only ever be called by put_device.
> 
> > > > @@ -162,7 +165,10 @@ static int tpm_add_char_device(struct tpm_chip *chip)
> > > >  			MINOR(chip->dev.devt), rc);
> > > >  
> > > >  		cdev_del(&chip->cdev);
> > > > -		return rc;
> > > > +	} else {
> > > > +		devm_remove_action(chip->dev.parent,
> > > > +				   (void (*)(void *)) tpm_dev_release,
> > > > +				   &chip->dev);
> > > 
> > > This is in the wrong place, the devm should be canceled only if
> > > tpm_chip_register returns success, at that point the caller's contract
> > > is to guarentee a call to tpm_chip_unregister, and
> > > tpm_chip_unregister does the put_device that calls the release
> > > function.
> > 
> > rc == 0 at that point i.e. success. I don't see the problem here.
> 
> It should not be in tpm_add_char_device
> 
> I'm also not completely sure about the error handling around
> tpm_register - if it fails the tpm_chip should not be destroyed, and I
> think it does..
> 
> It would probably be ideal to just rely on devm to always do the final
> put_device and avoid the devm_remove_action entirely. I think this
> means a get_device will be needed in tpm_register after device_add ?
> Didn't look closely at how all the refs balance.

I'm OK with letting devm always do the job. Then there needs to be
just dummy calback for release because the framework complains about
it otherwise.

> Jason

/Jarkko
