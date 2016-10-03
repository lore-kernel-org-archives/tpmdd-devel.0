From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH] tpm: don't destroy chip device prematurely
Date: Mon, 3 Oct 2016 17:16:18 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B542F474C@hasmsx108.ger.corp.intel.com>
References: <1475393971-12715-1-git-send-email-tomas.winkler@intel.com>
 <20161002101755.GA25844@intel.com> <20161002102455.GA27464@intel.com>
 <20161002212126.GA25872@obsidianresearch.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542F466B@hasmsx108.ger.corp.intel.com>
 <20161003160008.GE5722@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161003160008.GE5722@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

 
> On Mon, Oct 03, 2016 at 07:05:48AM +0000, Winkler, Tomas wrote:
> 
> > > This patch is wrong, I though the comments were clear. All entry
> > > points to find the device must be deleted before we commit to shutting
> down the device.
> > >
> > > You need to figure out some other way to solve your problem.
> >
> > Please be more specific regarding flows you think will be wrong with
> > this patch, you must agree that the current code is broken even w/o
> > runtime pm.
> 
> No, I don't agree. Accessing dev->name is OK after the device_del.

But you cannot assume that just dev->name is accessed and and runtime_pm breaks this assumption.. 
>
> 
> What devicde_del does is fence off all sorts of ways to access the device, eg
> sysfs files, bus registrations, etc, etc. That absolutely must be done before
> calling tpm_suspend.


But tpm2_shutdown is acceded via tpm_chip , we cannot call device_del before, this is just wrong from the Linux device mode perspective, we have to use other means to close the access to the device.

Thanks
Tomas
