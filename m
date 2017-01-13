From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Fri, 13 Jan 2017 11:01:10 -0700
Message-ID: <20170113180110.GA31397@obsidianresearch.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
 <20170112205628.qh3yf2jcargtw6qv@intel.com>
 <20170113172537.GA31125@obsidianresearch.com>
 <1484329208.2527.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484329208.2527.18.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 13, 2017 at 09:40:08AM -0800, James Bottomley wrote:
> On Fri, 2017-01-13 at 10:25 -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 12, 2017 at 10:56:28PM +0200, Jarkko Sakkinen wrote:
> > 
> > > >  dev_t tpm_devt;
> > > 
> > > But they should have different major device numbers.
> > 
> > major/minors don't really matter these days since they are dynamic
> 
> Right, although we have this weird piece of code:
> 
> 
> 	if (chip->dev_num == 0)
> 		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
> 	else
> 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
> 
> So the first TPM device gets the MISC_MAJOR with TPM_MINOR and the rest
> get the dynamic major/minor.  It means when you do an ls on a complex
> system you get something like:

The TPM has always used a static major/minor for tpm0 and dynamic for
the following. Originally this used a misc_device and did:

        } else if (chip->dev_num == 0)
                chip->vendor.miscdev.minor = TPM_MINOR;
        else
                chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;

When we moved to struct device the !0 tpms got a dynamic major as
well.

I don't really know what the broad kernel feeling is on historical
major/minor stability - this was mainly continuing what had always
been done in this code for pre-udev userspace compatibility.

Does it harm anything?

Jason
