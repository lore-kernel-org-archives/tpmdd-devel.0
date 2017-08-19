From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: vtpm: constify vio_device_id
Date: Sat, 19 Aug 2017 20:21:50 +0300
Message-ID: <20170819172150.sta6erdmikpfkrgv@linux.intel.com>
References: <a9ebcd668f5a7293c3805d0b6b21245f15c80212.1502989694.git.arvind.yadav.cs@gmail.com>
 <20170817191642.GF24735@obsidianresearch.com>
 <87ziaxp0v5.fsf@concordia.ellerman.id.au>
 <20170818203156.GA11385@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170818203156.GA11385@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Arvind Yadav <arvind.yadav.cs@gmail.com>, tpmdd@selhorst.net, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, ashleydlai@gmail.com, peterhuewe@gmx.de, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Aug 18, 2017 at 02:31:56PM -0600, Jason Gunthorpe wrote:
> On Fri, Aug 18, 2017 at 09:32:46PM +1000, Michael Ellerman wrote:
> 
> > >>  drivers/char/tpm/tpm_ibmvtpm.c | 2 +-
> > 
> > Who merges changes for this driver? I assume it's Jarkko?
> 
> Yes
> 
> Jason

Applied.

/Jarkko
