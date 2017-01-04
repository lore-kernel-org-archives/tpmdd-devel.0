From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 14:50:45 +0200
Message-ID: <20170104125045.7lorpe55drnrqce5@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
	<1483483198.2464.44.camel@HansenPartnership.com>
	<20170104001732.GB32185@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170104001732.GB32185-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 05:17:32PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 02:39:58PM -0800, James Bottomley wrote:
> 
> > > I think we should also consider TPM 1.2 support in all of this, it is
> > > still a very popular peice of hardware and it is equally able to
> > > support a RM.
> > 
> > I've been running with the openssl and gnome-keyring patches in 1.2 for
> > months now.  The thing about 1.2 is that the volatile store is much
> > larger, so there's a lot less of a need for a RM.  It's only a
> > requirement in 2.0 because most shipping TPMs only seem to have room
> > for about 3 objects.
> 
> It would be great if the 1.2 RM could support just enough to allow RSA
> key operations from userspace, without key virtualization. That would
> allow the plugins that already exist to move to the RM interface and
> we can get rid of the hard dependency on trousers.
> 
> I honestly don't think this should be much work beyond what Jarkko has
> already done...
> 
> > > So, in general, I'd prefer to see the unprivileged char dev hard
> > > prevented by the kernel from doing certain things:
> > > 
> > > - Wipe the TPM
> > > - Manipulate the SRK, nvram, tpm flags, change passwords etc
> > > - Read back the EK
> > 
> > These are all things that the TPM itself is capable of enforcing a
> > policy for.  I think we should aim for correct setup of the TPM in the
> > first place so it enforces the policy in a standard manner rather than
> > having an artificial policy enforcement in the kernel.
> 
> Well, by policy you mean 'know the owner password' which at least I am
> *very* nervous about exposing beyond the super user - certainly in my
> embedded systems.
> 
> On a desktop I think these actions should be protected by the usual
> 'sudo' scheme dbus has *in addition* to the owner password.
> 
> It is rare that anyone would want to do these actions this seems like
> the right choice from a security perspective.
> 
> > > - Write to PCRs
> > 
> > The design of a TPM is mostly that it's up to user space to deal with
> > this.  Userspace can, of course, kill the TPM ability to quote and seal
> > to PCRs by inappropriately extending them.  However, there are a lot of
> > responsible applications that want to use PCRs in userspace; for
> > instance cloud boot and attestation.  We don't really want to restrict
> > their ability arbitrarily.
> 
> The entire RM model is that of a sandbox, so if extending the PCR is
> viewable by other RM clients it must be prevented. We don't want a
> user to be able to DOS other users by extending a PCR and breaking
> system attestation or unsealing.
> 
> Like you say below localities may be part of the answer here, and I
> also recall that various PCRs become read-only at certain localities.
> 
> However, until we figure out a security model for writing PCRs I think
> the RM has to ban them.
> 
> > > Even if TPM 2 has a stronger password based model, I still think the
> > > kernel should hard prevent those sorts of actions even if the user
> > > knows the TPM password.
> > 
> > That would make us different from TPM1.2: there, if you know the owner
> > authorisation, trousers will pretty much let you do anything.
> 
> Well, I also think trousers is wrong to do that. :)
> 
> But this is not trousers, this is an in-kernel 0666 char dev that will
> be active on basically every Linux system with a TPM. I think we have
> a duty to be very conservative here.
> 
> This is why I want to see a command white list in Jarkko's patches to
> start. Every command exposed needs a very careful security analysis
> first, and we should start with only the commands we know are safe :\
> 
> > > Realistically people in less senstive environments will want to use
> > > the well known TPM passwords and still have reasonable safety in 
> > > their unprivileged accounts.
> > 
> > Can we not do most of this with localities?  In theory locality 0 is
> > supposed to be only the bios and the boot manager and the OS gets to
> > access 1-3.  We could reserve one for the internal kernel and still
> > have a couple for userspace (I'll have to go back and check numbers; I
> > seem to remember there were odd restrictions on which PCR you can reset
> > and extend in which locality).  If we have two devices (one for each
> > locality) we could define a UNIX ACL on the devices to achieve what you
> > want.
> 
> Good point, yes, localities should be thought about when designing
> this new RM char dev uAPI...
> 
> Our support for localities in the kernel today uses some really gross
> sysfs file and is basically insane, IMHO.
> 
> Maybe there should be a /dev/tpmrm for each locality? If so then only
> the safe one with unwritable localities can be 0666 by default..

Do you see that it would be possible to have ioctl for setting the
locality, or is it out of the question? I'm planning to have an ioctl
for the whitelist anyway.

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
