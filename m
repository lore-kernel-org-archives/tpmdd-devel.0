From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 15:48:36 +0300
Message-ID: <20161003124836.GE9990@intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 03, 2016 at 07:05:48AM +0000, Winkler, Tomas wrote:
> 
> > On Sun, Oct 02, 2016 at 01:24:55PM +0300, Jarkko Sakkinen wrote:
> > > On Sun, Oct 02, 2016 at 01:17:55PM +0300, Jarkko Sakkinen wrote:
> > > > On Sun, Oct 02, 2016 at 10:39:31AM +0300, Tomas Winkler wrote:
> > > > > In tpm_del_char_device device_del is called prior to tpm2_shutdown
> > > > > where it is still used.
> > > > >
> > > > > Fortunately, so far chip->dev was used only for printouts int
> > > > > tpm2_shutdown flow, hence system didn't crash. But with the
> > > > > introduction of runtime power management it will result in
> > > > > shutting down the parent device while it still in use.
> > > > >
> > > > > Fixes: 20e0152393b41 ("tpm: fix crash in tpm_tis
> > > > > deinitialization")
> > > > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > >
> > > > Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > >
> > > Applied.
> > 
> > This patch is wrong, I though the comments were clear. All entry points to find
> > the device must be deleted before we commit to shutting down the device.
> > 
> > You need to figure out some other way to solve your problem.
> 
> Please  be more specific regarding flows you think will be wrong  with
> this patch, you must agree that the current code is broken even w/o
> runtime pm.

Make the driver uncallable first. The worst race that can happen is that
open("/dev/tpm0", ...) returns -EPIPE. I do not consider this fatal at
all.

> Thanks
> Tomas

/Jarkko
