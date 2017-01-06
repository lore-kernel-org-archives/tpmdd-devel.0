From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: Do not print an error message when doing TPM auto
 startup
Date: Fri, 6 Jan 2017 14:25:51 -0700
Message-ID: <20170106212551.GA23815@obsidianresearch.com>
References: <20161121183109.GA18088@obsidianresearch.com>
 <20161121204211.iuwi2embugn4f74v@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121204211.iuwi2embugn4f74v@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Ed Swierk <eswierk@skyportsystems.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Nov 21, 2016 at 10:42:11PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 21, 2016 at 11:31:09AM -0700, Jason Gunthorpe wrote:
> > This is a regression when this code was reworked and made the error
> > print unconditional. The original code deliberately suppressed printing
> > of the first error message so it could quietly sense
> > TPM_ERR_INVALID_POSTINIT.
> > 
> > Fixes: a502feb67b47 ("tpm: Clean up reading of timeout and duration capabilities")
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Thanks for spotting this out. I'll apply this tomorrow (i.e. not
> tonight) as it does not endager stability in anyway as I test the
> other fixes.
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Hey Jarkko, I couldn't find this patch in your trees and it didn't
make 4.10-rc1, can you please pick it up?

https://patchwork.kernel.org/patch/9439931/

> /Jarkko
> 
> >  drivers/char/tpm/tpm-interface.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> > index a2688ac2b48f3c..c90f4f6d7871be 100644
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -523,8 +523,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
> >  		return 0;
> >  	}
> >  
> > -	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> > -			"attempting to determine the timeouts");
> > +	rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL);
> >  	if (rc == TPM_ERR_INVALID_POSTINIT) {
> >  		/* The TPM is not started, we are the first to talk to it.
> >  		   Execute a startup command. */
> > @@ -535,8 +534,12 @@ int tpm_get_timeouts(struct tpm_chip *chip)
> >  		rc = tpm_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap,
> >  				"attempting to determine the timeouts");
> >  	}
> > -	if (rc)
> > +	if (rc) {
> > +		dev_err(&chip->dev,
> > +			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> > +			rc);
> >  		return rc;
> > +	}
> >  
> >  	old_timeout[0] = be32_to_cpu(cap.timeout.a);
> >  	old_timeout[1] = be32_to_cpu(cap.timeout.b);

-- 
Jason Gunthorpe <jgunthorpe@obsidianresearch.com>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
