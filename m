From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Wed, 25 Jan 2017 22:21:37 +0200
Message-ID: <20170125202137.7bsv7lptvpzl2fjz@intel.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
	<20170124001918.GA29735@obsidianresearch.com>
	<20170124143600.siyhblj67qaatewi@intel.com>
	<20170124190707.GA9899@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170124190707.GA9899-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 24, 2017 at 12:07:07PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 24, 2017 at 04:36:00PM +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 23, 2017 at 05:19:18PM -0700, Jason Gunthorpe wrote:
> > > On Tue, Jan 24, 2017 at 02:02:52AM +0200, Jarkko Sakkinen wrote:
> > > > This commit adds a command filter for whitelisting a set of commands in
> > > > a TPM space. When a TPM space is created through /dev/tpms0, no
> > > > commands are allowed. The user of the TPM space must explicitly define
> > > > the list of commands allowed before sending any commands. This ioctl is
> > > > a one shot call so that a resource manager daemon can call it before
> > > > sending the file descriptor to the client.
> > > 
> > > I don't think it makes sense to have a daemon in user space that
> > > passes an open'd /dev/tpms0 FD directly to a client..
> > > 
> > > It is trivial and more powerful to just proxy the messages. Can you
> > > see some reason why passing a FD through a daemon would make sense?
> > > 
> > > The earlier discussion with James was to have some way to apply a
> > > global command filter to all tpms0 users with the idea that the
> > > 'right' restricted command set would enable a 0666 cdev node, and no
> > > daemon.
> > 
> > Is that a conflicting goal?
> >
> > Maybe the ioctl could be restricted by CAP_MAC_ADMIN in that case?
> 
> I think you need to spell out a clear use case for how userspace
> should use this filter feature and why having the kernel involved is a
> necessary element.
> 
> Driving userspace from the kernel uAPI design is a bit tricky without
> participation from people writing the user space code.
> 
> > How would you propose to change the code below? I guess the "core
> > code" is about right and this is more about API, am I right?
> 
> Generally, I'm of the opinion it is better to introduce the minimal
> amount of uAPI at this point and wait until people working on
> userspace figure out basic questions like, will there be a TPM2 daemon
> or not..
> 
> I would focus now on getting the RFC series finished up, hook the
> kAPI users into spaces and get it to the point where it does let
> user & kernel safely share the TPM.
> 
> Jason

There should be anyway someway to limit what commands can be sent but
I understand your point.

Would it make more sense to have a sysfs file for configuring the
global filter that would get the data in the same format (list of
16-bit words)?

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
