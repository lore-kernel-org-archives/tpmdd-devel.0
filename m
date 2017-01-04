From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 4 Jan 2017 12:24:23 -0700
Message-ID: <20170104192423.GA12929@obsidianresearch.com>
References: <1483393248.2458.32.camel@HansenPartnership.com>
	<20170103135121.4kh3jld5gaq3ptj4@intel.com>
	<1483461370.2464.19.camel@HansenPartnership.com>
	<20170103214702.GC29656@obsidianresearch.com>
	<1483483198.2464.44.camel@HansenPartnership.com>
	<20170104001732.GB32185@obsidianresearch.com>
	<20170104125045.7lorpe55drnrqce5@intel.com>
	<1483541583.2561.20.camel@HansenPartnership.com>
	<20170104183125.GC783@obsidianresearch.com>
	<1483556271.2561.50.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483556271.2561.50.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 10:57:51AM -0800, James Bottomley wrote:

> > You are doing all this work to get the user space side in shape, I'd
> > like to see matching kernel support. To me that means out-of-the-box
> > a user can just use your plugins, the plugins will access /dev/tmps
> > and everything will work fine for RSA key storage.
> 
> Actually, not necessarily; you're not considering the setup issue:
> right at the moment users get delivered TPMs mostly in the cleared

I have no problem with users being instructed to do 'sudo
tpm2-provision' or having that happen via GUI using the usual
privilege escalation techniques.

> state (thankfully they no longer have to clear via bios).  So the first
> thing a new user has to do is set all the authorizations and create an
> SRK equivalent primary object at 0x81000001.  I think in the interests
> of best practice we want to make that as easy as possible; saying they
> have to do this as root and use a different device is problematic.

The device names should never be exposed to the user. The user should
specify a chip number (default to 0) and the tools should select the
correct available device to do what the user is asking.

First try /dev/tpms and elevate filter, then try /dev/tpmX, then fail.

> You can say they don't have to use a different device because the
> filter can be lifted for root, but then how do I lock down root apps
> for this untrusted root setup secure boot has going on?

Presumably the same way you lock down /dev/tpm0 today?

selinux I guess?

> I suppose we could use TPMA_PERMANENT for this. The first three bits
> indicate whether the authorizations are set, so if they're all clear,
> we can assume an unowned TPM and lift the filter?  A sort of trust on
> first use model.

I feel tpm provisioning is something that should only be done by the
system owner, and that means root in unix parlance.

I don't want random end-users provisioning the TPM in my server, for
instance.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
