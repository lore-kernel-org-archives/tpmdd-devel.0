From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tpm: fix byte-order for the value
 read by tpm2_get_tpm_pt
Date: Mon, 18 Jul 2016 22:05:19 +0300
Message-ID: <20160718190519.GM31463@intel.com>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
	<1468544838-9990-3-git-send-email-apronin@chromium.org>
	<20160715031046.GC9347@obsidianresearch.com>
	<20160715031701.GA25406@apronin>
	<20160715033553.GJ9347@obsidianresearch.com>
	<20160715193143.GA7052@apronin>
	<20160715193928.GA20719@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715193928.GA20719-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smbarber-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, groeck-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jul 15, 2016 at 01:39:28PM -0600, Jason Gunthorpe wrote:
> On Fri, Jul 15, 2016 at 12:31:43PM -0700, Andrey Pronin wrote:
> 
> > I even tried changing the code there to
> > 	__be32 vv = cmd.params.get_tpm_pt_out.value;
> > 	u32 ret = vv;
> > to make it clear what's going on. Still, no complaints from sparse.
> 
> Hum, I'm not an expert at sparse, but I expect a warning from it here?
> 
> Maybe Jarkko knows when he gets back?

I do run sparse regularly. If look at the commit log there are even
couple of recent bug fixes related to sparse errors.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
