From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v2 5/5] tpm2: expose resource manager
 via a device link /dev/tpms<n>
Date: Mon, 16 Jan 2017 11:45:59 +0200
Message-ID: <20170116094559.jsw7ffrozs42ubue@intel.com>
References: <20170112174612.9314-1-jarkko.sakkinen@linux.intel.com>
 <20170112174612.9314-6-jarkko.sakkinen@linux.intel.com>
 <20170112205628.qh3yf2jcargtw6qv@intel.com>
 <20170113172537.GA31125@obsidianresearch.com>
 <1484329208.2527.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484329208.2527.18.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
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
> 
> crw------- 1 root root  10,   224 Jan 13 06:21 /dev/tpm0
> crw------- 1 root root 246,     1 Jan 13 09:38 /dev/tpm1
> crw-rw-rw- 1 root root 246, 65536 Jan 13 06:21 /dev/tpms0
> crw-rw-rw- 1 root root 246, 65537 Jan 13 09:38 /dev/tpms1
> 
> Perhaps it's time just to junk the reserved misc minor?

+1 

And Jason is correct about major numbers. I still am puzzled whether
these should share the device class and devt with raw /dev/tpm0.

/Jarkko
