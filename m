From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Thu, 25 May 2017 18:41:18 +0200
Message-ID: <20170525164118.GA28995@kroah.com>
References: <20170515173438.13420-1-joshz@google.com>
 <20170525130930.GA16244@kroah.com>
 <CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA@mail.gmail.com>
 <20170525160925.GA25318@kroah.com>
 <CAHSjozC4N7ShgCqNPbvycrhe17e3NKVik92Gy0vAHqBvBm-oAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHSjozC4N7ShgCqNPbvycrhe17e3NKVik92Gy0vAHqBvBm-oAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Zimmerman <joshz@google.com>
Cc: linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 09:24:30AM -0700, Josh Zimmerman wrote:
> On Thu, May 25, 2017 at 9:09 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, May 25, 2017 at 08:40:28AM -0700, Josh Zimmerman wrote:
> >> Thanks, Greg.
> >>
> >> Greg, Jarkko: Do either of you you have any objections to me
> >> backporting these changes to 4.4 and 4.9? I'd like to make sure that
> >> at least the couple most recent LTS kernels have this patch.
> >
> > Why?  What bug does this solve?
> If a TPM2 device has power removed without a TPM2_Shutdown being
> issued, it will increment its "dictionary attack" counter. After that
> counter reaches a certain value, the TPM2 device will lock the user
> out. Adding the shutdown callback allows the TPM kernel driver to send
> TPM2_Shutdown to all TPM2 devices.

Is all of that in the tpm patch description?  If so, great, if not,
please add it.

> > If it meets the rules of
> > Documentation/stable_kernel_rules.txt (or whereever that file moved to),
> > that's fine with me.
> Documentation/process/stable-kernel-rules.rst, right? To comply with
> option 1 referred to there (Adding the appropriate "Cc:" to the
> description), should I send a new patch email or just reply to this
> one and quote the relevant part? (I don't believe the document
> specifies.)

You (or who ever applies these patches) needs to add the cc: stable tag
to them.  I suggest resend these, as a patch series, with that in it, so
that it all makes more sense and the tpm maintainer has an easy job of
it.

thanks,

greg k-h
