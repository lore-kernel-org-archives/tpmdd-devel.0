From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 17:47:11 -0500
Message-ID: <201602122247.u1CMlEZa030908@d01av03.pok.ibm.com>
References: <20160211194810.GA24211@obsidianresearch.com><201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com><20160211221822.GA16304@obsidianresearch.com><201602112226.u1BMQZ59031657@d01av02.pok.ibm.com><20160211235611.GB16304@obsidianresearch.com><201602120353.u1C3rYif023135@d01av05.pok.ibm.com><20160212184051.GB4289@obsidianresearch.com><201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com><20160212203956.GB10540@obsidianresearch.com><201602122044.u1CKiMbR023495@d03av03.boulder.ibm.com><20160212211538.GA20737@obsidianresearch.com>
	<201602122223.u1CMNJXl023711@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1591656412484089153=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201602122223.u1CMNJXl023711-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1591656412484089153==
Content-Type: multipart/alternative;
	boundary="=_alternative 007D340A85257F57_="


--=_alternative 007D340A85257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Stefan Berger/Watson/IBM@IBMUS wrote on 02/12/2016 05:23:16 PM:

>=20
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/
> 2016 04:15:38 PM:

> >=20
> > On Fri, Feb 12, 2016 at 03:44:14PM -0500, Stefan Berger wrote:
> > >    What I observed is that both tpm=5Fchip and vtpm=5Fdev structuresa=
re=20
freed
> > >    once the last one of two sides (/dev/tpmX or server side file
> > >    descriptor) closes.
> >=20
> > Hmmm...
> >=20
> > I don't see how that can happen. Looking at the tpm cdev, it is
>=20
> Well, following my tests, it does happen.

Also I am zeroing tpm=5Fchip and vtpm=5Fdev structures before the free.=20
Nothing bad happens in any combination of device opening / closing tests I =

did.

    Stefan


--=_alternative 007D340A85257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Stefan Berger/Watson/IBM@IBMUS wrote on 02/12/2016 05:23=
:16
PM:<br></font></tt><br><tt><font size=3D2>&gt; <br>&gt; Jason Gunthorpe &lt=
;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt; wrote on 02/12/<br>&gt; 2016 04:15:38 =
PM:<br><br>&gt; &gt; <br>&gt; &gt; On Fri, Feb 12, 2016 at 03:44:14PM -0500=
, Stefan Berger wrote:<br>&gt; &gt; &gt; &nbsp; &nbsp;What I observed is th=
at both tpm=5Fchip and vtpm=5Fdev
structuresare freed<br>&gt; &gt; &gt; &nbsp; &nbsp;once the last one of two=
 sides (/dev/tpmX or
server side file<br>&gt; &gt; &gt; &nbsp; &nbsp;descriptor) closes.<br>&gt;=
 &gt; <br>&gt; &gt; Hmmm...<br>&gt; &gt; <br>&gt; &gt; I don't see how that=
 can happen. Looking at the tpm cdev, it
is<br>&gt; <br>&gt; Well, following my tests, it does happen.</font></tt><b=
r><br><tt><font size=3D2>Also I am zeroing tpm=5Fchip and vtpm=5Fdev struct=
ures
before the free. Nothing bad happens in any combination of device opening
/ closing tests I did.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp; =
Stefan</font></tt><BR>
--=_alternative 007D340A85257F57_=--



--===============1591656412484089153==
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
--===============1591656412484089153==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1591656412484089153==--
