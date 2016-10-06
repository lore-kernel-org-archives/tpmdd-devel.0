From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Thu, 6 Oct 2016 14:23:57 +0300
Message-ID: <20161006112357.GA10533@intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <20161005100234.GA20851@intel.com>
 <20161005162741.GA18636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161005162741.GA18636@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 05, 2016 at 10:27:41AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 05, 2016 at 01:02:34PM +0300, Jarkko Sakkinen wrote:
> 
> > I'll repeat my question: what worse can happen than returning -EPIPE?  I
> > though the whole rw lock scheme was introduced just for this purpose.
> 
> I thought I explained this, if device_del is moved after ops = null
> then if sysfs looses the race it will oops the kernel. device_del hard
> fences sysfs.

Sorry, I missed that comment somehow. Looking at the code it is like
that.

I think that they should be fenced then for the sake of consistency.
I do not see why sysfs code is privileged not to do fencing while other
peers have to do it.

/Jarkko
