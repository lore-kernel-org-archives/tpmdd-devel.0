From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 08/10] devicetree: Add Trusted Computing
 Group to vendor-prefix.txt
Date: Mon, 11 Apr 2016 14:21:19 -0600
Message-ID: <20160411202119.GA3357@obsidianresearch.com>
References: <1460323386-16892-1-git-send-email-christophe-h.ricard@st.com>
	<1460323386-16892-9-git-send-email-christophe-h.ricard@st.com>
	<20160411200600.GA23902@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160411200600.GA23902@rob-hp-laptop>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 11, 2016 at 03:06:00PM -0500, Rob Herring wrote:
> On Sun, Apr 10, 2016 at 11:23:04PM +0200, Christophe Ricard wrote:
> > Add missing vendor to vendor-prefix.txt.
> > 
> > Trusted Computing Group design common specifications for
> > TPM (Trusted Platform Module) vendors.
> > TCG designates a TPM answering to a public specification.
> 
> Not sure this should be a vendor prefix. Does TCG actually make h/w?

They define the common multi-vendor register API, similar to AHCI.

I would imagine compatible tags like

 compatible = 'winbond,xxxx','tcg,tis_iomap';

Since there actually is a legal entity administering the spec (unlike
AHCI?) 'tgc,' seems like a better prefix to me than 'generic-' ?

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
