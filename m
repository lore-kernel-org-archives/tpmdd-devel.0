From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 04/12] tpm_tis: Introduce intermediate
 layer for TPM access
Date: Tue, 19 Apr 2016 21:56:05 +0300
Message-ID: <20160419185605.GB13115@intel.com>
References: <1461017864-3903-1-git-send-email-christophe-h.ricard@st.com>
	<1461017864-3903-5-git-send-email-christophe-h.ricard@st.com>
	<20160419130747.GC4796@intel.com>
	<CALD+uuxbqVYrPxpAz2gZo5+5hu+Yagt4XkinJUXfZm3fztfKLw@mail.gmail.com>
	<20160419171625.GA11619@intel.com>
	<20160419173934.GA26460@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160419173934.GA26460-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 19, 2016 at 11:39:34AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 19, 2016 at 08:16:25PM +0300, Jarkko Sakkinen wrote:
> > On Tue, Apr 19, 2016 at 03:20:25PM +0200, Christophe Ricard wrote:
> > >    Hi Jarkko,
> > > 
> > >    Do you thing tpm_tis.c should be renamed tpm_tis_tcg.c as well ?
> > 
> > Yeah.
> > 
> > I would structure things like this:
> > 
> > * tpm_tis.ko (core stuff)
> > * tpm_tis_tcg.ko
> > * tpm_tis_spi.ko
> > * ...
> 
> No. We shouldn't change the module name for the LPC driver, that
> breaks the uAPI in a visible way.

Right. Lets keep the filename also as tpm_tis.c then...

> Jason

/Jarkko

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
