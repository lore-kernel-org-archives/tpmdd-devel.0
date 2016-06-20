From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: Factor out common startup code
Date: Mon, 20 Jun 2016 15:07:57 -0600
Message-ID: <20160620210757.GB11746@obsidianresearch.com>
References: <1466324401-5054-1-git-send-email-andrew.zamansky@nuvoton.com>
	<1466324401-5054-2-git-send-email-andrew.zamansky@nuvoton.com>
	<20160619123923.GA31053@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160619123923.GA31053-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, azamansk-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, Dan.Morav-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org, stimpy1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jun 19, 2016 at 02:39:24PM +0200, Jarkko Sakkinen wrote:
> > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > Tested-by: Andrew Zamansky <andrew.zamansky-KrzQf0k3Iz9BDgjK7y7TUQ@public.gmane.org>
> 
> Couldn't tpm?_auto_startup() be static functions inside tpm-chip.c?

Why? tpm-chip is for chip functions and tpm-interface is for command
issuing functions, the startup command sequencors seem appropriately
placed...

These are still module private functions.

> > +enum TPM_OPS_FLAGS {
> > +	TPM_OPS_PROBE_TPM2 = BIT(0),
> 
> I see two alternatives here:
> 
> 1. Make this work for tpm_tis.c if it is doable.
> 2. Remove this flag and call tpm2_probe() inside tpm_i2c_nuvoton.c.
> 
> If this flag works only for a single driver, it does not bring any value.

We already have two drivers that auto probe, you don't think there
will be more? The idea is to try and remove these low level entry
points so drivers are simpler.

TIS doesn't use it because it needs to get things setup in advance for
interrupt auto-probing, which is a very TIS unique thing.

Alternatively we can drop the auto-probe from nuvoton and force it to
rely on compatible string matching to enter TPM2 mode.

Jason

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports. http://sdm.link/zohomanageengine
