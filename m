From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 04 Jan 2017 10:57:51 -0800
Message-ID: <1483556271.2561.50.camel@HansenPartnership.com>
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
	<20170104183125.GC783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170104183125.GC783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open, list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-04 at 11:31 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 04, 2017 at 06:53:03AM -0800, James Bottomley wrote:
> 
> > > > But this is not trousers, this is an in-kernel 0666 char dev 
> > > > that will be active on basically every Linux system with a TPM. 
> > > > I think we have a duty to be very conservative here.
> > 
> > Just to note on this that trousers *is* effectively an 0666 kernel
> > device: all tcsd does is run with root privileges on the real 
> > /dev/tpm0 and mediate the calls.  It doesn't seem to police them at
> > all.
> 
> That may be, but IHMO trousers is simply not relevant. Real systems 
> do not seem to use trousers. I don't use it. Google doesn't use it. 
> You report it is crashy.
> 
> To me it just doesn't represent a reasonable way to use the TPM
> hardware.

It basically represents the only current way until there's a new API,
so all our current key handling tools use it.  Given how I slammed it
in Plumbers, I'd be the last one to defend its actual API as usable ...
we just don't have another (yet).

> > For localities, assuming they can have real meaning in terms of the
> > protection model, I think one device per locality is better than an
> > ioctl because device policy is settable in underspace via the UNIX 
> > ACL and hence locality policy is too.
> 
> Yes.
> 
> > I also think the command filter actually needs more thought.  Right 
> > at the moment, if we go with the current proposals, the kernel will
> > create two devices: /dev/tpm<n> and /dev/tpms<n>.  By default 
> > they'll both be root owned and 0600, so the current patch 
> > adequately protects the TPM.
> 
> Yes, but, considering the goals here I'd rather see the default 
> kernel permissions for tpms be 0666 ....
> 
> You are doing all this work to get the user space side in shape, I'd
> like to see matching kernel support. To me that means out-of-the-box
> a user can just use your plugins, the plugins will access /dev/tmps
> and everything will work fine for RSA key storage.

Actually, not necessarily; you're not considering the setup issue:
right at the moment users get delivered TPMs mostly in the cleared
state (thankfully they no longer have to clear via bios).  So the first
thing a new user has to do is set all the authorizations and create an
SRK equivalent primary object at 0x81000001.  I think in the interests
of best practice we want to make that as easy as possible; saying they
have to do this as root and use a different device is problematic.

You can say they don't have to use a different device because the
filter can be lifted for root, but then how do I lock down root apps
for this untrusted root setup secure boot has going on?

I suppose we could use TPMA_PERMANENT for this. The first three bits
indicate whether the authorizations are set, so if they're all clear,
we can assume an unowned TPM and lift the filter?  A sort of trust on
first use model.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
