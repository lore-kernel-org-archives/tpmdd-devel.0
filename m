From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Mon, 16 Jan 2017 09:28:17 -0800
Message-ID: <1484587697.2540.39.camel@HansenPartnership.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
         <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
         <20170116161413.GA19979@obsidianresearch.com>
         <20170116172443.kaakeyahnril55r3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170116172443.kaakeyahnril55r3@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-16 at 19:24 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 16, 2017 at 09:14:13AM -0700, Jason Gunthorpe wrote:
> > On Mon, Jan 16, 2017 at 03:12:11PM +0200, Jarkko Sakkinen wrote:
> > 
> > > @@ -199,7 +227,9 @@ struct tpm_chip *tpm_chip_alloc(struct device
> > > *pdev,
> > >  	return chip;
> > >  
> > >  out:
> > > +	put_device(&chip->devrm);
> > >  	put_device(&chip->dev);
> > > +	put_device(&chip->devrm);
> > >  	return ERR_PTR(rc);
> > >  }
> > 
> > Something has gone wrong here..
> 
> Not a big surprise. There were a bunch of these small patches
> that I had to squash. Thanks for spotting this.
> 
> Funny that I didn't experiece any issues when I run my smoke
> tests.

It's the error path in tpm_chip_alloc: it's incredibly hard to trigger,
which is probably why your tests didn't see it.  You basically either
have to be out of kernel memory or out of TPM device numbers.

James
