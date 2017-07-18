From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 0/2] Run TPM2_Shutdown on system shutdown
Date: Tue, 18 Jul 2017 17:50:19 +0200
Message-ID: <20170718155019.GE30882@kroah.com>
References: <20170714195803.7035-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714195803.7035-1-joshz@google.com>
Sender: stable-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 14, 2017 at 12:57:59PM -0700, Josh Zimmerman wrote:
> This is a backport to the 4.4 stable kernel.
> 
> I had to manually apply a couple of cherry picks and resolve some merge
> conflicts, so some of this may be worth a closer look and test on Jarkko's or
> some other TPM maintainer's part
> 
> This patchset causes all devices in the tpm class to issue TPM2_Shutdown
> when the system is shutting down.
> 
> As a prerequisite, it adds a "shutdown" method to "struct class".
> 
> Backporting to 4.4 since this bug can lock users out of their TPMs.

All now queued up, thanks.

greg k-h
