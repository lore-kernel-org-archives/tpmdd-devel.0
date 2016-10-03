From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 10:00:08 -0600
Message-ID: <20161003160008.GE5722@obsidianresearch.com>
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
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Oct 03, 2016 at 07:05:48AM +0000, Winkler, Tomas wrote:

> > This patch is wrong, I though the comments were clear. All entry points to find
> > the device must be deleted before we commit to shutting down the device.
> > 
> > You need to figure out some other way to solve your problem.
> 
> Please be more specific regarding flows you think will be wrong with
> this patch, you must agree that the current code is broken even w/o
> runtime pm.

No, I don't agree. Accessing dev->name is OK after the device_del.

What devicde_del does is fence off all sorts of ways to access the
device, eg sysfs files, bus registrations, etc, etc. That absolutely
must be done before calling tpm_suspend.

Jason
