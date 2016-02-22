From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [GIT PULL] remaining tpmdd fixes for Linux 4.5
Date: Mon, 22 Feb 2016 21:08:28 +0200
Message-ID: <20160222190828.GA32231@intel.com>
References: <20160220081705.GA12981@intel.com>
 <alpine.LRH.2.20.1602221255210.4918@namei.org>
 <20160222145023.GA28365@intel.com>
 <20160222175245.GA22828@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160222175245.GA22828@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, Wilck@intel.com, Martin <martin.wilck@ts.fujitsu.com>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Feb 22, 2016 at 10:52:45AM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 22, 2016 at 04:50:23PM +0200, Jarkko Sakkinen wrote:
> 
> > I already pushed a fix to my master for this issue:
> > 
> > https://github.com/jsakkine/linux-tpmdd/commit/6386544ad7bceb3d0248b85da29d4d99eebe9161
> 
> The goal is to reduce the number of #ifdef'd code segments so we have
> fewer problems in future with a large .config test matrix.
> 
> I'd rather see a __maybe_unused annotation instead.

Agreed that it's a better form but at this point it's probably revert
the breaking change and move to that later on. Otherwise, I don't see
reason not to include the patch that you authored to the release. I've
used it in my test kernels for quite some time now and it has worked
without issues.

I sent my fix for review now.

> Jason

/Jarkko
