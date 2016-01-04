From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v3 5/7] tpm_tis: Clean up the force=1 module parameter
Date: Mon, 4 Jan 2016 11:27:53 -0700
Message-ID: <20160104182753.GD20016@obsidianresearch.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1450376600-6970-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <20160103172650.GD4155@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160103172650.GD4155@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Martin Wilck <Martin.Wilck@ts.fujitsu.com>, Peter Huewe <peterhuewe@gmx.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jan 03, 2016 at 07:26:50PM +0200, Jarkko Sakkinen wrote:
> > @@ -695,8 +685,8 @@ static int tpm_tis_init(struct device *dev, struct tpm_info *tpm_info,
> >  #endif
> >  
> >  	chip->vendor.iobase = devm_ioremap_resource(dev, &tpm_info->res);
> > -	if (!chip->vendor.iobase)
> > -		return -EIO;
> > +	if (IS_ERR(chip->vendor.iobase))
> > +		return PTR_ERR(chip->vendor.iobase);
> 
> Isn't this a regression in the descendig patch in this series?

Oh yes, good catch.

The fix from Martin got rebased onto the wrong patch by accident.

Jason
