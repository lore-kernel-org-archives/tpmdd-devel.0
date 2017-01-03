From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 03 Jan 2017 14:39:58 -0800
Message-ID: <1483483198.2464.44.camel@HansenPartnership.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<1483374980.2458.13.camel@HansenPartnership.com>
	<20170102193320.trawto65nkjccbao@intel.com>
	<1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170103214702.GC29656-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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

On Tue, 2017-01-03 at 14:47 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 08:36:10AM -0800, James Bottomley wrote:
> 
> > > I'm not sure about this. Why you couldn't have a very thin daemon
> > > that prepares the file descriptor and sends it through UDS socket 
> > > to a client.
> > 
> > So I'm a bit soured on daemons from the trousers experience: tcsd
> > crashed regularly and when it did it took all the TPM connections 
> > down irrecoverably.  I'm not saying we can't write a stateless 
> > daemon to fix most of the trousers issues, but I think it's 
> > valuable first to ask the question, "can we manage without a daemon 
> > at all?"  I actually think the answer is "yes", so I'm interested 
> > in seeing how far that line of research gets us.
> 
> There is clearly no need for a daemon to be involved when working on
> simple tasks like key load and key sign/enc/dec actions, adding such 
> a thing only increases the complexity.
> 
> If we discover a reason to have a daemon down the road then it should
> work in some way where the user space can call out to the daemon over
> a different path than the kernel. (eg dbus or something)

Agreed ... I think the only reason I can currently see for needing a
daemon is if we need it to sort out access security (which I'm hoping
we don't).

> > Do you have a link to the presentation?  The Plumbers etherpad 
> > doesn't contain it.  I've been trying to work out whether a 
> > properly set up TPM actually does need any protections at all.  As 
> > far as I can tell, once you've set all the hierarchy authorities 
> > and the lockout one, you're pretty well protected.
> 
> I think we should also consider TPM 1.2 support in all of this, it is
> still a very popular peice of hardware and it is equally able to
> support a RM.

I've been running with the openssl and gnome-keyring patches in 1.2 for
months now.  The thing about 1.2 is that the volatile store is much
larger, so there's a lot less of a need for a RM.  It's only a
requirement in 2.0 because most shipping TPMs only seem to have room
for about 3 objects.

> So, in general, I'd prefer to see the unprivileged char dev hard
> prevented by the kernel from doing certain things:
> 
> - Wipe the TPM
> - Manipulate the SRK, nvram, tpm flags, change passwords etc
> - Read back the EK

These are all things that the TPM itself is capable of enforcing a
policy for.  I think we should aim for correct setup of the TPM in the
first place so it enforces the policy in a standard manner rather than
having an artificial policy enforcement in the kernel.

> - Write to PCRs

The design of a TPM is mostly that it's up to user space to deal with
this.  Userspace can, of course, kill the TPM ability to quote and seal
to PCRs by inappropriately extending them.  However, there are a lot of
responsible applications that want to use PCRs in userspace; for
instance cloud boot and attestation.  We don't really want to restrict
their ability arbitrarily.

> - etc.

> 
> Even if TPM 2 has a stronger password based model, I still think the
> kernel should hard prevent those sorts of actions even if the user
> knows the TPM password.

That would make us different from TPM1.2: there, if you know the owner
authorisation, trousers will pretty much let you do anything.

> Realistically people in less senstive environments will want to use
> the well known TPM passwords and still have reasonable safety in 
> their unprivileged accounts.

Can we not do most of this with localities?  In theory locality 0 is
supposed to be only the bios and the boot manager and the OS gets to
access 1-3.  We could reserve one for the internal kernel and still
have a couple for userspace (I'll have to go back and check numbers; I
seem to remember there were odd restrictions on which PCR you can reset
and extend in which locality).  If we have two devices (one for each
locality) we could define a UNIX ACL on the devices to achieve what you
want.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
