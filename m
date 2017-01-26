From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Thu, 26 Jan 2017 13:14:03 +0200
Message-ID: <20170126111403.ql6np2qulifxxw3p@intel.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
 <20170124001918.GA29735@obsidianresearch.com>
 <20170124143600.siyhblj67qaatewi@intel.com>
 <20170124190707.GA9899@obsidianresearch.com>
 <20170125202137.7bsv7lptvpzl2fjz@intel.com>
 <20170125221136.GA713@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125221136.GA713@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 03:11:36PM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 25, 2017 at 10:21:37PM +0200, Jarkko Sakkinen wrote:
> 
> > There should be anyway someway to limit what commands can be sent but
> > I understand your point.
> 
> What is the filter for?
> 
> James and I talked about a filter to create a safer cdev for use by
> users. However tpms0 cannot be that 'safer' cdev - it is now the 'all
> access' path.

What do you mean by "safer cdev"?

> I also suggested a filter in the kernel to ensure that the RM is only
> passing commands it actually knows it handles properly. eg you would
> filter out list handles. That is hardwired into the kernel, and does
> not ge to be configured by user space.

In many cases you would want to limit the set of operations that client
can use.  For example, not every client needs NV operations. In general
you might want to have mechanism for limiting privileges. I haven't
really considered this from the perspective that you've been discussing
but more from the "principle of least privilege" perspective.

Are you suggesting that in such cases you could just create daemon for
proxying the traffic (when you want to limit privileges)? You could just
make that daemon a whole lot simpler if it just needs to pass the file
desriptor to the client after defining the set of operations that the
client can use.

This is a high priority decision to make because it's hard to apply
principle of least privilege (with everything disallowed defaultts)
if it is not done in the first place.

/Jarkko
