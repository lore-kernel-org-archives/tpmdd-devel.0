From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v6 6/8] tpm/tpm_tis: Split tpm_tis driver
 into a core and TCG TIS compliant phy
Date: Mon, 2 May 2016 11:25:52 -0600
Message-ID: <20160502172552.GA32096@obsidianresearch.com>
References: <1461363085-9908-1-git-send-email-christophe-h.ricard@st.com>
	<1461363085-9908-7-git-send-email-christophe-h.ricard@st.com>
	<20160502171650.GC1764@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502171650.GC1764-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, jean-luc.blanc-qxv4g6HH51o@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, May 02, 2016 at 08:16:50PM +0300, Jarkko Sakkinen wrote:
> On Sat, Apr 23, 2016 at 12:11:23AM +0200, Christophe Ricard wrote:
> > To avoid code duplication between the old tpm_tis and the new and future
> > native tcg tis driver(ie: spi, i2c...), the tpm_tis driver was reworked,
> > so that all common logic is extracted and can be reused from all drivers.
> > 
> > The core methods can also be used from other TIS like drivers.
> > 
> > itpm workaround is now managed with a specific tis flag
> > TPM_TIS_ITPM_POSSIBLE.
> 
> Please drop this patch and add private functions for your SPI driver.
> This just grows the patch set size and does not add value.

? If you drop this then you might as well discard the entire series.

It seems there is alot of code overlap, so this seems like a good
idea.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
