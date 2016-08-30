From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6] tpm: fix a race condition in tpm2_unseal_trusted()
Date: Tue, 30 Aug 2016 21:41:41 +0300
Message-ID: <20160830184141.GA7031@intel.com>
References: <1472511066-20339-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20160830180701.GA7586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160830180701.GA7586@obsidianresearch.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, stable@vger.kernel.org, Marcel Selhorst <tpmdd@selhorst.net>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 30, 2016 at 12:07:01PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2016 at 01:51:06AM +0300, Jarkko Sakkinen wrote:
> > Unseal and load operations should be done as an atomic operation. This
> > commit introduces unlocked tpm_transmit() so that tpm2_unseal_trusted()
> > can do the locking by itself.
> > 
> > v2: Introduced an unlocked unseal operation instead of changing locking
> >     strategy in order to make less intrusive bug fix and thus more
> >     backportable.
> > 
> > v3: Have also separate __tpm_transmit() that takes 'flags' in order to
> >     better localize the bug fix and make it easier to backport.
> > 
> > v4: Cleaned up the control flow in tpm2_unseal_trusted. Added the
> >     missing 'Fixes' line.
> > 
> > v5: Previous versions did not set the enum to any value, so it was set
> >     to zero. Changed enum to TPM_TRANSMIT_UNLOCKED because it is
> >     guaranteed to catch such situation. With change the common case
> >     adds so little clutter that the wrappers do not make sense anymore.
> > 
> > v6: Added flags parameter to internal TPM command wrappers to have
> >     an expected default behavior and documented them.
> 
> Yeah, this is nice.
> 
> BTW, do not put the vX: stuff into the commit message, and it would be
> best to include it after the diffstat the patch email

I was going to strip it but including it after the diffstat sounds like
a great idea.

> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Jason

/Jarkko
