From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Thu, 26 Jan 2017 11:05:06 -0700
Message-ID: <20170126180506.GA20330@obsidianresearch.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
 <20170124001918.GA29735@obsidianresearch.com>
 <20170124143600.siyhblj67qaatewi@intel.com>
 <20170124190707.GA9899@obsidianresearch.com>
 <20170125202137.7bsv7lptvpzl2fjz@intel.com>
 <20170125221136.GA713@obsidianresearch.com>
 <20170126111403.ql6np2qulifxxw3p@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170126111403.ql6np2qulifxxw3p@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 26, 2017 at 01:14:03PM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 25, 2017 at 03:11:36PM -0700, Jason Gunthorpe wrote:
> > On Wed, Jan 25, 2017 at 10:21:37PM +0200, Jarkko Sakkinen wrote:
> > 
> > > There should be anyway someway to limit what commands can be sent but
> > > I understand your point.
> > 
> > What is the filter for?
> > 
> > James and I talked about a filter to create a safer cdev for use by
> > users. However tpms0 cannot be that 'safer' cdev - it is now the 'all
> > access' path.
> 
> What do you mean by "safer cdev"?

'safer cdev' is this concept of limiting privileges you are describing
below.

> > I also suggested a filter in the kernel to ensure that the RM is only
> > passing commands it actually knows it handles properly. eg you would
> > filter out list handles. That is hardwired into the kernel, and does
> > not ge to be configured by user space.
>
> In many cases you would want to limit the set of operations that client
> can use.  For example, not every client needs NV operations. In general
> you might want to have mechanism for limiting privileges. I haven't
> really considered this from the perspective that you've been discussing
> but more from the "principle of least privilege" perspective.

What does that mean? The kernel needs to provide an unrestricted
access path to the TPM and the RM - typically for use by root. I don't
think there is any debate on this point.

The kernel *could* provide restricted access to the TPM and the RM -
typically for use by a user.

These are *different* things and they should not both exist at once on
/dev/tpms0 (that is not the unix model).

IMHO this patch series should focus entirely on the unrestricted
access path. Otherwise the debate is too large and complex.

> Are you suggesting that in such cases you could just create daemon for
> proxying the traffic (when you want to limit privileges)?

If a daemon is to be involved in userspace then yes, it should proxy
the traffic and not use fd passing. That is easier and more normal.

Eg a daemon that creates /run/tpm.socket could present the usual
read/write interface and instantly provide the compatability that
James was talking about.

I would *like* to see a daemon-less solution, but to me that means a
kernel cdev that defaults to 0666 permissions. Until a patch comes
along that does that I propose people experiment using a user
space proxy... Mostly out of fear that we create a security issue in
the kernel by rushing.

> You could just make that daemon a whole lot simpler if it just needs
> to pass the file desriptor to the client after defining the set of
> operations that the client can use.

That really isn't simpler :)

Proxying + filtering is very easy as long as there is a 1:1
relationship of client and kernel RM fd. Doing all the filtering in
userspace is *clearly* better than trying to split it into the kernel.

fd passing is pretty arcane and doesn't bring any benifit here, you
are trying to be too clever.

> This is a high priority decision to make because it's hard to apply
> principle of least privilege (with everything disallowed defaultts)
> if it is not done in the first place.

This is why I argued these patches should use ioctl and defer a new
cdev until we sort the question of a restricted kernel interface. tpm0
is already the unrestricted access path to the TPM, it makes sense to
continue to use it in that role for the RM.

Otherwise tpms0 becomes the unrestricted interface to the RM and we
might need /dev/tpm_restricted0 down the road, which I think is really
ugly.

Jason
