From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 19:37:10 -0500
Message-ID: <201602130037.u1D0bD4V001015@d01av01.pok.ibm.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2887319304470698798=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1455321871-28296-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============2887319304470698798==
Content-Type: multipart/alternative;
	boundary="=_alternative 00036FB985257F58_="


--=_alternative 00036FB985257F58_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
07:04:30 PM:

>=20
> This is a hold over from before the struct device conversion.
>=20
> - All prints should be using &chip->dev, which is the Linux
>   standard. This changes prints to use tpm0 as the device name,
>   not the PnP/etc ID.
> - The few places involving sysfs/modules that really do need the
>   parent just use chip->dev.parent instead
> - We no longer need to get=5Fdevice(pdev) in any places since it is no
>   longer used by any of the code. The kref on the parent is held
>   by the device core during device=5Fadd and dropped in device=5Fdel

That is exactly what was needed for the vtpm driver and now you're=20
removing it. Is that still going to work after this change? Or do we need=20
to re-add it as get/put=5Fdevice(chip->dev.parent) ?

   Stefan


--=_alternative 00036FB985257F58_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 07:04:30 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; This is a hold over from before the struct device conversion.<br>=
&gt; <br>&gt; - All prints should be using &amp;chip-&gt;dev, which is the =
Linux<br>&gt; &nbsp; standard. This changes prints to use tpm0 as the devic=
e name,<br>&gt; &nbsp; not the PnP/etc ID.<br>&gt; - The few places involvi=
ng sysfs/modules that really do need the<br>&gt; &nbsp; parent just use chi=
p-&gt;dev.parent instead<br>&gt; - We no longer need to get=5Fdevice(pdev) =
in any places since it is
no<br>&gt; &nbsp; longer used by any of the code. The kref on the parent is=
 held<br>&gt; &nbsp; by the device core during device=5Fadd and dropped in =
device=5Fdel</font></tt><br><br><tt><font size=3D2>That is exactly what was=
 needed for the vtpm driver
and now you're removing it. Is that still going to work after this change?
Or do we need to re-add it as get/put=5Fdevice(chip-&gt;dev.parent) ?</font=
></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><BR>
--=_alternative 00036FB985257F58_=--



--===============2887319304470698798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=272487151&iu=/4140
--===============2887319304470698798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============2887319304470698798==--
