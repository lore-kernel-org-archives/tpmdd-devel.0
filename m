From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 0/2] Run TPM2_Shutdown on system shutdown
Date: Thu, 13 Jul 2017 14:23:04 +0200
Message-ID: <20170713122304.GA18527@kroah.com>
References: <20170713004121.21750-1-joshz@google.com>
 <CAHSjozAxEnA1xSBi5fNgsVpJpbHMabKaq7GKZQn8x8iEOdAWjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozAxEnA1xSBi5fNgsVpJpbHMabKaq7GKZQn8x8iEOdAWjg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jul 12, 2017 at 07:13:40PM -0700, Josh Zimmerman wrote:
> On Wed, Jul 12, 2017 at 5:41 PM, Josh Zimmerman <joshz@google.com> wrote:
> > This patchset causes all devices in the tpm class to issue TPM2_Shutdown
> > when the system is shutting down.
> >
> > As a prerequisite, it adds a "shutdown" method to "struct class".
> >
> > Backporting to 4.9 since this bug can lock users out of their TPMs.
> >
> > Backport of f77af1516584 'Add "shutdown" to "struct class".' and
> > d1bd4a792d39 'tpm: Issue a TPM2_Shutdown for TPM2 devices.'
> >
> >  drivers/base/core.c          |  6 +++++-
> >  drivers/char/tpm/tpm-chip.c  | 36 ++++++++++++++++++++++++++++++++++++
> >  drivers/char/tpm/tpm-sysfs.c |  5 +++++
> >  include/linux/device.h       |  2 ++
> >  4 files changed, 48 insertions(+), 1 deletion(-)
> 
> 
> In case this wasn't clear, this backport was tested on 4.9. I have not
> yet tested on 4.4. I'm intending to test and send another patch for
> that later this week (ideally tomorrow).

Thanks, both now queued up in the 4.9-stable queue.

greg k-h
