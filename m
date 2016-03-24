From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/12] tpm: Add tpm_set_vendordata and
	tpm_get_vendordata
Date: Thu, 24 Mar 2016 17:31:21 +0100
Message-ID: <CALD+uux0-nbwJfsHFHqPrZwWt=vEy73oi_djNrrY5QeiWwCq9A@mail.gmail.com>
References: <1458502483-16887-1-git-send-email-christophe-h.ricard@st.com>
	<1458502483-16887-6-git-send-email-christophe-h.ricard@st.com>
	<20160322062001.GB4058@intel.com>
	<CALD+uuxj2NHd0-LpDZpnfkfMHwY6ke0FPPqmR0FKzrC4BJmFNQ@mail.gmail.com>
	<20160324132732.GF8452@intel.com>
	<CALD+uuwVG_84dY4rCOjecZXxS4LZoE+Kh=CyhmVwyT2U0bAMrg@mail.gmail.com>
	<20160324161819.GA5263@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4952170786952204115=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160324161819.GA5263-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jean-Luc BLANC <jean-luc.blanc-qxv4g6HH51o@public.gmane.org>, "ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org" <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Christophe RICARD <christophe-h.ricard-qxv4g6HH51o@public.gmane.org>, Benoit HOUYERE <benoit.houyere-qxv4g6HH51o@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

--===============4952170786952204115==
Content-Type: multipart/alternative; boundary=047d7b3a8aca3a4250052ecdfbfd

--047d7b3a8aca3a4250052ecdfbfd
Content-Type: text/plain; charset=UTF-8

I got confused like you are but when looking a little bit better at the
code i think we have 2 differents "struct device" available on a tpm driver.
One is coming from the physical layer driver (aka: client->dev, spi->dev,
pdev->dev) and the other one from chip->dev which is initialized in
tpm_chip_alloc.
As a consequence, a quick trick allows to set data to physical layer driver
or to the tpm_chip device.

I haven't seen any place where this is already used for anything. Do you
confirm ?

Best Regards
Christophe

2016-03-24 17:18 GMT+01:00 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
:

> On Thu, Mar 24, 2016 at 02:30:24PM +0100, Christophe Ricard wrote:
> > Hi Jarkko,
> >
> > I am currently working at removing this TPM_VPRIV and priv field as
> requested
> > previously.
> > As pointed by you or Jason, i succeeded to go the dev_get_drvdata way :).
>
> We may need another patch or two to allow that, I have an ugly feeling
> the chip->drvdata is being used for something
>
> Jason
>

--047d7b3a8aca3a4250052ecdfbfd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>I got confused like you are but w=
hen looking a little bit better at the code i think we have 2 differents &q=
uot;struct device&quot; available on a tpm driver.<br></div>One is coming f=
rom the physical layer driver (aka: client-&gt;dev, spi-&gt;dev, pdev-&gt;d=
ev) and the other one from chip-&gt;dev which is initialized in tpm_chip_al=
loc.<br></div>As a consequence, a quick trick allows to set data to physica=
l layer driver or to the tpm_chip device.<br><br></div>I haven&#39;t seen a=
ny place where this is already used for anything. Do you confirm ?<br><br><=
/div>Best Regards<br></div>Christophe<br></div><div class=3D"gmail_extra"><=
br><div class=3D"gmail_quote">2016-03-24 17:18 GMT+01:00 Jason Gunthorpe <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" targ=
et=3D"_blank">jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org</a>&gt;</span>:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex"><span class=3D"">On Thu, Mar 24, 2016 at 02:30:24PM +0=
100, Christophe Ricard wrote:<br>
&gt; Hi Jarkko,<br>
&gt;<br>
</span><span class=3D"">&gt; I am currently working at removing this TPM_VP=
RIV and priv field as requested<br>
&gt; previously.<br>
&gt; As pointed by you or Jason, i succeeded to go the dev_get_drvdata way =
:).<br>
<br>
</span>We may need another patch or two to allow that, I have an ugly feeli=
ng<br>
the chip-&gt;drvdata is being used for something<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Jason<br>
</font></span></blockquote></div><br></div>

--047d7b3a8aca3a4250052ecdfbfd--


--===============4952170786952204115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785351&iu=/4140
--===============4952170786952204115==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4952170786952204115==--
