From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 1/5] tpm_tis: Improve reporting of IO errors
Date: Fri, 24 Jun 2016 23:21:31 +0300
Message-ID: <20160624202131.GB8399@intel.com>
References: <1466474042-110773-1-git-send-email-eswierk@skyportsystems.com>
 <1466557831-113440-1-git-send-email-eswierk@skyportsystems.com>
 <1466557831-113440-2-git-send-email-eswierk@skyportsystems.com>
 <20160624182515.GC14506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624182515.GC14506@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ed Swierk <eswierk@skyportsystems.com>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, stefanb@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

On Fri, Jun 24, 2016 at 12:25:15PM -0600, Jason Gunthorpe wrote:
> >  	expected = be32_to_cpu(*(__be32 *) (buf + 2));
> >  	if (expected > count) {
> > +		dev_err(chip->pdev, "Response too long (wanted %zd, got %d)\n",
> > +			count, expected);
> 
> This all needs to be rebased on Jarkko's tree I guess, chip->pdev is
> gone now.
> 
> http://git.infradead.org/users/jjs/linux-tpmdd.git/shortlog/refs/heads/master
> 
> Jarkko, did you miss a pull request for 4.7 or something? This is
> 4 month old stuff???

Hmm... Do you mean by 4 month old stuff the stuff that is in mainline
and not in my master branch?

I'm not sure what happened with 4.7. I merged the changes for in about
4.6-rc5. There was one issue that I fixed that Stephen reported.

At the moment linux-next seems contain the stuff that I have in my
next.

> Jason

/Jarkko
