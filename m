From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] tpm_tis: Increase ST19NP18 TPM
 command	timeout to avoid chip lockup
Date: Mon, 6 Jun 2016 21:07:00 -0400
Message-ID: <OFFA057E80.C169C00E-ON00257FCB.000588B0-85257FCB.0006225D@notes.na.collabserv.com>
References: <1465252079-126836-1-git-send-email-eswierk@skyportsystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1495712909137810107=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1465252079-126836-1-git-send-email-eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============1495712909137810107==
Content-Type: multipart/alternative;
	boundary="=_alternative 0006225D85257FCB_="


--=_alternative 0006225D85257FCB_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org> wrote on 06/06/2016 06:27:59 PM:

>=20
> The STMicro ST19NP18-TPM sometimes takes much longer to execute
> commands than it reports in its capabilities. For example, command 186
> (TPM=5FFlushSpecific) has been observed to take 14560 msec to complete,
> far longer than the 750 msec limit for "short" commands reported by
> the chip. The behavior has also been seen with command 101
> (TPM=5FGetCapability).

Hm, those should be really fast.

>=20
> Worse, when the tpm=5Ftis driver attempts to cancel the current command
> (by writing commandReady =3D 1 to TPM=5FSTS=5Fx), the chip locks up
> completely, returning all-1s from all memory-mapped register
> reads. The lockup can be cleared only by resetting the system.
>=20
> The occurrence of this excessive command duration depends on the
> sequence of commands preceding it. One sequence is creating at least 2
> new keys via TPM=5FCreateWrapKey, then letting the TPM idle for at least

How long does it take to create those keys? Maybe it will create new keys=20
in the 'background' after that.

> 30 seconds, then loading a key via TPM=5FLoadKey2. The next
> TPM=5FFlushSpecific occasionally takes tens of seconds to
> complete. Another sequence is creating many keys in a row without
> pause. The TPM=5FCreateWrapKey operation gets much slower after the
> first few iterations, as one would expect when the pool of precomputed
> keys is exhausted. Then after a 35-second pause, the same TPM=5FLoadKey2
> followed by TPM=5FFlushSpecific sequence triggers the behavior.
>=20
> Our working theory is that this older TPM sometimes pauses to perform
> internal garbage collection, which modern chips implement as a
> background process. Without access to the chip's implementation
> details it's impossible to know whether any commands are immune to
> this behavior.  So it seems safest to ignore the chip's reported
> command durations, and use a value much higher than any observed
> duration, like 2 minutes (which happens to be the value used for
> TPM=5FUNDEFINED commands in tpm=5Fcalc=5Fordinal=5Fduration()).
>=20
> v2: Minor correction of patch description.
>=20
> Signed-off-by: Ed Swierk <eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org>

Reviewed-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>





--=_alternative 0006225D85257FCB_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Ed Swierk &lt;eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org&gt; wrote on
06/06/2016 06:27:59 PM:<br><br>&gt; <br>&gt; The STMicro ST19NP18-TPM somet=
imes takes much longer to execute<br>&gt; commands than it reports in its c=
apabilities. For example, command
186<br>&gt; (TPM=5FFlushSpecific) has been observed to take 14560 msec to c=
omplete,<br>&gt; far longer than the 750 msec limit for &quot;short&quot; c=
ommands
reported by<br>&gt; the chip. The behavior has also been seen with command =
101<br>&gt; (TPM=5FGetCapability).</font></tt><br><br><tt><font size=3D2>Hm=
, those should be really fast.</font></tt><br><tt><font size=3D2><br>&gt; <=
br>&gt; Worse, when the tpm=5Ftis driver attempts to cancel the current com=
mand<br>&gt; (by writing commandReady =3D 1 to TPM=5FSTS=5Fx), the chip loc=
ks up<br>&gt; completely, returning all-1s from all memory-mapped register<=
br>&gt; reads. The lockup can be cleared only by resetting the system.<br>&=
gt; <br>&gt; The occurrence of this excessive command duration depends on t=
he<br>&gt; sequence of commands preceding it. One sequence is creating at l=
east
2<br>&gt; new keys via TPM=5FCreateWrapKey, then letting the TPM idle for a=
t least</font></tt><br><br><tt><font size=3D2>How long does it take to crea=
te those keys? Maybe
it will create new keys in the 'background' after that.</font></tt><br><tt>=
<font size=3D2><br>&gt; 30 seconds, then loading a key via TPM=5FLoadKey2. =
The next<br>&gt; TPM=5FFlushSpecific occasionally takes tens of seconds to<=
br>&gt; complete. Another sequence is creating many keys in a row without<b=
r>&gt; pause. The TPM=5FCreateWrapKey operation gets much slower after the<=
br>&gt; first few iterations, as one would expect when the pool of precompu=
ted<br>&gt; keys is exhausted. Then after a 35-second pause, the same TPM=
=5FLoadKey2<br>&gt; followed by TPM=5FFlushSpecific sequence triggers the b=
ehavior.<br>&gt; <br>&gt; Our working theory is that this older TPM sometim=
es pauses to perform<br>&gt; internal garbage collection, which modern chip=
s implement as a<br>&gt; background process. Without access to the chip's i=
mplementation<br>&gt; details it's impossible to know whether any commands =
are immune to<br>&gt; this behavior. &nbsp;So it seems safest to ignore the=
 chip's reported<br>&gt; command durations, and use a value much higher tha=
n any observed<br>&gt; duration, like 2 minutes (which happens to be the va=
lue used for<br>&gt; TPM=5FUNDEFINED commands in tpm=5Fcalc=5Fordinal=5Fdur=
ation()).<br>&gt; <br>&gt; v2: Minor correction of patch description.<br>&g=
t; <br>&gt; Signed-off-by: Ed Swierk &lt;eswierk-FilZDy9cOaHkQYj/0HfcvtBPR1lH4CV8@public.gmane.org&gt;</fo=
nt></tt><br><br><tt><font size=3D2>Reviewed-by: Stefan Berger &lt;stefanb@l=
inux.vnet.ibm.com&gt;</font></tt><br><br><br><BR>
--=_alternative 0006225D85257FCB_=--



--===============1495712909137810107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. https://ad.doubleclick.net/ddm/clk/305295220;132659582;e
--===============1495712909137810107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============1495712909137810107==--
