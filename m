From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: check for TPM_CHIP_FLAG_TPM2 before calling
 tpm2_shutdown()
Date: Mon, 25 Apr 2016 21:48:45 +0300
Message-ID: <20160425184845.GA15368@intel.com>
References: <1461576090-24813-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160425175720.GB7675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160425175720.GB7675@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, linux-security-module@vger.kernel.org, Stefan Berger <stefanb@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 25, 2016 at 11:57:20AM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 25, 2016 at 12:21:30PM +0300, Jarkko Sakkinen wrote:
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Reported-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
> >  drivers/char/tpm/tpm-chip.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Fixes: 20e0152393b41 ("tpm: fix crash in tpm_tis deinitialization")

Thanks and thanks for the fixes line (forgot to add it) :)

/Jarkko

> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index a12db8e..1965dc7 100644
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -270,7 +270,8 @@ static void tpm_del_char_device(struct tpm_chip *chip)
> >  
> >  	/* Make the driver uncallable. */
> >  	down_write(&chip->ops_sem);
> > -	tpm2_shutdown(chip, TPM2_SU_CLEAR);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		tpm2_shutdown(chip, TPM2_SU_CLEAR);
> >  	chip->ops = NULL;
> >  	up_write(&chip->ops_sem);
> >  }
> 
