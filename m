From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Thu, 6 Oct 2016 10:22:45 -0600
Message-ID: <20161006162245.GF1224@obsidianresearch.com>
References: <20161002101755.GA25844@intel.com>
 <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003124836.GE9990@intel.com>
 <20161004051946.GA10572@intel.com>
 <20161004164738.GA17149@obsidianresearch.com>
 <20161005100234.GA20851@intel.com>
 <20161005162741.GA18636@obsidianresearch.com>
 <20161006112357.GA10533@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161006112357.GA10533@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 06, 2016 at 02:23:57PM +0300, Jarkko Sakkinen wrote:

> I think that they should be fenced then for the sake of consistency.
> I do not see why sysfs code is privileged not to do fencing while other
> peers have to do it.

Certainly the locking could be changed, but it would be nice to have a
reason other than aesthetics.

sysfs is not unique, we also do not grab the rwlock lock during any
commands executed as part of probe. There are basically two locking
regimes - stuff that is proven to by synchronous with probe/remove
(sysfs, probe cmds) and everything else (kapi, cdev)

Further, the current sysfs implementation is nice and sane: the file
accesses cannot fail with ENODEV. That is a useful concrete property
and I don't think we should change it without a good reason.

Jason
