From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 11:31:25 -0700
Message-ID: <20170104183125.GC783@obsidianresearch.com>
References: <1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
	<1483483198.2464.44.camel@HansenPartnership.com>
	<20170104001732.GB32185@obsidianresearch.com>
	<20170104125045.7lorpe55drnrqce5@intel.com>
	<1483541583.2561.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483541583.2561.20.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 06:53:03AM -0800, James Bottomley wrote:

> > > But this is not trousers, this is an in-kernel 0666 char dev that 
> > > will be active on basically every Linux system with a TPM. I think 
> > > we have a duty to be very conservative here.
> 
> Just to note on this that trousers *is* effectively an 0666 kernel
> device: all tcsd does is run with root privileges on the real /dev/tpm0
> and mediate the calls.  It doesn't seem to police them at all.

That may be, but IHMO trousers is simply not relevant. Real systems do
not seem to use trousers. I don't use it. Google doesn't use it. You
report it is crashy.

To me it just doesn't represent a reasonable way to use the TPM
hardware.

> For localities, assuming they can have real meaning in terms of the
> protection model, I think one device per locality is better than an
> ioctl because device policy is settable in underspace via the UNIX ACL
> and hence locality policy is too.

Yes.

> I also think the command filter actually needs more thought.  Right at
> the moment, if we go with the current proposals, the kernel will create
> two devices: /dev/tpm<n> and /dev/tpms<n>.  By default they'll both be
> root owned and 0600, so the current patch adequately protects the TPM.

Yes, but, considering the goals here I'd rather see the default kernel
permissions for tpms be 0666 ....

You are doing all this work to get the user space side in shape, I'd
like to see matching kernel support. To me that means out-of-the-box
a user can just use your plugins, the plugins will access /dev/tmps
and everything will work fine for RSA key storage.

No messing with udev, no opt-in to TPM usage, no daemon to install,
no chmod on a dev node. It Just Works.

> Now if we look at use cases, for my laptop, where I'm the only user, I
> want unrestricted access  to the TPM.  I can achieve that by making
> /dev/tpms0 0666 (or changing its ownership to me).

This usecase is already handled by making /dev/tmp0 accessible to the
user. Keeping the 'enable RM' ioctl makes that a little wonky but
entirely workable..

> Jason's use case is devices running non-root apps that need restricted
> TPM access.  For them, a single filter on /dev/tpms0 might work,
> although there might be unrestricted apps needing a broader range of
> tpm access (perhaps not all running as root?)

Yes, I have a range of usage restrictions.

As an example: My systems support key migration, so I want to make it
very hard for an attacker to use the migration machinery to steal an
RSA key. The user controls the migration password, I hope it is
strong, but even so the system is currently desgined so that only a
ssh user can even issue migration commands to the tpm. Someone hacking
a network daemon simply cannot.

This is the sort of defence in depth I think is imporant in a security
system like this.

> For the cloud use case, we're going to have a variety of applications
> each with a variety of restrictions (for instance, the orchestration
> system is definitely going to need PCR extensions if it's doing
> attestations, but the guests might not want this) etc.

To me a design for how the PCRs actually need to work is what is
missing here. I only minimially understand this use case...

And it seems like a big leap that orchestration software *needs*
unprivileged TPM access.

> I think all this points to multiple potential users each with their own
> filter, so I think the actual architecture for the filter is an ioctl
> which adds a new filtered device connected to the RM which may be
> executed many times.

Maybe, but that also seems like over kill.. It entirely depends on
what the PCR use model actually is.

Here is an alternative starting idea:

- Introduce /dev/tpms a single cdev node that can talk to all chips
  and all localities.
- By default it is 0666
- By default it has a very strong filter allowing only key load,
  some key ops and any thing else we can identify as unambiguously safe.
- It has a root-only ioctl that can change the filter (op, chip)
- It has a root-only ioctl that can change the locality
- Keep the enable-RM ioctl on /dev/tmpX, except that enable-RM
  would switch the /dev/tpm0 FD to only use the above uAPI and
  set an all-permissive filter.

The followup would be a TPM namespace design that meets the needs of
people working on containers and related. We already know we need this
today for IMA in containers and vtpm isolation.

TPM namespaces would basically control the filtering options on
/dev/tmps and set the default TPM. So one could run orchestration
software unprivileged inside a TPM namespace with greater access.

This should be enough stuff for people to explore different security
models in user space.

The root-only ioctls and /dev/tpm0 are enough to let user space create
FDs with whatever properties are needed and pass them to unprivileged,
eg via fd passing or via open-as-root/drop privs techniques.

The default configuration is enough to enable the RSA key model that
we actually do understand well and almost have code for :) I think
this is very important..

We don't introduce any new security risks we don't understand.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
