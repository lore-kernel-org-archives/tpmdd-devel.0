From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Sun, 14 Feb 2016 07:24:14 +0200
Message-ID: <20160214052414.GB8065@intel.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
 <20160213011130.GA2547@obsidianresearch.com>
 <201602130128.u1D1S2Xn006955@d01av05.pok.ibm.com>
 <20160213033320.GA27869@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160213033320.GA27869@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Stefan Berger <stefanb@us.ibm.com>, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 12, 2016 at 08:33:20PM -0700, Jason Gunthorpe wrote:
> On Fri, Feb 12, 2016 at 08:31:21PM -0500, Stefan Berger wrote:
> > > I'll send you something else that might work for vtpm...'
> > 
> > The vtpm driver will introduce chip->priv, which will point to vtpm_dev. For
> > this reason we need to hold a reference to the vtpm_dev->dev in the
> > front end.
> 
> This should take care of it for all drivers including vtpm.
> 
> https://github.com/jgunthorpe/linux/commits/for-jarkko
> 
> At the very least this turns silent use after free into a null pointer
> oops.
> 
> We should also discuss if we want to continue to have the driver
> module locked while /dev/tpmX is open, that is no longer needed for
> corectness.

I'm happy the patch that was sent before although I didn't give it
Reviewed-by because it had couple of style errors. If those two
style errors are the *only* issues I can fix up them.

Unless the differences are trivial (like a missing return value or
couple of minor style errors something very obvious) for me to fixup I'd
hope to re-review the code.

I'm not trying to be difficult here. For small errors I can amend
the commits but it seems that there was something more non-trival
done

Other than the first patch (for which I'm still waiting a clear
explanation why it is wrong), these are not going to 4.5 anyway so
there's lots time to things the long way.

/Jarkko
