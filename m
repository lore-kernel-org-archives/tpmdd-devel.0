From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] tpm: Get rid of chip->pdev
Date: Fri, 12 Feb 2016 20:31:21 -0500
Message-ID: <201602130131.u1D1VN5E007955@d01av03.pok.ibm.com>
References: <1455321871-28296-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1455321871-28296-3-git-send-email-jgunthorpe@obsidianresearch.com>
	<201602130037.u1D0bDEN029756@d01av04.pok.ibm.com>
	<20160213011130.GA2547@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6863404589649315300=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160213011130.GA2547-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============6863404589649315300==
Content-Type: multipart/alternative;
	boundary="=_alternative 0008659285257F58_="


--=_alternative 0008659285257F58_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
08:11:30 PM:


>=20
> On Fri, Feb 12, 2016 at 07:37:10PM -0500, Stefan Berger wrote:
> >    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on=20
02/12/2016
> >    07:04:30 PM:
> >    >
> >    > This is a hold over from before the struct device conversion.
> >    >
> >    > - All prints should be using &chip->dev, which is the Linux
> >    >   standard. This changes prints to use tpm0 as the device name,
> >    >   not the PnP/etc ID.
> >    > - The few places involving sysfs/modules that really do need the
> >    >   parent just use chip->dev.parent instead
> >    > - We no longer need to get=5Fdevice(pdev) in any places since it i=
s=20
no
> >    >   longer used by any of the code. The kref on the parent is held
> >    >   by the device core during device=5Fadd and dropped in device=5Fd=
el
> >    That is exactly what was needed for the vtpm driver and now you're
> >    removing it. Is that still going to work after this change? Or do=20
we
> >    need to re-add it as get/put=5Fdevice(chip->dev.parent) ?
>=20
> That code was not correct, the get=5Fdevice side has racy
> lack-of-locking problems and it serves no purpose for the tpm core or
> any existing driver.
>=20
> I already fixed this once in commit ba0ef85479c46a 'tpm: Fix
> initialization of the cdev' - that solves the racing of get=5Fdevice,
> and grabs the correct device kref, but I forgot to delete the broken
> residual get=5Fdevice. Sigh.
>=20
> It is unfortunate that bogus code sent you down this rabbit hole. My
> bad :(
>=20
> I'll send you something else that might work for vtpm...'

The vtpm driver will introduce chip->priv, which will point to vtpm=5Fdev. =

For this reason we need to hold a reference to the vtpm=5Fdev->dev in the=20
front end. So we could optimize it:

if (chip->priv)
        get=5Fdevice(chip->dev.parent);

Stefan

>=20
> Jason
>=20



--=_alternative 0008659285257F58_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 08:11:30 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Fri, Feb 12, 2016 at 07:37:10PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; &nbsp; &nbsp;Jason Gunthorpe &lt;jgunthorpe@obsidianresearch=
.com&gt;
wrote on 02/12/2016<br>&gt; &gt; &nbsp; &nbsp;07:04:30 PM:<br>&gt; &gt; &nb=
sp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp;&gt; This is a hold over from befo=
re the struct
device conversion.<br>&gt; &gt; &nbsp; &nbsp;&gt;<br>&gt; &gt; &nbsp; &nbsp=
;&gt; - All prints should be using &amp;chip-&gt;dev,
which is the Linux<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; standard. This cha=
nges prints to use
tpm0 as the device name,<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; not the PnP/=
etc ID.<br>&gt; &gt; &nbsp; &nbsp;&gt; - The few places involving sysfs/mod=
ules that
really do need the<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; parent just use ch=
ip-&gt;dev.parent
instead<br>&gt; &gt; &nbsp; &nbsp;&gt; - We no longer need to get=5Fdevice(=
pdev) in
any places since it is no<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; longer used=
 by any of the code. The
kref on the parent is held<br>&gt; &gt; &nbsp; &nbsp;&gt; &nbsp; by the dev=
ice core during device=5Fadd
and dropped in device=5Fdel<br>&gt; &gt; &nbsp; &nbsp;That is exactly what =
was needed for the vtpm driver
and now you're<br>&gt; &gt; &nbsp; &nbsp;removing it. Is that still going t=
o work after this
change? Or do we<br>&gt; &gt; &nbsp; &nbsp;need to re-add it as get/put=5Fd=
evice(chip-&gt;dev.parent)
?<br>&gt; <br>&gt; That code was not correct, the get=5Fdevice side has rac=
y<br>&gt; lack-of-locking problems and it serves no purpose for the tpm core
or<br>&gt; any existing driver.<br>&gt; <br>&gt; I already fixed this once =
in commit ba0ef85479c46a 'tpm: Fix<br>&gt; initialization of the cdev' - th=
at solves the racing of get=5Fdevice,<br>&gt; and grabs the correct device =
kref, but I forgot to delete the broken<br>&gt; residual get=5Fdevice. Sigh=
.<br>&gt; <br>&gt; It is unfortunate that bogus code sent you down this rab=
bit hole.
My<br>&gt; bad :(<br>&gt; <br>&gt; I'll send you something else that might =
work for vtpm...'</font></tt><br><br><tt><font size=3D2>The vtpm driver wil=
l introduce chip-&gt;priv, which
will point to vtpm=5Fdev. For this reason we need to hold a reference to
the vtpm=5Fdev-&gt;dev in the front end. So we could optimize it:</font></t=
t><br><br><tt><font size=3D2>if (chip-&gt;priv)</font></tt><br><tt><font si=
ze=3D2>&nbsp; &nbsp; &nbsp; &nbsp; get=5Fdevice(chip-&gt;dev.parent);</font=
></tt><br><br><tt><font size=3D2>Stefan</font></tt><br><tt><font size=3D2><=
br>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 0008659285257F58_=--



--===============6863404589649315300==
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
--===============6863404589649315300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6863404589649315300==--
