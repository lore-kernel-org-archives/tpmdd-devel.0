From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 06/10] tpm: Replace device
 number	bitmap with IDR
Date: Mon, 29 Feb 2016 14:36:41 -0500
Message-ID: <201602291937.u1TJbDSf000641@d01av01.pok.ibm.com>
References: <1456766996-9300-1-git-send-email-stefanb@linux.vnet.ibm.com><1456766996-9300-7-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160229193103.GD15042@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3372722455721289833=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160229193103.GD15042-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
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


--===============3372722455721289833==
Content-Type: multipart/alternative;
	boundary="=_alternative 006BBB3485257F68_="


--=_alternative 006BBB3485257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 02/29/2016=20
02:31:03 PM:


>=20
> On Mon, Feb 29, 2016 at 12:29:52PM -0500, Stefan Berger wrote:
> > Replace the device number bitmap with IDR. Extend the number of=20
devices we
> > can create to 64k.
> > Since an IDR allows us to associate a pointer with an ID, we use this=20
now
> > to rewrite tpm=5Fchip=5Ffind=5Fget() to simply look up the chip pointer=
 by=20
the
> > given device ID.
> >=20
> > Protect the IDR calls with a mutex.
> >=20
> > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>=20
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
>  -   TPM=5FNUM=5FDEVICES =3D 256,
>  +   TPM=5FNUM=5FDEVICES =3D 65536,
>         rc =3D alloc=5Fchrdev=5Fregion(&tpm=5Fdevt, 0, TPM=5FNUM=5FDEVICE=
S, "tpm");
>=20
> Although I do still wonder if passing such a large number to
> alloc=5Fchrdev=5Fregion is a good idea. Should it be MINORMASK instead=20
> or something?

Likely we would not use MINORMASK but we should use ( 1 << MINORBITS)=20
instead, but that's 2^20 then.

   Stefan

>=20
> Jason
>=20



--=_alternative 006BBB3485257F68_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jason Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;
wrote on 02/29/2016 02:31:03 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Mon, Feb 29, 2016 at 12:29:52PM -0500, Stefan Berger wrote=
:<br>&gt; &gt; Replace the device number bitmap with IDR. Extend the number
of devices we<br>&gt; &gt; can create to 64k.<br>&gt; &gt; Since an IDR all=
ows us to associate a pointer with an ID, we
use this now<br>&gt; &gt; to rewrite tpm=5Fchip=5Ffind=5Fget() to simply lo=
ok up the chip pointer
by the<br>&gt; &gt; given device ID.<br>&gt; &gt; <br>&gt; &gt; Protect the=
 IDR calls with a mutex.<br>&gt; &gt; <br>&gt; &gt; Signed-off-by: Stefan B=
erger &lt;stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org&gt;<br>&gt; <br>&gt; Reviewed-by: Jaso=
n Gunthorpe &lt;jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org&gt;<br>&gt; <br>&gt; &nbsp;=
- &nbsp; TPM=5FNUM=5FDEVICES =3D 256,<br>&gt; &nbsp;+ &nbsp; TPM=5FNUM=5FDE=
VICES =3D 65536,<br>&gt; &nbsp; &nbsp; &nbsp; &nbsp; rc =3D alloc=5Fchrdev=
=5Fregion(&amp;tpm=5Fdevt,
0, TPM=5FNUM=5FDEVICES, &quot;tpm&quot;);<br>&gt; <br>&gt; Although I do st=
ill wonder if passing such a large number to<br>&gt; alloc=5Fchrdev=5Fregio=
n is a good idea. Should it be MINORMASK instead
<br>&gt; or something?</font></tt><br><br><tt><font size=3D2>Likely we woul=
d not use MINORMASK but we should use
( 1 &lt;&lt; MINORBITS) instead, but that's 2^20 then.</font></tt><br><br><=
tt><font size=3D2>&nbsp; &nbsp;Stefan</font></tt><br><tt><font size=3D2><br=
>&gt; <br>&gt; Jason<br>&gt; <br></font></tt><BR>
--=_alternative 006BBB3485257F68_=--



--===============3372722455721289833==
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
--===============3372722455721289833==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============3372722455721289833==--
