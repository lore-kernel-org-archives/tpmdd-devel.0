From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 05/12] tpm: Use read/write_bytes for
 drivers without more specialized methods
Date: Thu, 14 Apr 2016 15:50:11 -0600
Message-ID: <20160414215011.GC14137@obsidianresearch.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
	<1460577351-24632-6-git-send-email-christophe-h.ricard@st.com>
	<20160413204230.GB3836@obsidianresearch.com>
	<57100FB9.5050908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57100FB9.5050908-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 14, 2016 at 11:46:33PM +0200, Christophe Ricard wrote:
> 
> 
> On 13/04/2016 22:42, Jason Gunthorpe wrote:
> >On Wed, Apr 13, 2016 at 09:55:44PM +0200, Christophe Ricard wrote:
> >>Some drivers might choose to implement only functions for transferring an
> >>arbitrary number of bytes, without special handling of word or dword
> >>transfers.
> >Hurm, better to provide common write/read16/32 helpers that a driver can
> >just dump into it's function pointers rather than using null,
> >simpler/faster.
> It is not really clear to me here. In short, Do you expect me to drop this
> patch and force drivers to
> implement their own write/read16/32 helpers so that it will avoid a null
> check ?

No, just do something like

static const tpm_..ops spi_phy_ops = {
   .read_bytes = spi_read_bytes,
   .read16 = tpm_tis_common_read16,
   .read32 = tpm_tis_common_read32,
}

And have the core provide implementations of tpm_tis_common_readXX
that call read_bytes.

Jason

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
