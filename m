From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Tue, 16 Feb 2016 14:26:56 -0500
Message-ID: <201602161927.u1GJRKfc016287@d01av01.pok.ibm.com>
References: <20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120356.u1C3usEe002034@d03av04.boulder.ibm.com>
	<201602121813.u1CIDu4O015272@d01av01.pok.ibm.com>
	<20160212183415.GA4289@obsidianresearch.com>
	<201602140637.u1E6baNX028563@d03av04.boulder.ibm.com>
	<201602161648.u1GGmdZv000468@d01av03.pok.ibm.com>
	<20160216180028.GA4967@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5930612616530643618=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160216180028.GA4967-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============5930612616530643618==
Content-Type: multipart/alternative;
	boundary="=_alternative 006ADECC85257F5B_="


--=_alternative 006ADECC85257F5B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/16/2016=20
01:00:28 PM:

>=20
> On Tue, Feb 16, 2016 at 11:44:06AM -0500, Stefan Berger wrote:
>=20
> >    Scratch that. The easier way to fix this was to release the=20
tpm=5Fchip
> >    after the vtpm=5Fdev.
>=20
> Right, that is nicer
>=20
> Did you solve the lock ups when register fails?

The re-ordering of the tpm=5Fchip and vtpm=5Fdev release actually solved th=
at=20
problem.

[My feeling is, something outside of the vtpm driver doesn't unroll=20
properly and locks up if there's lots of concurrency].

>=20
> One other thing you can look at is ditching the vtpm struct
> device. With the last patches I sent the tpm core would only need two
> more lines to work with a null parent device, which would be even
> simpler for vtpm.

Not having a parent device isn't really necessary, except for not having=20
it appear in sysfs maybe?

   Stefan

>=20
> Jason
>=20



--=_alternative 006ADECC85257F5B_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/16/2016 01:00:28 PM:<br><br>&gt; <br>&gt; On Tue, Feb 16, 2016 =
at 11:44:06AM -0500, Stefan Berger wrote:<br>&gt; <br>&gt; &gt; &nbsp; &nbs=
p;Scratch that. The easier way to fix this was to
release the tpm=5Fchip<br>&gt; &gt; &nbsp; &nbsp;after the vtpm=5Fdev.<br>&=
gt; <br>&gt; Right, that is nicer<br>&gt; <br>&gt; Did you solve the lock u=
ps when register fails?</font></tt><br><br><tt><font size=3D2>The re-orderi=
ng of the tpm=5Fchip and vtpm=5Fdev release
actually solved that problem.</font></tt><br><br><tt><font size=3D2>[My fee=
ling is, something outside of the vtpm driver
doesn't unroll properly and locks up if there's lots of concurrency].</font=
></tt><br><tt><font size=3D2><br>&gt; <br>&gt; One other thing you can look=
 at is ditching the vtpm struct<br>&gt; device. With the last patches I sen=
t the tpm core would only need
two<br>&gt; more lines to work with a null parent device, which would be ev=
en<br>&gt; simpler for vtpm.</font></tt><br><br><tt><font size=3D2>Not havi=
ng a parent device isn't really necessary,
except for not having it appear in sysfs maybe?</font></tt><br><br><tt><fon=
t size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br>&gt; <=
br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 006ADECC85257F5B_=--



--===============5930612616530643618==
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
--===============5930612616530643618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============5930612616530643618==--
