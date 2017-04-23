From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [backport v4.9] tpm_tis: use default timeout value
 if chip reports it as zero
Date: Sun, 23 Apr 2017 15:14:00 +0300
Message-ID: <20170423121400.ki7vuvn3xwtiaocr@intel.com>
References: <20170415152622.14451-1-user@jsakkine-mobl1>
 <20170415205032.GA17774@kroah.com>
 <79399e000218504619c21ce6729c8334@molgen.mpg.de>
 <20170419152908.vq55so4mtqyp6sc7@intel.com>
 <20170419153807.GB10969@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170419153807.GB10969@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 19, 2017 at 05:38:07PM +0200, Greg KH wrote:
> On Wed, Apr 19, 2017 at 06:29:08PM +0300, Jarkko Sakkinen wrote:
> > On Sun, Apr 16, 2017 at 09:14:29PM +0200, Paul Menzel wrote:
> > > Dear Greg,
> > > 
> > > 
> > > On 2017-04-15 22:50, Greg KH wrote:
> > > > On Sat, Apr 15, 2017 at 06:26:22PM +0300, Jarkko Sakkinen wrote:
> > > > > From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
> > > > > 
> > > > > Since commit 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for
> > > > > TPM access") Atmel 3203 TPM on ThinkPad X61S (TPM firmware version
> > > > > 13.9)
> > > > > no longer works.  The initialization proceeds fine until we get and
> > > > > start using chip-reported timeouts - and the chip reports C and D
> > > > > timeouts of zero.
> > > > > 
> > > > > It turns out that until commit 8e54caf407b98e ("tpm: Provide a generic
> > > > > means to override the chip returned timeouts") we had actually let
> > > > > default timeout values remain in this case, so let's bring back this
> > > > > behavior to make chips like Atmel 3203 work again.
> > > > > 
> > > > > Use a common code that was introduced by that commit so a warning is
> > > > > printed in this case and /sys/class/tpm/tpm*/timeouts correctly says
> > > > > the
> > > > > timeouts aren't chip-original.
> > > > > 
> > > > > Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM
> > > > > access")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> > > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > 
> > > > What is the git commit id for this patch in Linus's tree?
> > > 
> > > The git commit hash is 1d70fe9d9c3a4c627f9757cbba5d628687b121c1.
> > > 
> > > 
> > > Kind regards,
> > > 
> > > Paul
> > 
> > Do you want me to revise the backport? Thanks.
> 
> I can't take it as-is, so yes, if you want it applied, it needs to be
> fixed :)
> 
> thanks,
> 
> greg k-h

I will send it asap. Thanks.

/Jarkko
