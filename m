From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 3/3] tpm: Get rid of
 TPM_CHIP_FLAG_REGISTERED
Date: Fri, 4 Nov 2016 01:22:30 -0600
Message-ID: <20161104072230.bcqwafv2a55k3cni@intel.com>
References: <1477520926-32594-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1477520926-32594-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161102103303.tgodrsbo3ptzwkki@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102103303.tgodrsbo3ptzwkki@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Nov 02, 2016 at 04:33:03AM -0600, Jarkko Sakkinen wrote:
> On Wed, Oct 26, 2016 at 04:28:46PM -0600, Jason Gunthorpe wrote:
> > This is no longer necessary, all calls to tpm_chip_unregister happen
> > in remove() callbacks.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> /Jarkko

Applied.

/Jarkko

> 
> > ---
> >  drivers/char/tpm/tpm-chip.c | 5 -----
> >  drivers/char/tpm/tpm.h      | 1 -
> >  2 files changed, 6 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index e5950131bd90..836f056f7d27 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -375,8 +375,6 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  		return rc;
> >  	}
> >  
> > -	chip->flags |= TPM_CHIP_FLAG_REGISTERED;
> > -
> >  	rc = tpm_add_legacy_sysfs(chip);
> >  	if (rc) {
> >  		tpm_chip_unregister(chip);
> > @@ -402,9 +400,6 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
> >   */
> >  void tpm_chip_unregister(struct tpm_chip *chip)
> >  {
> > -	if (!(chip->flags & TPM_CHIP_FLAG_REGISTERED))
> > -		return;
> > -
> >  	tpm_del_legacy_sysfs(chip);
> >  
> >  	tpm1_chip_unregister(chip);
> > diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> > index 2611459271e5..79ce937ec557 100644
> > --- a/drivers/char/tpm/tpm.h
> > +++ b/drivers/char/tpm/tpm.h
> > @@ -139,7 +139,6 @@ enum tpm2_startup_types {
> >  #define TPM_PPI_VERSION_LEN		3
> >  
> >  enum tpm_chip_flags {
> > -	TPM_CHIP_FLAG_REGISTERED	= BIT(0),
> >  	TPM_CHIP_FLAG_TPM2		= BIT(1),
> >  	TPM_CHIP_FLAG_IRQ		= BIT(2),
> >  	TPM_CHIP_FLAG_VIRTUAL		= BIT(3),
> > -- 
> > 2.1.4
> > 
> 
> ------------------------------------------------------------------------------
> Developer Access Program for Intel Xeon Phi Processors
> Access to Intel Xeon Phi processor-based developer platforms.
> With one year of Intel Parallel Studio XE.
> Training and support from Colfax.
> Order your platform today. http://sdm.link/xeonphi
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
