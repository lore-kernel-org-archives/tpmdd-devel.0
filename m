From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: TPM emulator driver status
Date: Thu, 14 Jan 2016 15:05:57 -0500
Message-ID: <201601142006.u0EK65HG018390@d03av01.boulder.ibm.com>
References: <201601131436.u0DEaIdD015610@d03av02.boulder.ibm.com>
	<11083.1452692382@warthog.procyon.org.uk>
	<25224.1452779110@warthog.procyon.org.uk>,
	<201601141458.u0EEwsMi006753@d01av01.pok.ibm.com>
	<trinity-bc340f40-4d00-4382-afb2-83639b925c0d-1452799694114@3capp-gmx-bs69>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6392621010494916208=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <trinity-bc340f40-4d00-4382-afb2-83639b925c0d-1452799694114@3capp-gmx-bs69>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net


--===============6392621010494916208==
Content-Type: multipart/alternative;
	boundary="=_alternative 006E6A6785257F3A_="


--=_alternative 006E6A6785257F3A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

"Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org> wrote on 01/14/2016 02:28:14 PM:

>=20
>=20
> Hmm, interesting.
>=20
> I like David's driver since it is super simple to use, and works=20
> with the old Strasser's TPM Emulator for 1.2 and with the Microsoft=20
> TPM Simulator for 2.0.
>=20
> Have you tested one or the other with your approach?

No, I haven't, since we have our of TPM 1.2 implementation. The referenced =

swtpm (and libtpms) projects will at some point be extended with TPM 2.

>=20
> I'm not 100% sure about the different name for the tpm emulation, as
> quite some software relies on the /dev/tpmZ naming - e.g. for=20
> testing it would be good to not be able to distinguish them.
> So I have the exact same runs on machines with a emulated tpm and=20
> with a real hw one.
> BUT on the other hand I think it's good to distinguish both=20
> (somehow, maybe a sysfs attribute?).=20
>=20
>=20
> Honestly I'm lacking a bit behind on the vTPM stuff.
> Would this work on a regular x86 machine?

Yes.

   Stefan



--=_alternative 006E6A6785257F3A_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>&quot;Peter Huewe&quot; &lt;PeterHuewe-Mmb7MZpHnFY@public.gmane.org&gt; wrote
on 01/14/2016 02:28:14 PM:<br><br>&gt; <br>&gt; <br>&gt; Hmm, interesting.<=
br>&gt; <br>&gt; I like David's driver since it is super simple to use, and=
 works <br>&gt; with the old Strasser's TPM Emulator for 1.2 and with the M=
icrosoft
<br>&gt; TPM Simulator for 2.0.<br>&gt; <br>&gt; Have you tested one or the=
 other with your approach?</font></tt><br><br><tt><font size=3D2>No, I have=
n't, since we have our of TPM 1.2 implementation.
The referenced swtpm (and libtpms) projects will at some point be extended
with TPM 2.</font></tt><br><tt><font size=3D2><br>&gt; <br>&gt; I'm not 100=
% sure about the different name for the tpm emulation,
as<br>&gt; quite some software relies on the /dev/tpmZ naming - e.g. for <b=
r>&gt; testing it would be good to not be able to distinguish them.<br>&gt;=
 So I have the exact same runs on machines with a emulated tpm and
<br>&gt; with a real hw one.<br>&gt; BUT on the other hand I think it's goo=
d to distinguish both <br>&gt; (somehow, maybe a sysfs attribute?). <br>&gt=
; <br>&gt; <br>&gt; Honestly I'm lacking a bit behind on the vTPM stuff.<br=
>&gt; Would this work on a regular x86 machine?</font></tt><br><br><tt><fon=
t size=3D2>Yes.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;Stefan</=
font></tt><br><BR>
--=_alternative 006E6A6785257F3A_=--



--===============6392621010494916208==
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
--===============6392621010494916208==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6392621010494916208==--
