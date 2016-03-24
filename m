From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Thu, 24 Mar 2016 11:10:32 -0600
Message-ID: <20160324171032.GA27978@obsidianresearch.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
	<20160322062001.GB4058@intel.com>
	<CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ@mail.gmail.com>
	<20160324132732.GF8452@intel.com>
	<CALD+uuwVG_84dY4rCOjecZXxS4LZoE+Kh=CyhmVwyT2U0bAMrg@mail.gmail.com>
	<20160324161819.GA5263@obsidianresearch.com>
	<CALD+uux0-nbwJfsHFHqPrZwWt=vEy73oi_djNrrY5QeiWwCq9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALD+uux0-nbwJfsHFHqPrZwWt=vEy73oi_djNrrY5QeiWwCq9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Mar 24, 2016 at 05:31:21PM +0100, Christophe Ricard wrote:
>    I got confused like you are but when looking a little bit better at the
>    code i think we have 2 differents "struct device" available on a tpm
>    driver.
>    One is coming from the physical layer driver (aka: client->dev,
>    spi->dev, pdev->dev) and the other one from chip->dev which is
>    initialized in tpm_chip_alloc.

Yes, client->dev's drvdata (aka chip->dev.parent) should point to the
chip. In an ideal world the TPM core will never touch this, but we are
not quite there yet, sysfs in particular is broken.

chip->dev's drvdata could/should point to the driver's priv, that
would make sense. With Jarkko's tree today that is OK.

But Stefan's vtpm driver adds a use:

 https://github.com/stefanberger/linux/commit/3ab4e3aabf50137068e2807910e5f867668b4e23

Which is an ugly hacky thing..

So, if you are planning a tpm_get_drvdata or whatever then we should
probably patch vtpm to put priv back in or patch vtpm to not need that
hack.

Jason

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
