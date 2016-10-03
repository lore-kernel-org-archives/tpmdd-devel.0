From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 10:03:08 -0600
Message-ID: <20161003160308.GA6801@obsidianresearch.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F46C1@hasmsx108.ger.corp.intel.com>
 <20161003124225.GD9990@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161003124225.GD9990@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 03, 2016 at 03:42:25PM +0300, Jarkko Sakkinen wrote:

> > I've looked to the registration code and it indeed has few more issues

?

> > Maybe TPM_CHIP_FLAG_REGISTERED can be used for sealing the access
> > to the device during deregistration, current usage is void.

This is done via chip->ops = NULL and the rwlock scheme.
 
> Good catch BTW. This flag has gone quite obsolote.

I think all the drivers have been updated at this point so we can
probably get rid of it entirely.

Jason
