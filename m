From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM emulator driver status
Date: Wed, 13 Jan 2016 09:36:12 -0500
Message-ID: <201601131436.u0DEaIR4005452@d01av02.pok.ibm.com>
References: <11083.1452692382@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7281230473647343812=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <11083.1452692382-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============7281230473647343812==
Content-Type: multipart/alternative;
	boundary="=_alternative 005038D785257F39_="


--=_alternative 005038D785257F39_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote on 01/13/2016 08:39:42 AM:

>=20
> Hi Peter, Jarkko,
>=20
> Is the TPM emulator likely to go upstream at any point?  Or is it=20
waiting for
> some sort of update?

David,=20

I wrote a driver for support of (v)TPM for containers. It has ioctl's for=20
creating and deleting of pairs of devices where one device is used by=20
clients and the other end is used by a TPM emulator to listen for=20
commands. The client device can be 'moved' in the container, meaning a=20
device node with the same major/minor numbers is created inside a=20
container.  Any number of such device pairs can be create. Does this=20
driver sound like it would provide more functionality than yours and would =

it address your use case as well?

   Stefan


>=20
> Thanks,
> David
>=20
>=20
---------------------------------------------------------------------------=
---
> Site24x7 APM Insight: Get Deep Visibility into Application Performance
> APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
> Monitor end-to-end web transactions and take corrective actions now
> Troubleshoot faster and improve end-user experience. Signup Now!
> http://pubads.g.doubleclick.net/gampad/clk?id=3D267308311&iu=3D/4140
> =5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F
> tpmdd-devel mailing list
> tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>=20



--=_alternative 005038D785257F39_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>David Howells &lt;dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org&gt; wrote on 01/13=
/2016
08:39:42 AM:<br><br>&gt; <br>&gt; Hi Peter, Jarkko,<br>&gt; <br>&gt; Is the=
 TPM emulator likely to go upstream at any point? &nbsp;Or is
it waiting for<br>&gt; some sort of update?</font></tt><br><br><tt><font si=
ze=3D2>David, </font></tt><br><br><tt><font size=3D2>I wrote a driver for s=
upport of (v)TPM for containers.
It has ioctl's for &nbsp;creating and deleting of pairs of devices where
one device is used by clients and the other end is used by a TPM emulator
to listen for commands. The client device can be 'moved' in the container,
meaning a device node with the same major/minor numbers is created inside
a container. &nbsp;Any number of such device pairs can be create. Does
this driver sound like it would provide more functionality than yours and
would it address your use case as well?</font></tt><br><br><tt><font size=
=3D2>&nbsp; &nbsp;Stefan</font></tt><br><br><tt><font size=3D2><br>&gt; <br=
>&gt; Thanks,<br>&gt; David<br>&gt; <br>&gt; ------------------------------=
------------------------------------------------<br>&gt; Site24x7 APM Insig=
ht: Get Deep Visibility into Application Performance<br>&gt; APM + Mobile A=
PM + RUM: Monitor 3 App instances at just $35/Month<br>&gt; Monitor end-to-=
end web transactions and take corrective actions now<br>&gt; Troubleshoot f=
aster and improve end-user experience. Signup Now!<br>&gt; </font></tt><a h=
ref=3D"http://pubads.g.doubleclick.net/gampad/clk?id=3D267308311&amp;iu=3D/=
4140"><tt><font size=3D2>http://pubads.g.doubleclick.net/gampad/clk?id=3D26=
7308311&amp;iu=3D/4140</font></tt></a><tt><font size=3D2><br>&gt; =5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=
=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F=5F<br>&gt; tpmdd-dev=
el mailing list<br>&gt; tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org<br>&gt; </font></=
tt><a href=3D"https://lists.sourceforge.net/lists/listinfo/tpmdd-devel"><tt=
><font size=3D2>https://lists.sourceforge.net/lists/listinfo/tpmdd-devel</f=
ont></tt></a><tt><font size=3D2><br>&gt; <br></font></tt><BR>
--=_alternative 005038D785257F39_=--



--===============7281230473647343812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============7281230473647343812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============7281230473647343812==--
