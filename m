From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: add driver for cr50 on SPI
Date: Thu, 21 Jul 2016 15:00:24 -0600
Message-ID: <20160721210024.GA10039@obsidianresearch.com>
References: <1468549218-19215-1-git-send-email-apronin@chromium.org>
	<1468549218-19215-3-git-send-email-apronin@chromium.org>
	<20160715033236.GH9347@obsidianresearch.com>
	<20160715034444.GA28128@apronin> <20160719125527.GB5047@intel.com>
	<20160720002411.GA147098@apronin>
	<20160720170336.GC21460@obsidianresearch.com>
	<20160721181047.GA115653@apronin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160721181047.GA115653@apronin>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andrey Pronin <apronin-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 21, 2016 at 11:10:47AM -0700, Andrey Pronin wrote:
> On Wed, Jul 20, 2016 at 11:03:36AM -0600, Jason Gunthorpe wrote:
> > On Tue, Jul 19, 2016 at 05:24:11PM -0700, Andrey Pronin wrote:
> > 
> > > The only two things that bother me with such approach are
> > > (1) whatever names I pick for the new set of functions, they
> > >     will be similar to and thus might be confused with the
> > >     original tpm_tis_read/writeXX;
> > 
> > tpm_tis_helper_read16 ?
> > 
> > > (2) these functions are phy-specific, so possibly it's better
> > >     to create tpm_tis_spi.h and put them there with proper
> > >     name prefixes. And then use in tpm_tis_spi and cr50_spi.
> > 
> > No, they are generic to any tis phy that implements read only through
> > read_bytes.
> > 
> > (Honestly, I'm not sure we made the best choice here having phy
> >  functions for all the versions, we are not that performance
> >  sensitive, just getting rid of everything but read_bytes from the
> >  phy_ops would probably also be a reasonable thing to do.)
> > 
> 
> One thing we can do is re-implement functions tpm_tis_read/writeXX
> to use phy-specific implementations of read16, read32, write32 if they
> are provided. But if those function pointers are left NULL in phy_ops,
> fallback to using read/write_bytes and byte-swapping.

I was thinking of just getting rid of phy_ops->read16 entirely and
only use read_bytes at the ops layer.

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
