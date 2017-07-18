From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v1 4/4] tpm: Issue a TPM2_Shutdown for TPM2 devices.
Date: Tue, 18 Jul 2017 18:29:05 +0200
Message-ID: <20170718162905.GA4809@kroah.com>
References: <20170714195803.7035-1-joshz@google.com>
 <20170714195803.7035-5-joshz@google.com>
 <20170718154942.GD30882@kroah.com>
 <CAHSjozBE-=aCZoBvuHanPWYQKhY3Lj5YTNnnA65Q-GgZ2y1iSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozBE-=aCZoBvuHanPWYQKhY3Lj5YTNnnA65Q-GgZ2y1iSQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jul 18, 2017 at 09:11:49AM -0700, Josh Zimmerman wrote:
> On Tue, Jul 18, 2017 at 8:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jul 14, 2017 at 12:58:03PM -0700, Josh Zimmerman wrote:
> >> Backport of d1bd4a792d3961a04e6154118816b00167aad91a upstream.
> >>
> >> If a TPM2 loses power without a TPM2_Shutdown command being issued (a
> >> "disorderly reboot"), it may lose some state that has yet to be
> >> persisted to NVRam, and will increment the DA counter. After the DA
> >> counter gets sufficiently large, the TPM will lock the user out.
> >>
> >> NOTE: This only changes behavior on TPM2 devices. Since TPM1 uses sysfs,
> >> and sysfs relies on implicit locking on chip->ops, it is not safe to
> >> allow this code to run in TPM1, or to add sysfs support to TPM2, until
> >> that locking is made explicit.
> >> ---
> >>  drivers/char/tpm/tpm-chip.c  | 36 ++++++++++++++++++++++++++++++++++++
> >>  drivers/char/tpm/tpm-sysfs.c |  7 +++++++
> >>  2 files changed, 43 insertions(+)
> >>
> >
> > Again no signed-off-by :(
> 
> Oops, sorry about that.
> 
> Did you pull in the two cherry-picks as well? They're needed for these
> two to build and merge cleanly.
> 
> I can send a v2 if you need with a corrected signed-off-by and correct
> number of patches in the cover letter.

I should have them all now, and you should have gotten emails about
it...

thanks,

greg k-h
