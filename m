From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 04 Jan 2017 06:53:03 -0800
Message-ID: <1483541583.2561.20.camel@HansenPartnership.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
	<1483483198.2464.44.camel@HansenPartnership.com>
	<20170104001732.GB32185@obsidianresearch.com>
	<20170104125045.7lorpe55drnrqce5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170104125045.7lorpe55drnrqce5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-04 at 14:50 +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 03, 2017 at 05:17:32PM -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 03, 2017 at 02:39:58PM -0800, James Bottomley wrote:
[...]
> > > > Even if TPM 2 has a stronger password based model, I still
> > > > think the kernel should hard prevent those sorts of actions
> > > > even if the user knows the TPM password.
> > > 
> > > That would make us different from TPM1.2: there, if you know the 
> > > owner authorisation, trousers will pretty much let you do
> > > anything.
> > 
> > Well, I also think trousers is wrong to do that. :)
> > 
> > But this is not trousers, this is an in-kernel 0666 char dev that 
> > will be active on basically every Linux system with a TPM. I think 
> > we have a duty to be very conservative here.

Just to note on this that trousers *is* effectively an 0666 kernel
device: all tcsd does is run with root privileges on the real /dev/tpm0
and mediate the calls.  It doesn't seem to police them at all.

I realise you want better than this, and I definitely think this is a
worthy goal, but the point I want to make is that an 0666 device and
trousers are basically equivalent.

> > This is why I want to see a command white list in Jarkko's patches 
> > to start. Every command exposed needs a very careful security 
> > analysis first, and we should start with only the commands we know 
> > are safe :\
> > 
> > > > Realistically people in less senstive environments will want to 
> > > > use the well known TPM passwords and still have reasonable 
> > > > safety in their unprivileged accounts.
> > > 
> > > Can we not do most of this with localities?  In theory locality 0 
> > > is supposed to be only the bios and the boot manager and the OS 
> > > gets to access 1-3.  We could reserve one for the internal kernel 
> > > and still have a couple for userspace (I'll have to go back and 
> > > check numbers; I seem to remember there were odd restrictions on 
> > > which PCR you can reset and extend in which locality).  If we 
> > > have two devices (one for each locality) we could define a UNIX 
> > > ACL on the devices to achieve what you want.
> > 
> > Good point, yes, localities should be thought about when designing
> > this new RM char dev uAPI...
> > 
> > Our support for localities in the kernel today uses some really 
> > gross sysfs file and is basically insane, IMHO.
> > 
> > Maybe there should be a /dev/tpmrm for each locality? If so then 
> > only the safe one with unwritable localities can be 0666 by
> > default..
> 
> Do you see that it would be possible to have ioctl for setting the
> locality, or is it out of the question? I'm planning to have an ioctl
> for the whitelist anyway.

For localities, assuming they can have real meaning in terms of the
protection model, I think one device per locality is better than an
ioctl because device policy is settable in underspace via the UNIX ACL
and hence locality policy is too.  If we have an ioctl, we then have to
introduce a "who's allowed to do this?" policy in the kernel.

I also think the command filter actually needs more thought.  Right at
the moment, if we go with the current proposals, the kernel will create
two devices: /dev/tpm<n> and /dev/tpms<n>.  By default they'll both be
root owned and 0600, so the current patch adequately protects the TPM.

I think we go with this now and do the filter later.

On the filter design:

Now if we look at use cases, for my laptop, where I'm the only user, I
want unrestricted access  to the TPM.  I can achieve that by making
/dev/tpms0 0666 (or changing its ownership to me).

Jason's use case is devices running non-root apps that need restricted
TPM access.  For them, a single filter on /dev/tpms0 might work,
although there might be unrestricted apps needing a broader range of
tpm access (perhaps not all running as root?)

For the cloud use case, we're going to have a variety of applications
each with a variety of restrictions (for instance, the orchestration
system is definitely going to need PCR extensions if it's doing
attestations, but the guests might not want this) etc.

I think all this points to multiple potential users each with their own
filter, so I think the actual architecture for the filter is an ioctl
which adds a new filtered device connected to the RM which may be
executed many times.  That way the creator of the device can decide the
filter policy and the use policy via the standard device UNIX ACL and
you can have lots of them to make this fine grained.  It could also be
done with something /dev/ptmx like, so perhaps a filesystem may be the
answer as well?

If you want, I can commit to building this once we have all the
requirements and we can get Jarkko's patch set reviewed now without it.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
