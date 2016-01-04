From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v3 7/7] tpm_crb: Use devm_ioremap_resource
Date: Mon, 4 Jan 2016 21:43:06 +0200
Message-ID: <20160104194306.GA19608@intel.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1450376600-6970-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <20160103173213.GF4155@intel.com>
 <20160104183025.GE20016@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160104183025.GE20016@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Martin Wilck <Martin.Wilck@ts.fujitsu.com>, Peter Huewe <peterhuewe@gmx.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 04, 2016 at 11:30:25AM -0700, Jason Gunthorpe wrote:
> On Sun, Jan 03, 2016 at 07:32:13PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Dec 17, 2015 at 11:23:20AM -0700, Jason Gunthorpe wrote:
> > > To support the force mode in tpm_tis we need to use resource locking
> > > in tpm_crb as well, via devm_ioremap_resource.
> > > 
> > > The light restructuring better aligns crb and tis and makes it easier
> > > to see the that new changes make sense.
> > 
> > This patch mixes two items: restructing and actual change.
> 
> Do you have a suggestion how to split this?
> 
> Everything is done for a reason, it isn't just churn for the sake of
> churn.

I'll appy this to master.

> Jason

/Jarkko
