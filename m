From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm-emulator: add a TPM emulator pass
 through
Date: Mon, 9 Jan 2017 09:54:16 -0700
Message-ID: <20170109165416.GA13960@obsidianresearch.com>
References: <1483923513.2644.1.camel@HansenPartnership.com>
	<20170109154945.GA28023@obsidianresearch.com>
	<1483978982.2448.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483978982.2448.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 09, 2017 at 08:23:02AM -0800, James Bottomley wrote:
> On Mon, 2017-01-09 at 08:49 -0700, Jason Gunthorpe wrote:
> > On Sun, Jan 08, 2017 at 04:58:33PM -0800, James Bottomley wrote:
> > > I noticed, while playing around with the kernel based resource
> > > manager, that it's very advantageous to have an emulated TPM device
> > > to
> > > test now that I'm playing with startup sequences and TPM ownership.
> > > 
> > > This is an emulator pass through.  It connects an existing emulator
> > > running on the platform (expected to be the MS Simulator available
> > > from https://sourceforge.net/projects/ibmswtpm2/) and adds it as an
> > > in-kernel device, meaning you can exercise the kernel TPM interface
> > > from either inside the kernel or using the device node.
> > > 
> > > The tpm-emulator simply connects to the command socket of the MS
> > > simulator (on localhost:2321) and proxies TPM commands.  The
> > > destination and port are settable as module parameters meaning that
> > > the TPM emulator doesn't have to be running locally.
> > 
> > What is wrong with using drivers/char/tpm/tpm_vtpm_proxy.c and doing
> > the socket connection in userspace?
> 
> Simplicity, mostly.  It's a tiny driver to proxy the network protocol
> directly, meaning it's much easier to set up.

Not sure I see it, surely running a program in userspace is simpler
than patching the kernel?

> Plus if you're running smoke tests in a VM you can actually run the
> emulator in the host without any additional code in the guest.

I haven't tried it, but qemu has TPM passthrough support, so it should
be able to pass /dev/tpm1, created by vtpm through to the guest. AFAIK
this should support all existing guests without a custom kernel or
messing with module options.

Honestly, I'd rather see the emulator community get behind vtpm..

Jason

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
