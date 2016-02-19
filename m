From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm_crb: fix bad name pointer usage with
 struct resource
Date: Fri, 19 Feb 2016 17:06:06 +0200
Message-ID: <20160219150606.GB7474@intel.com>
References: <1455668874-13261-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160217045219.GA26086@obsidianresearch.com>
 <20160217093623.GA9831@intel.com>
 <20160217142016.GA6951@intel.com>
 <20160218173140.GA5899@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160218173140.GA5899@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 18, 2016 at 10:31:40AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 17, 2016 at 04:20:16PM +0200, Jarkko Sakkinen wrote:
> > Maybe for the release the safest bet would be anyway explicitly not
> > use the name field? That's the safest bet given the release time
> > frame.
> 
> nulling it in the acpi paths of tis and crb, if you know those are broken
> seems good for a rc.
> 
> I haven't looked at what other options there are, I suspect it needs
> strdup due to how the drivers are working with acpi..

Can you quickly check the two top-most patches:

https://github.com/jsakkine/linux-tpmdd/commits/master

This is for 4.5 release.

> Jason

/Jarkko
