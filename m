From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: move struct tpm_class_ops to drivers/char/tpm/tpm.h
Date: Mon, 5 Sep 2016 11:44:48 -0600
Message-ID: <20160905174448.GB14403@obsidianresearch.com>
References: <1472852886-7640-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160902221122.GA1897@obsidianresearch.com>
 <20160902223522.GA27454@intel.com>
 <20160902224531.GC1897@obsidianresearch.com>
 <20160903062221.GA2061@intel.com>
 <20160903062605.GB2061@intel.com>
 <20160904201406.GA9854@obsidianresearch.com>
 <20160905054434.GB5712@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160905054434.GB5712@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 05, 2016 at 08:44:34AM +0300, Jarkko Sakkinen wrote:
> On Sun, Sep 04, 2016 at 02:14:06PM -0600, Jason Gunthorpe wrote:
> > On Sat, Sep 03, 2016 at 09:26:05AM +0300, Jarkko Sakkinen wrote:
> > > > 
> > > > OK, how would one get the chip instance?
> > 
> > Most subsystems have a get function that returns a kref'd pointer. For
> > TPM all we really need today is a 'get_default_tpm_for_ns' kind of
> > function.
> 
> Sorry, but I have no idea what you are talking about.

Go look at how rtc or net work.

> This does not imply that these structure definitions need to be in
> include/linux/tpm.h since you are talking something that does not exist.

Well, I've been slowly pushing tpm to be more like a standard subystem
for a long time - not all the parts are there yet. A standard
subsystem will have a get/put scheme for tpm_chip.

So, yes, it does not exist, but you should be planning for it to exist
someday..

Jason
