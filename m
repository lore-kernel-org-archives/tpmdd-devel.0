From: Josh Zimmerman <joshz@google.com>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Mon, 15 May 2017 10:39:08 -0700
Message-ID: <CAHSjozBLBUpSzxrRsfnO49Thf9__MHdOmUdsX+5ST55=T2BWLA@mail.gmail.com>
References: <20170515173438.13420-1-joshz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170515173438.13420-1-joshz@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, Josh Zimmerman <joshz@google.com>
List-Id: tpmdd-devel@lists.sourceforge.net

(Continuing thread from patch v1)
> > On Sat, May 13, 2017 at 12:43:11PM +0000, Winkler, Tomas wrote:
> > > > The TPM class has some common shutdown code that must be executed
> > > > for all drivers. This adds some needed functionality for that
> > >
> > > The issue with this is, that on some platforms the only storage can be
> > > eMMC and TPM is using it,. It has to be ensured that the storage
> > > device won't go down before TPM2_shutdown is called.  And there is no
> > > direct device hierarchy to ensure an orderly shutdown.
> >
> > Something will have to use the new device links stuff to define that
> > dependency, but that seems unrelated to this patch?
>
>
> Yep, it's not directly related to this specific patch, this is more relevant particularly to TPM2_shutdown.

Jason, do you want me to do that in my patch on the tpmdd-devel list?
If so, mind giving me a documentation pointer or two? I'm not familiar
with this area.

Thanks,
Josh
