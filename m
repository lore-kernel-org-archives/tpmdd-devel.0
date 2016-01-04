From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 7/7] tpm_crb: Use devm_ioremap_resource
Date: Mon, 4 Jan 2016 11:30:25 -0700
Message-ID: <20160104183025.GE20016@obsidianresearch.com>
References: <1450376600-6970-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1450376600-6970-8-git-send-email-jgunthorpe@obsidianresearch.com>
	<20160103173213.GF4155@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160103173213.GF4155-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Martin Wilck <Martin.Wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jan 03, 2016 at 07:32:13PM +0200, Jarkko Sakkinen wrote:
> On Thu, Dec 17, 2015 at 11:23:20AM -0700, Jason Gunthorpe wrote:
> > To support the force mode in tpm_tis we need to use resource locking
> > in tpm_crb as well, via devm_ioremap_resource.
> > 
> > The light restructuring better aligns crb and tis and makes it easier
> > to see the that new changes make sense.
> 
> This patch mixes two items: restructing and actual change.

Do you have a suggestion how to split this?

Everything is done for a reason, it isn't just churn for the sake of
churn.

Jason

------------------------------------------------------------------------------
