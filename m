From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/3] tpm: Hold the kref during tpm_chip_find_get
Date: Sun, 14 Feb 2016 10:02:17 +0200
Message-ID: <20160214080217.GB11156@intel.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1455321871-28296-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20160214045512.GA7777@intel.com>
 <20160214065008.GC9551@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160214065008.GC9551@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Stefan Berger <stefanb@us.ibm.com>, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Feb 13, 2016 at 11:50:08PM -0700, Jason Gunthorpe wrote:
> On Sun, Feb 14, 2016 at 06:55:12AM +0200, Jarkko Sakkinen wrote:
> > On Fri, Feb 12, 2016 at 05:04:29PM -0700, Jason Gunthorpe wrote:
> > > This was missed during the struct device conversion, we
> > > need to hold a kref on the chip to make sure it isn't freed.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > 
> > I'm bit confused about this patch. What is the regression if this
> > needs
> 
> The patch is simply totally broken, the placement of the get_device is
> wrong:
> 
> > > @@ -53,6 +53,8 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
> > >  			chip = pos;
> > >  			break;
> > >  		}
> > > +
> > > +		get_device(&chip->dev);
> 
> It needs to be moved up two lines before the break, into the if
> statement.

Right.

> As for the urgency - today the tpm core relies on module locking to
> try and prevent tpm_chip_unregister from racing with stuff like the
> above. That is totally broken in modern kernels, but it is what the
> core tries to do. Within that framework the get/put are not needed
> because of the module locking.

Right, because that gives the guarantee that device has refcount of
at least one.

> The only time these additional get/put do anything is when we are
> racing with tpm_unregister, but if we are racing with unregister then
> there are much bigger problems and things will crash anyhow.
> 
> So, this patch is just a tiny step.
> 
> The revised version of this patch with the rw_sem attempts to address
> the complete race.

Got it. Yeah, I'll drop this from my next pull request. Thanks for
the explanation.

> Jason

/Jarkko
