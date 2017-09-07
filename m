From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: NACK: [PATCH] tpm_tis: unconstify array cmd_getticks
Date: Thu, 7 Sep 2017 19:21:47 +0300
Message-ID: <20170907162147.zfkoblaoswkzgvgu@linux.intel.com>
References: <20170907084245.19513-1-colin.king@canonical.com>
 <4c4d2976-3c24-528b-605d-a8dfcdd8439f@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c4d2976-3c24-528b-605d-a8dfcdd8439f@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Sep 07, 2017 at 03:02:32PM +0100, Colin Ian King wrote:
> On 07/09/17 09:42, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Remove const from cmd_getticks, fixes build warnings:
> > 
> > drivers/char/tpm/tpm_tis_core.c:469:31: warning: passing argument 2 of
> > 'tpm_tis_send_data' discards 'const' qualifier from pointer target
> > type [-Wdiscarded-qualifiers]
> >   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> >                                ^
> > drivers/char/tpm/tpm_tis_core.c:477:31: warning: passing argument 2 of
> > 'tpm_tis_send_data' discards 'const' qualifier from pointer target
> > type [-Wdiscarded-qualifiers]
> >   rc = tpm_tis_send_data(chip, cmd_getticks, len);
> >                                ^
> > Fixes: 5e35bd8e06b9 ("tpm_tis: make array cmd_getticks static const to shink object code size")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/char/tpm/tpm_tis_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 1e957e923d21..91cf38be314f 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -445,7 +445,7 @@ static int probe_itpm(struct tpm_chip *chip)
> >  {
> >  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> >  	int rc = 0;
> > -	static const u8 cmd_getticks[] = {
> > +	static u8 cmd_getticks[] = {
> >  		0x00, 0xc1, 0x00, 0x00, 0x00, 0x0a,
> >  		0x00, 0x00, 0x00, 0xf1
> >  	};
> > 
> Ignore this, seems like Arnd Bergmann has fixed this properly.

Got you! Thanks.

/Jarkko
