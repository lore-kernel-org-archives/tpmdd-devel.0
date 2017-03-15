From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: Add sysfs interface to show TPM
 hardware version
Date: Wed, 15 Mar 2017 11:25:56 -0600
Message-ID: <20170315172556.GA6399@obsidianresearch.com>
References: <1489382517-9078-1-git-send-email-Meng.Li@windriver.com>
 <29B2C361-A0C0-410E-ACCA-07AFA382A251@gmx.de>
 <9f67321b-50bd-9e6f-61f8-c29ae14f261f@linux.vnet.ibm.com>
 <074515F2-51E7-485B-B1AB-11B913CC4B46@gmx.de>
 <20170314212425.GA29359@obsidianresearch.com>
 <1489527771.19081.49.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489527771.19081.49.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Mar 14, 2017 at 02:42:51PM -0700, James Bottomley wrote:
> On Tue, 2017-03-14 at 15:24 -0600, Jason Gunthorpe wrote:
> > On Tue, Mar 14, 2017 at 07:58:37PM +0100, Peter Huewe wrote:
> > 
> > > > In practice, I suspect that a single user space application won't
> > > > support both TPMs. 
> > > Think of init scripts.
> > > Which daemon should it start?
> > 
> > Right, ideally we'd have a udev rule that triggers systemd to start
> > the userspace daemons when a TPM is detected, as other hardware does.
> > 
> > So whatever format we use has to be compatible with udev's matcher..
> 
> Technically, we have that already: my TPM2.0 detection stuff for udev
> triggers off the presence of the SUBSYSTEM=="tpmrm"  that matches any
> TPM2 device but not a 1.x one.

but long term tpmrm won't be TPM2 exclusive..

Jason
