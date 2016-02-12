From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 4/5] Initialize TPM and get durations
 and timeouts
Date: Fri, 12 Feb 2016 15:44:14 -0500
Message-ID: <201602122044.u1CKiMnV001872@d03av04.boulder.ibm.com>
References: <20160211181208.GA6285@obsidianresearch.com>
	<201602111911.u1BJB2nK017410@d01av03.pok.ibm.com>
	<20160211194810.GA24211@obsidianresearch.com>
	<201602112210.u1BMAYPe015452@d03av01.boulder.ibm.com>
	<20160211221822.GA16304@obsidianresearch.com>
	<201602112226.u1BMQZ59031657@d01av02.pok.ibm.com>
	<20160211235611.GB16304@obsidianresearch.com>
	<201602120353.u1C3rYif023135@d01av05.pok.ibm.com>
	<20160212184051.GB4289@obsidianresearch.com>
	<201602122031.u1CKVIOp028400@d03av03.boulder.ibm.com>
	<20160212203956.GB10540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6308702842926493941=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160212203956.GB10540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============6308702842926493941==
Content-Type: multipart/alternative;
	boundary="=_alternative 0071F25985257F57_="


--=_alternative 0071F25985257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/12/2016=20
03:39:56 PM:

>=20
> On Fri, Feb 12, 2016 at 03:31:13PM -0500, Stefan Berger wrote:
>=20
> >    Where is the race? I tested the following:
> >    The tpm=5Fvtpm module use counter increases with every server file
> >    descriptor being handed out, so every run of ./vtpmctrl increases=20
it by
> >    1.
> >    Every opening of /dev/tpm%d (exec 1XY<>/dev/tpm%d) increases the
> >    tpm=5Fvtpm module use counter also by 1.
> >    If the vtpmctrl's die, the module use counter decreases for every
> >    vtpmctrl termiating. However, the use counter is still at the=20
number of
> >    open /dev/tpm%d devices.
> >    vtpm=5Fdev and chip structures only get free'd once the file=20
descriptor
> >    is close. So it looks like expected good behavior to me. We cannot
> >    remove the 'backend' module following the usage counter increase,=20
so
> >    this is good too.
>=20
> We don't expect tpm=5Fchip=5Funregister to run concurrently with any
> in-progress operation, that isn't properly synchronized.
>=20
> So your driver will call tpm=5Fchip=5Funregister and then put=5Fdevice it=
's
> structure, but the tpm=5Fchip is still active and could still generate a
> callback to vtpm code resulting in use-after-free.

What I observed is that both tpm=5Fchip and vtpm=5Fdev structures are freed=
=20
once the last one of two sides (/dev/tpmX or server side file descriptor)=20
closes. Closing means there's no more code being executed by an=20
application. So how can we have something still executing in the driver=20
when both sides closed?

  Stefan



--=_alternative 0071F25985257F57_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/12/2016 03:39:56 PM:<br></font></tt><br><tt><font size=3D2>&gt;=
 <br>&gt; On Fri, Feb 12, 2016 at 03:31:13PM -0500, Stefan Berger wrote:<br=
>&gt; <br>&gt; &gt; &nbsp; &nbsp;Where is the race? I tested the following:=
<br>&gt; &gt; &nbsp; &nbsp;The tpm=5Fvtpm module use counter increases with=
 every
server file<br>&gt; &gt; &nbsp; &nbsp;descriptor being handed out, so every=
 run of ./vtpmctrl
increases it by<br>&gt; &gt; &nbsp; &nbsp;1.<br>&gt; &gt; &nbsp; &nbsp;Ever=
y opening of /dev/tpm%d (exec 1XY&lt;&gt;/dev/tpm%d)
increases the<br>&gt; &gt; &nbsp; &nbsp;tpm=5Fvtpm module use counter also =
by 1.<br>&gt; &gt; &nbsp; &nbsp;If the vtpmctrl's die, the module use count=
er decreases
for every<br>&gt; &gt; &nbsp; &nbsp;vtpmctrl termiating. However, the use c=
ounter is
still at the number of<br>&gt; &gt; &nbsp; &nbsp;open /dev/tpm%d devices.<b=
r>&gt; &gt; &nbsp; &nbsp;vtpm=5Fdev and chip structures only get free'd once
the file descriptor<br>&gt; &gt; &nbsp; &nbsp;is close. So it looks like ex=
pected good behavior
to me. We cannot<br>&gt; &gt; &nbsp; &nbsp;remove the 'backend' module foll=
owing the usage
counter increase, so<br>&gt; &gt; &nbsp; &nbsp;this is good too.<br>&gt; <b=
r>&gt; We don't expect tpm=5Fchip=5Funregister to run concurrently with any=
<br>&gt; in-progress operation, that isn't properly synchronized.<br>&gt; <=
br>&gt; So your driver will call tpm=5Fchip=5Funregister and then put=5Fdev=
ice it's<br>&gt; structure, but the tpm=5Fchip is still active and could st=
ill generate
a<br>&gt; callback to vtpm code resulting in use-after-free.</font></tt><br=
><br><tt><font size=3D2>What I observed is that both tpm=5Fchip and vtpm=5F=
dev
structures are freed once the last one of two sides (/dev/tpmX or server
side file descriptor) closes. Closing means there's no more code being
executed by an application. So how can we have something still executing
in the driver when both sides closed?</font></tt><br><br><tt><font size=3D2=
>&nbsp; Stefan</font></tt><br><BR>
--=_alternative 0071F25985257F57_=--



--===============6308702842926493941==
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
--===============6308702842926493941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6308702842926493941==--
