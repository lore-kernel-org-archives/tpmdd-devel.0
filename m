From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Tue, 24 Jan 2017 12:07:07 -0700
Message-ID: <20170124190707.GA9899@obsidianresearch.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
 <20170124001918.GA29735@obsidianresearch.com>
 <20170124143600.siyhblj67qaatewi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124143600.siyhblj67qaatewi@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 24, 2017 at 04:36:00PM +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 05:19:18PM -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 24, 2017 at 02:02:52AM +0200, Jarkko Sakkinen wrote:
> > > This commit adds a command filter for whitelisting a set of commands in
> > > a TPM space. When a TPM space is created through /dev/tpms0, no
> > > commands are allowed. The user of the TPM space must explicitly define
> > > the list of commands allowed before sending any commands. This ioctl is
> > > a one shot call so that a resource manager daemon can call it before
> > > sending the file descriptor to the client.
> > 
> > I don't think it makes sense to have a daemon in user space that
> > passes an open'd /dev/tpms0 FD directly to a client..
> > 
> > It is trivial and more powerful to just proxy the messages. Can you
> > see some reason why passing a FD through a daemon would make sense?
> > 
> > The earlier discussion with James was to have some way to apply a
> > global command filter to all tpms0 users with the idea that the
> > 'right' restricted command set would enable a 0666 cdev node, and no
> > daemon.
> 
> Is that a conflicting goal?
>
> Maybe the ioctl could be restricted by CAP_MAC_ADMIN in that case?

I think you need to spell out a clear use case for how userspace
should use this filter feature and why having the kernel involved is a
necessary element.

Driving userspace from the kernel uAPI design is a bit tricky without
participation from people writing the user space code.

> How would you propose to change the code below? I guess the "core
> code" is about right and this is more about API, am I right?

Generally, I'm of the opinion it is better to introduce the minimal
amount of uAPI at this point and wait until people working on
userspace figure out basic questions like, will there be a TPM2 daemon
or not..

I would focus now on getting the RFC series finished up, hook the
kAPI users into spaces and get it to the point where it does let
user & kernel safely share the TPM.

Jason
