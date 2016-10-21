From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] char/tpm: Check return code of wait_for_tpm_stat
Date: Fri, 21 Oct 2016 18:35:48 +0300
Message-ID: <20161021153548.rfdcbetqxg7srdgs@intel.com>
References: <1476187261-29027-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20161011171313.GD6881@obsidianresearch.com>
 <9174B547-9CD1-4F1B-A2A7-38B9A6AA3B33@gmx.de>
 <20161012121606.GA11604@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161012121606.GA11604@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Oct 12, 2016 at 03:16:06PM +0300, Jarkko Sakkinen wrote:
> On Tue, Oct 11, 2016 at 08:01:09PM +0200, Peter Huewe wrote:
> > 
> > 
> > Hi
> > Am 11. Oktober 2016 19:13:13 MESZ, schrieb Jason Gunthorpe <jgunthorpe@obsidianresearch.com>:
> > >On Tue, Oct 11, 2016 at 03:01:01PM +0300, Jarkko Sakkinen wrote:
> > >> From: Peter Huewe <peterhuewe@gmx.de>
> > >> 
> > >> In some weird cases it might be possible that the TPM does not set
> > >> STS.VALID within the given timeout time (or ever) but sets STS.EXPECT
> > >> (STS=0x0C) In this case the driver gets stuck in the while loop of
> > >> tpm_tis_send_data and loops endlessly.
> > >
> > >Doesn't that exchange mean the TPM has lost synchronization with the
> > >driver? Or maybe it crashed executing a command or something..
> > 
> > I saw that in the field on quite a few (similar) systems with our lpc tpms - so it affects end users.
> > Yes it is caused by some desynchronization or something similar.
> > 
> > If you manually send a commandReady by mmaping the memory region you can un-stuck the driver and the situation was never seen again on that system.
> > 
> > The exact reason how this happens is yet unknown, but the driver should definitely not be stuck in an endless loop (which zombies the application too) in that case but bail out as defined in the TIS protocol. The next access sends the cr which cures the unsynchronization.
> 
> Even as a sanity check return codes should be checked so in
> any case I leaned towards applying this patch. It makes the
> driver more robust.

I applied this.

/Jarkko
