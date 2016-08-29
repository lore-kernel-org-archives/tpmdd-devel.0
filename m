From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix a race condition in tpm2_unseal_trusted()
Date: Mon, 29 Aug 2016 23:03:26 +0300
Message-ID: <20160829200326.GA6758@intel.com>
References: <1472366212-8571-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160828185149.GF12783@obsidianresearch.com>
 <20160829152520.GA9063@intel.com>
 <20160829192110.GA1509@obsidianresearch.com>
 <20160829194027.GA21946@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160829194027.GA21946@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Aug 29, 2016 at 10:40:27PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 29, 2016 at 01:21:10PM -0600, Jason Gunthorpe wrote:
> > On Mon, Aug 29, 2016 at 06:25:21PM +0300, Jarkko Sakkinen wrote:
> > > On Sun, Aug 28, 2016 at 12:51:49PM -0600, Jason Gunthorpe wrote:
> > > > On Sun, Aug 28, 2016 at 08:36:52AM +0200, Jarkko Sakkinen wrote:
> > > > >  
> > > > > @@ -576,7 +576,8 @@ static int tpm2_load(struct tpm_chip *chip,
> > > > >  		goto out;
> > > > >  	}
> > > > >  
> > > > > -	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, "loading blob");
> > > > > +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, TPM_TRANSMIT_UNLOCKED,
> > > > > +			      "loading blob");
> > > > 
> > > > I still don't like this, required mutex's should not be split outside the
> > > > function that needs them without more a more obvious indication:
> > > > 
> > > > > +	mutex_lock(&chip->tpm_mutex);
> > > > >  	rc = tpm2_load(chip, payload, options, &blob_handle);
> > > > >  	if (rc)
> > > > > -		return rc;
> > > > 
> > > > I recommend you stick with the idiom and do this:
> > > > 
> > > >         mutex_lock(&chip->tpm_mutex);
> > > >   	rc = tpm2_load(chip, payload, options, &blob_handle, TPM_TRANSMIT_UNLOCKED);
> > > > 
> > > > Which makes it easy to see we are doing it right everywhere.
> > > 
> > > Why consume stack for unnecessary stuff? This is a static function. For
> > > me this sounds like cutting hairs really.
> > 
> > Well, tpm2_load looks like any other normal command that would grab
> > the mutex, so something has to be done to indicate to the reader it is
> > the unlocked version.
> > 
> > I wouldn't worry about the stack, the compiler will inline that away
> > anyhow.
> > 
> > > One thing that would improve readability would be to rename internal
> > > functions tpm2_load and tpm2_unseal to tpm2_load_cmd and tpm2_unseal_cmd
> > > in order to underline that they are command wrappers and not to mix with
> > > tpm2_unseal_trusted().
> > 
> > That seems reasonable as well, as long as all _cmd varients are unlocked.
> 
> I think this more reasonable argument for your proposal than previous
> ones for the flags parameter. Or maybe you had this argument in earlier
> responses but I just failed to decipher it.
> 
> I can buy this.

I fix the comments as well because they have some errors concerning
return value and also do not match guidelines of [1] now that I'm at it.

I will also add documentation comments for tpm2_unseal_cmd,
tpm2_load_cmd and tpm2_flush_context_cmd. Do you think it is sufficient
to say "Return: same as with tpm_transmit_cmd"?

[1]  https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

/Jarkko
