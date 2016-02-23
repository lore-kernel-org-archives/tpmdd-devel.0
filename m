From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/11] tpm: Replace device number
 bitmap with IDR
Date: Tue, 23 Feb 2016 18:04:38 -0500
Message-ID: <201602232305.u1NN52uZ022431@d01av04.pok.ibm.com>
References: <1455885728-10315-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1455885728-10315-8-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160222190629.GE22088@obsidianresearch.com>
	<201602230116.u1N1G4iu012263@d03av02.boulder.ibm.com>
	<20160223021606.GC26177@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6133056239383462473=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160223021606.GC26177-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============6133056239383462473==
Content-Type: multipart/alternative;
	boundary="=_alternative 007ECCEB85257F62_="


--=_alternative 007ECCEB85257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/22/2016=20
09:16:06 PM:

>=20
> On Mon, Feb 22, 2016 at 08:15:38PM -0500, Stefan Berger wrote:
> > > - Tear down /dev/tpmX, sysfs and all other user accessible entry
> > >   points
> > > - Do device=5Fdel (get rid of all the sysfs stuff)
> > > - NULL the IDR (disables kAPI access and allow reuse of the ID)
> > > - NULL the ops (flush in-progress access now that new access is=20
> impossible)
> >=20

>=20
> > - Free the chip's device number from the IDR (makes IDR re-usable;
> must happen
> > after /dev/tpmX is released to avoid clashes
>=20
> With this new arrangment the idr=5Fremove can happen directly after
> device=5Fdel and we can avoid the intermediate state of a NULL'd entry,
> which seems slightly simplifying. Before there was the problem because
> vtpm was using a struct device, but that is gone now.

Let's stay with the 2 stage removal unrolled in the functions that are the =

opposite where the do the staged adding.

I just ran into the problem that when tpm=5Fchip=5Fregister wasn't called d=
ue=20
to me killing the process while the driver task attempted to get the=20
durations, the tpm=5Fchip=5Funregister didn't get called either. So we lost=
=20
ID's in the IDR. So we allocate the id in tpm=5Fchip=5Falloc and free it=20
before the kfree(chip) in tpm=5Fdev=5Frelease. We put the chip on the IDR i=
n=20
tpm=5Fdev=5Fadd=5Fdevice and remove it in tpm=5Fdev=5Fdel=5Fdevice -- nice =
and=20
symmetric.

  Stefan



--=_alternative 007ECCEB85257F62_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/22/2016 09:16:06 PM:<br><br>&gt; <br>&gt; On Mon, Feb 22, 2016 =
at 08:15:38PM -0500, Stefan Berger wrote:<br>&gt; &gt; &gt; - Tear down /de=
v/tpmX, sysfs and all other user accessible
entry<br>&gt; &gt; &gt; &nbsp; points<br>&gt; &gt; &gt; - Do device=5Fdel (=
get rid of all the sysfs stuff)<br>&gt; &gt; &gt; - NULL the IDR (disables =
kAPI access and allow reuse of
the ID)<br>&gt; &gt; &gt; - NULL the ops (flush in-progress access now that=
 new access
is <br>&gt; impossible)<br>&gt; &gt; <br><br>&gt; <br>&gt; &gt; - Free the =
chip's device number from the IDR (makes IDR re-usable;<br>&gt; must happen=
<br>&gt; &gt; after /dev/tpmX is released to avoid clashes<br>&gt; <br>&gt;=
 With this new arrangment the idr=5Fremove can happen directly after<br>&gt=
; device=5Fdel and we can avoid the intermediate state of a NULL'd entry,<b=
r>&gt; which seems slightly simplifying. Before there was the problem becau=
se<br>&gt; vtpm was using a struct device, but that is gone now.</font></tt=
><br><br><tt><font size=3D2>Let's stay with the 2 stage removal unrolled in=
 the
functions that are the opposite where the do the staged adding.</font></tt>=
<br><br><tt><font size=3D2>I just ran into the problem that when tpm=5Fchip=
=5Fregister
wasn't called due to me killing the process while the driver task attempted
to get the durations, the tpm=5Fchip=5Funregister didn't get called either.
So we lost ID's in the IDR. So we allocate the id in tpm=5Fchip=5Falloc and
free it before the kfree(chip) in tpm=5Fdev=5Frelease. We put the chip on t=
he
IDR in tpm=5Fdev=5Fadd=5Fdevice and remove it in tpm=5Fdev=5Fdel=5Fdevice -=
- nice and
symmetric.</font></tt><br><br><tt><font size=3D2>&nbsp; Stefan</font></tt><=
br><BR>
--=_alternative 007ECCEB85257F62_=--



--===============6133056239383462473==
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
--===============6133056239383462473==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6133056239383462473==--
