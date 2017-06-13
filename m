From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] char: tmp: fix potential null pointer dereference
Date: Tue, 13 Jun 2017 21:03:19 +0300
Message-ID: <20170613180319.ezszgevmgwno2v5u@intel.com>
References: <20170530215123.GA7484@embeddedgus>
 <20170531121129.f3576lq7peott6gd@intel.com>
 <20170612172544.Horde.Br2grYSXmXw3bfXZefqg8tb@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170612172544.Horde.Br2grYSXmXw3bfXZefqg8tb@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jun 12, 2017 at 05:25:44PM -0500, Gustavo A. R. Silva wrote:
> Hi Jarkko,
> 
> Please, see my comments below
> 
> Quoting Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>:
> 
> > On Tue, May 30, 2017 at 04:51:23PM -0500, Gustavo A. R. Silva wrote:
> > > NULL check at line 147: if (chip) {, implies chip might be NULL.
> > > Function dev_get_drvdata() dereference pointer chip.
> > > Move pointer priv assignment inside the IF block that checks
> > > pointer chip.
> > > 
> > > Addresses-Coverity-ID: 1397646
> > > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> > 
> > It cannot be.
> > 
> 
> I got it.
> 
> > /Jarkko
> > 
> > > ---
> > >  drivers/char/tpm/tpm_atmel.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> > > index 0d322ab..0826efd 100644
> > > --- a/drivers/char/tpm/tpm_atmel.c
> > > +++ b/drivers/char/tpm/tpm_atmel.c
> > > @@ -142,9 +142,10 @@ static struct platform_device *pdev;
> > >  static void atml_plat_remove(void)
> > >  {
> > >  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
> > > -	struct tpm_atmel_priv *priv = dev_get_drvdata(&chip->dev);
> > > +	struct tpm_atmel_priv *priv;
> > > 
> > >  	if (chip) {
> 
> So, this NULL check could be removed?

Yes, this would be right way to fix it.

/Jarkko
