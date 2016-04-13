From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix crash in tpm_tis deinitialization
Date: Wed, 13 Apr 2016 09:58:05 +0300
Message-ID: <20160413065805.GB6986@intel.com>
References: <1460390720-9509-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160411174037.GA371@obsidianresearch.com>
 <20160412042627.GA6608@intel.com>
 <20160412172655.GA5759@obsidianresearch.com>
 <20160413061651.GA6986@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413061651.GA6986@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Apr 13, 2016 at 09:16:51AM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 12, 2016 at 11:26:55AM -0600, Jason Gunthorpe wrote:
> > On Tue, Apr 12, 2016 at 07:26:27AM +0300, Jarkko Sakkinen wrote:
> > > > This needs to be after ops is fenced, something like this.
> > > 
> > > I would appreciate a supporting argument.
> > > 
> > > I guess the argument here is that this will prevent user space from
> > > issuing TPM commands after the shutdown command has been sent?
> > 
> > It prevents everything including the kernel from issuing a command
>                          ^^^^^^^^^^^^^^^^^^^^
> 
> That lock is not used to exclude kernel access. Read lock is only taken
> for the user space device in tpm-dev.c.

My bad. For the in-kernel API it is taken through tpm_find_get().

I'll update the fix.

/Jarkko
