From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 09/11] tpm: Driver for supporting
 multiple emulated TPMs
Date: Mon, 22 Feb 2016 20:45:51 -0500
Message-ID: <201602230146.u1N1kGaQ019055@d03av02.boulder.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com><1455885728-10315-10-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222192741.GI22088@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0068239902142846068=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160222192741.GI22088-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============0068239902142846068==
Content-Type: multipart/alternative;
	boundary="=_alternative 0009B97385257F62_="


--=_alternative 0009B97385257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
02:27:41 PM:


> Subject: Re: [tpmdd-devel] [PATCH v3 09/11] tpm: Driver for=20
> supporting multiple emulated TPMs
>=20
> On Fri, Feb 19, 2016 at 07:42:06AM -0500, Stefan Berger wrote:
>=20
> > +#define VTPM=5FNUM=5FDEVICES TPM=5FNUM=5FDEVICES
>=20
> Never used
>=20

Dropped.

> > +   rc =3D copy=5Fto=5Fuser(buf, vtpm=5Fdev->buffer, len);
> > +   memset(vtpm=5Fdev->buffer, 0, len);
> > +   vtpm=5Fdev->req=5Flen =3D 0;
> > +
> > +   spin=5Funlock(&vtpm=5Fdev->buf=5Flock);
>=20
> No, do not call copy=5Fto=5Fuser in a spin lock, (or copy=5Ffrom=5Fuser)

I suppose we don't copy into an intermediary buffer, right? Just copy=20
without the protection then??


>=20
> > +   chip->vendor.irq =3D 1;
>=20
> Do not set this, I am trying to remove it..

dropped.

>=20
> Overall, I think everything has turned out very nice indeed.

Thanks. I could not race it anymore with lots of concurrency, so a bit=20
hesitant about the reordering of the IDR stuff.

Two things:
- the ioctl takes flags; should we return an error on flags that are not=20
supported but set by userspace?
- the sysfs works but I wished we could give some control over whether it=20
shows any entries. Can we have a flag in the ioctl on whether to show=20
these files in sysfs?

  Stefan




--=_alternative 0009B97385257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 02:27:41 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; Subject: Re: [tpmdd-devel] [PATCH v3 09/11] tpm:
Driver for <br>&gt; supporting multiple emulated TPMs</font></tt><br><tt><f=
ont size=3D2>&gt; <br>&gt; On Fri, Feb 19, 2016 at 07:42:06AM -0500, Stefan=
 Berger wrote:<br>&gt; <br>&gt; &gt; +#define VTPM=5FNUM=5FDEVICES TPM=5FNU=
M=5FDEVICES<br>&gt; <br>&gt; Never used<br>&gt; </font></tt><br><br><tt><fo=
nt size=3D2>Dropped.</font></tt><br><tt><font size=3D2><br>&gt; &gt; + &nbs=
p; rc =3D copy=5Fto=5Fuser(buf, vtpm=5Fdev-&gt;buffer, len);<br>&gt; &gt; +=
 &nbsp; memset(vtpm=5Fdev-&gt;buffer, 0, len);<br>&gt; &gt; + &nbsp; vtpm=
=5Fdev-&gt;req=5Flen =3D 0;<br>&gt; &gt; +<br>&gt; &gt; + &nbsp; spin=5Funl=
ock(&amp;vtpm=5Fdev-&gt;buf=5Flock);<br>&gt; <br>&gt; No, do not call copy=
=5Fto=5Fuser in a spin lock, (or copy=5Ffrom=5Fuser)</font></tt><br><br><tt=
><font size=3D2>I suppose we don't copy into an intermediary buffer,
right? Just copy without the protection then??</font></tt><br><br><tt><font=
 size=3D2><br>&gt; <br>&gt; &gt; + &nbsp; chip-&gt;vendor.irq =3D 1;<br>&gt=
; <br>&gt; Do not set this, I am trying to remove it..</font></tt><br><br><=
tt><font size=3D2>dropped.</font></tt><br><tt><font size=3D2><br>&gt; <br>&=
gt; Overall, I think everything has turned out very nice indeed.</font></tt=
><br><br><tt><font size=3D2>Thanks. I could not race it anymore with lots o=
f concurrency,
so a bit hesitant about the reordering of the IDR stuff.</font></tt><br><br=
><tt><font size=3D2>Two things:</font></tt><br><tt><font size=3D2>- the ioc=
tl takes flags; should we return an error
on flags that are not supported but set by userspace?</font></tt><br><tt><f=
ont size=3D2>- the sysfs works but I wished we could give some
control over whether it shows any entries. Can we have a flag in the ioctl
on whether to show these files in sysfs?</font></tt><br><br><tt><font size=
=3D2>&nbsp; Stefan</font></tt><br><br><BR>
--=_alternative 0009B97385257F62_=--



--===============0068239902142846068==
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
--===============0068239902142846068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============0068239902142846068==--
