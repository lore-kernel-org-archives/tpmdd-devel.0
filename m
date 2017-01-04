From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 03 Jan 2017 16:29:59 -0800
Message-ID: <1483489799.2464.79.camel@HansenPartnership.com>
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
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-03 at 17:17 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 02:39:58PM -0800, James Bottomley wrote:
> 
> > > I think we should also consider TPM 1.2 support in all of this, 
> > > it is still a very popular peice of hardware and it is equally 
> > > able to support a RM.
> > 
> > I've been running with the openssl and gnome-keyring patches in 1.2 
> > for months now.  The thing about 1.2 is that the volatile store is 
> > much larger, so there's a lot less of a need for a RM.  It's only a
> > requirement in 2.0 because most shipping TPMs only seem to have 
> > room for about 3 objects.
> 
> It would be great if the 1.2 RM could support just enough to allow 
> RSA key operations from userspace, without key virtualization. That 
> would allow the plugins that already exist to move to the RM 
> interface and we can get rid of the hard dependency on trousers.
[getting long, let's divide into separate issues]

They actually already do: Trousers, for all its annoying complexity,
doesn't actually implement a resource manager, so we should be able to
do all the RSA operations we want today with the current 1.2 interface
and no RM.  The difficulty is no API ... unless you want to speak at
the TPM command level and do all the HMAC calculations yourself.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
